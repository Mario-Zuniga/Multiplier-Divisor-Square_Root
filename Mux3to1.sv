module Mux3to1
#(
	parameter NBits=4
)
(
	input [1:0] Selector,
	input [NBits-1:0] MUX_Data0,	// Division
	input [NBits-1:0] MUX_Data1,  // Multiplicacion
	input [NBits-1:0] MUX_Data2,  // Raiz Cuadrada
	
	output [NBits-1:0] MUX_Output

);

logic [NBits-1:0] Mux_Output_Logic;


always_comb	
begin
	if(Selector == 2'b00) // Division
		Mux_Output_Logic = MUX_Data0;
		
	else if(Selector == 2'b01) // Multiplicacion
		Mux_Output_Logic = MUX_Data1;
		
	else if(Selector == 2'b10)				// Raiz Cuadrada
		Mux_Output_Logic = MUX_Data2;
	
	else 
		Mux_Output_Logic = 0;
		
end
	
assign MUX_Output = Mux_Output_Logic;

endmodule
