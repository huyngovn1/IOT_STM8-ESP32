#include "stm8s.h"
#include "stm8s_clk.h"
#include "stm8s_gpio.h"
#include "stm8s_tim4.h"
#include "stm8s_uart1.h"
#include "sw_i2c.h"      

#define MAX30102_ADDR            (0x57 << 1)
#define FINGER_DETECT_THRESHOLD  30000   
#define BEAT_DETECT_HYSTERESIS   120     
#define RATE_SIZE 4                      
#define SAMPLE_PERIOD 10                 

#define MPU6050_ADDR             (0x68 << 1)
#define ACCEL_IMPACT_THRESHOLD_SQ   500000000 

// KHAI BAO BIEN
volatile uint32_t current_millis = 0;
uint32_t lastReadTime = 0;
uint32_t lastBeatTime = 0;

uint32_t ir_avg = 0;       
uint32_t ir_smooth = 0;    
uint8_t beatDetected = 0;  

uint8_t rates[RATE_SIZE];
uint8_t rateSpot = 0;
uint16_t bpm_to_display = 0; 
uint16_t last_valid_bpm = 0; 

typedef struct { int16_t Ax, Ay, Az; } MPUData;
MPUData mpu_data;
uint32_t fall_timer = 0;    
uint8_t alarm_state = 0;    
uint32_t accel_mag_sq = 0;

uint32_t lastUartSendTime = 0;

void delay_ms(uint16_t ms) { uint16_t i, j; for (i = 0; i < ms; i++) for (j = 0; j < 1275; j++); }

void CLK_Config(void) { 
    CLK_DeInit(); 
    CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1); 
    CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, ENABLE); 
    CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, ENABLE); 
}

void TIM4_Config(void) { 
    TIM4_TimeBaseInit(TIM4_PRESCALER_128, 125); 
    TIM4_ClearFlag(TIM4_FLAG_UPDATE); 
    TIM4_ITConfig(TIM4_IT_UPDATE, ENABLE); 
    TIM4_Cmd(ENABLE); 
}

@far @interrupt void TIM4_UPD_OVF_IRQHandler(void) { 
    current_millis++; 
    TIM4_ClearITPendingBit(TIM4_IT_UPDATE); 
}

void UART1_Config(void) { 
    UART1_DeInit(); 
    UART1_Init((uint32_t)9600, UART1_WORDLENGTH_8D, UART1_STOPBITS_1, UART1_PARITY_NO, UART1_SYNCMODE_CLOCK_DISABLE, UART1_MODE_TX_ENABLE); 
    UART1_Cmd(ENABLE); ki.p/
}

void UART1_SendChar(uint8_t c) { UART1_SendData8(c); while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET); }
void UART1_SendString(char* str) { char *c = str; while (*c) { UART1_SendChar(*c); c++; } }

void UART_SendBPM(uint8_t bpm) {
    uint8_t tens, units;
    if (bpm > 200) return; 
    tens = bpm / 10; units = bpm % 10;
    // --- DOI THANH TIENG VIET ---
    UART1_SendString("NhipTim:"); 
    if (bpm >= 100) UART1_SendChar('1');
    UART1_SendChar(tens + '0'); UART1_SendChar(units + '0');
    UART1_SendString("\n");
}

uint8_t MAX30102_Write(uint8_t reg, uint8_t data) { i2c_start(); i2c_write_byte(MAX30102_ADDR); i2c_write_byte(reg); i2c_write_byte(data); i2c_stop(); return 0; }
uint32_t MAX30102_Read_IR(void) {
    uint8_t b[3]; i2c_start(); i2c_write_byte(MAX30102_ADDR); i2c_write_byte(0x07); i2c_stop();
    i2c_start(); i2c_write_byte(MAX30102_ADDR|1); i2c_read_byte(1); i2c_read_byte(1); i2c_read_byte(1); 
    b[0]=i2c_read_byte(1); b[1]=i2c_read_byte(1); b[2]=i2c_read_byte(0); i2c_stop();
    return (((uint32_t)b[0]&0x03)<<16)|((uint32_t)b[1]<<8)|b[2];
}
uint8_t MAX30102_Init(void) {
    MAX30102_Write(0x09, 0x40); delay_ms(100);
    MAX30102_Write(0x08, 0x4F); MAX30102_Write(0x0A, 0x27); 
    MAX30102_Write(0x0C, 0x1F); MAX30102_Write(0x0D, 0x1F); MAX30102_Write(0x09, 0x03);
    return 1;
}

uint8_t MPU6050_Init(void) { i2c_start(); i2c_write_byte(MPU6050_ADDR); i2c_write_byte(0x6B); i2c_write_byte(0x00); i2c_stop(); return 0; }
void MPU6050_Read(MPUData* d) {
    uint8_t b[6]; i2c_start(); i2c_write_byte(MPU6050_ADDR); i2c_write_byte(0x3B); i2c_stop();
    i2c_start(); i2c_write_byte(MPU6050_ADDR|1);
    b[0]=i2c_read_byte(1); b[1]=i2c_read_byte(1); b[2]=i2c_read_byte(1); b[3]=i2c_read_byte(1); b[4]=i2c_read_byte(1); b[5]=i2c_read_byte(0); i2c_stop();
    d->Ax=(int16_t)((b[0]<<8)|b[1]); d->Ay=(int16_t)((b[2]<<8)|b[3]); d->Az=(int16_t)((b[4]<<8)|b[5]);
}

main() {
    uint32_t ir_value, IBI;
    uint16_t new_bpm;
    uint8_t x, init_ok;
    uint16_t beatAvg;
    uint8_t count; 
    int diff;      
    
    CLK_Config(); i2c_init(); TIM4_Config(); UART1_Config(); 
    init_ok = MAX30102_Init(); MPU6050_Init();
    enableInterrupts();
    
    if(!init_ok) { while(1) { UART1_SendString("LOI_CAM_BIEN\n"); delay_ms(1000); } }
    
    UART1_SendString("KHOI_DONG: CHE_DO_ON_DINH\n"); 
    
    while (1) {
        if (current_millis - lastReadTime >= SAMPLE_PERIOD) {
            lastReadTime = current_millis;
            
            ir_value = MAX30102_Read_IR();

            if (ir_value < FINGER_DETECT_THRESHOLD) {
                // RESET
                bpm_to_display = 0;
                last_valid_bpm = 0; 
                beatDetected = 0;
                ir_avg = 0; ir_smooth = 0;
                lastBeatTime = 0;
                for(x=0; x<RATE_SIZE; x++) rates[x] = 0; 
            } else {
                // XU LY TIN HIEU
                if (ir_smooth == 0) ir_smooth = ir_value;
                ir_smooth = (ir_smooth * 7 + ir_value) / 8;

                if (ir_avg == 0) ir_avg = ir_smooth;
                ir_avg = (ir_avg * 95 + ir_smooth) / 96; 
                
                if (ir_smooth > ir_avg + BEAT_DETECT_HYSTERESIS && beatDetected == 0) {
                    beatDetected = 1;
                    
                    if (lastBeatTime != 0) {
                        IBI = current_millis - lastBeatTime;
                        
                        if (IBI > 375 && IBI < 1350) {
                            new_bpm = 60000 / IBI;
                            // CHONG SOC
                            if (last_valid_bpm == 0) {
                                last_valid_bpm = new_bpm;
                                rates[rateSpot++] = (uint8_t)new_bpm;
                                rateSpot %= RATE_SIZE;
                            } 
                            else {
                                diff = (int)new_bpm - (int)last_valid_bpm;
                                if (diff > 15 || diff < -15) { } 
                                else {
                                    rates[rateSpot++] = (uint8_t)new_bpm;
                                    rateSpot %= RATE_SIZE;
                                    last_valid_bpm = new_bpm; 
                                }
                            }
                            // TINH TRUNG BINH
                            beatAvg = 0; count = 0;
                            for (x = 0 ; x < RATE_SIZE ; x++) {
                                if (rates[x] != 0) { beatAvg += rates[x]; count++; }
                            }
                            if (count > 0) beatAvg /= count;
                            if (beatAvg > 0) bpm_to_display = beatAvg;
                        }
                    }
                    lastBeatTime = current_millis;
                }
                else if (ir_smooth < ir_avg) {
                    beatDetected = 0; 
                }
            }
            
            switch (alarm_state) {
                case 0: // BINH THUONG
                    MPU6050_Read(&mpu_data);
                    accel_mag_sq = (uint32_t)mpu_data.Ax*mpu_data.Ax + (uint32_t)mpu_data.Ay*mpu_data.Ay + (uint32_t)mpu_data.Az*mpu_data.Az;
                    
                    if (accel_mag_sq > ACCEL_IMPACT_THRESHOLD_SQ) {
                        alarm_state = 1; fall_timer = current_millis; 
                        UART1_SendString("PHAT_HIEN_NGA\n"); 
                    }
                    
                    if (current_millis - lastUartSendTime > 1000) { 
                        lastUartSendTime = current_millis;
                        if (bpm_to_display > 0) UART_SendBPM((uint8_t)bpm_to_display);
                        else if (ir_value < FINGER_DETECT_THRESHOLD) UART1_SendString("KHONG_CO_TAY\n");
                        else UART1_SendString("DANG_DO...\n");
                    }
                    break;

                case 1: //NGHI NGO
                    if (current_millis - fall_timer > 10000) { 
                        if (bpm_to_display >= 40) { 
                            alarm_state = 0; 
                            UART1_SendString("HUY_CANH_BAO\n"); 
                        } 
                        else { 
                            alarm_state = 2; 
                            UART1_SendString("CANH_BAO_KICH_HOAT\n"); 
                        }
                    }
                    break;

                case 2: //Canh bao
                    if (bpm_to_display >= 40) { 
                        alarm_state = 0; 
                        UART1_SendString("DUNG_CANH_BAO\n"); 
                    } else {
                        if (current_millis - lastUartSendTime > 1000) {
                            lastUartSendTime = current_millis;
                            UART1_SendString("DANG_BAO_DONG\n"); 
                        }
                    }
                    break;
            }
        } 
    } 
}