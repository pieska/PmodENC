----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.07.2017 21:44:40
-- Design Name: 
-- Module Name: controller_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rotaryencoder_tb is
--  Port ( );
end rotaryencoder_tb;

architecture Behavioral of rotaryencoder_tb is

component rotaryencoder is
	port (
		clk: in std_logic;
		a: in std_logic;
		b: in std_logic;
		click: out std_logic_vector(1 downto 0) -- 1= left, 0 = right
	);
end component;

signal clk_sim: std_logic;
signal a_sim: std_logic := '1'; -- default 1
signal b_sim: std_logic := '1';	-- default 1
signal click_sim: std_logic_vector(1 downto 0) := "00";

constant clkp:time := 10ns;

begin

	dut: rotaryencoder
	port map (
		clk => clk_sim,
		a => a_sim,
		b => b_sim,
		click => click_sim
	);
	
	clk_gen: process
	begin
		clk_sim <= '0';
		wait for clkp / 2;
		clk_sim <= '1';
		wait for clkp / 2;
	end process clk_gen;	
	
	sim: process
	begin
		-- AB turn right; A1B1 -> A1B0 -> A0B0 -> A0B1 -> A1B1
		wait for clkp*4;
		b_sim <= '0';
		wait for clkp;
		a_sim <= '0';
		wait for clkp;
		b_sim <= '1';
		wait for clkp;
		a_sim <= '1';
		wait for clkp * 2;
		assert click_sim = "01" report "keine rechtsdrehung";
				
		-- AB turn left:  A1B1 -> A0B1 -> A0B0 -> A1B0 -> A1B1
		wait for clkp*4;
		a_sim <= '0';
		wait for clkp;
		b_sim <= '0';
		wait for clkp;
		a_sim <= '1';
		wait for clkp;
		b_sim <= '1';
		wait for clkp * 2;
		assert click_sim = "10" report "keine linksdrehung";

		-- keine komplette rechtsdrehung, sondern zurückgedreht

		-- A1B1 -> A1B0 -> A1B1
		wait for clkp*4;
		b_sim <= '0';
		wait for clkp;
		b_sim <= '1';

		-- A1B1 -> A1B0 -> A0B0 -> A1B0 -> A1B1
		wait for clkp*4;
		b_sim <= '0';
		wait for clkp;
		a_sim <= '0';
		wait for clkp;
		a_sim <= '1';
		wait for clkp;
		b_sim <= '1';

		-- A1B1 -> A1B0 -> A0B0 -> A0B1 -> A0B0 -> A1B0 -> A1B1
		wait for clkp*4;
		b_sim <= '0';
		wait for clkp;
		a_sim <= '0';
		wait for clkp;
		b_sim <= '1';
		wait for clkp;
		b_sim <= '0';
		wait for clkp;
		a_sim <= '1';
		wait for clkp;
		b_sim <= '1';

		wait;
				
	end process sim;


end Behavioral;
