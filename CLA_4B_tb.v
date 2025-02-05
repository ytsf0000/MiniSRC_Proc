module FourBitCLA_tb ();

// test values

reg [9:0] stimulus;
reg signed [4:0] test_sum;
reg signed [3:0] x;
reg signed [3:0] y;
reg c_in;

//output values

wire signed [3:0] s; // sum
wire c_out; //c4 is c_out
wire g; // for higher-bit compound CLA 
wire p;

CLA_4B test_4b_CLA(
	.x(x),
	.y(y),
	.c_in(c_in),
	.s(s),
	.c_out(c_out),
	.g(g),
	.p(p)
);

initial begin
	for(stimulus = 9'b0; stimulus < 10'b1000000000; stimulus = stimulus + 1) begin
		{x,y,c_in} = stimulus[8:0];
		#5;
		test_sum = {1'b0,x} + {1'b0,y} + {4'b0, c_in};
		if (!(test_sum[3:0] == s)) begin
			$display("Incorrect sum for x: %b, y: %b, c_in: %b", x, y, c_in);
			$display("Expected %b, instead got %b", test_sum[3:0], s);
			$finish;
		end
		if (!(test_sum[4] == c_out)) begin
			$display("Incorrect carry signal, expected: %b, instead got: %b", test_sum[4], c_out);
			$finish;
		end
	end
	$display("Testbench complete.");
end

endmodule