module ALU_Shifting_tb ();
	
	reg clk;
	wire signed [31:0] a;
	reg signed [31:0] b;
	reg SHR;
	reg SHRA;
	reg SHL;
	reg ROR;
	reg ROL;
	reg [31:0] stimulus;
	wire signed [31:0] c;
	
	ALU_Shifting ALU_Shifting_tb (
		.a(a),
		.b(b),
		.SHR(SHR),
		.SHRA(SHRA),
		.SHL(SHL),
		.ROR(ROR),
		.ROL(ROL),
		.c(c)
	);
	
	assign a = stimulus;
	reg signed[31:0] temp = 32'b0;
	
	integer i;
	initial begin
		clk <= 1'b0;
		SHR <= 1'b1;
		SHRA <= 1'b0;
		SHL <= 1'b0;
		ROR <= 1'b0;
		ROL <= 1'b0;
		stimulus <= 64'b1;
		
		b = 32'b0;
		repeat (32) begin
			#10;
			$display("a=%b, shifted by %d = %b", a, b, c);
			if (!(c == (a >> b))) begin
				$display("Incorrect");
				$finish;
			end
			b = b + 1;
			#10;
		end
		$display("SHR testbench passed.");
		
		clk <= 1'b0;
		SHR <= 1'b0;
		SHRA <= 1'b1;
		SHL <= 1'b0;
		ROR <= 1'b0;
		ROL <= 1'b0;
		
		b = 32'b0;
		repeat (32) begin
			#10;
			$display("%b", a>>>b);
			$display("a=%b, shifted by %d = %b, %d", a, b, c, c);
			if (!(c == a>>>b)) begin
				$display("Incorrect, correct value is %b, %d", a>>>b, a>>>b);
				$finish;
			end
			b = b + 1;
			#10;
		end
		$display("SHRA testbench passed.");
		
		clk <= 1'b0;
		SHR <= 1'b0;
		SHRA <= 1'b0;
		SHL <= 1'b1;
		ROR <= 1'b0;
		ROL <= 1'b0;
		
		b = 32'b0;
		repeat (32) begin
			#10;
			$display("a=%b, shifted by %d = %b", a, b, c);
			if (!(c == (a << b))) begin
				$display("Incorrect");
				$finish;
			end
			b = b + 1;
			#10;
		end
		$display("SHL testbench passed.");
		
		clk <= 1'b0;
		SHR <= 1'b0;
		SHRA <= 1'b0;
		SHL <= 1'b0;
		ROR <= 1'b1;
		ROL <= 1'b0;
		
		b = 32'b0;
		repeat (32) begin
			#10;
			$display("a=%b, shifted by %d = %b", a, b, c);
			
			temp = a;
			repeat (b) begin
				temp = {temp[0],temp[31:1]};
			end
			
			if (!(c == temp)) begin
				$display("Incorrect");
				$finish;
			end
			b = b + 1;
			#10;
		end
		$display("ROR testbench passed.");
		
		clk <= 1'b0;
		SHR <= 1'b0;
		SHRA <= 1'b0;
		SHL <= 1'b0;
		ROR <= 1'b0;
		ROL <= 1'b1;
		
		b = 32'b0;
		repeat (32) begin
			#10;
			$display("a=%b, shifted by %d = %b", a, b, c);
			
			temp = a;
			repeat (b) begin
				temp = {temp[30:0],temp[31]};
			end
			
			if (!(c == temp)) begin
				$display("Incorrect, correct value is %b", temp);
				$finish;
			end
			b = b + 1;
			#10;
		end
		$display("ROL testbench passed.");
		
		$display("All test cases completed.");
	end
	
	
	
	always begin
		#10;
		clk <= ~clk;
	end
	
	always @ (posedge clk) begin
		stimulus <= {stimulus[30:0], stimulus[0]^stimulus[1]^stimulus[30]};
	end
	
	
endmodule