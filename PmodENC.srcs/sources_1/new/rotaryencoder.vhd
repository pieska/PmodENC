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

entity rotaryencoder is
	port (
		clk: in std_logic;
		a: in std_logic;
		b: in std_logic;
		click: out std_logic_vector(1 downto 0) -- 1= left, 0 = right
	);
end rotaryencoder;

architecture Behavioral of rotaryencoder is

type enc_state_type is (unknown, idle, start_right, start_left, middle_right, middle_left, end_right, end_left);

signal enc_state_reg: enc_state_type := unknown;
signal enc_state_next: enc_state_type;

signal enc_click_reg: std_logic_vector(1 downto 0) := (others => '0');
signal enc_click_next: std_logic_vector(1 downto 0);

signal enc_a_reg: std_logic;
signal enc_b_reg: std_logic;

begin

	upd: process(clk)
	begin
		if rising_edge(clk) then
			-- übernehme input
			enc_a_reg <= a;
			enc_b_reg <= b;
			-- aktualisiere output register
			enc_state_reg <= enc_state_next;
			enc_click_reg <= enc_click_next;		
		end if;
	end process upd;

	fsm: process(enc_state_reg, enc_a_reg, enc_b_reg)
	begin
		-- set defaults
		enc_state_next <= enc_state_reg;
		enc_click_next <= (others => '0');
		
		-- turn right; A1B1 -> B0 -> A0 -> B1 -> A1B1
		-- turn left:  A1B1 -> A0 -> B0 -> A1 -> A1B1

		case enc_state_reg is
			-- unknown state, warte auf detent position (AB="11")
			when unknown =>
				-- warte auf Nullstellung 
				if enc_a_reg = '1' and enc_b_reg = '1' then
					enc_state_next <= idle;
				end if;
			when idle =>
				if enc_b_reg = '0' then	-- drehung nach rechts gestartet
					enc_state_next <= start_right;
				elsif enc_a_reg = '0' then	-- drehung nach links gestartet
					enc_state_next <= start_left;
				end if;
			when start_right =>
				if enc_a_reg = '0' then -- mittelstellung bei rechtsdreh
					enc_state_next <= middle_right;
				elsif enc_b_reg = '1' then	-- zuürckgedreht
					enc_state_next <= idle;
				end if;
			when middle_right =>
				if enc_b_reg = '1' then -- letzte rechtsphase
					enc_state_next <= end_right;
				elsif enc_a_reg = '1' then -- zuürckgedreht
					enc_state_next <= start_right;
				end if;
			when end_right =>
				if enc_a_reg = '1' then -- wieder auf null == 1 rechtsclick
					enc_state_next <= idle;
					enc_click_next(0) <= '1';
				elsif enc_b_reg = '0' then -- zuürckgedreht
					enc_state_next <= middle_right;
				end if;
			when start_left =>
				if enc_b_reg = '0' then	-- mittelstellung bei linkdsdreh
					enc_state_next <= middle_left;
				elsif enc_a_reg = '1' then -- zuürckgedreht
					enc_state_next <= idle;
				end if;
			when middle_left =>
				if enc_a_reg = '1' then -- letzte linksphase
					enc_state_next <= end_left;
				elsif enc_b_reg = '1' then
					enc_state_next <= start_left;	-- zuürckgedreht
				end if;
			when end_left =>
				if enc_b_reg = '1' then -- wieder auf null == 1 leftsclick
					enc_state_next <= idle;
					enc_click_next(1) <= '1';
				elsif enc_a_reg = '0' then -- zuürckgedreht
					enc_state_next <= middle_left;
				end if;
		end case;
		
	end process fsm;

	-- outputs
	click <= enc_click_reg;
	
end Behavioral;
