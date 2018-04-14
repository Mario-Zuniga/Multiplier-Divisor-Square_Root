/**********************************************************
Module Name: 
	Sync_Counter.sv
Description: 
	Generates a syncronized counter with a specific frequency
Inputs:
	- clk
	- reset	
Outputs:
	- flag
Version:
	1.0
Authors:
	- Oscar Alejandro Cortes Acosta
	- Mario Eugenio Zuñiga Carrillo
Date:
	12/02/18
**********************************************************/
module Sync_Counter
#(
	// Parameter Declarations
	parameter REF_FREQUNCY = 0,
	parameter FIXED_FREQUENCY= 0,
   parameter MAXIMUM_VALUE = REF_FREQUNCY/FIXED_FREQUENCY,
	parameter NBITS_FOR_COUNTER = CeilLog2(MAXIMUM_VALUE)
)

(
	// Input Ports
	input clk,
	input reset,
	
	// Output Ports
	output flag
);

bit MaxValue_Bit;

/* Array with dynamic size */
logic [NBITS_FOR_COUNTER-1 : 0] Count_logic;

/* Flip-Flop cycle */
always_ff@(posedge clk or negedge reset) begin
	/* We check if reset is activated */
	if (reset == 1'b0)
		/* The Count_logic is put back to 0 */
		Count_logic <= {NBITS_FOR_COUNTER{1'b0}};
	else begin
	
		/* We check if the Count_logic has reached it's maximum value */
		if(Count_logic == MAXIMUM_VALUE - 1)
			/* The count resets to 0 */
			Count_logic <= 0;
		else
			/* The count logic is increased */
			Count_logic <= Count_logic + 1'b1;
	end
end

//--------------------------------------------------------------------------------------------

/* Always combinational */
always_comb
	/* We check if the Count_logic has reached it's maximum value */
	if(Count_logic == MAXIMUM_VALUE-1)
		/* If it's true, the max value bit is 1 */
		MaxValue_Bit = 1;
	else
		/* If not, max value bit is 0 */
		MaxValue_Bit = 0;

		
//---------------------------------------------------------------------------------------------
/* Max value bit is assigned to flag */
assign flag = MaxValue_Bit;


 /*--------------------------------------------------------------------*/
 /*--------------------------------------------------------------------*/
 /*--------------------------------------------------------------------*/
   
 /* Log Function */
 function integer CeilLog2;
	input integer data;
   integer i,result;
   begin
		for(i = 0; 2 ** i < data; i = i + 1)
			result = i + 1;
         CeilLog2 = result;
   end
endfunction

/*--------------------------------------------------------------------*/
/*--------------------------------------------------------------------*/
/*--------------------------------------------------------------------*/

endmodule
