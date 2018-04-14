module Data_Inputs_Comp
#(
	parameter INBits=16
)
(
	input [INBits-1:0] Q,
	input [INBits-1:0] M,
	
	output [INBits-1:0] Q_out,
	output [INBits-1:0] M_out

);

logic [INBits-1:0] Q_logic;
logic [INBits-1:0] M_logic;

always_comb
begin	
	
	if(M == 16'b0)
	begin
		M_logic = Q;
		Q_logic = M;
	end
	
	else
	begin
		M_logic = M;
		Q_logic = Q;
	end
	
	
	if(Q == 16'b1000000000000000  && M == 16'b1000000000000000)
	begin
		M_logic = 16'b1;
		Q_logic = 16'b1;
	end
	
	else
	begin
		M_logic = M;
		Q_logic = Q;
	end

end

assign M_out = M_logic;
assign Q_out = Q_logic;

endmodule
