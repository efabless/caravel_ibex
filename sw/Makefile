# SPDX-FileCopyrightText: 2020 Mohamed Shalan
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0


gcc_path := /usr/local/opt/riscv-gnu-toolchain/bin
name ?= test

%.hex: $(name).c n5_drv.c crt0.S link.ld
	$(gcc_path)/riscv64-unknown-elf-gcc -Wall  -falign-functions=4 -march=rv32ic -mabi=ilp32 -nostdlib -mstrict-align -T link.ld -o $(name).elf -lgcc crt0.S n5_drv.c $(name).c  -lgcc
	$(gcc_path)/riscv64-unknown-elf-objcopy -O binary $(name).elf $(name).bin
	$(gcc_path)/riscv64-unknown-elf-objcopy -O verilog $(name).elf $(name).hex
	$(gcc_path)/riscv64-unknown-elf-objdump -D $(name).elf > $(name).lst

all: $(name).hex