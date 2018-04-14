module Operation
(
/* Inputs */
input[1:0] Q,

/* Outputs */
output Op,
output Shift_Op
);

bit Op_bit;
bit Shift_Op_bit;

/* Conditions for Outputs
	Op_bit = 1 -> Add
	Op_bit = 0 -> Sub
	
	Shift_Op_bit -> 1 then Op_bit doesn't matter */

always_comb begin: Ope

	if(Q[1] == Q[0])
	begin
		Op_bit = 1'b0;
		Shift_Op_bit = 1'b1;
	end
	
	else if(Q[1] == 1'b0 && Q[0] == 1'b1)
	begin
		Op_bit = 1'b1;
		Shift_Op_bit = 1'b0;
	end
	
	else
	begin
		Op_bit = 1'b0;
		Shift_Op_bit = 1'b0;
	end
end

assign Op = Op_bit;
assign Shift_Op = Shift_Op_bit;


endmodule
