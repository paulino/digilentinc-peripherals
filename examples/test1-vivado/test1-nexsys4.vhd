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
--
-- Description: Demo/test to run in Nexsys 4 Digilent prototype board.
-- This test transfers the data set from switches to one peripheral when a
-- button is pressed:
--   - When BTNU is pressed the value set in switches is copied to the leds
--   - When BTNC is pressed 8+2 bits are copied to 2 digits of display:
--      The value is taken from SW7 to SW0
--      Two display points are taken from SW8 and SW9
--      The destination display digit is selected using SW15 and SW14 
--
--

--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.ALL;
use work.digilent_peripherals_pk.all;

entity demo1_nexys4 is
 port(
    clk      : in   std_logic;
    leds_out : out  std_logic_vector (15 downto 0);
    seg_out  : out  std_logic_vector (6 downto 0);
    dp_out   : out  std_logic;
    an_out   : out  std_logic_vector (7 downto 0);
    sw_in    : in   std_logic_vector (15 downto 0);

    btnu_in  : in std_logic;  
    btnr_in  : in std_logic;
    btnl_in  : in std_logic;
    btnd_in  : in std_logic;
    btnc_in  : in std_logic
    );

end demo1_nexys4;

architecture behavioral of demo1_nexys4 is

  -- Internal signals
  signal port_display_enable : std_logic;
  signal port_switches_out   : std_logic_vector(15 downto 0);
  signal port_buttons_out    : std_logic_vector(7 downto 0);
  

  begin
       

  -- leds MSB 8 leds, LSB 8 leds
  u_leds_msb: port_leds_dig port map ( 
    clk      => clk,
    enable   => '1',
    w        => port_buttons_out(0), -- BTNU
    port_in  => port_switches_out(15 downto 8),
    leds_out => leds_out(15 downto 8));
  
  u_led_lsb: port_leds_dig port map ( 
    clk      => clk,
    enable   => '1',
    w        => port_buttons_out(0), -- BTNU
    port_in  => port_switches_out(7 downto 0),
    leds_out => leds_out(7 downto 0));


  -- Display, 8 bits are written from switches
  u_display : port_display32_dig port map (
    reset    => '0',
    clk      => clk,
    w        => port_buttons_out(4), -- BTNC
    enable   => '1',
    byte_sel => port_switches_out(15 downto 14),   
    digit_in => port_switches_out(7 downto 0),
    dp_in    => port_switches_out(9 downto 8),
    seg_out  => seg_out,
    dp_out   => dp_out,
    an_out   => an_out(7 downto 0)
  );
  

  -- Switches 8 bits 
  u_switches_lsb : port_switches_dig port map(
    clk          =>  clk,
    enable       =>  '1',
    r            =>  '1',
    port_out     =>  port_switches_out(7 downto 0),
    switches_in  =>  sw_in(7 downto 0));
    
  u_switches_msb : port_switches_dig port map(
    clk          =>  clk,
    enable       =>  '1',
    r            =>  '1',
    port_out     =>  port_switches_out(15 downto 8),
    switches_in  =>  sw_in(15 downto 8)
    );
    
  -- Buttons
  u_buttons : port_buttons_nexsys4 port map(
    clk        => clk,
    enable     => '1',
    r          => '1',
    btnu_in    =>  btnu_in,  
    btnr_in    =>  btnr_in,
    btnl_in    =>  btnl_in,
    btnd_in    =>  btnd_in,
    btnc_in    =>  btnc_in,    
    port_out   =>  port_buttons_out
    );

end behavioral;

