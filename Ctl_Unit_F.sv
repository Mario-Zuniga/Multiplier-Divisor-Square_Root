module Ctl_Unit_F
(
	//Inputs
	input start,
	input reset,
	input clk,
	input [1:0]op,
	input loadctl,
	
	//Outputs

	output sys_reset,
	output load,
	
	output loadrst,
	output loadx,
	output loady,
	
	output on,
	output on_m,
	output ready,
	output last,
	
	output [4:0] i,
	output ready_pulse
);


/*  */
enum logic [4:0] {IDLE, OPRST,LOADX,LOADXONESHOT, LOADY, LOADYONESHOT, ONE_SHOT, LOAD, FIRST_DIV, FIRST_MULT, SECOND, THIRD, FOURTH, FIFTH, SIXTH, SEVENTH, EIGHTH, NINTH, TENTH, ELEVENTH, TWELVETH, THIRTEENTH, FOURTEENTH, FIVETEENTH, SIXTEENTH, LAST, READY_PULSE, READY} state; 

/*  */
bit sys_reset_bit;
bit load_bit;
bit ready_bit;
bit on_bit;
bit on_m_bit;
bit last_bit;

bit  loadrst_bit;
bit  loadx_bit;
bit  loady_bit;
bit [4:0] i_bit;
bit ready_pulse_bit;

/* Cycle to assign to the next state */
always_ff@(posedge clk, negedge reset) begin

	if(reset == 1'b0)
		state <= IDLE;
		
	else
	begin
		case(state)
			IDLE:			if(start == 1'b1) 		state <= OPRST;
			OPRST:										state <= LOADX;
			LOADX:		if(loadctl== 1'b1)		state <= LOADXONESHOT;
			LOADXONESHOT:								state <= LOADY;
			LOADY:		if(loadctl== 1'b0)		state <= LOADYONESHOT;
			LOADYONESHOT:								state <= ONE_SHOT;
			
			ONE_SHOT:									state <= LOAD;
			LOAD:			begin
								if(op==2'b00)			state <= FIRST_DIV;
								else if(op==2'b01)	state <= FIRST_MULT;
								else if (op==2'b10)	state <= FIRST_DIV;
								else						state <= IDLE;
							end
			
			FIRST_DIV:									state <= SECOND;
			FIRST_MULT:									state <= SECOND;
			SECOND:										state <= THIRD;
			THIRD:										state <= FOURTH;
			FOURTH:										state <= FIFTH;
			FIFTH:										state <= SIXTH;
			SIXTH:										state <= SEVENTH;
			SEVENTH:										state <= EIGHTH;
			EIGHTH:	begin
							if (op==2'b10)				state <= LAST;
							else							state <= NINTH;
						end
			NINTH:										state <= TENTH;
			TENTH:										state <= ELEVENTH;
			ELEVENTH:									state <= TWELVETH;
			TWELVETH:									state <= THIRTEENTH;
			THIRTEENTH:									state <= FOURTEENTH;
			FOURTEENTH:									state <= FIVETEENTH;
			FIVETEENTH:									state <= SIXTEENTH;
			SIXTEENTH:									state <= LAST;
			LAST:											state <= READY_PULSE;
			READY_PULSE:								state <= READY;
			READY:			if(start == 1'b0) 			state <= IDLE;
			
			default:		state <= IDLE;
				
		endcase
	end
end



always_comb begin
	sys_reset_bit	 =  1'b0;
	load_bit 		 =  1'b0;
	ready_bit 	  	 =	 1'b0;
	on_bit 			 =	 1'b0;
	on_m_bit	 		 =  1'b0;
	last_bit		 	 =  1'b0;
	loadrst_bit		 =  1'b0;
	loadx_bit		 =  1'b0;
	loady_bit		 =  1'b0;
	i_bit				 =  5'b0;
	ready_pulse_bit =  1'b0;
	
	case(state) 		
			
			OPRST:			loadrst_bit= 1'b1;
			
			LOADXONESHOT:  loadx_bit= 1'b1;
			
			LOADYONESHOT:  loady_bit= 1'b1;
			
			ONE_SHOT:	begin
							sys_reset_bit = 1'b1;
							on_bit = 1'b1;
							on_m_bit = 1'b1;
							end							
			LOAD:		   
							begin
							i_bit= 5'd16;
							load_bit = 	1'b1;	
							on_m_bit = 1'b1;	
							end
							
			FIRST_DIV:	begin
							i_bit= 5'd14;
							on_bit= 1'b1;
							on_m_bit = 1'b1;
							end 
							
			FIRST_MULT:	begin
							load_bit=1'b1;
							on_bit= 1'b1;
							on_m_bit = 1'b1;
							end 
							
							
			SECOND:		begin
							i_bit= 5'd12;
							on_bit= 1'b1;
							on_m_bit = 1'b1;
							end 
			THIRD:		begin
							i_bit= 5'd10;
							on_bit= 1'b1;
							on_m_bit = 1'b1;
							end 
			FOURTH:		begin
							i_bit= 5'd8;
							on_bit= 1'b1;
							on_m_bit = 1'b0;
							end 
			FIFTH:		begin
							i_bit= 5'd6;
							on_bit= 1'b1;
							on_m_bit = 1'b0;
							end 
			SIXTH:		begin
							i_bit= 5'd4;
							on_bit= 1'b1;
							on_m_bit = 1'b0;
							end 
			SEVENTH:		begin
							i_bit= 5'd2;
							on_bit= 1'b1;
							on_m_bit = 1'b0;
							end 
			EIGHTH:		begin
							i_bit= 5'd0;
							on_bit= 1'b1;
							on_m_bit = 1'b0;
							end 
			NINTH:		begin
							on_bit= 1'b1;
							on_m_bit = 1'b0;
							end 
			TENTH:		begin
							on_bit= 1'b1;
							on_m_bit = 1'b0;
							end 
			ELEVENTH:	begin
							on_bit= 1'b1;
							on_m_bit = 1'b0;
							end 
			TWELVETH:	begin
							on_bit= 1'b1;
							on_m_bit = 1'b0;
							end 
			THIRTEENTH:	begin
							on_bit= 1'b1;
							on_m_bit = 1'b0;
							end 
			FOURTEENTH:	begin
							on_bit= 1'b1;
							on_m_bit = 1'b0;
							end 
			FIVETEENTH:	begin
							on_bit= 1'b1;
							on_m_bit = 1'b0;
							end 		
			SIXTEENTH:	begin
							on_bit= 1'b1;
							on_m_bit = 1'b0;
							end 							
							
		  LAST:		   begin
							last_bit = 1'b1;
							on_bit= 1'b1;
							on_m_bit = 1'b0;
							end 
		 					
		  READY_PULSE: begin
							ready_pulse_bit= 1'b1;
							end 
							
			READY:		begin
							ready_bit =	 1'b1;	
							on_bit= 1'b1;
							on_m_bit = 1'b0;
							end
			
			
			default:	;
	endcase

end

assign sys_reset = sys_reset_bit;
assign load = load_bit;
assign ready = ready_bit;
assign on = on_bit;
assign on_m = on_m_bit;
assign last= last_bit;
assign loadrst= loadrst_bit;		 
assign loadx= loadx_bit;		
assign loady= loady_bit;
assign i=i_bit;
assign ready_pulse=ready_pulse_bit;


endmodule
