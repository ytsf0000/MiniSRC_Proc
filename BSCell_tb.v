`timescale 1ns/10ps
module BSCell_tb();

	wire s;
	wire g;
	wire p;

	reg [3:0] test_input;

	BSCell test_cell(
		.x(test_input[0]), //x
		.y(test_input[1]), //y
		.c(test_input[2]), //carry in
		.s(s), //sum
		.g(g), //generate
		.p(p) //propogate
	);


	initial begin
		for (test_input = 4'b0; test_input < 4'b1000; test_input = test_input + 1) begin
			$display("x: %b, y: %b, c: %b, s: %b, g: %b, p: %b", test_input[0], test_input[1], test_input[2], s, g, p);
			
			#20; //arbitrary delay
			
			if (s == (test_input[0] ^ test_input[1] ^ test_input[2])) 
				$display ("Summation correct");
			else begin
				$display ("Summation incorrect");
				$finish;
			end
			
			// test if carry out is properly generated given the propogate and generate signals and equivalent to definitions
			
			if ((g | p & test_input[2]) == ((test_input[0] & test_input[1]) | (test_input[0] | test_input[1]) & (test_input[2]))) 
				$display ("Lookahead logic correct");
			else begin
				$display ("Lookahead logic incorrect");
			end
		end
	end

endmodule