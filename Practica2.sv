module Practica2
#(
	parameter INBitsSQ=32,
	parameter INBitsD_M = 16,
	parameter IBits = 5
)
(
	/* Inputs */
	input clk,
	input reset,
	input start,
	input loadctl,
	input [1:0]op,
	input [15:0] Data,
	input show_value,
	
	/* Outputs */
	output [6:0]seg1_out,
	output [6:0]seg2_out,
	output [6:0]seg3_out,
	output [6:0]seg4_out,
	output [6:0]seg5_out,
	output [6:0]seg6_out,
	output [6:0]seg7_out,
	output [6:0]seg_sign,
	output [15:0]high_bits
);

/* Wires */
wire [INBitsSQ-1:0] result_wire;
wire [INBitsSQ-1:0] reminder_wire;
wire sign_MDR_wire;
wire ready_MDR_wire;

wire [3:0] out1_wire;
wire [3:0] out2_wire;
wire [3:0] out3_wire;
wire [3:0] out4_wire;
wire [3:0] out5_wire;
wire [3:0] out6_wire;
wire [3:0] out7_wire;
wire [3:0] out8_wire;
wire [3:0] out9_wire;
wire [3:0] out10_wire;
wire [3:0] out11_wire;

wire [3:0] rem_out1_wire;
wire [3:0] rem_out2_wire;
wire [3:0] rem_out3_wire;
wire [3:0] rem_out4_wire;
wire [3:0] rem_out5_wire;
wire [3:0] rem_out6_wire;
wire [3:0] rem_out7_wire;
wire [3:0] rem_out8_wire;
wire [3:0] rem_out9_wire;
wire [3:0] rem_out10_wire;
wire [3:0] rem_out11_wire;


wire [43:0] seg_In;
wire [76:0] seg_out;

wire [43:0] rem_seg_In;
wire [76:0] rem_seg_out;


genvar i;
genvar j;

wire clkInter;


/* The input of the segment is alligned with the values of the BCD output */
assign seg_In = {out11_wire, out10_wire, out9_wire, out8_wire, out7_wire, out6_wire, out5_wire, out4_wire, out3_wire, out2_wire, out1_wire};
assign rem_seg_In = {rem_out11_wire, rem_out10_wire, rem_out9_wire, rem_out8_wire, rem_out7_wire, rem_out6_wire, rem_out5_wire, rem_out4_wire, rem_out3_wire, rem_out2_wire, rem_out1_wire};



Clock_Divider CD
(
	.clk(clk),
	.reset(reset),
	.clk_FPGA_out(clkInter)
);

MDR #( 32, 16, 5 ) MDR_Practica
(
	.clk(clkInter),
	.reset(reset),
	.start(start),
	.loadctl(loadctl),
	.op(~op),
	.Data(Data),
	
	.result(result_wire),
	.reminder(reminder_wire),
	.sign_MDR(sign_MDR_wire),
	.ready_MDR(ready_MDR_wire)
);


BCD_32bits BCD
(
	.bits_in(result_wire),
	
	.out1(out1_wire),
	.out2(out2_wire),
	.out3(out3_wire),
	.out4(out4_wire),
	.out5(out5_wire),
	.out6(out6_wire),
	.out7(out7_wire),
	.out8(out8_wire),
	.out9(out9_wire),
	.out10(out10_wire),
	.out11(out11_wire)
);


BCD_32bits BCD_remainder
(
	.bits_in(reminder_wire),
	
	.out1(rem_out1_wire),
	.out2(rem_out2_wire),
	.out3(rem_out3_wire),
	.out4(rem_out4_wire),
	.out5(rem_out5_wire),
	.out6(rem_out6_wire),
	.out7(rem_out7_wire),
	.out8(rem_out8_wire),
	.out9(rem_out9_wire),
	.out10(rem_out10_wire),
	.out11(rem_out11_wire)
);


generate
	for(i = 4; i < 45; i = i + 4) begin :Seg7
	
			SegmentDisplay SD
			(
				.value(seg_In[(i-1):(i-4)]),
				.Seg_Result(seg_out[((7*(i/4))-1):((7*(i/4))-7)])
			);
			
	end: Seg7
endgenerate

generate
	for(j = 4; j < 45; j = j + 4) begin :rem_Seg7
	
			SegmentDisplay SD
			(
				.value(rem_seg_In[(j-1):(j-4)]),
				.Seg_Result(rem_seg_out[((7*(j/4))-1):((7*(j/4))-7)])
			);
			
	end: rem_Seg7
endgenerate


Multiplexer2to1 #( 7 ) SD_Mux7
		(
			.Selector(~show_value),
			.MUX_Data0(seg_out[6:0]),
			.MUX_Data1(rem_seg_out[6:0]),
			.MUX_Output(seg1_out)
		);


		Multiplexer2to1 #( 7 ) SD_Mux8
		(
			.Selector(~show_value),
			.MUX_Data0(seg_out[13:7]),
			.MUX_Data1(rem_seg_out[13:7]),
			.MUX_Output(seg2_out)

		);

		Multiplexer2to1 #( 7 ) SD_Mux9
		(
			.Selector(~show_value),
			.MUX_Data0(seg_out[20:14]),
			.MUX_Data1(rem_seg_out[20:14]),
			.MUX_Output(seg3_out)

		);

		Multiplexer2to1 #( 7 ) SD_Mux10
		(
			.Selector(~show_value),
			.MUX_Data0(seg_out[27:21]),
			.MUX_Data1(rem_seg_out[27:21]),
			.MUX_Output(seg4_out)

		);

		Multiplexer2to1 #( 7 ) SD_Mux11
		(
			.Selector(~show_value),
			.MUX_Data0(seg_out[34:28]),
			.MUX_Data1(rem_seg_out[34:28]),
			.MUX_Output(seg5_out)
		);


		Multiplexer2to1 #( 7 ) SD_Mux12
		(
			.Selector(~show_value),
			.MUX_Data0(seg_out[41:35]),
			.MUX_Data1(rem_seg_out[41:35]),
			.MUX_Output(seg6_out)

		);
		
		Multiplexer2to1 #( 7 ) SD_Mux13
		(
			.Selector(~show_value),
			.MUX_Data0(seg_out[48:42]),
			.MUX_Data1(rem_seg_out[48:42]),
			.MUX_Output(seg7_out)

		);

SegmentSign SS
(
	.SignValue(sign_MDR_wire),
	.Value(result_wire),
	
	// Outputs
	.Seg_Result(seg_sign)
);
		
		
Multiplexer2to1 #( 16 ) SD_Mux14
(
	.Selector(~show_value),
	.MUX_Data0(result_wire[31:16]),
	.MUX_Data1(reminder_wire[31:16]),
	.MUX_Output(high_bits)

);


endmodule
