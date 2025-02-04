`timescale 1ns/10ps

module Register_tb ();

// declare inputs as reg
reg clear;
reg clock;
reg enable;
reg [31:0] BusMuxOut;

//ALWAYS declare outputs as wire
wire [31:0] BusMuxIn;

//instantiate module
Register regtest(clear, clock, enable, BusMuxOut, BusMuxIn);

initial begin
	clock = 0;
end

always begin
	#10 clock <= ~clock;
end 

initial begin 

	BusMuxOut = 32'hACADACAD;
	clear = 1;
	enable = 0;
	
	@ (posedge clock); #5 
	if (BusMuxIn == 32'b0) begin
		$display("Cleared Properly");
	end
	
	clear = 0;
	BusMuxOut = 32'hBEEFBEEF;
	enable = 1;
	
	@ (posedge clock); #5
	
	if(BusMuxIn == 32'hBEEFBEEF) begin
		$display("Write Properly");
	end
	else begin
		$display("Not correct, output is %h", BusMuxIn);
	end
	
	clear = 0;
	BusMuxOut = 32'hFEEDFEED;
	enable = 0;
	
	
	@ (posedge clock); #5
	if(BusMuxIn == 32'hBEEFBEEF) begin
		$display("Correctly doesn't change");
	end
	
end
	
endmodule