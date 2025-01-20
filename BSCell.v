module BSCell (
	input x,
	input y,
	input c,
	output s,
	output g,
	output p
);

assign p = x ^ y;
assign g = x & y;
assign s = c ^ p;

endmodule