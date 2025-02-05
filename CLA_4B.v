module CLA_4B (
	input [3:0] x,
	input [3:0] y,
	input c_in,
	output [3:0] s, // sum
	output c_out, //c4 is c_out
	output g, // for higher-bit compound CLA 
	output p
);
	wire g0, p0; //c0 is c_in
	wire c1, g1, p1;
	wire c2, g2, p2;
	wire c3, g3, p3;
	
	//Bit-stage cells
	BSCell cell0 (x[0],y[0],c_in,s[0],g0,p0);
	BSCell cell1 (x[1],y[1],c1,s[1],g1,p1);
	BSCell cell2 (x[2],y[2],c2,s[2],g2,p2);
	BSCell cell3 (x[3],y[3],c3,s[3],g3,p3);
	
	//carry lookahead logic
	assign c1 = g0 | p0 & c_in;
	assign c2 = g1 | (p1 & g0) | (p1 & p0 & c_in);
	assign c3 = g2 | (p2 & g1) | (p2 & p1 & g0) | (p2 & p1 & p0 & c_in);
	assign g = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0);
	assign p = p3 & p2 & p1 & p0;
	assign c_out = g | p & c_in;
	
endmodule