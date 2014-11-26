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

package digilent_peripherals_pk is

  component port_leds_dig port (
    w         : in  std_logic;
    clk       : in  std_logic;
    enable    : in  std_logic;
    port_in   : in  std_logic_vector (7 downto 0);
    leds_out  : out std_logic_vector (7 downto 0));
  end component;

  component port_buttons_dig port ( 
    r          : in  std_logic;
    clk        : in  std_logic;
    enable     : in  std_logic;
    port_out   : out std_logic_vector (7 downto 0);
    buttons_in : in  std_logic_vector (3 downto 0));
  end component;

  component port_switches_dig port (
    r           : in  std_logic;
    clk         : in  std_logic;
    enable      : in  std_logic;
    port_out    : out std_logic_vector (7 downto 0);
    switches_in : in  std_logic_vector (7 downto 0));
  end component;

  component port_display_dig is port (
    clk      : in  std_logic;
    enable   : in  std_logic;
    digit_in : in  std_logic_vector (7 downto 0);
    w_msb    : in  std_logic;
    w_lsb    : in  std_logic;
    seg_out  : out std_logic_vector (6 downto 0);
    dp_out   : out std_logic;
    an_out   : out std_logic_vector (3 downto 0));
  end component;

  component port_spi_dig is port (
    clk       : in  std_logic; 
    data_in   : in  std_logic_vector (7 downto 0);
    data_out  : out std_logic_vector (7 downto 0);
    enable    : in  std_logic;
    rw        : in  std_logic; -- 0: read / 1: write
    cfst_data : in  std_logic; -- 0: cfg/status access, 1: data access
    miso      : in  std_logic;
    mosi      : out std_logic;
    sclk      : out std_logic;
    ss        : out std_logic);
  end component;
end package;