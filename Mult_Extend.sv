module Mult_Extend
(
	/* Input */
	input [15:0] value_in,
	
	/* Output */
	output [32:0] value_out
);


logic [32:0] value_out_logic = 33'b0;

always_comb begin: Extend

	value_out_logic[16:1] = value_in;

end

assign value_out = value_out_logic;

endmodule
