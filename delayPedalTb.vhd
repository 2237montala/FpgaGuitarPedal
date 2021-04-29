LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity delayPedalTb   is
end delayPedalTb ;


architecture my_tb of delayPedalTb is

COMPONENT delay_pedal
	port(
		clk: in std_logic;
		audioUpdate: in std_logic;
		delay_time: in std_logic_vector(3 downto 0);
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

dut : delay_pedal
    port map(
	clk => clk_i,
	audioUpdate => audioClk,
	delay_time => "0000",
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
	audioClk <= '0'; wait for 10 us;
	audioClk <= '1'; wait for 10 us;
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
    for i in 0 to 16384 loop
	audioLeftInTb <= std_logic_vector(to_unsigned(i,24));
	audioRightInTb <= std_logic_vector(to_unsigned(i,24));
	--audioLeftInTb <= x"000000";
	wait for 20us;
    end loop;		
	  
    -- Send in first audio sample
    audioLeftInTb <= x"000001";
    audioRightInTb <= x"000001";
    wait for 20 us;

    -- Send in second audio sample
    --audioLeftInTb <= x"000002";
    --audioRightInTb <= x"000002";
    --wait for 10 us;

end process test;

end my_tb;