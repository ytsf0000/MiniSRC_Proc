`timescale 1ns/10ps
module Fast2complement_tb();

wire [63:0] res;

reg [63:0] test_input;
reg enable;

Fast2complement Test(
	.enable(enable),
	.in(test_input),
	.out(res)
);

reg [63:0] test_compare;
reg [31:0] seed;

integer i;
initial begin
	for (i = 32'b0; i < 64'hFFFFFFFFFFFFFFFF; i = i + 1) begin
		seed =$random(seed);
		test_input = i;
		seed =$random(seed);
		enable = 1;

		$display("enable: %b, in: %t, out: %t", enable, test_input, res);
		
		#20; //arbitrary delay
		
		test_compare = test_input * (enable?-1:1);
		if (test_compare == res) 
			$display ("Correct");
		else begin
			$display ("Incorrect");
			$finish;
		end
	end
end

endmodule