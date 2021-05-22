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


`timescale 1ns/1ps
`default_nettype none

module GPIO (
		// Wrapper ports
		output 	wire [`GPIO_PINS-1:0] WGPIODIN,
        input 	wire [`GPIO_PINS-1:0] WGPIODOUT,
        input 	wire [`GPIO_PINS-1:0] WGPIOPU,
        input 	wire [`GPIO_PINS-1:0] WGPIOPD,
        input 	wire [`GPIO_PINS-1:0] WGPIODIR,		
		// Externals
        input 	wire [`GPIO_PINS-1:0] GPIOIN,
        output 	wire [`GPIO_PINS-1:0] GPIOOUT,
        output 	wire [`GPIO_PINS-1:0] GPIOPU,
        output 	wire [`GPIO_PINS-1:0] GPIOPD,
        output 	wire [`GPIO_PINS-1:0] GPIOOEN		
);
		assign GPIOOEN 	= WGPIODIR;
		assign GPIOPU 	= WGPIOPU;
		assign GPIOPD 	= WGPIOPD;
		assign GPIOOUT	= WGPIODOUT;
		assign WGPIODIN = GPIOIN;
endmodule