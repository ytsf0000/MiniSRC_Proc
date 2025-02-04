module PC (
	input clk,
	input PCout,
	input IncPC,
	input PCin,
	output reg [31:0] PCcount
);
	
	initial PCcount = 32'b0;
	
	always @(posedge clk) begin
	
	//dedicated PC XOR increment
		if (IncPC) begin
			PCcount = PCcount ^ {PCcount[30:0], 1'b1};
		end
	end
	

endmodule