--this is the entity of the delay for our FPGA course final project

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity delay_pedal is 
port(
	clk: in std_logic;
	audioUpdate: in std_logic;
	delay_time: in std_logic_vector(3 downto 0);
	--effect_gain: in std_logic_vector(2 downto 0);
	--attenuation: in std_logic_vector(3 downto 0);-- might not need FIR filter might do this
	wave_in: in std_logic_vector(23 downto 0);
	wave_out: out std_logic_vector(23 downto 0);
	reset : in std_logic
	);
end delay_pedal;

architecture delay of delay_pedal is 

component fifo 
  generic(
    B: natural:=24; -- number of bits
    W: natural:=10 -- number of address bits
  );
  port(
    clk, reset: in std_logic;
    rd, wr: in std_logic;
    w_data: in std_logic_vector (B-1 downto 0);
    empty, full: out std_logic;
    r_data: out std_logic_vector (B-1 downto 0)
  );
end component;

-- Create signals
type state_type is (WAITING_STATE, UPDATE_OUTPUT_STATE, END_STATE); 
signal state_next, state_reg: state_type;

signal clk_i, reset_i, readData, writeData : std_logic; 
signal leftEmptyOut, leftFullOut : std_logic;
signal rightEmptyOut, rightFullOut : std_logic;

signal leftDataOut : std_logic_vector (23 downto 0);
signal rightDataOut : std_logic_vector (23 downto 0);

signal leftDataIn : std_logic_vector (23 downto 0);
signal rightDataIn : std_logic_vector (23 downto 0);

signal prev_out : std_logic_vector(23 downto 0);
signal signalSum : std_logic_vector(23 downto 0);
--integer effect_gain := 2;

--tickSinceLastDelay: std_logic := 0;
--constant clockRate: integer := 50000000;

begin

-- Create our fifos
leftChannelFifo : fifo
	port map(
		clk => clk,
		reset => reset,
		rd => readData,
		wr => writeData,
		w_data => leftDataIn,
		r_data => leftDataOut,
		empty => leftEmptyOut,
		full => leftFullOut
	);
	
rightChannelFifo : fifo
	port map(
		clk => clk,
		reset => reset,
		rd => readData,
		wr => writeData,
		w_data => rightDataIn,
		r_data => rightDataOut,
		empty => rightEmptyOut,
		full => rightFullOut
	);

	
process(reset, clk)
  begin
    if (reset = '1') then    
		state_reg <= WAITING_STATE;
    elsif (clk'event and clk = '1') then
		state_reg <= state_next;
    end if;
  end process;


process(state_reg,audioUpdate)
	begin
	
	case state_reg is
	
	when WAITING_STATE =>
		-- Do nothing until we get an audio update signal
		if(audioUpdate = '1') then
			-- Move to the update state
			state_next <= UPDATE_OUTPUT_STATE;
			
			-- Set the fifo read data to true
			readData <= '1';
		end if;
	when UPDATE_OUTPUT_STATE =>
		-- Create the delay signal and set the output
		prev_out <= leftDataOut + wave_in;
		
		wave_out <= prev_out;
		
		leftDataIn <= prev_out;
		writeData <= '1';
		readData <= '0';
		state_next <= UPDATE_OUTPUT_STATE;
	when END_STATE =>
		-- Update the fifo and reset the signals
		state_next <= WAITING_STATE;
	end case;
end process;

end delay;