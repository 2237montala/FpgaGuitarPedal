--this is the entity of the delay for our FPGA course final project

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity delay_pedal is 
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
end delay_pedal;

architecture delay of delay_pedal is 

COMPONENT delayFifo
	PORT
	(
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (23 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		sclr		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (23 DOWNTO 0);
		usedw		: OUT STD_LOGIC_VECTOR (12 DOWNTO 0)
	);
END COMPONENT;

COMPONENT edge_detect
  port(
    clk, reset: in std_logic;
    level: in std_logic;
    tick: out std_logic
  );
end COMPONENT;

-- Create signals
type state_type is (WAITING_STATE, UPDATE_OUTPUT_STATE, END_STATE); 
signal state_next, state_reg: state_type;

signal clk_i, reset_i :std_logic;
signal localReset : std_logic;
signal readData, writeData : std_logic := '0'; 
signal leftEmptyOut, leftFullOut : std_logic;
signal rightEmptyOut, rightFullOut : std_logic;
signal audioUpdateED : std_logic := '0';

-- Output of the fifo
signal leftDataOut : std_logic_vector (23 downto 0) := x"000000";
signal rightDataOut : std_logic_vector (23 downto 0) := x"000000";

-- Data to write to the fifo
signal leftDataIn : std_logic_vector (23 downto 0);
signal rightDataIn : std_logic_vector (23 downto 0);

signal leftDataOutReduced : signed(23 downto 0);
signal rightDataOutReduced : signed(23 downto 0);

-- Signals to hold the sum of the input and fifo values
signal leftAudioSum : signed(23 downto 0) := x"000000";
signal rightAudioSum : signed(23 downto 0) := x"000000";

begin

-- Create our fifos	
-- The fifo hold 65536 data samples
leftChannelFifo : delayFifo
	port map(
		clock => clk,
		data  => leftDataIn,
		rdreq	=> readData,
		wrreq	=> writeData,
		sclr => '0',
		empty	=> leftEmptyOut,
		full	=> leftFullOut,
		q	=> leftDataOut
	);
	
rightChannelFifo : delayFifo
	port map(
		clock => clk,
		data  => rightDataIn,
		rdreq	=> readData,
		wrreq	=> writeData,
		sclr => '0',
		empty	=> rightEmptyOut,
		full	=> rightFullOut,
		q	=> rightDataOut
	);
	
audioUpdateEdgeDetect : edge_detect
	port map(
		clk => clk,
		reset => reset,
		level => audioUpdate,
		tick => audioUpdateED
	);

	
-- Code below is what creates the delay effect -------------------------------------
-- Shift the old signal to the right by one
-- and make sure we keep the sign of the original number
leftDataOutReduced <= signed(leftDataOut(leftDataOut'length-1) & leftDataOut(23 downto 1));
rightDataOutReduced <= signed(rightDataOut(rightDataOut'length-1) & rightDataOut(23 downto 1));

-- Create the delay signal and set the output		
-- Combine the old and the new signal
leftAudioSum <= signed(audioLeftIn) + leftDataOutReduced;
rightAudioSum <= signed(audioRightIn) + rightDataOutReduced;

-- Set the combined audio to the output of the entity
audioLeftOut <= std_logic_vector(leftAudioSum);
audioRightOut <= std_logic_vector(rightAudioSum);
		
-- Set the data to write back to the fifo to the sum of the new and old signals
leftDataIn <= std_logic_vector(leftAudioSum);
rightDataIn <= std_logic_vector(rightAudioSum);

process(reset, clk)
  begin
    if (reset = '1') then    
		state_reg <= WAITING_STATE;
		-- Set the outputs to be 0
    elsif (clk'event and clk = '1') then
		state_reg <= state_next;
    end if;
  end process;
  
process(state_reg,clk)
	begin
	
	case state_reg is
	
	when WAITING_STATE =>
		-- Do nothing until we get an audio update signal
		--if(audioUpdate'event and audioUpdate = '1') then
		if(audioUpdateED = '1') then
			-- Move to the update state
			state_next <= UPDATE_OUTPUT_STATE;
			
			-- Check if the fifo is full and if so we want to read from it
			if(leftFullOut = '1' and rightFullOut = '1') then
				-- Set the fifo read data to true
				readData <= '1';	
			else
				readData <= '0';
			end if;
		end if;
		state_next <= UPDATE_OUTPUT_STATE;	
	when UPDATE_OUTPUT_STATE =>		
		-- Update the signals
		writeData <= '1';
		readData <= '0';
		
		state_next <= END_STATE;
	when END_STATE =>
		writeData <= '0';
		
		-- Update the fifo and reset the signals
		state_next <= WAITING_STATE;
	end case;
end process;

end delay;
