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

entity port_switches_dig is port (
  r            : in  std_logic;
  clk          : in  std_logic;
  enable       : in  std_logic;
  port_out     : out std_logic_vector (7 downto 0);
  switches_in  : in  std_logic_vector (7 downto 0));
end port_switches_dig;

architecture behavioral of port_switches_dig is
  begin
  read_proc: process(clk)
  begin
    if falling_edge(clk) and enable='1' and r='1' then
      port_out <= switches_in;
    end if;
  end process;

end behavioral;

