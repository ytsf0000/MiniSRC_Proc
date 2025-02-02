module ALU_Logical (
	input [31:0] a,
	input [31:0] b,
	input in_and,
	input in_or,
	input in_neg,
	input in_not,
	output reg [31:0] c
);

	//NOTE: For single register argument operations neg, not, input a is read only.

	wire [31:0] out_and;
	wire [31:0] out_or;
	wire [31:0] out_neg;
	wire [31:0] out_not;

	always @ (*) begin
		if (in_and) c = out_and;
		else if (in_or) c = out_or;
		else if (in_neg) c = out_neg;
		else if (in_not) c = out_not;
		else c = 32'b0;
	end

	assign out_and = a & b;
	assign out_or = a | b;
	assign out_neg = a |
	assign out_not = ~a;

endmodule