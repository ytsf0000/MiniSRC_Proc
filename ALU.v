module ALU (
	input [31:0] a,
	input [31:0] b,
	input ADD, // done
	input SUB, // done
	input MUL, // done
	input DIV, // done
	input SHR, // done
	input SHRA, // done
	input SHL, // done
	input ROR, // done
	input ROL, // done
	input AND, 
	input OR, 
	input NEG, 
	input NOT,
	output reg [63:0] c
);

	wire [31:0] AddSub_Out;
	wire [31:0] Div_Rem_Out;
	wire [31:0] Div_Quo_Out;
	wire [31:0] Shift_Out;
	wire [31:0] Logical_Out;
	wire [63:0] Mul_Out;
	
	wire [31:0] AddSub_In;
	
	// determines whether b should be 2's complement for sub
	assign AddSub_Op = (SUB) ? ~(b) : b;
	
	CLA_32B AddSub_DUT (
		.a(a),
		.b(AddSub_Op),
		.c_in(SUB),
		.s(AddSub_Out), // sum
	);
	
	Div Div_DUT (
		.a(a),
		.b(b),
		.result(Div_Quo_Out),
		.remainderOut(Div_Rem_Out)
	);
	
	Mult Mult_DUT (
		.a(a),
		.b(b),
		.result(Mul_Out)
	);
	
	ALU_Shifting ALU_Shifting_DUT(
		.a(a),
		.b(b),
		.SHR(SHR),
		.SHRA(SHRA),
		.SHL(SHL),
		.ROR(ROR),
		.ROL(ROL),
		.c(Shift_Out)
	);
	
	ALU_Logical ALU_Logical_DUT (
		.a(a),
		.b(b),
		.in_and(AND),
		.in_or(OR),
		.in_neg(NEG),
		.in_not(NOT),
		.c(Logical_Out)
);
	
	always @ (*) begin
		if (ADD | SUB) c = {32'b0,AddSub_Out};
		else if (DIV) c = {Div_Rem_Out,Div_Quo_Out};
		else if (MUL) c = Mul_Out;
		else if (SHR | SHRA | SHL | ROR | ROL) c = {32'b0,Shift_Out};
		else if (AND | OR | NEG | NOT) c = {32'b0,Logical_Out};
		else c = 64'b0;
	end

endmodule