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
		audioLeftIn : in std_logic_vector(23 downto 0);
		audioRightIn : in std_logic_vector(23 downto 0);
		audioLeftOut : out std_logic_vector(23 downto 0);
		audioRightOut : out std_logic_vector(23 downto 0);
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
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (23 DOWNTO 0);
		usedw		: OUT STD_LOGIC_VECTOR (14 DOWNTO 0)
	);
END COMPONENT;

-- Create signals
type state_type is (WAITING_STATE, UPDATE_OUTPUT_STATE, END_STATE); 
signal state_next, state_reg: state_type;

signal clk_i, reset_i, readData, writeData : std_logic; 
signal leftEmptyOut, leftFullOut : std_logic;
signal rightEmptyOut, rightFullOut : std_logic;

signal leftDataOut : std_logic_vector (23 downto 0) := x"000000";
signal rightDataOut : std_logic_vector (23 downto 0) := x"000000";

signal leftDataIn : std_logic_vector (23 downto 0);
signal rightDataIn : std_logic_vector (23 downto 0);

signal leftDataOutRead : std_logic;

signal prev_out : std_logic_vector(23 downto 0);
signal signalSum : std_logic_vector(23 downto 0);

signal leftAudioSum : std_logic_vector(23 downto 0);
signal rightAudioSum : std_logic_vector(23 downto 0);

begin

-- Create our fifos	
leftChannelFifo : delayFifo
	port map(
		clock => clk,
		data  => leftDataIn,
		rdreq	=> readData,
		wrreq	=> writeData,
		empty	=> leftEmptyOut,
		full	=> leftFullOut,
		q		=> leftDataOut
	);
	
rightChannelFifo : delayFifo
	port map(
		clock => clk,
		data  => rightDataIn,
		rdreq	=> readData,
		wrreq	=> writeData,
		empty	=> rightEmptyOut,
		full	=> rightFullOut,
		q		=> rightDataOut
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
			
			-- Check if the fifo is full and if so we want to read from it
			if(leftFullOut = '1' and rightFullOut = '1') then
				-- Set the fifo read data to true
				readData <= '1';	
			else
				readData <= '0';
			end if;
		end if;
	when UPDATE_OUTPUT_STATE =>
		-- Create the delay signal and set the output
		leftAudioSum <= leftDataOut + audioLeftIn;
		rightAudioSum <= rightDataOut + audioRightIn;
		
		-- Set the combined audio to the output of the entity
		audioLeftOut <= leftAudioSum;
		audioRightOut <= rightAudioSum;
		
		leftDataIn <= leftAudioSum;
		rightDataIn <= rightAudioSum;
		
		-- Update the signals
		writeData <= '1';
		readData <= '0';
		state_next <= UPDATE_OUTPUT_STATE;
	when END_STATE =>
		writeData <= '0';
		
		-- Update the fifo and reset the signals
		state_next <= WAITING_STATE;
	end case;
end process;

end delay;