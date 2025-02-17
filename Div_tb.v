`timescale 1ns/10ps
module Div_tb();

wire signed [31:0] res;
wire signed [31:0] rem;

reg signed [31:0] a;
reg signed [31:0] b;

Div Test(
	a,b,
	res,rem
);

reg signed [31:0] test_compare;
reg signed [31:0] test_result;
reg [31:0] seed;

integer i;
initial begin
	seed =$random(seed);
	for (i = 0; i < 10000; i = i + 1) begin
		seed =$random(seed);
		a = seed%32'hFFFFFFFF;
		seed =$random(seed);
		b = seed;
		
		#50; //arbitrary delay
		
		test_compare = a/b;
		test_result=res;
		
		$display("a: %d,b: %d, res: %d, remainder: %d", a,b,res,rem);
		$display("true: %d, true remainder: %d, test: %d",test_compare,a%b,test_result);
		
		
		if (test_compare === test_result) 
			$display ("Correct");
		else begin
			$display ("Incorrect");
			#20
			$finish;
		end
	end
end

endmodule