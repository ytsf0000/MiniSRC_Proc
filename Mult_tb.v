`timescale 1ns/10ps
module Mult_tb();

wire signed [63:0] res1;
wire signed [63:0] res2;

reg signed [31:0] a;
reg signed [31:0] b;
wire done;

Mult Test(
	a,b,
	res1,res2,done
);

reg signed [63:0] test_compare;
reg signed [63:0] test_result;
reg [31:0] seed;

integer i;
initial begin
	seed =$random(seed);
	for (i = 0; i < 100000; i = i + 1) begin
		seed =$random(seed);
		a = seed;
		seed =$random(seed);
		b = seed;
		
		#50; //arbitrary delay
		
		test_compare = a*b;
		test_result=res1;
		test_result=test_result<<1;
		test_result=test_result+res2;
		
		$display("a: %d,b: %d, res1: %d, res2: %d, done=%d", a,b,res1<<1,res2,done);
		$display("true: %d, test: %d",test_compare,test_result);
		
		
		if (test_compare == test_result) 
			$display ("Correct");
		else begin
			$display ("Incorrect");
			#20
			$finish;
		end
	end
end

endmodule