-------------------------------------------------------------------------------
-- Copyright 2014 Paulino Ruiz de Clavijo Vázquez <paulino@dte.us.es>
-- This file is part of the Digilentinc-peripherals project.
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.  
--
-- You can get more info at http://www.dte.us.es/id2
--
--*------------------------------- End auto header, don't touch this line --*--

-- Description: picoblaze demo
--  Port conections using one hot code:
--  + SPI write conf  => in  port 01h
--  + SPI write data  => in  port 02h
--  + SPI read status => in  port 01h
--  + SPI read data   => in  port 02h
--  + Leds peripheral => out port 04h
--  + Display LSB     => out port 08h
--  + Display MSB     => out port 10h
--  + Switches        => in  port 00h
--  + Buttons         => in  port 03h
--   
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.digilent_peripherals_pk.all;

entity dig_peripherals_demo is port(
  clk      : in   std_logic;
  leds_out : out  std_logic_vector (7 downto 0);
  seg_out  : out  std_logic_vector (6 downto 0);
  dp_out   : out  std_logic;
  an_out   : out  std_logic_vector (3 downto 0);
  sw_in    : in   std_logic_vector (7 downto 0);
  btn_in   : in   std_logic_vector (3 downto 0);
    
  miso : in  std_logic; -- PMOD SD
  mosi : out std_logic;
  sclk : out std_logic;
  ss   : out std_logic);

end dig_peripherals_demo;

architecture behavioral of dig_peripherals_demo is

-- declaration of KCPSM3
--
  component kcpsm3 
    port (      address : out std_logic_vector(9 downto 0);
            instruction : in  std_logic_vector(17 downto 0);
                port_id : out std_logic_vector(7 downto 0);
           write_strobe : out std_logic;
               out_port : out std_logic_vector(7 downto 0);
            read_strobe : out std_logic;
                in_port : in  std_logic_vector(7 downto 0);
              interrupt : in  std_logic;
          interrupt_ack : out std_logic;
                  reset : in  std_logic;
                    clk : in  std_logic);
    end component;

component asmcode 
    Port (      address : in  std_logic_vector(9 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                    clk : in  std_logic);
    end component;


------------------------------------------------------------------------------------
--
-- Signals used to connect KCPSM3 to program ROM and I/O logic
--
signal address         : std_logic_vector(9 downto 0);
signal instruction     : std_logic_vector(17 downto 0);
signal port_id         : std_logic_vector(7 downto 0);
signal out_port        : std_logic_vector(7 downto 0);
signal in_port         : std_logic_vector(7 downto 0);
signal write_strobe    : std_logic;
signal read_strobe     : std_logic;
signal interrupt       : std_logic;
signal interrupt_ack   : std_logic;

signal port_display      : std_logic;
signal port_display_wlsb : std_logic;
signal port_display_wmsb : std_logic;

-- SPI port signals
signal port_spi_enable : std_logic;
signal port_spi_op     : std_logic; -- select config/status or data io

-- Input ports multiplexer
signal port_switches : std_logic_vector(7 downto 0);
signal port_buttons  : std_logic_vector(7 downto 0);
signal port_spi      : std_logic_vector(7 downto 0);

begin

  u_processor: kcpsm3
    port map(      address => address,
               instruction => instruction,
                   port_id => port_id,
              write_strobe => write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     reset => '0',
                       clk => clk);
 
  u_asmcode: asmcode
    port map(      address => address,
               instruction => instruction,
                       clk => clk);

  --------------------------------------------
  -- Picoblaze out ports 

  -- Leds connected to port 4

  u_leds: port_leds_dig
      Port  map ( 
     w        => write_strobe,
     enable   => port_id(2),
     clk      => clk,
     port_in  => out_port,
     leds_out => leds_out);


  -- Display needs two ports: LSB and MSB digit. Port 8  and 16
  port_display      <= port_id(3)  or port_id(4);
  port_display_wlsb <= port_id (3) and write_strobe;
  port_display_wmsb <= port_id (4) and write_strobe; 

  u_display : port_display_dig
    port map (
     clk      => clk,
     enable   => port_display,
     digit_in => out_port,
     w_msb    => port_display_wmsb,
     w_lsb    => port_display_wlsb,
     seg_out  => seg_out,
     dp_out   => dp_out,
     an_out   => an_out
    );

  ----------------------------------------
  -- Picoblaze input ports

  with port_id(1 downto 0) select
    in_port <= port_switches when "00",
               port_buttons  when "11",
               port_spi      when others;
    
  
  -- Switches connected to input port 0
  u_switches : port_switches_dig
    port map(
     r            =>  read_strobe,
     clk          =>  clk,
     enable       =>  '1',
     port_out     =>  port_switches,
     switches_in  =>  sw_in);

  -- Buttons on input port 3

  u_buttons : port_buttons_dig
    port map(
     r            => read_strobe,
     clk          => clk,
     enable       => '1',
     port_out     => port_buttons,
     buttons_in   => btn_in);

  
  -- SPI component for PMOD SD
  -- Two ports are used: config (at port 1) and data (at port 2)
  port_spi_enable <= port_id(0) or port_id(1); -- data/conf selector
  port_spi_op     <= port_id(1); -- Write mode

  u_spi: port_spi_dig
      port map ( 
      clk       => clk,
      data_in   => out_port,
      data_out  => port_spi,
      enable    => port_spi_enable,
      rw        => write_strobe,
      cfst_data => port_spi_op,
      miso      => miso,
      mosi      => mosi,
      sclk      => sclk,
      ss        => ss);

end behavioral;

