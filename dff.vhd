Library IEEE;
USE IEEE.Std_logic_1164.all;

entity DFlipFlop is 
   port(
      Q : out std_logic_vector(23 downto 0);    
      Clk :in std_logic;   
      D :in  std_logic_vector(23 downto 0)    
   );
end DFlipFlop;

architecture Behavioral of DFlipFlop is  
begin  
	process(Clk)

	begin 
		if(rising_edge(Clk)) then
			Q <= D; 
		end if;       
	end process;  

end Behavioral;