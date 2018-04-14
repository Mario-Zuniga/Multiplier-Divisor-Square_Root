module Add_Sub
#(
	parameter Size = 33
)
(
	/* Inputs */
	input Op,
	input [Size - 1 : 0]A,
	input [Size - 1 : 0]B,
	
	/* Outputs */
	output [Size - 1 : 0]C
	
);

logic [Size - 1 : 0] C_logic;

always_comb begin: Add_Sub_Op

	if(Op == 1'b1)
		C_logic = A + B;
		
	else
		C_logic = A - B;
		
end

assign C = C_logic;

endmodule
