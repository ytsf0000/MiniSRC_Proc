`timescale 1ns/10ps
module Reducer3_2_tb();

wire [32:0] res1;
wire [31:0] res2;

reg [31:0] a;
reg [31:0] b;
reg [31:0] c;
wire done;

Reducer3_2 Test(
	a,b,c,
	res1,res2,done
);

reg [63:0] test_compare;
reg [63:0] test_result;
reg [31:0] seed;

integer i;
initial begin
	for (i = 32'b0; i < 32'h100; i = i + 1) begin
		seed =$random(seed);
		a = seed;
		seed =$random(seed);
		b = seed;
		seed =$random(seed);
		c = seed;

		
		#20; //arbitrary delay
		
		test_compare = a+b+c;
		test_result=res1+res2;
		
//		res1[0]<=1'b0;
		$display("a: %d,b: %d,c: %d, res1: %d, res2: %d, done=%d", a,b,c,res1<<1,res2,done);

		
		
		if (test_compare == test_result) 
			$display ("Correct");
		else begin
			$display ("Incorrect");
			$finish;
		end
	end
end

endmodule