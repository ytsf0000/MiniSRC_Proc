module AddSub_64B (
	input [63:0] a,
	input [63:0] b,
	input add,
	input sub,
	output [63:0] s, // sum
	output c_out, //c4 is c_out
	output c_out32b
);

	wire g0, p0; //c0 is c_in
	wire c1, g1, p1;
	wire c2, g2, p2;
	wire c3, g3, p3;
	
	wire [63:0] operand;
	wire [63:0] sum;
	wire c_in;
	
	// For subtraction control bit, provide 2's complement to y, output logic multiplexer
	assign operand = sub ? ~b : b;
	assign c_in = sub ? 1'b1 : 1'b0;
	assign s = (add | sub) ? sum : 64'b0;
	
	//Bit-stage cells
	SixteenBitCLA CLA0 (
		.x(a[15:0]),
		.y(operand[15:0]),
		.c_in(c_in),
		.s(sum[15:0]),
		.c_out(), //c_out is intentionally left empty, may remove logic associated with this later
		.g(g0),
		.p(p0)
	);
	SixteenBitCLA CLA1 (
		.x(a[31:16]),
		.y(operand[31:16]),
		.c_in(c1),
		.s(sum[31:16]),
		.c_out(), //c_out is intentionally left empty, may remove logic associated with this later
		.g(g1),
		.p(p1)
	);
	SixteenBitCLA CLA2 (
		.x(a[47:32]),
		.y(operand[47:32]),
		.c_in(c2),
		.s(sum[47:32]),
		.c_out(),
		.g(g2),
		.p(p2)
	);
	SixteenBitCLA CLA3 (
		.x(a[63:48]),
		.y(operand[63:48]),
		.c_in(c3),
		.s(sum[63:48]),
		.c_out(),
		.g(g3),
		.p(p3)
	);
	
	//carry lookahead logic
	assign c1 = g0 | p0 & c_in;
	assign c2 = g1 | (p1 & g0) | (p1 & p0 & c_in);
	assign c3 = g2 | (p2 & g1) | (p2 & p1 & g0) | (p2 & p1 & p0 & c_in);
	assign c_out = (g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0)) | (p3 & p2 & p1 & p0) & c_in;
	assign c_out32b = s[32];
	
endmodule