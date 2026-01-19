/* ===================================================================
 * File:   sw_i2c.h
 * Mô t?:  Thu vi?n I2C ph?n m?m (Bit-bang) cho STM8S
 * =================================================================== */

#ifndef _SW_I2C_H_
#define _SW_I2C_H_

#include "stm8s.h" // C?n cho các ki?u d? li?u (uint8_t) và GPIO

// === C?u hình I2C Ph? thu?c vào ph?n c?ng ===
// (B?n có th? thay d?i các chân này t?i dây)
#define I2C_PORT     GPIOB
#define I2C_SCL_PIN  GPIO_PIN_4
#define I2C_SDA_PIN  GPIO_PIN_5
// ===========================================

// === Nguyên m?u hàm (Prototypes) ===

/**
 * @brief  Kh?i t?o các chân GPIO cho I2C ph?n m?m.
 */
void i2c_init(void);

/**
 * @brief  T?o di?u ki?n START trên bus I2C.
 */
void i2c_start(void);

/**
 * @brief  T?o di?u ki?n STOP trên bus I2C.
 */
void i2c_stop(void);

/**
 * @brief  Ghi m?t byte ra bus I2C.
 * @param  data: Byte d? li?u c?n ghi.
 * @retval Tr?ng thái ACK (0 = ACK, 1 = NACK).
 */
uint8_t i2c_write_byte(uint8_t data);

/**
 * @brief  Ð?c m?t byte t? bus I2C.
 * @param  send_ack: 1 d? g?i ACK (khi d?c nhi?u byte), 0 d? g?i NACK (khi k?t thúc).
 * @retval Byte d? li?u dã d?c du?c.
 */
uint8_t i2c_read_byte(uint8_t send_ack);

/**
 * @brief  Hàm delay micro giây (us) co b?n cho I2C.
 * @param  us: S? micro giây d? delay (ch? là tuong d?i).
 */
void delay_us(uint8_t us);


#endif // _SW_I2C_H_