// SPDX-FileCopyrightText: 2020 Mohamed Shalan
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0


/* GPIO */
void gpio_set_dir(unsigned int );
void gpio_write(unsigned int );
unsigned int gpio_read(); 
void gpio_pull (unsigned char );
void gpio_im(unsigned int );

/* UART */
int uart_init(unsigned int , unsigned int );
int uart_puts(unsigned int , unsigned char *, unsigned int );
int uart_gets(unsigned int , unsigned char *, unsigned int );

/* SPI */
int spi_init(unsigned int , unsigned char , unsigned char , unsigned char );
unsigned int spi_status(unsigned int );
unsigned char spi_read(unsigned int );
int spi_write(unsigned int , unsigned char );
int spi_start(unsigned int );
int spi_end(unsigned int );

/* i2c */
int i2c_init(unsigned int , unsigned int );
int i2c_send(unsigned int , unsigned char , unsigned char );

/* PWM */
int pwm_init(unsigned int, unsigned int, unsigned int, unsigned int);
int pwm_enable(unsigned int);
int pwm_disable(unsigned int);
