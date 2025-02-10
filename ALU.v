module ALU (
	input [31:0] a,
	input [31:0] b,
	input ADD, // done
	input SUB, // done
	input MUL, // done
	input DIV, //done
	input SHR, 
	input SHRA,
	input SHL, 
	input ROR, 
	input ROL, 
	input AND, 
	input OR, 
	input NEG, 
	input NOT,
	output reg [63:0] ALU_Out
);

	wire [31:0] AddSub_Out;
	wire [31:0] Div_Rem_Out;
	wire [31:0] Div_Quo_Out;
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
	
	always @ (*) begin
		if (ADD | SUB) ALU_Out = AddSub_Out;
		else if (DIV) ALU_Out = {Div_Rem_Out,Div_Quo_Out};
		else if (MUL) ALU_Out = Mul_Out;
		
	end

endmodule