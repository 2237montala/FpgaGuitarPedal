--this is the entity of the delay for our FPGA course final project

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity delay_pedal is 
port(
	clk: in std_logic;
	delay_time: in std_logic;
	--effect_gain: in std_logic_vector(2 downto 0);
	--attenuation: in std_logic_vector(3 downto 0);-- might not need FIR filter might do this
	wave_in: in std_logic_vector(23 downto 0);
	wave_out: out std_logic_vector(23 downto 0)
	);
end delay_pedal;

signal prev_out: std_logic_vector(23 downto 0);
integer effect_gain := 2;
architecture delay of delay_pedal is 
wave_out <= wave_in + prev_out/2;


	






end delay;