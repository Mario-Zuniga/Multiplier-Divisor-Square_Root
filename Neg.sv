
module Neg
#(
	parameter INBits=1
)
(
	input [INBits-1:0] A,
	
	output [INBits-1:0]OUT

);

 logic [INBits-1:0]OUT_Logic;

 always_comb
 begin
	 OUT_Logic = ~A;
 end
 
 assign OUT = OUT_Logic;


endmodule
