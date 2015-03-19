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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity port_display_dig is port ( clk : in  std_logic;
  enable    : in std_logic;
  digit_in  : in  std_logic_vector (7 downto 0);
  w_msb     : in  std_logic;
  w_lsb     : in  std_logic;
  seg_out   : out  std_logic_vector (6 downto 0);
  dp_out    : out  std_logic;
  an_out    : out  std_logic_vector (3 downto 0));
end port_display_dig;

architecture Behavioral of port_display_dig is

  signal counter : unsigned (23 downto 0);
  signal counter4: unsigned (1 downto 0);

  signal digit_lsb : std_logic_vector (7 downto 0);
  signal digit_msb : std_logic_vector (7 downto 0);

  signal conv_in : std_logic_vector (3 downto 0);
  signal divider : std_logic;

begin
  -- Writer process
  write_proc : process (clk,enable)
  begin 
   if falling_edge(clk) and enable='1' then 
    if w_msb='1' then
     digit_msb <= digit_in;
    end if;
    if w_lsb='1' then
     digit_lsb <= digit_in;
    end if;
   end if;
  end process;

-- Clock divider process
  div_proc : process (clk,counter)
  begin
   if falling_edge(clk) then
    if(counter > x"0000ffff") then 
     counter <= x"000000";
     divider <= '1';
    else
     counter <= counter + 1;
     divider <= '0';
    end if;
   end if;
  end process;

  div2_proc : process(clk,divider)
  begin 
   if falling_edge(clk) then
    if divider='1' then
     counter4 <= counter4 +1;
    end if;
   end if;
  end process;

  -- Anode control
  mux_proc:  process (counter4,digit_lsb,digit_msb) 
    begin
      case counter4 is
      when "00" =>
        an_out <= "1110";
    conv_in <= digit_lsb(3 downto 0);
      when "01" =>
        an_out <= "1101";
    conv_in <= digit_lsb(7 downto 4);
      when "10" =>
        an_out <= "1011";
    conv_in <= digit_msb(3 downto 0);
      when others => 
        an_out <= "0111";
    conv_in <= digit_msb(7 downto 4);
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
  dp_out <= '1';
end Behavioral;

