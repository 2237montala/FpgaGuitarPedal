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

COMPONENT audioInTest
	port (
		reg_clk     : in  std_logic                     := '0';             --       control_clock.clk
		reg_reset   : in  std_logic                     := '0';             -- control_clock_reset.reset
		aes_clk     : in  std_logic                     := '0';             --   conduit_aes_audio.export
		aes_de      : in  std_logic                     := '0';             --                    .export
		aes_ws      : in  std_logic                     := '0';             --                    .export
		aes_data    : in  std_logic                     := '0';             --                    .export
		aud_clk     : in  std_logic                     := '0';             --          dout_clock.clk
		reset       : in  std_logic                     := '0';             --    dout_clock_reset.reset
		aud_ready   : in  std_logic                     := '0';             --                dout.ready
		aud_valid   : out std_logic;                                        --                    .valid
		aud_sop     : out std_logic;                                        --                    .startofpacket
		aud_eop     : out std_logic;                                        --                    .endofpacket
		aud_channel : out std_logic_vector(7 downto 0);                     --                    .channel
		aud_data    : out std_logic_vector(23 downto 0);                    --                    .data
		channel0    : in  std_logic_vector(7 downto 0)  := (others => '0'); --     conduit_control.export
		channel1    : in  std_logic_vector(7 downto 0)  := (others => '0'); --                    .export
		fifo_status : out std_logic_vector(7 downto 0);                     --                    .export
		fifo_reset  : in  std_logic                     := '0'              --                    .export
	);
end COMPONENT;

COMPONENT outAudioTest
	port (
		reg_clk     : in  std_logic                     := '0';             --       control_clock.clk
		reg_reset   : in  std_logic                     := '0';             -- control_clock_reset.reset
		aud_clk     : in  std_logic                     := '0';             --           din_clock.clk
		reset       : in  std_logic                     := '0';             --     din_clock_reset.reset
		aud_ready   : out std_logic;                                        --                 din.ready
		aud_valid   : in  std_logic                     := '0';             --                    .valid
		aud_sop     : in  std_logic                     := '0';             --                    .startofpacket
		aud_eop     : in  std_logic                     := '0';             --                    .endofpacket
		aud_channel : in  std_logic_vector(7 downto 0)  := (others => '0'); --                    .channel
		aud_data    : in  std_logic_vector(23 downto 0) := (others => '0'); --                    .data
		aes_clk     : in  std_logic                     := '0';             --   conduit_aes_audio.export
		aes_de      : out std_logic;                                        --                    .export
		aes_ws      : out std_logic;                                        --                    .export
		aes_data    : out std_logic;                                        --                    .export
		channel0    : in  std_logic_vector(7 downto 0)  := (others => '0'); --     conduit_control.export
		channel1    : in  std_logic_vector(7 downto 0)  := (others => '0'); --                    .export
		fifo_status : out std_logic_vector(7 downto 0);                     --                    .export
		fifo_reset  : in  std_logic                     := '0'              --                    .export
	);
end COMPONENT;

component volume_control is


end component;



component gain_control is

end component;


component distortion is


end component;


begin




end  my_structure;
