module PC_tb();
	
	reg clk;
	reg PCout;
	reg IncPC;
	reg PCin;
	wire [31:0] PCcount;
	
	PC PC_dut (clk, PCout, IncPC, PCin, PCcount);
	
	always begin
		#10;
		clk <= ~clk;
	end
	
	initial begin
		clk <= 1'b0;
		PCout <= 1'b0;
		IncPC <= 1'b0;
		PCin <= 1'b0;
		
		#20;
		clk <= 1'b0;
		PCout <= 1'b0;
		IncPC <= 1'b1;
		PCin <= 1'b0;
		
		repeat (20) begin
			$display("%d", PCcount);
			#20;
		end
		$finish;
	end
	
	
endmodule