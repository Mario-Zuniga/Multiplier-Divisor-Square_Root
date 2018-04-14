module BCD_32bits
(
	/* Inputs */
	input [31:0] bits_in,
	
	output [3:0] out1,
	output [3:0] out2,
	output [3:0] out3,
	output [3:0] out4,
	output [3:0] out5,
	output [3:0] out6,
	output [3:0] out7,
	output [3:0] out8,
	output [3:0] out9,
	output [3:0] out10,
	output [3:0] out11
);


/* Variables for the generate cycles */
genvar i1;			// For cycle Binaries
genvar i2;			// For cycle Binaries_2
genvar i3;			// For cycle Binaries_3
genvar i4;			// For cycle Binaries_4
genvar i5;			// For cycle Binaries_5
genvar i6;			// For cycle Binaries_6
genvar i7;			// For cycle Binaries_7
genvar i8;			// For cycle Binaries_8
genvar i9;			// For cycle Binaries_9


/* Wires for the interconections between modules */
wire [120:0]For0_wire;		// Conections in Binaries_1
wire [120:0]For1_wire;		// Conections in Binaries_2
wire [120:0]For2_wire;		// Conections in Binaries_3
wire [120:0]For3_wire;		// Conections in Binaries_4
wire [120:0]For4_wire;		// Conections in Binaries_5
wire [120:0]For5_wire;		// Conections in Binaries_6
wire [120:0]For6_wire;		// Conections in Binaries_7
wire [120:0]For7_wire;		// Conections in Binaries_8
wire [120:0]For8_wire;		// Conections in Binaries_9
wire [120:0]For9_wire;		// Conections in Binaries_10
wire [120:0]For10_wire;		// Conections in Binaries_11





/* Wire to catch the values for the outputs*/
wire [43:0]bits_out;




//								Specific Instances
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
/* First module of first stage has an specific instance declaration  */
Binary_shift_three_adder
C1
(
	.In_Bits({1'b0,bits_in[31:29]}),
	.Out_Bits({For0_wire[3:0]})
);


/* First module of second stage has an specific instance declaration  */
Binary_shift_three_adder
C30
(
	.In_Bits({1'b0,For0_wire[3],For0_wire[7],For0_wire[11]}),
	.Out_Bits({For1_wire[3:0]})
);



/* First module of third stage has an specific instance declaration  */
Binary_shift_three_adder
C56
(
	.In_Bits({1'b0,For1_wire[3],For1_wire[7],For1_wire[11]}),
	.Out_Bits({For2_wire[3:0]})
);


/* First module of fourth stage has an specific instance declaration  */
Binary_shift_three_adder
C79
(
	.In_Bits({1'b0,For2_wire[3],For2_wire[7],For2_wire[11]}),
	.Out_Bits({For3_wire[3:0]})
);


/* First module of fifth stage has an specific instance declaration  */
Binary_shift_three_adder
C99
(
	.In_Bits({1'b0,For3_wire[3],For3_wire[7],For3_wire[11]}),
	.Out_Bits({For4_wire[3:0]})
);


/* First module of sixth stage has an specific instance declaration  */
Binary_shift_three_adder
C116
(
	.In_Bits({1'b0,For4_wire[3],For4_wire[7],For4_wire[11]}),
	.Out_Bits({For5_wire[3:0]})
);



/* First module of seventh stage has an specific instance declaration  */
Binary_shift_three_adder
C130
(
	.In_Bits({1'b0,For5_wire[3],For5_wire[7],For5_wire[11]}),
	.Out_Bits({For6_wire[3:0]})
);


/* First module of eighth stage has an specific instance declaration  */
Binary_shift_three_adder
C141
(
	.In_Bits({1'b0,For6_wire[3],For6_wire[7],For6_wire[11]}),
	.Out_Bits({For7_wire[3:0]})
);


/* First module of nineth stage has an specific instance declaration  */
Binary_shift_three_adder
C149
(
	.In_Bits({1'b0,For7_wire[3],For7_wire[7],For7_wire[11]}),
	.Out_Bits({For8_wire[3:0]})
);


/* First module of tenth stage has an specific instance declaration  */
Binary_shift_three_adder
C154
(
	.In_Bits({1'b0,For8_wire[3],For8_wire[7],For8_wire[11]}),
	.Out_Bits({bits_out[41],For9_wire[2:0]})
);


/* First module of eleventh stage has an specific instance declaration  */
Binary_shift_three_adder
C155
(
	.In_Bits({For9_wire[2:0],For8_wire[15]}),
	.Out_Bits(bits_out[40:37])
);

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////




/* Generation of instances for the Binary Shift Three Adder */
generate
	
	/* Binary cycle 1 */
	for(i1 = 0; i1 < 112; i1 = i1 + 4) begin:Binaries
	
	/* We check if it's the last one */
	if(i1 == 108) begin
		Binary_shift_three_adder
		C_Stage1
		(
			.In_Bits({For0_wire[i1+2:i1+0],bits_in[28-(i1/4)]}),
			.Out_Bits({bits_out[4:1]})
		);
	end
	else
	
	/* If not, continue with the regular instance */
	begin
		Binary_shift_three_adder
		C_Stage1
		(
			.In_Bits({For0_wire[i1+2:i1+0],bits_in[28-(i1/4)]}),
			.Out_Bits({For0_wire[i1+7:i1+4]})
		);
	end
	end:Binaries

	
	/* Binary cycle 2 */
	for(i2 = 0; i2 < 100; i2 = i2 + 4) begin:Binaries_2
	
	/* We check if it's the last one */
	if(i2 == 96) begin
		Binary_shift_three_adder
		C_Stage2
		(
			.In_Bits({For1_wire[i2+2:i2+0],For0_wire[15+i2]}),
			.Out_Bits({bits_out[8:5]})
		);
	end
	else
	
	/* If not, continue with the regular instance */
	begin
		Binary_shift_three_adder
		C_Stage2
		(
			.In_Bits({For1_wire[i2+2:i2+0],For0_wire[15+i2]}),
			.Out_Bits({For1_wire[i2+7:i2+4]})
		);
	end
	end:Binaries_2
	
	
	/* Binary cycle 3 */
	for(i3 = 0; i3 < 88; i3 = i3 + 4) begin:Binaries_3
	
	/* We check if it's the last one */
	if(i3 == 84) begin
		Binary_shift_three_adder
		C_Stage3
		(
			.In_Bits({For2_wire[i3+2:i3+0],For1_wire[15+i3]}),
			.Out_Bits({bits_out[12:9]})
		);
	end
	else
	
	/* If not, continue with the regular instance */
	begin
		Binary_shift_three_adder
		C_Stage3
		(
			.In_Bits({For2_wire[i3+2:i3+0],For1_wire[15+i3]}),
			.Out_Bits({For2_wire[i3+7:i3+4]})
		);
	end
	end:Binaries_3
	
	
	
	/* Binary cycle 4 */
	for(i4 = 0; i4 < 76; i4 = i4 + 4) begin:Binaries_4
	
	/* We check if it's the last one */
	if(i4 == 72) begin
		Binary_shift_three_adder
		C_Stage4
		(
			.In_Bits({For3_wire[i4+2:i4+0],For2_wire[15+i4]}),
			.Out_Bits({bits_out[16:13]})
		);
	end
	else
	
	/* If not, continue with the regular instance */
	begin
		Binary_shift_three_adder
		C_Stage4
		(
			.In_Bits({For3_wire[i4+2:i4+0],For2_wire[15+i4]}),
			.Out_Bits({For3_wire[i4+7:i4+4]})
		);
	end
	end:Binaries_4
	
	
	/* Binary cycle 5 */
	for(i5 = 0; i5 < 64; i5 = i5 + 4) begin:Binaries_5
	
	/* We check if it's the last one */
	if(i5 == 60) begin
		Binary_shift_three_adder
		C_Stage5
		(
			.In_Bits({For4_wire[i5+2:i5+0],For3_wire[15+i5]}),
			.Out_Bits({bits_out[20:17]})
		);
	end
	else
	
	/* If not, continue with the regular instance */
	begin
		Binary_shift_three_adder
		C_Stage5
		(
			.In_Bits({For4_wire[i5+2:i5+0],For3_wire[15+i5]}),
			.Out_Bits({For4_wire[i5+7:i5+4]})
		);
	end
	end:Binaries_5
	
	
	/* Binary cycle 6 */
	for(i6 = 0; i6 < 52; i6 = i6 + 4) begin:Binaries_6
	
	/* We check if it's the last one */
	if(i6 == 48) begin
		Binary_shift_three_adder
		C_Stage6
		(
			.In_Bits({For5_wire[i6+2:i6+0],For4_wire[15+i6]}),
			.Out_Bits({bits_out[24:21]})
		);
	end
	else
	
	/* If not, continue with the regular instance */
	begin
		Binary_shift_three_adder
		C_Stage6
		(
			.In_Bits({For5_wire[i6+2:i6+0],For4_wire[15+i6]}),
			.Out_Bits({For5_wire[i6+7:i6+4]})
		);
	end
	end:Binaries_6
	
	
	
	/* Binary cycle 7 */
	for(i7 = 0; i7 < 40; i7 = i7 + 4) begin:Binaries_7
	
	/* We check if it's the last one */
	if(i7 == 36) begin
		Binary_shift_three_adder
		C_Stage7
		(
			.In_Bits({For6_wire[i7+2:i7+0],For5_wire[15+i7]}),
			.Out_Bits({bits_out[28:25]})
		);
	end
	else
	
	/* If not, continue with the regular instance */
	begin
		Binary_shift_three_adder
		C_Stage7
		(
			.In_Bits({For6_wire[i7+2:i7+0],For5_wire[15+i7]}),
			.Out_Bits({For6_wire[i7+7:i7+4]})
		);
	end
	end:Binaries_7
	
	
	
	/* Binary cycle 8 */
	for(i8 = 0; i8 < 28; i8 = i8 + 4) begin:Binaries_8
	
	/* We check if it's the last one */
	if(i8 == 24) begin
		Binary_shift_three_adder
		C_Stage8
		(
			.In_Bits({For7_wire[i8+2:i8+0],For6_wire[15+i8]}),
			.Out_Bits({bits_out[32:29]})
		);
	end
	else
	
	/* If not, continue with the regular instance */
	begin
		Binary_shift_three_adder
		C_Stage8
		(
			.In_Bits({For7_wire[i8+2:i8+0],For6_wire[15+i8]}),
			.Out_Bits({For7_wire[i8+7:i8+4]})
		);
	end
	end:Binaries_8
	
	
	
	/* Binary cycle 9 */
	for(i9 = 0; i9 < 16; i9 = i9 + 4) begin:Binaries_9
	
	/* We check if it's the last one */
	if(i9 == 12) begin
		Binary_shift_three_adder
		C_Stage9
		(
			.In_Bits({For8_wire[i9+2:i9+0],For7_wire[15+i9]}),
			.Out_Bits({bits_out[36:33]})
		);
	end
	else
	
	/* If not, continue with the regular instance */
	begin
		Binary_shift_three_adder
		C_Stage9
		(
			.In_Bits({For8_wire[i9+2:i9+0],For7_wire[15+i9]}),
			.Out_Bits({For8_wire[i9+7:i9+4]})
		);
	end
	end:Binaries_9
	
	
endgenerate
	
	
	
	
	
/* The bit 0 goes directly to the output */
assign bits_out[0] = bits_in[0];
assign bits_out[43:42] = 1'b0;


/* The output values are assigned */
assign out1  = bits_out[3:0];
assign out2  = bits_out[7:4];
assign out3  = bits_out[11:8];
assign out4  = bits_out[15:12];
assign out5  = bits_out[19:16];
assign out6  = bits_out[23:20];
assign out7  = bits_out[27:24];
assign out8  = bits_out[31:28];
assign out9  = bits_out[35:32];
assign out10 = bits_out[39:36];
assign out11 = bits_out[43:40];
	
endmodule
