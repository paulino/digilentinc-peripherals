----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2015 09:34:55
-- Design Name: 
-- Module Name: port_display32_dig_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.digilent_peripherals_pk.all;

entity port_display32_dig_tb is
end port_display32_dig_tb;

architecture Behavioral of port_display32_dig_tb is

signal clk,w,enable,dp_out,reset : std_logic;
signal byte_sel : std_logic_vector(1 downto 0);
signal digit_in : std_logic_vector(7 downto 0);
signal dp_in    : std_logic_vector(1 downto 0);
signal seg_out  : std_logic_vector(6 downto 0);    
signal an_out   : std_logic_vector(7 downto 0);
   
-- Clock period definitions
constant clk_period : time := 10 ns;

begin

  -- Display, 8 bits are written from switches
  u_display : port_display32_dig port map (
    clk      => clk,
    w        => w,
    enable   => enable,
    byte_sel => byte_sel,   
    digit_in => digit_in,
    dp_in    => dp_in,
    seg_out  => seg_out,
    dp_out   => dp_out,
    an_out   => an_out,
    reset    => reset
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
    enable   <= '0'; 
    w        <= '0';
    reset    <= '1';
    wait for clk_period*5;
    reset <= '0';
    
    wait until rising_edge(clk);
    digit_in <= x"F0";
    dp_in    <= "01";
    byte_sel <= "00";
    w <= '1';
    enable <= '1';
    wait until rising_edge(clk);
    digit_in <= x"E0";
    dp_in    <= "10";
    byte_sel <= "01";
    wait until rising_edge(clk);
    digit_in <= x"D0";
    dp_in    <= "11";
    byte_sel <= "10";
    wait until rising_edge(clk);
    digit_in <= x"70";
    dp_in    <= "11";
    byte_sel <= "11";
    wait until rising_edge(clk);
    
    enable <= '0';
    w      <= '0';
    wait for 1000 ms;
  end process;
end Behavioral;
