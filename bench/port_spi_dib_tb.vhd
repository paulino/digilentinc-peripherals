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

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.b2_peripherals_pk.all;
 
ENTITY port_spi_basys2_tb IS
END port_spi_basys2_tb;
 
ARCHITECTURE behavior OF port_spi_basys2_tb IS 
 
   -- Component Declaration for the Unit Under Test (UUT)
	
   -- Inputs
   signal clk : std_logic := '0';
   signal enable : std_logic := '0';
   signal data_in : std_logic_vector(7 downto 0) := (others => '0');
   signal cfst_data : std_logic := '0';
	signal rw : std_logic;
   signal miso : std_logic := '0';

 	--Outputs
   signal data_out : std_logic_vector(7 downto 0);
   
   signal mosi : std_logic;
   signal sclk : std_logic;
   signal ss : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: port_spi_basys2 PORT MAP (
          clk => clk,
          enable => enable,
          data_in => data_in,
          data_out => data_out,
          cfst_data => cfst_data,
          rw => rw,
          miso => miso,
          mosi => mosi,
          sclk => sclk,
          ss => ss
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin
   	data_in   <= "00000000"; -- set clock to ext_clk/2
		enable    <= '0';
		cfst_data <= '0'; 
		rw 		 <= '0';
		miso      <= '0';				
		enable    <= '0';     		
		wait for clk_period*10;
		
		
		
		-- writing config
		wait until rising_edge(clk); 
		data_in   <= "10000001"; -- set clock to ext_clk/2, rise ss
		enable    <= '0';		
		miso      <= '0';		
		enable    <= '1';  		
		rw 		 <= '1';
		cfst_data <= '0';
		wait until rising_edge(clk);
		enable    <= '0';		
		wait until rising_edge(clk);
		
		
		wait for clk_period*8;
		
		
		-- Try fall ss
		wait until rising_edge(clk);
		data_in(7) <= '0';
		enable    <= '1';  		
		rw 		 <= '1';
		cfst_data <= '0';
		wait until rising_edge(clk);
		enable <= '0';
		
		wait for clk_period*10;
				
		-- Sendind data
		wait until rising_edge(clk);
		data_in     <= "10011001";
		enable 		<= '1'; -- 
		cfst_data 	<= '1'; -- write data
		rw 		 	<= '1';
		wait until rising_edge(clk);
		enable      <= '0';
		rw 		 	<= '0'; -- Data written
		
		wait until rising_edge(clk);
		miso      <= '1';
      wait until rising_edge(clk);
		enable     <='0';
		wait until rising_edge(clk);
		miso      <= '0';		
		wait until rising_edge(clk);
		miso      <= '1';
		wait until rising_edge(clk);
		miso      <= '1';
		
		
		wait for clk_period*50; -- reading data in
		wait until rising_edge(clk);
		enable 		<= '1'; -- 
		cfst_data 	<= '1'; -- data access
		rw 		 	<= '0';		
		wait until rising_edge(clk);
		enable      <= '0';
		rw 		 	<= '0'; -- readed

      wait;
   end process;

END;
