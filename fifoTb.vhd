LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


entity fifoTb is
end fifoTb;


architecture my_tb of fifoTb is

component fifo
   generic(
      RAM_WIDTH: natural:=32; -- number of bits
      RAM_DEPTH: natural:=11 -- number of address bits
   );
   port(
      clk, reset: in std_logic;
      rd_en, wr_en: in std_logic;
      wr_data: in std_logic_vector (RAM_WIDTH-1 downto 0);
      empty, full: out std_logic;
      rd_data: out std_logic_vector (RAM_WIDTH-1 downto 0);
      rd_valid : out std_logic
   );
end component;


signal clk_i, reset_i, rd_i, wr_i : std_logic; 
signal w_data_i : std_logic_vector (31 downto 0);

signal empty_o, full_o, r_data_valid: std_logic;
signal r_data_o : std_logic_vector (31 downto 0);

begin
  
  -- (1) instantiate design under test (DUT);
  DUT: fifo
    generic map(
      RAM_WIDTH => 32, 
      RAM_DEPTH => 11 
    )
    port map (
      clk => clk_i, reset => reset_i,
      rd_en => rd_i, wr_en => wr_i,
      wr_data => w_data_i,
      empty => empty_o, full => full_o,
      rd_data => r_data_o, 
      rd_valid => r_data_valid
    );

  -- (2) process to generate clock signal;
  clk_gen : process
  begin
    clk_i <= '0'; wait for 1 ns;
    clk_i <= '1'; wait for 1 ns;
  end process clk_gen;

process 
begin

	reset_i <= '1';
    	rd_i    <= '0';
    	wr_i    <= '0';
    	w_data_i<= x"00000000";
    	wait for 4 ns;

	reset_i <= '0';
    	rd_i    <= '0';
    	wr_i    <= '1';
    	w_data_i<= x"00000001";
    	wait for 2 ns;

	reset_i <= '0';
    	rd_i    <= '0';
    	wr_i    <= '0';
    	w_data_i<= x"00000001";
    	wait for 2 ns;

	reset_i <= '0';
    	rd_i    <= '1';
    	wr_i    <= '0';
    	w_data_i<= x"00000001";
    	wait for 2 ns;


	reset_i <= '0';
    	rd_i    <= '0';
    	wr_i    <= '1';
    	w_data_i<= x"00000002";
    	wait for 2 ns;

--	reset_i <= '0';
--    	rd_i    <= '0';
--    	wr_i    <= '1';
--    	w_data_i<= x"00000002";
--    	wait for 2 ns;
--
--	reset_i <= '0';
--    	rd_i    <= '1';
--    	wr_i    <= '0';
--    	w_data_i<= x"00000000";
--    	wait for 2 ns;
--
--	reset_i <= '0';
--    	rd_i    <= '0';
--    	wr_i    <= '1';
--    	w_data_i<= x"00000003";
--    	wait for 2 ns;
--
--	reset_i <= '0';
--    	rd_i    <= '1';
--    	wr_i    <= '0';
--    	w_data_i<= x"00000000";
--    	wait for 2 ns;

end process;


end my_tb;