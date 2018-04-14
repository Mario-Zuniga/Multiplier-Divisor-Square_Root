module Comparador
#(
	parameter Size = 16
)
(
	/* Inputs */
	input [Size - 1 : 0]A,
	input [Size - 1 : 0]B,
	
	/* Outputs */
	output C
	
);

bit C_bit;

always_comb begin: Comp

	if(A <= B)
		C_bit = 1'b1;
	else
		C_bit = 1'b0;

end

assign C = C_bit;

endmodule
