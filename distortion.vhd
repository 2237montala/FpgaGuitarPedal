-- Distortion Pedal

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity distortion_pedal is 
port(
	clk: in std_logic;
	audioUpdate: in std_logic;
	audioLeftIn : in std_logic_vector(23 downto 0);
	audioRightIn : in std_logic_vector(23 downto 0);
	audioLeftOut : out std_logic_vector(23 downto 0);
	audioRightOut : out std_logic_vector(23 downto 0);
	reset : in std_logic
	);
end distortion_pedal;

architecture distortion of distortion_pedal is 

--COMPONENT signOf	
--	generic(
--			N: natural:=8 -- number of bits
--		);
--	port(
--		input : std_logic_vector(N-1 downto 0);
--		sign : std_logic
--);
--end COMPONENT;

signal temp : std_logic_vector(23 downto 0);

signal audioLeftAsInt : integer := 0;
signal audioRightAsInt : integer := 0;

signal audioLeftIntDistort : integer := 0;
signal audioRightIntDistort : integer := 0;

-- Algorithm
-- f(x) = sign(x)*(1 - e^(abs(x)))
-- Since we are using PCM there is no negative numbers but PCM
-- negative values are from 0 to 2^(n/2) where N is the number
-- of bits in our audio. In our case its 24 bits

begin

process(audioUpdate)
	begin
	-- Convert audio in from PCM to integer
	audioLeftAsInt <= to_integer(signed(audioLeftIn));
	audioRightAsInt <= to_integer(signed(audioRightIn));

	if audioLeftAsInt > 0 then
		audioLeftIntDistort <= audioLeftAsInt;
		
		--Convert from into back to unsigned vector
		audioLeftOut <= std_logic_vector(to_unsigned(audioLeftIntDistort,audioLeftOut'length));
	else
		audioLeftIntDistort <= audioLeftAsInt;
		
		--Convert from into back to unsigned vector
		audioLeftOut <= std_logic_vector(to_unsigned(audioLeftIntDistort,audioLeftOut'length));
	end if;

	if audioRightAsInt > 0 then
		audioRightIntDistort <= audioRightAsInt;
		
		--Convert from into back to unsigned vector
		audioRightOut <= std_logic_vector(to_unsigned(audioRightIntDistort,audioRightOut'length));
	else
		audioRightIntDistort <= audioRightAsInt;
		
		--Convert from into back to unsigned vector
		audioRightOut <= std_logic_vector(to_unsigned(audioRightIntDistort,audioRightOut'length));
	end if;
end process;
end distortion;