--Top Level
 --Group 4
 --guitar pedal(s)
 --anthony, aj, mark
 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity GuitarPedalTopLevel is 
	port(
	audio_in: in std_logic;--might be different than std_lgoic
	clk_50: in std_logic;
	adjust_one: in std_logic;
	adjust_two: in std_logic;
	AUD_ADCLRCK: in std_logic;
	AUD_ADCDAT: in std_logic;
	AUD_DACDAT: out std_logic;
	AUD_XCX: in std_logic;
	AUD_BCLK: in std_logic;
	I2C_SCLK: in std_logic;
	I2C_SDAT: in std_logic;
	audio_out: out std_logic --might be different than std logic
	);
end GuitarPedalTopLevel;

architecture my_structure of GuitarPedalTopLevel is

component volume_control is


end component;



component gain_control is

end component;


component distortion is


end component;


begin




end  my_structure;
