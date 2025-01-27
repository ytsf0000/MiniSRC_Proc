`timescale 1ns/10ps
module Reducer7_3_tb();

wire [31:0] res1;
wire [32:0] res2;
wire [33:0] res3;


reg [31:0] a;
reg [31:0] b;
reg [31:0] c;
reg [31:0] d;
reg [31:0] e;
reg [31:0] f;
reg [31:0] g;
wire done;

Reducer7_3 Test(
	a,b,c,d,e,f,
	res3,res2,res1,done
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
		seed =$random(seed);
		d = seed;
		seed =$random(seed);
		e = seed;
		seed =$random(seed);
		f = seed;
		seed =$random(seed);
		g = seed;

		
		#20; //arbitrary delay
		
		test_compare = a+b+c+d+e+f+g;
		test_result=res1+res2+res3;
		
//		res1[0]<=1'b0;
		$display("a: %d,b: %d,c: %d,d: %d,e: %d,f: %d,g: %d, res1: %d, res2: %d, done=%d", a,b,c,d,e,f,g,res1,res2,res3,done);

		
		
		if (test_compare == test_result) 
			$display ("Correct");
		else begin
			$display ("Incorrect");
			$finish;
		end
	end
end

endmodule