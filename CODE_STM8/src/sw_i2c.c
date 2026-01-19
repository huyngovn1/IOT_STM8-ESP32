/* ===================================================================
 * File:   sw_i2c.c
 * Mô t?:  Tri?n khai thu vi?n I2C ph?n m?m (Bit-bang) cho STM8S
 * =================================================================== */

#include "sw_i2c.h"
#include "stm8s_gpio.h" // C?n cho các hàm GPIO_Init, GPIO_Write...

// === Hàm delay us (cho I2C) ===
void delay_us(uint8_t us) {
    uint8_t i;
    for (i = 0; i < us; i++) {
        _asm("nop"); _asm("nop"); _asm("nop"); _asm("nop");
        _asm("nop"); _asm("nop"); _asm("nop"); _asm("nop");
        _asm("nop"); _asm("nop");
    }
}

// === Các hàm I2C Ph?n M?m (Bit-bang) ===

void i2c_init(void) {
    GPIO_Init(I2C_PORT, I2C_SCL_PIN, GPIO_MODE_OUT_OD_HIZ_FAST);
    GPIO_Init(I2C_PORT, I2C_SDA_PIN, GPIO_MODE_OUT_OD_HIZ_FAST);
    GPIO_WriteHigh(I2C_PORT, I2C_SCL_PIN | I2C_SDA_PIN);
}

void i2c_start(void) {
    GPIO_WriteHigh(I2C_PORT, I2C_SDA_PIN);
    GPIO_WriteHigh(I2C_PORT, I2C_SCL_PIN);
    delay_us(5);
    GPIO_WriteLow(I2C_PORT, I2C_SDA_PIN);
    delay_us(5);
    GPIO_WriteLow(I2C_PORT, I2C_SCL_PIN);
    delay_us(5);
}

void i2c_stop(void) {
    GPIO_WriteLow(I2C_PORT, I2C_SDA_PIN);
    GPIO_WriteLow(I2C_PORT, I2C_SCL_PIN);
    delay_us(5);
    GPIO_WriteHigh(I2C_PORT, I2C_SCL_PIN);
    delay_us(5);
    GPIO_WriteHigh(I2C_PORT, I2C_SDA_PIN);
    delay_us(5);
}

uint8_t i2c_write_byte(uint8_t data) {
    uint8_t i, nack;
    for (i = 0; i < 8; i++) {
        if (data & 0x80) GPIO_WriteHigh(I2C_PORT, I2C_SDA_PIN);
        else GPIO_WriteLow(I2C_PORT, I2C_SDA_PIN);
        data <<= 1;
        GPIO_WriteHigh(I2C_PORT, I2C_SCL_PIN); delay_us(5);
        GPIO_WriteLow(I2C_PORT, I2C_SCL_PIN);  delay_us(5);
    }
    GPIO_Init(I2C_PORT, I2C_SDA_PIN, GPIO_MODE_IN_FL_NO_IT);
    GPIO_WriteHigh(I2C_PORT, I2C_SCL_PIN); delay_us(5);
    nack = GPIO_ReadInputPin(I2C_PORT, I2C_SDA_PIN);
    GPIO_WriteLow(I2C_PORT, I2C_SCL_PIN); delay_us(5);
    GPIO_Init(I2C_PORT, I2C_SDA_PIN, GPIO_MODE_OUT_OD_HIZ_FAST);
    return nack;
}

uint8_t i2c_read_byte(uint8_t send_ack) {
    uint8_t i, data = 0;
    GPIO_Init(I2C_PORT, I2C_SDA_PIN, GPIO_MODE_IN_FL_NO_IT);
    for (i = 0; i < 8; i++) {
        data <<= 1;
        GPIO_WriteHigh(I2C_PORT, I2C_SCL_PIN); delay_us(5);
        if (GPIO_ReadInputPin(I2C_PORT, I2C_SDA_PIN)) data |= 1;
        GPIO_WriteLow(I2C_PORT, I2C_SCL_PIN); delay_us(5);
    }
    GPIO_Init(I2C_PORT, I2C_SDA_PIN, GPIO_MODE_OUT_OD_HIZ_FAST);
    if (send_ack) GPIO_WriteLow(I2C_PORT, I2C_SDA_PIN);
    else GPIO_WriteHigh(I2C_PORT, I2C_SDA_PIN);
    GPIO_WriteHigh(I2C_PORT, I2C_SCL_PIN); delay_us(5);
    GPIO_WriteLow(I2C_PORT, I2C_SCL_PIN);  delay_us(5);
    GPIO_WriteHigh(I2C_PORT, I2C_SDA_PIN);  
    return data;
}