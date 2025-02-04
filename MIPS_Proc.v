module Register_tb ();

// declare inputs as reg
reg clear;
reg clock;
reg enable;

//ALWAYS declare outputs as wire
wire [31:0] BusMuxOut;
wire [31:0] BusMuxIn;

//instantiate module
Register regtest(clear, clock, enable, BusMuxOut, BusMuxIn);

initial begin
	clock = 0;
	forever #10 clock = ~clock;
end

initial begin 
	clear = 1;
	enable = 0;
	
	@ (posedge clock);
	if (BusMuxIn == 32'b0) begin
		$display("Cleared Properly");
	end
end
	
endmodule