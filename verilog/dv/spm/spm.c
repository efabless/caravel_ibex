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

void IRQ() {
    gpio_write(0x0099);        
}

int fact(int n){
    int f = 1;
    for(int i=2; i<=n; i++)
        f = f * i;
    return f;
}

#define     DELAY(n)   for(int i=0; i<n; i++)

int main(){
    // Initialization
    uart_init (0, 0);
    gpio_set_dir(0x0000);

    // External SPM Accelerator
    uart_puts (0, "Monitor SPM Test: ", 18);
    int factorial = fact(5);
    DELAY(100);
    if(factorial==120)
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

