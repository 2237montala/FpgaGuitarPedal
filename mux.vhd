library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux221 is
    Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (23 downto 0);
           B   : in  STD_LOGIC_VECTOR (23 downto 0);
           X   : out STD_LOGIC_VECTOR (23 downto 0));
end mux221;

architecture Behavioral of mux221 is
begin
    X <= A when (SEL = '0') else B;
end Behavioral;