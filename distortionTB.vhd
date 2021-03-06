LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity distortionTB    is
end distortionTB  ;


architecture my_tb of distortionTB is

COMPONENT distortion_pedal
	port(
		clk: in std_logic;
		audioUpdate: in std_logic;
		audioLeftIn : in std_logic_vector(23 downto 0);
		audioRightIn : in std_logic_vector(23 downto 0);
		audioLeftOut : out std_logic_vector(23 downto 0);
		audioRightOut : out std_logic_vector(23 downto 0);
		reset : in std_logic
		);
end COMPONENT;


signal clk_i, reset_i : std_logic; 
signal audioClk : std_logic;
signal audioLeftInTb : std_logic_vector(23 downto 0);
signal audioRightInTb : std_logic_vector(23 downto 0);
signal audioLeftOutTb : std_logic_vector(23 downto 0);
signal audioRightOutTb : std_logic_vector(23 downto 0);

begin

dut : distortion_pedal
    port map(
	clk => clk_i,
	audioUpdate => audioClk,
	audioLeftIn => audioLeftInTb,
	audioRightIn => audioRightInTb,
	audioLeftOut => audioLeftOutTb,
	audioRightOut => audioRightOutTb,
	reset => reset_i
    );

-- (2) process to generate clock signal;
clk_gen : process
    begin
	clk_i <= '0'; wait for 10 ns;
	clk_i <= '1'; wait for 10 ns;
end process clk_gen;

audioClkGen : process
    begin
	audioClk <= '0'; wait for 10.5 us;
	audioClk <= '1'; wait for 10.5 us;
end process audioClkGen;

test : process
begin

    -- Reset system
    reset_i <= '1';
    audioLeftInTb <= x"000000";
    audioRightInTb <= x"000000";
    wait for 10 us;

    -- Create a for loop to fill the fifos
    reset_i <= '0';
    audioLeftInTb <= x"F00000";
    audioRightInTb <= x"F00000";
    wait for 21 us;



end process test;

end my_tb;
