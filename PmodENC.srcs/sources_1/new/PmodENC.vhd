----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.07.2017 21:08:53
-- Design Name: 
-- Module Name: controller - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PmodENC is
	port (
		clk: in std_logic;
		pmod_j1: in std_logic_vector(3 downto 0);	-- 0=A, 1=B, 2=BTN, 3=SWT 
		btn: out std_logic;
		swt: out std_logic;
		click: out std_logic_vector(1 downto 0) -- 1= left, 0 = right
	);
end PmodENC;

architecture Behavioral of PmodENC is

component debounce
	generic (
		cntr_size: integer := 11
	);
    port (
    	clk : in STD_LOGIC;
    	data_in : in STD_LOGIC;
    	data_deb : out STD_LOGIC
    );
end component;

component rotaryencoder is
	port (
		clk: in std_logic;
		a: in std_logic;
		b: in std_logic;
		click: out std_logic_vector(1 downto 0) -- 1= left, 0 = right
	);
end component;

type enc_state_type is (unknown, idle, start_right, start_left, middle_right, middle_left, end_right, end_left);

signal enc_state_reg: enc_state_type := unknown;
signal enc_state_next: enc_state_type;

signal enc_click_reg: std_logic_vector(1 downto 0) := (others => '0');
signal enc_click_next: std_logic_vector(1 downto 0);

signal enc_a_reg: std_logic;
signal enc_b_reg: std_logic;
signal enc_btn_reg: std_logic;
signal enc_swt_reg: std_logic;

begin

	-- debounce a
	debounce_a: debounce
	port map (
		clk => clk,
		data_in => pmod_j1(0),
		data_deb => enc_a_reg
	);

	-- debounce b
	debounce_b: debounce
	port map (
		clk => clk,
		data_in => pmod_j1(1),
		data_deb => enc_b_reg
	);

	-- debounce btn
	debounce_btn: debounce
	port map (
		clk => clk,
		data_in => pmod_j1(2),
		data_deb => enc_btn_reg
	);

	-- debounce swt
	debounce_swt: debounce
	port map (
		clk => clk,
		data_in => pmod_j1(3),
		data_deb => enc_swt_reg
	);

	-- rotaryancoder
	rotenc: rotaryencoder
	port map (
		clk => clk,
		a => enc_a_reg,
		b => enc_b_reg,
		click => click
	);

	btn <= enc_btn_reg;
	swt <= enc_swt_reg;
	
end Behavioral;
