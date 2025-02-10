module Modulo (
	input [31:0] a,
	input [31:0] b,
	output [31:0] result
);


Div div(.a(a),.b(b),.result(),.remainderOut(result));

endmodule