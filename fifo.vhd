-- https://vhdlwhiz.com/ring-buffer-fifo/
-- this is a modified version of this one but instead of 
-- using a logic vector it uses bram

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo is
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
end fifo;

architecture arch of fifo is

	COMPONENT delayRam
		PORT
		(
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			rdaddress		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
			wraddress		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
			wren		: IN STD_LOGIC  := '0';
			q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END COMPONENT;

--	type ram_type is array (0 to RAM_DEPTH - 1) of
--		std_logic_vector(wr_data'range);
--	signal ram : ram_type;

	subtype index_type is integer range RAM_DEPTH downto 0;
	signal head : index_type;
	signal tail : index_type;

	signal empty_i : std_logic;
	signal full_i : std_logic;
	signal fill_count_i : integer range RAM_DEPTH - 1 downto 0;
	
	signal leftBuffWriteAddr : std_logic_vector(RAM_DEPTH-1 downto 0);
	signal leftBuffReadAddr : std_logic_vector(RAM_DEPTH-1 downto 0);
 
	-- Increment and wrap
	procedure incr(signal index : inout index_type) is
	begin
	 if index = index_type'high then
		index <= index_type'low;
	 else
		index <= index + 1;
	 end if;
	end procedure;
   
begin
	-- Create bram entity
	leftBuff : delayRam
		port map(
			clock => clk,
			data => wr_data,
			rdaddress => leftBuffReadAddr,
			wraddress => leftBuffWriteAddr,
			wren => wr_en,
			q => rd_data
		);
 
 
	-- Copy internal signals to output
	empty <= empty_i;
	full <= full_i;
	--fill_count <= fill_count_i;

	-- Set the flags
	empty_i <= '1' when fill_count_i = 0 else '0';
	full_i <= '1' when fill_count_i >= RAM_DEPTH - 1 else '0';
	
	-- Convert the head and tail signals to the write and read addresses
	leftBuffReadAddr <= std_logic_vector(to_unsigned(tail,RAM_DEPTH));
	leftBuffWriteAddr <= std_logic_vector(to_unsigned(head,RAM_DEPTH));

	-- Update the head pointer in write
	PROC_HEAD : process(clk)
	begin
	 if rising_edge(clk) then
		if reset = '1' then
		  head <= 0;
		else
		  if wr_en = '1' and full_i = '0' then
			 incr(head);
		  end if;

		end if;
	 end if;
	end process;

	-- Update the tail pointer on read and pulse valid
	PROC_TAIL : process(clk)
	begin
	 if rising_edge(clk) then
		if reset = '1' then
		  tail <= 0;
		  rd_valid <= '0';
		else
		  rd_valid <= '0';

		  if rd_en = '1' and empty_i = '0' then
			 incr(tail);
			 rd_valid <= '1';
		  end if;

		end if;
	 end if;
	end process;

--	-- Write to and read from the RAM
--	PROC_RAM : process(clk)
--	begin
--	 if rising_edge(clk) then
--		--ram(head) <= w_data;
--		
--		-- Set BRAM input to write data
--		--data <= w_data;
--		
--		-- Set output to BRAM output
--		--rd_data <= q;
--	 end if;
--	end process;

	-- Update the fill count
	PROC_COUNT : process(head, tail)
	begin
	 if head < tail then
		fill_count_i <= head - tail + RAM_DEPTH;
	 else
		fill_count_i <= head - tail;
	 end if;
	end process;
 
end architecture;