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
		delay_time: in std_logic_vector(2 downto 0);
		audioLeftIn : in std_logic_vector(23 downto 0);
		audioRightIn : in std_logic_vector(23 downto 0);
		audioLeftOut : out std_logic_vector(23 downto 0) :=x"000000";
		audioRightOut : out std_logic_vector(23 downto 0) := x"000000";
		reset : in std_logic
		);
end COMPONENT;


signal clk_i, reset_i : std_logic; 
signal audioClk : std_logic;
signal audioLeftInTb : std_logic_vector(23 downto 0);
signal audioRightInTb : std_logic_vector(23 downto 0);
signal audioLeftOutTb : std_logic_vector(23 downto 0);
signal audioRightOutTb : std_logic_vector(23 downto 0);

signal audioRightOutCorrect,audioLeftOutCorrect : std_logic_vector(23 downto 0);

constant fifoLength : integer := 8192;
signal currentFifoFill : integer := 0;

begin

dut : delay_pedal
    port map(
	clk => clk_i,
	audioUpdate => audioClk,
	delay_time => "000",
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

    -- Add in some fake outputs for testing
    reset_i <= '0';

    audioLeftInTb <= x"000000";
    audioRightInTb <= x"000000";
    currentFifoFill <= currentFifoFill + 1;
    wait for 21 us;
    
    audioLeftInTb <= x"000001";
    audioRightInTb <= x"000001";
    currentFifoFill <= currentFifoFill + 1;
    wait for 21 us;

    audioLeftInTb <= x"000002";
    audioRightInTb <= x"000002";
    currentFifoFill <= currentFifoFill + 1;
    wait for 21 us;

    audioLeftInTb <= x"000003";
    audioRightInTb <= x"000003";
    currentFifoFill <= currentFifoFill + 1;
    wait for 21 us;

    audioLeftInTb <= x"000004";
    audioRightInTb <= x"000004";
    currentFifoFill <= currentFifoFill + 1;
    wait for 21 us;

    -- Add in some negative values
    audioLeftInTb <= x"800000";
    audioRightInTb <= x"800000";
    currentFifoFill <= currentFifoFill + 1;
    wait for 21 us;

    audioLeftInTb <= x"FFFFFF";
    audioRightInTb <= x"FFFFFF";
    currentFifoFill <= currentFifoFill + 1;
    wait for 21 us;

    audioLeftInTb <= x"FFF000";
    audioRightInTb <= x"FFF000";
    currentFifoFill <= currentFifoFill + 1;
    wait for 21 us;

    -- Add some non edge cases

    -- Create a for loop to fill the fifos
    for i in currentFifoFill to fifoLength-1 loop
	audioLeftInTb <= std_logic_vector(to_unsigned(i,24));
	audioRightInTb <= std_logic_vector(to_unsigned(i,24));
	wait for 21 us;
    end loop;	

    -- Check if the output is correct
    -- Since after the fifo is full if we should expect the 
    -- next sequence of signals to be the current + old/2
    
    audioLeftInTb <= x"000000";
    audioRightInTb <= x"000000";
    
    audioLeftOutCorrect <= x"000000";
    audioRightOutCorrect <= x"000000";
    wait for 21 us;
    assert (audioLeftOutTb = audioLeftOutCorrect) report "Delayed output supposed to be 0" severity error;
   
    -- Repeat again the next value in the fifo should be 0x1
    -- and the delayed output is going to be 0 so the expected
    -- result should be the same as the input
    audioLeftInTb <= x"000000";
    audioRightInTb <= x"000000";
    
    audioLeftOutCorrect <= x"000000";
    audioRightOutCorrect <= x"000000";
    wait for 21 us;
    assert (audioLeftOutTb = audioLeftOutCorrect) report "Delayed output supposed to be 0" severity error;
    
    -- Repeat again but now the value in the fifo is 0x2 and the delayed output
    -- is going to be 2/2 = 1 so the pedal output should be input + 0x1
    audioLeftInTb <= x"000000";
    audioRightInTb <= x"000000";
    
    audioLeftOutCorrect <= x"000001";
    audioRightOutCorrect <= x"000001";
    wait for 21 us;
    assert (audioLeftOutTb = audioLeftOutCorrect) report "Delayed output supposed to be 1" severity error;
    
    -- Repeat again but now the value in the fifo is 0x3 and the delayed output
    -- is going to be 2/2 = 1 so the pedal output should be input + 0x1
    audioLeftInTb <= x"000000";
    audioRightInTb <= x"000000";
    
    audioLeftOutCorrect <= x"000001";
    audioRightOutCorrect <= x"000001";
    wait for 21 us;
    assert (audioLeftOutTb = audioLeftOutCorrect) report "Delayed output supposed to be 1" severity error;

    -- Repeat again but now the value in the fifo is 0x4 and the delayed output
    -- is going to be 2/2 = 1 so the pedal output should be input + 0x1
    
    audioLeftOutCorrect <= x"000002";
    audioRightOutCorrect <= x"000002";
    wait for 21 us;
    assert (audioLeftOutTb = audioLeftOutCorrect) report "Delayed output supposed to be 1" severity error;

    -- Repeat again but now the value in the fifo is 0x800000 and the delayed output
    -- is going to be C00000 becase we shift down 1 and make the number negative again
    
    audioLeftOutCorrect <= x"C00000";
    audioRightOutCorrect <= x"C00000";
    wait for 21 us;
    assert (audioLeftOutTb = audioLeftOutCorrect) report "Delayed output supposed to be 0x800000" severity error;

    audioLeftOutCorrect <= x"FFFFFF";
    audioRightOutCorrect <= x"FFFFFF";
    wait for 21 us;
    assert (audioLeftOutTb = audioLeftOutCorrect) report "Delayed output supposed to be 0x800000" severity error;

    audioLeftOutCorrect <= x"FFF800";
    audioRightOutCorrect <= x"FFF800";
    wait for 21 us;
    assert (audioLeftOutTb = audioLeftOutCorrect) report "Delayed output supposed to be 0x800000" severity error;

    audioLeftInTb <= x"000000";
    audioRightInTb <= x"000000";
    wait for 21 us;
--
--    -- Send in first audio sample
--    audioLeftInTb <= x"000000";
--    audioRightInTb <= x"000000";
--    wait for 21 us;
--
--    -- Send in first audio sample
--    audioLeftInTb <= x"000000";
--    audioRightInTb <= x"000000";
--    wait for 21 us;
--
--    audioLeftInTb <= x"000000";
--    audioRightInTb <= x"000000";
--    wait for 21 us;
--
--    -- Send in first audio sample
--    audioLeftInTb <= x"000000";
--    audioRightInTb <= x"000000";
--    wait for 21 us;
--
--    -- Send in first audio sample
--    audioLeftInTb <= x"000000";
--    audioRightInTb <= x"000000";
--    wait for 21 us;

end process test;

end my_tb;
