--Top Level
 --Group 4
 --guitar pedal(s)
 --anthony, aj, mark

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GuitarPedalTopLevel is 
	port(
			clk_50: in std_logic;
			reset : in std_logic;
			AUD_ADCLRCK: in std_logic;
			AUD_ADCDAT: in std_logic;
			AUD_DACLRCK : in std_logic;
			AUD_DACDAT: out std_logic;
			AUD_XCK: out std_logic;
			AUD_BCLK: in std_logic;
			I2C_SCLK: out std_logic;
			I2C_SDAT: inout std_logic
		);
end GuitarPedalTopLevel;

architecture my_structure of GuitarPedalTopLevel is

	-- Component for taking in audio and output it
	-- https://class.ece.uw.edu/271/hauck2/de1/audio/Audio_Tutorial.pdf
	COMPONENT audio_driver
		port (
			CLOCK_50 : in std_logic;
			reset : in std_logic;
			
			-- I2C config
			FPGA_I2C_SCLK : out std_logic;
			FPGA_I2C_SDAT : inout std_logic;
			
			-- Audio codec
			AUD_XCK : out std_logic;
			AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK : in std_logic;
			AUD_ADCDAT : in std_logic;
			AUD_DACDAT : out std_logic;

			-- Audio data
			dac_left, dac_right : in std_logic_vector(23 downto 0);
			adc_left, adc_right : out std_logic_vector(23 downto 0);
			advance : out std_logic
		);
	end COMPONENT;
	
	

--component volume_control is
--
--
--end component;
--
--
--
--component gain_control is
--
--end component;
--
--
--component distortion is
--
--
--end component;

	signal audioInBuffL: std_logic_vector(23 downto 0);
	signal audioInBuffR: std_logic_vector(23 downto 0);

	signal audioOutBuffR: std_logic_vector(23 downto 0);
	signal audioOutBuffL: std_logic_vector(23 downto 0);
	signal audioReady : std_logic;

	signal resetButton : std_logic;
		
begin 

	-- Create a audio driver entity to handle the audio chip
	audioDriver : audio_driver
		port map(
			CLOCK_50 => clk_50,
			reset => resetButton,
			FPGA_I2C_SCLK => I2C_SCLK,
			FPGA_I2C_SDAT => I2C_SDAT,
			AUD_XCK => AUD_XCK,
			AUD_DACLRCK => AUD_DACLRCK,
			AUD_ADCLRCK => AUD_ADCLRCK,
			AUD_BCLK => AUD_BCLK,
			AUD_ADCDAT => AUD_ADCDAT,
			AUD_DACDAT => AUD_DACDAT,
			dac_left => audioOutBuffL,
			dac_right => audioOutBuffR,
			adc_left => audioInBuffL,
			adc_right => audioInBuffR,
			advance => audioReady
		);

	-- DE1-SOC board key buttons are active low so invert it
	resetButton <= not reset;
	
	process(audioReady)
	begin
		-- When data is asserted move data from the in buffer
		-- to the out buffer
		audioOutBuffL <= audioInBuffL;
		audioOutBuffR <= audioInBuffR;
	end process;
end  my_structure;
