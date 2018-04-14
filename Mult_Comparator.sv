module Mult_Comparator
 #(
	parameter INBits=16
)
(
	input [INBits-1:0] A,
	
	output Out

);

bit Out_bit;

always_comb
begin	
	
	if(A == 16'b0)
		Out_bit = 1'b1;
		
	else
		Out_bit = 1'b0;
		
	
end

assign Out = Out_bit;


endmodule
