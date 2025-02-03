module CLA_64B (
	input [63:0] a,
	input [63:0] b,
	output [63:0] s, // sum
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
		.c_in(1'b0),
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
		.c_out(), //c_out is intentionally left empty, may remove logic associated with this later
		.g(g1),
		.p(p1)
	);
	CLA_16B CLA2 (
		.x(a[47:32]),
		.y(b[47:32]),
		.c_in(c2),
		.s(s[47:32]),
		.c_out(),
		.g(g2),
		.p(p2)
	);
	CLA_16B CLA3 (
		.x(a[63:48]),
		.y(b[63:48]),
		.c_in(c3),
		.s(s[63:48]),
		.c_out(c_out),
		.g(g3),
		.p(p3)
	);
	
	//carry lookahead logic
	assign c1 = g0 ;
	assign c2 = g1 | (p1 & g0) ;
	assign c3 = g2 | (p2 & g1) | (p2 & p1 & g0) ;
	
endmodule