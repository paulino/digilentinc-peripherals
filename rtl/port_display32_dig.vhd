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

-- Nexyys4 brings a dual display where 4 bytes can be displayes
-- This module defines a 8+2 bits inputs 


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.digilent_peripherals_pk.all;

entity port_display32_dig is port (
  clk       : in  std_logic;
  reset     : in  std_logic;
  enable    : in  std_logic;
  w         : in  std_logic;
  digit_in  : in  std_logic_vector (7 downto 0);
  dp_in     : in  std_logic_vector (1 downto 0);
  byte_sel  : in  std_logic_vector (1 downto 0);
  
  seg_out   : out std_logic_vector (6 downto 0);
  dp_out    : out std_logic;
  an_out    : out std_logic_vector (7 downto 0));
end port_display32_dig;

architecture Behavioral of port_display32_dig is

  signal counter : unsigned (23 downto 0);
  signal counter8 : unsigned (2 downto 0);

  signal digits  : std_logic_vector (31 downto 0);
  signal dps     : std_logic_vector (7 downto 0);

  signal conv_in : std_logic_vector (3 downto 0);
  signal divider : std_logic;
  signal dp_inter_out : std_logic;

begin

  dp_out <= not dp_inter_out;
  
  -- Writer process
  write_proc : process (clk,enable,byte_sel,w)
  begin 
   if falling_edge(clk) and enable='1' and w='1' then
    case byte_sel is
        when "00" =>
            digits(7 downto 0)  <= digit_in(7 downto 0);
            dps(1 downto 0) <= dp_in;
        when "01" =>
            digits(15 downto 8) <= digit_in(7 downto 0);
            dps(3 downto 2) <= dp_in;
        when "10" =>
            digits(23 downto 16)<= digit_in(7 downto 0);
            dps(5 downto 4) <= dp_in;
        when others =>
            digits(31 downto 24)<= digit_in(7 downto 0);
            dps(7 downto 6) <= dp_in;
    end case;
   end if;
  end process;

-- Clock divider process
  div_proc : process (clk,counter,reset)
  begin
   if falling_edge(clk) then
    if counter > NEXYS4_DIVIDER or reset = '1'  then 
     counter <= x"000000";
     divider <= '1';
    else
     counter <= counter + 1;
     divider <= '0';
    end if;
   end if;
  end process;
  
  div2_proc : process(clk,divider,reset)
  begin 
   if falling_edge(clk) then
    if reset = '1' then
      counter8 <= "000";
    elsif divider='1' then
      counter8 <= counter8 +1;
    end if;
   end if;
  end process;
  
    
    
  mux_anod : process (counter8) 
  begin
    case counter8 is 
      when "000" =>
        conv_in <= digits(3 downto 0);
        dp_inter_out <= dps(0);
        an_out <= "11111110";
      when "001" =>
        conv_in <= digits(7 downto 4);
        dp_inter_out <= dps(1);
        an_out <= "11111101";
      when "010" =>
        conv_in <= digits(11 downto 8);
        dp_inter_out <= dps(2);
        an_out <= "11111011";
      when "011" =>
        conv_in <= digits(15 downto 12);
        dp_inter_out <= dps(3);
        an_out <= "11110111";
      when "100" =>
        conv_in <= digits(19 downto 16);
        dp_inter_out <= dps(4);
        an_out <= "11101111";
      when "101" =>
        conv_in <= digits(23 downto 20);
        dp_inter_out <= dps(5);
        an_out <= "11011111";
      when "110" =>
        conv_in <= digits(27 downto 24);
        dp_inter_out <= dps(6);
        an_out <= "10111111";
      when others =>
        conv_in <= digits(31 downto 28);
        dp_inter_out <= dps(7);
        an_out <= "01111111";
    end case;
  end process;
                                
   -- Binary to seven seg converter
   with conv_in select 
   seg_out <= "1000000" when "0000", --0 
    "1111001" when "0001",  --1 
    "0100100" when "0010",  --2 
    "0110000" when "0011",  --3 
    "0011001" when "0100",  --4 
    "0010010" when "0101",  --5 
    "0000010" when "0110",  --6 
    "1111000" when "0111",  --7 
    "0000000" when "1000",  --8 
    "0010000" when "1001",  --9 
    "0001000" when "1010",  --A 
    "0000011" when "1011",  --b 
    "1000110" when "1100",  --C 
    "0100001" when "1101",  --d 
    "0000110" when "1110",  --E 
    "0001110" when others;  --F 
  
end Behavioral;

