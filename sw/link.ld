/*
# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0
*/

ENTRY(_start)

MEMORY
{
    FLASH (x) :
        ORIGIN = 0x0
        LENGTH = 1M
    SRAM (rwx) :
        ORIGIN = 0x20000000,
        LENGTH = 12K
    stack (rw):
        ORIGIN = 0x20000000 + 8K
        LENGTH = 4K
}

PROVIDE(_fstack = ORIGIN(stack) + LENGTH(stack) - 4);

SECTIONS
{
    .text : {
        *(.text*)
        *(.rodata*)
        . = ALIGN(8);
        __idata__ = .;
    } > FLASH
    
    .bss (NOLOAD) :
    {
        __bss_start__ = .;
        *(.bss*)
        *(COMMON)
        __bss_end__ = .;
    } > SRAM

    .data : 
    {
        __data_start__ = .;
        *(.data*);
        __data_end__ = .;
        
    } > SRAM AT > FLASH

}

