module ALU_Shifting_tb ();
	
	reg clk;
	wire [31:0] a;
	reg [31:0] b;
	reg SHR;
	reg SHRA;
	reg SHL;
	reg ROR;
	reg ROL;
	reg [31:0] stimulus;
	wire [31:0] c;
	
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
			$display("a=%b, shifted by %d = %b", a, b, c);
			if (!(c == (a >> b))) begin
				$display("Incorrect");
				$finish;
			end
			b = b + 1;
			#10;
		end
		$display("SHR testbench passed.");
		
	end
	
	always begin
		#10;
		clk <= ~clk;
	end
	
	always @ (posedge clk) begin
		stimulus <= {stimulus[30:0], stimulus[0]^stimulus[1]^stimulus[30]};
	end
	
	
endmodule