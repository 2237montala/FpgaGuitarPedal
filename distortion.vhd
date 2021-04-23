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

component DFlipFlop
	port(
		Q : out std_logic_vector(23 downto 0);    
		Clk :in std_logic;   
		D :in  std_logic_vector(23 downto 0)    
		);
end Component;

component mux221
	Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (23 downto 0);
           B   : in  STD_LOGIC_VECTOR (23 downto 0);
           X   : out STD_LOGIC_VECTOR (23 downto 0));
end component;

signal storageLeft: std_logic_vector(23 downto 0);
signal storageRight: std_logic_vector(23 downto 0);

begin



leftMux: mux221 PORT MAP(
	SEL => audioLeftIn(23),
	A => audioLeftIn,
	B => not audioLeftIn,
	X => storageLeft
);
	
latchLeft: DFlipFlop Port map(
	Q => audioLeftOut,
	Clk => audioUpdate,
	D => storageLeft
	);


rightMux: mux221 PORT MAP(
	SEL => audioRightIn(23),
	A => audioRightIn,
	B => not audioRightIn,
	X => storageRight
	);

latchRight: DFlipFlop Port map(
	Q => audioRightOut,
	Clk => audioUpdate,
	D => storageRight
	);


end distortion;