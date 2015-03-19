# Demos for peripherals

 * **test1**: Simple example of peripherals interconnected. This demo 
 runs in Basys2 board
 
 * **test1-vivado**: Vivado project with a test to run in Nexys 4 board.
 
 * **test2-picoblaze-basys2**: Programs to test the set of peripherals 
 connected to the output ports of Picoblaze microcontroller
 

## Demo 1: test1

Demo/test to run in Basys2 Digilent prototype board. This test transfers the 
data set from switches to one peripheral when a button is pressed:

* When BTN0 is pressed the switches value set is copied to the leds
* When BTN1 is pressed the switches value set is copied to the LSB display
* When BTN2 is pressed the switches value set is copied to the MSB display

## Demo 2: test1-vivado

Demo/test to run in Nexys 4 Digilent prototype board.
The peripherals are designed to be connected to 8 bit bus but the Nexys has 
dual display, 16 switches and 16 leds.

The example instantiates two components per peripheral and uses a 32 bits 
seven segments display controller.

Demo description:
 * When BTNU is pressed the values set in switches are copied to the leds
 * When BTNC is pressed 8+2 bits are copied to 2 digits of display:

   - The value is taken from SW7 to SW0.
   - Two display points are taken from SW8 and SW9.
   - The destination display digit is selected using SW15 and SW14.


## Demo 3: test2-picoblaze-basys2

To run this demo you must download Picoblaze microcontroller from Xilinx. 
PicoBlaze processor cores can be downloaded from Xilinx, Inc. at
http://www.xilinx.com/products/intellectual-property/picoblaze.htm

Once you get the files, place them following the next steps

1. Copy *picoblaze-spartan3/Assembler/\** to picoblaze directory
2. Copy *kcpsm3.vhd* to picoblaze directory
3. Copy *KCPSM3.EXE* to picoblaze directory

*KCPSM3.EXE* is the assembler tool. It runs in old DOS shell but it can be
used in Linux by installing *dosbox* emulator.

### Demo 2 programs

If you are using linux to assemble the programs there is a script 
'assembler.sh' in the picoblaze directory. Before run the script, the 'dosbox' 
emulator must be installed in the system. 

The 'assembler.sh' script generates one VHD file for each program assembled 
successfully: outdemo.vhd, indemo.vhd, sdread.vhd and pmoddemo.vhd. The ISE 
project includes a file called 'asmcode.vhd', to use some of the previous VHD 
files you must copy one file as 'asmcode.vhd' in the same directory.

Brief description of the available demo programs:

 * **outdemo.psm**: Test the out ports display and leds. It shows a counter in 
 an infinite loop

 * **indemo.psm**: Test input ports: switches and buttons. The switches values 
are copied 
 to the leds. The number of the button pressed is displayed into LSB digit
 
 * **pmoddemo.psm**: Tries to initialize a SDHC card and shows the result on 
the display
 
 * **sdread.psm**: Reads and shows byte by byte a SDHC card block. It goes 
forward to next byte each time one button is pressed


Peripherals connections:

|Peripheral    |Address|Type       |
|--------------|-------|-----------|
|Switches      |  0x00 |input port |
|Buttons       |  0x03 |input port |
|Leds          |  0x04 |output port|
|LSB display   |  0x08 |output port|
|MSB display   |  0x10 |output port|


### SDHC Card demo

This demo is not fully tested but it seems it works right in basys2 board.

The SD cars has been connected to the board Basys2 with the PMODSD. The 
protocol used is the SPI therefore, only four connections are required. With 
the UCF file supplied you must only connect the 'B' connector of PMOD to the 
'JB' connector of the Basys2. Be carefully with the GND and VCC pins, put them 
in correct side.





