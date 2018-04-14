
module ShiftRight
#(
	parameter INBits=32,
	parameter IBits=2
)
(
	input [INBits-1:0] A,
	input [IBits-1:0]B,
	
	output [INBits-1:0]OUT

);

 logic [INBits-1:0]OUT_Logic;

 always_comb
 begin
	OUT_Logic = A>>B;
 end
 
 assign OUT = OUT_Logic;


endmodule
