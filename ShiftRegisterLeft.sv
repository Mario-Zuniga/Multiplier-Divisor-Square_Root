/**********************************************************
Module Name: 
	ShiftRegisterLoR.sv
Description: 
	Accumulates values of the Sequential Multiplier
Inputs:
	- clk
	- reset
	- load
	- shift
	- parallelInput
	- LoR
	- ready
Outputs:
	- serialOutput
	- parallelOutput
	- readyFlag
Version:
	1.0
Authors:
	- Oscar Alejandro Cortes Acosta
	- Mario Eugenio Zuñiga Carrillo
Date:
	24/02/18
**********************************************************/
module ShiftRegisterLeft
#(
	parameter WORD_LENGTH = 8
)
(
	input clk,
	input reset,
	input sys_reset,
	input serialInput,
	input load,
	input shift,
	input [WORD_LENGTH - 1 : 0] parallelInput,
	
	output serialOutput,
	output [WORD_LENGTH - 1 : 0] parallelOutput
	

);

reg [WORD_LENGTH - 1 : 0] shiftRegister_logic;


always@(posedge clk, negedge reset) begin
	
	if(reset == 1'b0)
		shiftRegister_logic <= {WORD_LENGTH{1'b0}};
		
	else if(sys_reset == 1'b1)
	shiftRegister_logic <= {WORD_LENGTH{1'b0}};
		
	else
		case ({load, shift})
			2'b01:
				shiftRegister_logic <= {shiftRegister_logic[WORD_LENGTH -2 : 0], serialInput};
			2'b10:
				shiftRegister_logic <= parallelInput;
			default:
				shiftRegister_logic <= shiftRegister_logic;
		endcase
end

assign serialOutput = shiftRegister_logic[WORD_LENGTH - 1]; 
assign parallelOutput = shiftRegister_logic;


endmodule
