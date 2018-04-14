
module Xor_M
#(
	parameter INBits=32
)
(
	//Input
	input [INBits-1:0] A,
	input [INBits-1:0]B,
	
	//Output
	output [INBits-1:0]OUT

);

logic [INBits-1:0]OUT_Logic;

 always_comb
 begin
	OUT_Logic = A^B;
 end
 
 assign OUT = OUT_Logic;

endmodule
