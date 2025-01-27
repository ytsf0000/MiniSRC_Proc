`timescale 1ns/10ps
module Reducer3_2_tb();

wire [63:0] res1;
wire [63:0] res2;

reg [63:0] a;
reg [63:0] b;
reg [63:0] c;

Reducer3_2 Test(
	a[31:0],b[31:0],c[31:0],
	res2[31:0],res1[31:0]
);
Reducer3_2 Test1(
	a[63:32],b[63:32],c[63:32],
	res2[63:32],res1[63:32]
);

reg [63:0] test_compare;
reg [63:0] test_result;
reg [31:0] seed;

integer i;
initial begin
	for (i = 0; i < 10000000; i = i + 1) begin
		seed =$random(seed);
		a[31:0] = seed;
		seed =$random(seed);
		a[63:32]=seed;
		seed =$random(seed);
		b[31:0] = seed;
		seed =$random(seed);
		b[63:32] = seed;
		seed =$random(seed);
		c[31:0] = seed;
		seed =$random(seed);
		c[63:32] = seed;
		
		#20; //arbitrary delay
		
		test_compare = a+b+c;
		test_result=res1;
		test_result=test_result<<1;
		test_result=test_result+res2;
		
//		res1[0]<=1'b0;
		$display("a: %d,b: %d,c: %d, res1: %d, res2: %d", a,b,c,res1<<1,res2);

		
		
		if (test_compare == test_result) 
			$display ("Correct");
		else begin
			$display ("Incorrect");
			$finish;
		end
	end
end

endmodule