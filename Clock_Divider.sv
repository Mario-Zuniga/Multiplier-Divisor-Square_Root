/**********************************************************
Module Name: 
	Clock_Divider.sv
Description: 
	Creates the frequency desired by the user
Inputs:
	- clk
	- reset	
Outputs:
	- clk_FPGA_out
Version:
	1.0
Authors:
	- Oscar Alejandro Cortes Acosta
	- Mario Eugenio Zuñiga Carrillo
Date:
	12/02/18
**********************************************************/
module Clock_Divider

#(
	// Parameter Declarations
	parameter REF_FREQUNCY = 50000000,
	parameter FIXED_FREQUENCY= 1000
)

(
	// Input Ports
	input clk,
	input reset,
	

	// Output Ports
	output clk_FPGA_out
);

/* Logic declaration */
logic clk_FPGA_out_logic;
logic clk_FPGA_out_logic_flag;

/* Wire declaration */
wire flag_con;
 
generate
	/* We check if the desired frequency is lower or equal to 12.5 MHz */
	if (FIXED_FREQUENCY <= 12500000) 
	begin
		/* If it is, we send the desired frequency multiplied by 2 to the Sync_Counter */
		Sync_Counter #(REF_FREQUNCY,FIXED_FREQUENCY*2) SC1 (.clk(clk),.reset(reset),.flag(flag_con));
	end
	else 
	begin
		/* If it isn't, we send the desired frequenc to the Sync_Counter */
		Sync_Counter #(REF_FREQUNCY,FIXED_FREQUENCY) SC1 (.clk(clk),.reset(reset),.flag(flag_con));
	end
endgenerate
 
 
/* Flip-Flop cycle */
always_ff@(posedge clk or negedge reset) begin
	/* We check if reset is activated */
	if (reset == 1'b0)
		/* If it is, the clk_FPGA goes back to 0 */
		clk_FPGA_out_logic<= 1'b0;
	else
	
	begin
		/* We check if the flag was raised */
		if (flag_con == 1)
			/* If it is, we negate the clk */
			clk_FPGA_out_logic<= ~clk_FPGA_out_logic;
	end
 
end
 
/* Always combinational */
always_comb
begin
	/* We check if the desired frequency is lower or equal to 12.5 MHz */
	if(FIXED_FREQUENCY <= 12500000)
		/* If it is, logic flag is equal to the clk from the flip-flop */
		clk_FPGA_out_logic_flag = clk_FPGA_out_logic;
	else
		/* The flip-flop is sended */
		clk_FPGA_out_logic_flag = flag_con;
end
 
/* The logic flag is assigned to clk_FPGA_out */ 
assign clk_FPGA_out = clk_FPGA_out_logic_flag;
 
endmodule
