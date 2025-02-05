module CLA_32B (
	input[31:0] a,
	input[31:0] b,
	input c_in,
	output [31:0] s, // sum
	output c_out //c4 is c_out
);

	wire g0, p0; //c0 is c_in
	wire c1, g1, p1;
	wire c2, g2, p2;
	wire c3, g3, p3;
	
	//Bit-stage cells
	CLA_16B CLA0 (
		.x(a[15:0]),
		.y(b[15:0]),
		.c_in(c_in),
		.s(s[15:0]),
		.c_out(), //c_out is intentionally left empty, may remove logic associated with this later
		.g(g0),
		.p(p0)
	);
	CLA_16B CLA1 (
		.x(a[31:16]),
		.y(b[31:16]),
		.c_in(c1),
		.s(s[31:16]),
		.c_out(c_out), //c_out is intentionally left empty, may remove logic associated with this later
		.g(g1),
		.p(p1)
	);

	//carry lookahead logic
	assign c1 = g0 | p0 & c_in;

endmodule