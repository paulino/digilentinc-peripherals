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

entity port_spi_dig is port (
  clk    : in std_logic;
  enable : in std_logic;
  
  data_in  : in  std_logic_vector (7 downto 0);
  data_out : out std_logic_vector (7 downto 0);
  rw       : in  std_logic;  -- 0: read / 1: write
  cfst_data: in  std_logic;  -- 0: cfg/status access, 1: data access
        
  miso    : in  std_logic;
  mosi    : out std_logic;
  sclk    : out std_logic;
  ss      : out std_logic);
end port_spi_dig;


architecture behavioral of port_spi_dig is

-- Configuration/control flags
constant SS_F        : positive := 7; -- bit 7
constant CDIV_MSB_F  : positive := 2; -- bits 2 - 0

signal clkdiv_flag  : std_logic_vector (CDIV_MSB_F downto 0); 
signal ss_flag       : std_logic; 

-- Status flags for reading
constant SND_F        : positive := 7; -- Sending flag:   bit 7
constant DR_F         : positive := 6; -- Dataready flag: bit 6
constant SCLK_F       : positive := 5; -- SCLK flag: bit 5

signal sending_flag : std_logic; 
signal dready_flag  : std_logic; 
signal sclk_flag    : std_logic; 

-- IO regs
signal data_out_reg : std_logic_vector (7 downto 0);
signal data_in_reg  : std_logic_vector (7 downto 0);

-- internal decoded signals 

signal w_conf : std_logic;
signal w_data : std_logic;
signal r_data : std_logic;
signal r_status : std_logic;

-- Internal counters

signal counter8    : unsigned (2 downto 0); -- bit send counter
signal counter_div : unsigned (7 downto 0); -- CLK Divider

begin

-- Decoding internal signals 
w_conf   <= enable and not cfst_data and rw;
r_status <= enable and not cfst_data and not rw;
w_data   <= enable and cfst_data and rw;
r_data   <= enable and cfst_data and not rw;

-- IO Conections
mosi <= data_out_reg(7);
ss   <= ss_flag;
sclk <= sclk_flag;

-- Sending process
send_proc : process (clk)
begin  
  if falling_edge(clk) then
    -- Read, after read data ready flag is cleared
    if r_status = '1' then
      data_out(SND_F)  <= sending_flag;
      data_out(DR_F)   <= dready_flag;
      data_out(SCLK_F) <= sclk_flag;
    elsif r_data = '1' then
      data_out    <= data_in_reg;
      dready_flag <= '0';
    end if;  
    
    -- Sending process;
    if w_conf='1' then  -- Writing config, break current sending process
      sending_flag <= '0';
      dready_flag  <= '0';
      clkdiv_flag  <= data_in(CDIV_MSB_F downto 0);
      ss_flag      <= data_in(SS_F);
      sclk_flag    <='1';      
      counter8     <= "000";
      counter_div  <= "00000000";
      data_out_reg <= "00000000";
    elsif w_data='1' then
      data_out_reg  <= data_in;
      sending_flag  <= '1';
      dready_flag   <= '0';
      counter8      <= "000";
      counter_div   <= "00000000";
      sclk_flag     <= '0'; -- start clock
    elsif sending_flag='1' then
      counter_div  <= counter_div + 1;
      if (clkdiv_flag(2)='1' and counter_div(6)='1') or
        (clkdiv_flag(1)='1' and counter_div(2)='1') or
        (clkdiv_flag(0)='1' and counter_div(0)='1')  then
        counter_div <= "00000000";
        if sclk_flag='0' then -- Data is captured by slave at rising edge
          data_in_reg  <= data_in_reg(6 downto 0) & miso;
          sclk_flag <='1';
        else 
          if counter8 = "111" then
            sending_flag <= '0';
            dready_flag  <= '1';
            sclk_flag    <='1';
          else
            sclk_flag    <='0';
          end if;             
          counter8     <= counter8 + 1;
          data_out_reg <= data_out_reg(6 downto 0) & data_out_reg(0);
        end if;
      end if;    
    end if;
  end if;
end process;
end behavioral;

