module MDR
#(
	parameter INBitsSQ=32,
	parameter INBitsD_M = 16,
	parameter IBits = 5
)
(
	input clk,
	input reset,
	input start,
	input loadctl,
	input [1:0]op,
	input [15:0] Data,
	
	output [INBitsSQ-1:0] result,
	output [INBitsSQ-1:0] reminder,
	output sign_MDR,
	output ready_MDR
);

	/* Wires Mult */
	wire [15:0] Mult_Data_Q;
	wire [15:0] Mult_Data_M;
	wire [15:0] Mult_True_Data_M;
	wire [15:0] Mult_True_Data_Q;
	wire [15:0] Mult_Data_Q_wire;
	wire [15:0] Mult_Data_M_wire;
	wire [32:0] Mult_Data_Extended_wire;
	wire [32:0] Mult_First_Result_wire;
	wire [32:0] Mult_Register_Q_wire;
	wire [15:0] Mult_Register_M_wire;
	wire [15:0] Mult_Add_Sub_wire;
	wire [15:0] Mult_Mux2to1_Result_wire;
	wire [32:0] Mult_Final_Result_wire;
	wire [31:0] Mult_Result;
	wire Mult_Result_Sign;
	

	/* Wires SQRR */
	wire [INBitsSQ-1:0] SQRR_RSL1;
	wire [INBitsSQ-1:0] SQRR_DSR1;
	wire [INBitsSQ-1:0] SQRR_DA1;
	wire [INBitsSQ-1:0] SQRR_RO1;
	wire [INBitsSQ-1:0] SQRR_QSL2;
	wire [INBitsSQ-1:0] SQRR_RSR2;
	wire [1:0] SQRR_RMUX1;
	wire [INBitsSQ-1:0] SQRR_QO2;
	wire [INBitsSQ-1:0] SQRR_RADDER1;
	wire [INBitsSQ-1:0] SQRR_QSL3;
	wire [INBitsSQ-1:0] SQRR_QO3;
	wire [INBitsSQ-1:0] SQRR_QMUX2;
	wire [INBitsSQ-1:0] SQRR_RSR3;
	wire [INBitsSQ-1:0] SQRR_RMUXIN1;
	wire [INBitsSQ-1:0] SQRR_QMUXIN2;
	wire [INBitsSQ-1:0] SQRR_Ro;
	wire [INBitsSQ-1:0] SQRR_Qo;
	wire [INBitsSQ-1:0] SQRR_RMUXLAST1;
	wire [INBitsSQ-1:0] SQRR_QMUXLAST2;
	wire SQRR_RMUXLAST3;
	wire SQRR_RMUXLAST4;
	wire [INBitsSQ-1:0] SQRR_RMUXLAST5;
	wire [INBitsSQ-1:0] SQRR_RSR4;
	wire [INBitsSQ-1:0] SQRR_Rf;
	wire [INBitsSQ-1:0] SQRR_Qf;
	wire [INBitsSQ-1:0] SQRR_DSR5;
	wire [INBitsSQ-1:0] SQRR_DMUXNEG1;
	wire [INBitsSQ-1:0] SQRR_QMUXNEG2;
	wire [INBitsSQ-1:0]SQRR_D;
	
	/* Wires DIV */
	wire DIV_DSRL1;
	wire [INBitsD_M-1:0] DIV_DOR1;
	wire [INBitsD_M-1:0] DIV_SL1;
	wire [INBitsD_M-1:0] DIV_REG1;
	wire DIV_COMP1;
	wire [INBitsD_M-1:0] DIV_MUXOP1;
	wire [INBitsD_M-1:0] DIV_ADDER;
	wire [INBitsD_M-1:0] DIV_SRL2;
	wire [INBitsD_M-1:0] DIV_REG2;
	wire [INBitsD_M-1:0] DIV_REG3;
	wire [INBitsD_M-1:0] DIV_A2Divisor;
	wire [INBitsD_M-1:0] DIV_A2Dividendo;
	wire DIV_DivisorSign;
	wire DIV_DividendSign;
	wire DIV_XOR1Sign;
	wire DIV_COMPCERO1;
	wire [INBitsD_M-1:0] DIV_MUXCERO1;
	wire [INBitsD_M-1:0] DIV_MUXCERO2;
	wire [INBitsD_M-1:0] Div_Dividend;
	wire [INBitsD_M-1:0] Div_Divisor;
	
	/* Flags MULT*/

	bit Sign_Q_bit;
	bit Sign_M_bit;
	bit Op_bit;
	bit Shift_Op_bit;
	bit sign_0_Q_bit;
	bit sign_0_M_bit;
	bit Sign_Final_bit;
	bit Sign_Selector_bit;
	
	/* Bits MULT*/
	bit one_shot_bit;
	bit first_bit;
	bit first_m_bit;
	bit ready_bit;
	bit sys_reset_bit;
	bit loadX_bit;
	bit loadY_bit;
	bit loadrst_bit;
	
	/*STATE Flags SQRR_DIV_MULT*/
	wire sys_reset;
	wire load;
	wire on;
	wire ready;
	wire last;
	wire loadrst;
	wire loadx;
	wire loady;
	
	/*STATE Flags SQRR*/
	wire [4:0] i;
	
	/*STATE Flags MULT*/
	wire on_m;
	
	wire ready_pulse;
	

	wire MUXADDEROPW;
	wire [31:0] MUXADDERAW;
	wire [31:0]MUXADDERBW;
	wire [31:0] AdderSubOut;
	
	wire [31:0] result_out;
	wire [31:0] reminder_out;
	wire sign_out;
	

//////// MULT Instances************************************************************

Register #( 16 ) Mult_Init_Q
(
	.clk(clk),
	.reset(reset),
	.enable(loadx),
	.sys_reset(loadrst),
	.Data_Input(Data),
	.Data_Output(Mult_Data_Q)
);


Register #( 16 ) Mult_Init_M
(
	.clk(clk),
	.reset(reset),
	.enable(loady),
	.sys_reset(loadrst),
	.Data_Input(Data),
	.Data_Output(Mult_Data_M)
);



Data_Inputs_Comp #( 16 ) Mult_Data_In
(
	.Q(Mult_Data_Q),
	.M(Mult_Data_M),
	.Q_out(Mult_True_Data_Q),
	.M_out(Mult_True_Data_M)
);

Mult_Comparator #( 16 ) Mult_Check_0_Q
(
	.A(Mult_True_Data_Q),
	.Out(sign_0_Q_bit)
);


Mult_Comparator #( 16 ) Mult_Check_forM
(
	.A(Mult_True_Data_M),
	.Out(sign_0_M_bit)
);


Binary_a2_complement_converter #(INBitsD_M)  Mult_a2_Q
(
	.In_Bits(Mult_True_Data_Q),
	.Out_Bits(Mult_Data_Q_wire),
	.Sign(Sign_Q_bit)
);



Binary_a2_complement_converter#(INBitsD_M)  Mult_a2_M
(
	.In_Bits(Mult_True_Data_M),
	.Out_Bits(Mult_Data_M_wire),
	.Sign(Sign_M_bit)
);



Mult_Extend Mult_Mult_Extend
(
	.value_in(Mult_Data_Q_wire),
	.value_out(Mult_Data_Extended_wire)
);



Multiplexer2to1 #( 33 ) Mult_Multiplexer2to1_Init
(
	.Selector(load),
	.MUX_Data0(Mult_Final_Result_wire),
	.MUX_Data1(Mult_Data_Extended_wire),
	.MUX_Output(Mult_First_Result_wire)

);



Register #( 33 ) Mult_Register_Q
(
	.clk(clk),
	.reset(reset),
	.enable(on),
	.sys_reset(sys_reset),
	.Data_Input(Mult_First_Result_wire),
	.Data_Output(Mult_Register_Q_wire)
);



Register #( 16 ) Mult_Register_M
(
	.clk(clk),
	.reset(reset),
	.enable(on_m),
	.sys_reset(sys_reset),
	.Data_Input(Mult_Data_M_wire),
	.Data_Output(Mult_Register_M_wire)
);



Operation Mult_Operation_for_Qs
(
	.Q(Mult_Register_Q_wire[1:0]),
	.Op(Op_bit),
	.Shift_Op(Shift_Op_bit)
);


Multiplexer2to1 #( 16 ) Mult_Multiplexer2to1
(
	.Selector(Shift_Op_bit),
	.MUX_Data0(Mult_Add_Sub_wire),
	.MUX_Data1(Mult_Register_Q_wire[32:17]),
	.MUX_Output(Mult_Mux2to1_Result_wire)

);


OrM #( 33 ) Mult_Or_Result
(
	.A({Mult_Register_Q_wire[1],Mult_Mux2to1_Result_wire[15:1],17'b00000000000000000}),
	.B({16'b0000000000000000,Mult_Mux2to1_Result_wire[0],Mult_Register_Q_wire[16:1]}),	
	.OUT(Mult_Final_Result_wire)
);



Register #( 32 ) Register_Result
(
	.clk(clk),
	.reset(reset),
	.enable(last),
	.sys_reset(sys_reset),
	.Data_Input(Mult_Final_Result_wire[32:1]),
	.Data_Output(Mult_Result)
);


Xor_M #( 1 ) Mult_Xor_Sign

(
	.A(Sign_Q_bit),
	.B(Sign_M_bit),
	.OUT(Sign_Final_bit)
);

OrM #( 1 ) Mult_Sign_0
(
	.A(sign_0_Q_bit),
	.B(sign_0_M_bit),
	.OUT(Sign_Selector_bit)

);


Multiplexer2to1 #( 1 ) Mult_Mux_Sign
(
	.Selector(Sign_Selector_bit),
	.MUX_Data0(Sign_Final_bit),
	.MUX_Data1(1'b0),
	.MUX_Output(Mult_Result_Sign)

);


//////// SQRR Instances***************************************************************


///////////////////////////////////////////////
  
  ShiftLeft #(INBitsSQ,2) SQRR_SL1
(
	.A(SQRR_Ro),
	.B(2'd2),
	
	.OUT(SQRR_RSL1)

);

  ShiftRight #(INBitsSQ,IBits) SQRR_SR1
(
	.A(SQRR_D),
	.B(i),
	
	.OUT(SQRR_DSR1)

);
 
 AndM #(INBitsSQ) SQRR_And1
(
	.A(SQRR_DSR1),
	.B(32'd3),
	
	.OUT(SQRR_DA1)

);

 OrM #(INBitsSQ) SQRR_Or1
(
	.A(SQRR_RSL1),
	.B(SQRR_DA1),
	
	.OUT(SQRR_RO1)

);
/////////////////////////////////////////////////////////Until OP1

  ShiftLeft #(INBitsSQ,2) SQRR_SL2
(
	.A(SQRR_Qo),
	.B(2'd2),
	
	.OUT(SQRR_QSL2)

);

 ShiftRight #(INBitsSQ,5) SQRR_SR2
(
	.A(SQRR_Ro),
	.B(5'd31),
	
	.OUT(SQRR_RSR2)

);

 Multiplexer2to1 #(2) SQRR_MUX1

(
	.Selector(SQRR_RSR2[0]),
	.MUX_Data0(2'd1),
	.MUX_Data1(2'd3),
	
	.MUX_Output(SQRR_RMUX1)

);

 OrM #(INBitsSQ) SQRR_Or2
(
	.A({30'd0,SQRR_RMUX1}),
	.B(SQRR_QSL2),
	
	.OUT(SQRR_QO2)

);
 
////////////////////////////////////////////////Until OP2

  ShiftLeft #(INBitsSQ,1) SQRR_SL3
(
	.A(SQRR_Qo),
	.B(1'd1),
	
	.OUT(SQRR_QSL3)

);

 OrM #(INBitsSQ) SQRR_Or3
(
	.A(32'd1),
	.B(SQRR_QSL3),
	
	.OUT(SQRR_QO3)

);

 ShiftRight #(INBitsSQ,5) SQRR_SR3
(
	.A(SQRR_RADDER1),
	.B(5'd31),
	
	.OUT(SQRR_RSR3)

);



 Multiplexer2to1 #(INBitsSQ) SQRR_MUX2

(
	.Selector(SQRR_RMUXLAST4),
	.MUX_Data0(SQRR_QO3),
	.MUX_Data1(SQRR_QSL3),
	
	.MUX_Output(SQRR_QMUX2)

);

///////////////////////////////////////////////Until Op3


 Multiplexer2to1 #(INBitsSQ) SQRR_MUXIN1

(
	.Selector(~load),
	.MUX_Data0({INBitsSQ{1'b0}}),
	.MUX_Data1(SQRR_RADDER1),
	
	.MUX_Output(SQRR_RMUXIN1)

);

 Multiplexer2to1 #(INBitsSQ) SQRR_MUXIN2

(
	.Selector(~load),
	.MUX_Data0({INBitsSQ{1'b0}}),
	.MUX_Data1(SQRR_QMUX2),
	
	.MUX_Output(SQRR_QMUXIN2)

);


 Register #(INBitsSQ) SQRR_Reg1
(
	
	.clk(clk),
	.reset(reset),
	.enable(on),
	.sys_reset(sys_reset),
	.Data_Input(SQRR_RMUXIN1),

	.Data_Output(SQRR_Ro)
);

 Register #(INBitsSQ) SQRR_Reg2
(
	
	.clk(clk),
	.reset(reset),
	.enable(on),
	.sys_reset(sys_reset),
	.Data_Input(SQRR_QMUXIN2),

	.Data_Output(SQRR_Qo)
);


Ctl_Unit_F CTL_UNIT1
(
	//Inputs
	.start(start),
	.reset(reset),
	.clk(clk),
	.op(op),
	.loadctl(loadctl),
	
	//Outputs

	.sys_reset(sys_reset),
	.load(load),
	.loadrst(loadrst),
	.loadx(loadx),
	.loady(loady),
	
	.on(on),
	.on_m(on_m),
	.ready(ready),
	.last(last),
	.i(i),
	.ready_pulse(ready_pulse)
);

///////////////////////////////////////////////Until all cycles

 Multiplexer2to1 #(INBitsSQ) SQRR_MUXLAST1

(
	.Selector(last),
	.MUX_Data0(SQRR_RO1),
	.MUX_Data1(SQRR_Ro),
	
	.MUX_Output(SQRR_RMUXLAST1)

);

 Multiplexer2to1 #(INBitsSQ) SQRR_MUXLAST2

(
	.Selector(last),
	.MUX_Data0(SQRR_QO2),
	.MUX_Data1(SQRR_QMUX2),
	
	.MUX_Output(SQRR_QMUXLAST2)

);

 Multiplexer2to1 #(1) SQRR_MUXLAST3

(
	.Selector(last),
	.MUX_Data0(SQRR_RSR2[0]),
	.MUX_Data1(1'b1),
	
	.MUX_Output(SQRR_RMUXLAST3)

);

 Multiplexer2to1 #(1) SQRR_MUXLAST4

(
	.Selector(last),
	.MUX_Data0(SQRR_RSR3[0]),
	.MUX_Data1(1'b0),
	
	.MUX_Output(SQRR_RMUXLAST4)

);

 ShiftRight #(INBitsSQ,5) SQRR_SR4
(
	.A(SQRR_Ro),
	.B(5'd31),
	
	.OUT(SQRR_RSR4)

);


 Multiplexer2to1 #(INBitsSQ) SQRR_MUXLAST5

(
	.Selector(SQRR_RSR4[0]),
	.MUX_Data0(SQRR_Ro),
	.MUX_Data1(SQRR_RADDER1),
	
	.MUX_Output(SQRR_RMUXLAST5)

);

 Register #(INBitsSQ) SQRR_Reg3
(
	
	.clk(clk),
	.reset(reset),
	.enable(last),
	.sys_reset(sys_reset),
	.Data_Input(SQRR_DMUXNEG1),

	.Data_Output(SQRR_Rf)
);

 Register #(INBitsSQ) SQRR_Reg4
(
	
	.clk(clk),
	.reset(reset),
	.enable(last),
	.sys_reset(sys_reset),
	.Data_Input(SQRR_QMUXNEG2),

	.Data_Output(SQRR_Qf)
);


///////////////////////////////////////////////Until Last Validation

 ShiftRight #(INBitsSQ,5) SQRR_SR5
(
	.A(SQRR_D),
	.B(5'd15),
	
	.OUT(SQRR_DSR5)

);

 Multiplexer2to1 #(INBitsSQ) SQRR_MUXNEGD1

(
	.Selector(SQRR_DSR5[0]),
	.MUX_Data0(SQRR_RMUXLAST5),
	.MUX_Data1(32'd65535),
	
	.MUX_Output(SQRR_DMUXNEG1)

);

 Multiplexer2to1 #(INBitsSQ) SQRR_MUXNEGQ2

(
	.Selector(SQRR_DSR5[0]),
	.MUX_Data0(SQRR_Qo),
	.MUX_Data1(32'd65535),
	
	.MUX_Output(SQRR_QMUXNEG2)

);

/////////////////////////////////////////////////////////////////

Register #(INBitsSQ) SQRR_DREG
(
	.clk(clk),
	.reset(reset),
	.enable(loadx),
	.sys_reset(loadrst),
	.Data_Input({{16{1'b0}},Data}),
	.Data_Output(SQRR_D)
);	


//////// DIV Instances***************************************************************

ShiftRegisterLeft #(INBitsD_M) Div_SRL1
(
	.clk(clk),
	.reset(reset),
	.sys_reset(sys_reset),
	.load(load),
	.serialInput(1'b0),
	.shift(on),
	.parallelInput(DIV_A2Divisor),	
	.serialOutput(DIV_DSRL1),
	.parallelOutput()
);

OrM #(INBitsD_M) Div_OR1
(
	.A(DIV_SL1),
	.B({15'b0,DIV_DSRL1}),
	.OUT(DIV_DOR1)

);

Shift_Left  #( INBitsD_M, 1 ) Div_SL1
(
	.A(DIV_REG1),
	.B(1'b1),
	.OUT(DIV_SL1)

);

Register #(INBitsD_M) Div_REG1
(
	.clk(clk),
	.enable(on),
	.reset(reset),
	.sys_reset(sys_reset),
	.Data_Input(DIV_ADDER),
	.Data_Output(DIV_REG1)
);


Multiplexer2to1 #(INBitsD_M) Div_MuxOP1
(
	.Selector(DIV_COMP1),
	.MUX_Data0(16'b0),
	.MUX_Data1(DIV_A2Dividendo),
	.MUX_Output(DIV_MUXOP1)

);


Comparador #(INBitsD_M) Div_Comp1
(
	.A(DIV_A2Dividendo),
	.B(DIV_DOR1),
	.C(DIV_COMP1)
	
);


ShiftRegisterLeft #(INBitsD_M) Div_SRL2
(
	.clk(clk),
	.reset(reset),
	.sys_reset(sys_reset),
	.load(1'b0),
	.serialInput(DIV_COMP1),
	.shift(on),
	.parallelInput(),	
	.serialOutput(),
	.parallelOutput(DIV_SRL2)
);

Register #(INBitsD_M) Div_REG2
(
	.clk(clk),
	.enable(last),
	.reset(reset),
	.sys_reset(sys_reset),
	.Data_Input(DIV_MUXCERO1),
	.Data_Output(DIV_REG2)
);

Register #(INBitsD_M) Div_REG3
(
	.clk(clk),
	.enable(last),
	.reset(reset),
	.sys_reset(sys_reset),
	.Data_Input(DIV_MUXCERO2),
	.Data_Output(DIV_REG3)
);

//////////////////////////////////////////////////Sign and extra Validations

 Binary_a2_complement_converter#(INBitsD_M) Div_A2CMP1 
(
	.In_Bits(Div_Divisor),

	.Out_Bits(DIV_A2Divisor),
	.Sign(DIV_DivisorSign)
);

 Binary_a2_complement_converter#(INBitsD_M) Div_A2CMP2 

(
	.In_Bits(Div_Dividend),

	.Out_Bits(DIV_A2Dividendo),
	.Sign(DIV_DividendSign)
);


 Xor_M #(1) Div_XOR1

(
	.A(DIV_DivisorSign),
	.B(DIV_DividendSign),
	
	.OUT(DIV_XOR1Sign)

);



 ComparadorCero #(INBitsD_M) Div_COMPCERO

(
	.A(Div_Dividend),
	
	.OUT(DIV_COMPCERO1)
	
);

Multiplexer2to1 #(INBitsD_M) Div_MUXCERO1
(
	.Selector(DIV_COMPCERO1),
	.MUX_Data0(DIV_SRL2),
	.MUX_Data1(16'd65535),
	.MUX_Output(DIV_MUXCERO1)

);

Multiplexer2to1 #(INBitsD_M) Div_MUXCERO2
(
	.Selector(DIV_COMPCERO1),
	.MUX_Data0(DIV_REG1),
	.MUX_Data1(16'd65535),
	.MUX_Output(DIV_MUXCERO2)

);


//////////////////////////////////////////////////////


Register #(INBitsD_M) Div_Init_Divisor
(
	.clk(clk),
	.reset(reset),
	.enable(loadx),
	.sys_reset(loadrst),
	.Data_Input(Data),
	.Data_Output(Div_Divisor)
);


Register #(INBitsD_M) Div_Init_Dividend
(
	.clk(clk),
	.reset(reset),
	.enable(loady),
	.sys_reset(loadrst),
	.Data_Input(Data),
	.Data_Output(Div_Dividend)
);

///////ADDER and MUX*******************************************


//Add_Sub #( 16 ) Mult_Add_Sub
//(
//	.Op(Op_bit),
//	.A(Mult_Register_Q_wire[32:17]),
//	.B(Mult_Register_M_wire),
//	.C(Mult_Add_Sub_wire)
//	
//);
//
//Add_Sub #(INBitsD_M) Div_Adder
//(
//	.Op(1'b0),
//	.A(DIV_DOR1),
//	.B(DIV_MUXOP1),
//	.C(DIV_ADDER)
//	
//);
//
// Add_Sub #(32) AdderSubSQRR
//(
//
//	.Op(SQRR_RMUXLAST3),
//	.A(SQRR_RMUXLAST1),
//	.B(SQRR_QMUXLAST2),
//	
//	.C(SQRR_RADDER1)
//	
//);



Mux3to1 #(1) MUXADDEROP

(
	.Selector(op),
	.MUX_Data0(1'b0),	// Division
	.MUX_Data1(Op_bit),  // Multiplicacion
	.MUX_Data2(SQRR_RMUXLAST3),  // Raiz Cuadrada
	
	.MUX_Output(MUXADDEROPW)

);


Mux3to1 #(32) MUXADDERA

(
	.Selector(op),
	.MUX_Data0({16'b0, DIV_DOR1}),							// Division
	.MUX_Data1({16'b0, Mult_Register_Q_wire[32:17]}),  // Multiplicacion
	.MUX_Data2(SQRR_RMUXLAST1), 				 // Raiz Cuadrada
	
	.MUX_Output(MUXADDERAW)

);


Mux3to1 #(32) MUXADDERB

(
	.Selector(op),
	.MUX_Data0({16'b0,DIV_MUXOP1}),							// Division
	.MUX_Data1({16'b0,Mult_Register_M_wire}),  // Multiplicacion
	.MUX_Data2(SQRR_QMUXLAST2), 				 // Raiz Cuadrada
	
	.MUX_Output(MUXADDERBW)

);


 Add_Sub #(32) AdderSub
(

	.Op(MUXADDEROPW),
	.A(MUXADDERAW),
	.B(MUXADDERBW),
	
	.C(AdderSubOut)
	
);



assign Mult_Add_Sub_wire = AdderSubOut[15:0];
assign DIV_ADDER = AdderSubOut[15:0];
assign SQRR_RADDER1 = AdderSubOut;


Mux3to1 #(32) MUXresult

(
	.Selector(op),
	.MUX_Data0({16'b0,DIV_REG2}),		 // Division
	.MUX_Data1(Mult_Result), 			 // Multiplicacion
	.MUX_Data2(SQRR_Qf), 				 // Raiz Cuadrada
	
	.MUX_Output(result_out)

);

Mux3to1 #(32) MUXreminder

(
	.Selector(op),
	.MUX_Data0({16'b0,DIV_REG3}),		 // Division
	.MUX_Data1(32'b0), 					 // Multiplicacion
	.MUX_Data2(SQRR_Rf), 				 // Raiz Cuadrada
	
	.MUX_Output(reminder_out)

);

Mux3to1 #(1) MUXsign

(
	.Selector(op),
	.MUX_Data0(DIV_XOR1Sign),								    		 // Division
	.MUX_Data1(Mult_Result_Sign),  									 // Multiplicacion
	.MUX_Data2(1'b0), 															 // Raiz Cuadrada
	
	.MUX_Output(sign_out)

);

assign ready_MDR= ready;


Register #(INBitsSQ) REG_result
(
	
	.clk(clk),
	.reset(reset),
	.enable(ready_pulse),
	.sys_reset(loadrst),
	.Data_Input(result_out),

	.Data_Output(result)
);

Register #(INBitsSQ) REG_rem
(
	
	.clk(clk),
	.reset(reset),
	.enable(ready_pulse),
	.sys_reset(loadrst),
	.Data_Input(reminder_out),

	.Data_Output(reminder)
);

Register #(1) REG_sign
(
	
	.clk(clk),
	.reset(reset),
	.enable(ready_pulse),
	.sys_reset(loadrst),
	.Data_Input(sign_out),

	.Data_Output(sign_MDR)
);

endmodule
