module SixteenBitCLA (
	input [15:0] x,
	input [15:0] y,
	input c_in,
	output [15:0] s, // sum
	output c_out, //c4 is c_out
	output g, // for higher-bit compound CLA 
	output p
);

	wire g0, p0; //c0 is c_in
	wire c1, g1, p1;
	wire c2, g2, p2;
	wire c3, g3, p3;
	
	//Bit-stage cells
	FourBitCLA CLA0 (
		.x(x[3:0]),
		.y(y[3:0]),
		.c_in(c_in),
		.s(s[3:0]),
		.c_out(), //c_out is intentionally left empty, may remove logic associated with this later
		.g(g0),
		.p(p0)
	);
	FourBitCLA CLA1 (
		.x(x[7:4]),
		.y(y[7:4]),
		.c_in(c1),
		.s(s[7:4]),
		.c_out(), //c_out is intentionally left empty, may remove logic associated with this later
		.g(g1),
		.p(p1)
	);
	FourBitCLA CLA2 (
		.x(x[11:8]),
		.y(y[11:8]),
		.c_in(c2),
		.s(s[11:8]),
		.c_out(),
		.g(g2),
		.p(p2)
	);
	FourBitCLA CLA3 (
		.x(x[15:12]),
		.y(y[15:12]),
		.c_in(c3),
		.s(s[15:12]),
		.c_out(),
		.g(g3),
		.p(p3)
	);
	
	//carry lookahead logic
	assign c1 = g0 | p0 & c_in;
	assign c2 = g1 | (p1 & g0) | (p1 & p0 & c_in);
	assign c3 = g2 | (p2 & g1) | (p2 & p1 & g0) | (p2 & p1 & p0 & c_in);
	assign g = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0);
	assign p = p3 & p2 & p1 & p0;
	assign c_out = g | p & c_in;

endmodule