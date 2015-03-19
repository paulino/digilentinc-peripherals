# Set of peripherals for Digilent Inc. boards

Set of basic peripherals controllers for
Basys and Nexys Digilent Inc. boards.

The goal is a set of peripherals to easily connect to embedded microcontrollers 
with a 8 bits bus width.

The controllers included are:

 * Buttons controller
 * Leds controller
 * Switches controller
 * Display controller. Two versions, 16bits for Nexys2 and 32 bits from Nexys4

Tested boards:

 * Basys 2
 * Nexys 2
 * Nexys 4
 

A functional description is available at doc directory.

## Contents

rtl directory contains peripherals, examples directory contais two examples:

 1. *test1-basys*: simple example of connections
 2. *test1-picoblaze*: connection of the peripherals to picoblaze 
microcontroller
 
See README.md at examples directory.

