module Div (
	input [31:0] a,
	input [31:0] b,
	output [63:0] result
);


wire divisor;
Fast2complement(b[31],{32'b0,b},divisor);

wire [63:0]divisorArray[32:0];
wire [63:0]resultArray[32:0];

assign resultArray[0]=64'b0;
genvar i;
generate for (i = 0; i < 32; i = i + 1) begin: DivisionStep
  Fast2complement stepDivisor(~resultArray[i][31],divisor,divisorArray[i]);
  CLA_64B step(
    .a({{32{1'b0}},{resultArray[i][30:0],a[31-i]}}),
    .b(stepDivisor),
    .s(resultArray[i+1]),
    .c_out()
  );
  assign result[31-i]=~resultArray[i+1][31];
end endgenerate


always @(*) begin

end

endmodule