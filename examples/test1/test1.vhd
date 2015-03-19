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
-- Description: Demo/test to run in Basys2 Digilent prototype board.
-- This test transfers the data set from switches to one peripheral when a
-- button is pressed:
--   - When BTN0 is pressed the switches value set is copied to the leds
--   - When BTN1 is pressed the switches value set is copied to the LSB display
--   - When BTN2 is pressed the switches value set is copied to the MSB display
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.ALL;
use work.digilent_peripherals_pk.all;

entity demo1_digilent is
 port(
    clk      : in   std_logic;
    leds_out : out  std_logic_vector (7 downto 0);
    seg_out  : out  std_logic_vector (6 downto 0);
    dp_out   : out  std_logic;
    an_out   : out  std_logic_vector (3 downto 0);
    sw_in    : in   std_logic_vector (7 downto 0);
    btn_in   : in   std_logic_vector (3 downto 0)
    );

end demo1_digilent;

architecture behavioral of demo1_digilent is

  -- Internal signals
  signal port_display_enable : std_logic;
  signal port_switches_out : std_logic_vector(7 downto 0);
  signal port_buttons_out  : std_logic_vector(7 downto 0);

  begin

  -- leds
  u_leds: port_leds_dig port map ( 
    clk      => clk,
    enable   => '1',
    w        => port_buttons_out(0),
    port_in  => port_switches_out,
    leds_out => leds_out);

  -- Display enabled when BTN1 ot BNT2 is pressed
  port_display_enable <= port_buttons_out(1) or port_buttons_out(2);

  u_display : port_display_dig port map (
    clk      => clk,
    enable   => port_display_enable,
    digit_in => port_switches_out,
    w_msb    => port_buttons_out(2),
    w_lsb    => port_buttons_out(1),
    seg_out  => seg_out,
    dp_out   => dp_out,
    an_out   => an_out
  );

  -- Switches 
  u_switches : port_switches_dig port map(
    clk          =>  clk,
    enable       =>  '1',
    r            =>  '1',
    port_out     =>  port_switches_out,
    switches_in  =>  sw_in);

  -- Buttons
  u_buttons : port_buttons_dig port map(
    clk        => clk,
    enable     => '1',
    r          => '1',
    port_out   => port_buttons_out,
    buttons_in => btn_in);

end behavioral;

