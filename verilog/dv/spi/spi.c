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


#include "../../../sw/n5_drv.h"
#include "../../../sw/n5_int.h"

unsigned int A[100];

void IRQ() {
    gpio_write(0x0099);        
}

void M23LC_write_byte(int n, unsigned int addr, unsigned int data){
  spi_start(n);
  spi_write(n, 0x2);
  spi_write(n, addr >> 8);     // Address high byte
  spi_write(n, addr & 0xFF);   // Address low byte
  spi_write(n, data);
  spi_end(n);
}

unsigned char M23LC_read_byte(int n, unsigned short addr){
  spi_start(n);
  spi_write(n, 0x3);
  spi_write(n, addr >> 8);     // Address high byte
  spi_write(n, addr & 0xFF);   // Address low byte
  spi_write(n, 0);             // just write a dummy data to get the data out
  spi_end(n);
  return spi_read(n);
}

#define     DELAY(n)   for(int i=0; i<n; i++)

int main(){
    // Initialization
    uart_init (0, 0);
    gpio_set_dir(0x0000);
    spi_init(0, 0,0,20);
    
    // SPI
    uart_puts (0, "Monitor: SPI Test ", 18);
    M23LC_write_byte(0, 0, 0xA5);
    unsigned int spi_data = M23LC_read_byte(0, 0);
    DELAY(100);
    if(spi_data==0xA5)
        uart_puts(0,"Passed!\n", 8);
    else 
        uart_puts(0,"Failed!\n", 8);

    // Done!
    uart_puts(0, "Done!\n\n", 7);
    DELAY(20);
    // Flag end of test
    gpio_write(0x00A4);
    return 0;
}

