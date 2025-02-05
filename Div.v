module Div (
	input [31:0] a,
	input [31:0] b,
	output [31:0] result,
	output [31:0] remainderOut
);

wire [31:0] dividend;
Fast2complement DividendNeg(a[31],{{32{a[31]}},a},dividend);


wire [31:0]tmpResult;
wire [31:0]divisor;
Fast2complement DivisorNeg(b[31],{{32{b[31]}},b},divisor);

wire [31:0]divisorArray[31:0];
wire [31:0]remainder[32:0];

assign remainder[0]=32'b0;

genvar i;
generate for (i = 0; i < 32; i = i + 1) begin: DivisionStep
	Fast2complement stepDiv(~remainder[i][31],divisor,divisorArray[i]);
	CLA_32B setp(
		.a({remainder[i][30:0],dividend[31-i]}),
		.b(divisorArray[i]),
		.c_in(1'b0),
		.s(remainder[i+1]),
		.c_out()
	);
	 
	assign tmpResult[31-i] = ~remainder[i+1][31];
end endgenerate


assign remainderOut=remainder[32];
Fast2complement ResultCompl(a[31]^b[31],{{32{tmpResult[31]}},tmpResult},result);

endmodule