module ALU_Logical_tb ();

	reg clk;
	reg in_and;
	reg in_or;
	reg in_neg;
	reg in_not;
	reg [63:0] stimulus;
	wire [31:0] c;
	
	ALU_Logical ALU_Logical_tb (
		.a(stimulus[31:0]),
		.b(stimulus[63:32]),
		.in_and(in_and),
		.in_or(in_or),
		.in_neg(in_neg),
		.in_not(in_not),
		.c(c)
	);
	
	always @ (posedge clk) begin
		stimulus <= {stimulus[62:0], ~(stimulus[63] ^ stimulus[62] ^ stimulus[60] ^ stimulus[59])};
	end
	
	initial begin
		in_and <= 1'b1;
		in_or <= 1'b0;
		in_neg <= 1'b0;
		in_not <= 1'b0;
		stimulus <= 64'b1;
		clk <= 1'b0;
		
		repeat (1000) begin
			clk <= 1'b1;
			#10;
			$display("Bitwise AND, a=%b, b=%b, c=%b", stimulus[31:0], stimulus[63:32], c);
			if ((stimulus[31:0] & stimulus[63:32]) == c) begin
				$display("Correct output.");
			end
			else begin
				$display("Incorrect output.");
				$finish;
			end
			clk <= 1'b0;
			#10;
		end
		
		in_and <= 1'b0;
		in_or <= 1'b1;
		in_neg <= 1'b0;
		in_not <= 1'b0;
		
		repeat (1000) begin
			clk <= 1'b1;
			#10;
			$display("Bitwise OR, a=%b, b=%b, c=%b", stimulus[31:0], stimulus[63:32], c);
			if ((stimulus[31:0] | stimulus[63:32]) == c) begin
				$display("Correct output.");
			end
			else begin
				$display("Incorrect output.");
				$finish;
			end
			clk <= 1'b0;
			#10;
		end
		
		in_and <= 1'b0;
		in_or <= 1'b0;
		in_neg <= 1'b1;
		in_not <= 1'b0;
		
		repeat (1000) begin
			clk <= 1'b1;
			#10;
			$display("NEG, a=%b, c=%b", stimulus[31:0], c);
			if ((~stimulus[31:0]+32'b1) == c) begin
				$display("Correct output.");
			end
			else begin
				$display("Incorrect output.");
				$finish;
			end
			clk <= 1'b0;
			#10;
		end
		
		in_and <= 1'b0;
		in_or <= 1'b0;
		in_neg <= 1'b0;
		in_not <= 1'b1;
		
		repeat (1000) begin
			clk <= 1'b1;
			#10;
			$display("NOT, a=%b, c=%b", stimulus[31:0], c);
			if (~stimulus[31:0] == c) begin
				$display("Correct output.");
			end
			else begin
				$display("Incorrect output.");
				$finish;
			end
			clk <= 1'b0;
			#10;
		end
		
		$display("Testbench complete.");
	end

endmodule