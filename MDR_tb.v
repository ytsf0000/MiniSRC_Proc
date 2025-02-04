`timescale 1ns/10ps

module MDR_tb();

// declare inputs as reg
reg clear;
reg clock;
reg MDRin;
reg [31:0] BusMuxOut;
reg [31:0] Mdatain;
reg read;

// Always declare outputs as wire
wire [31:0] q;

// instantiate module
MDR mdr(clear, clock, MDRin, BusMuxOut, Mdatain, read);

// Clock
initial begin
	clock = 0;
	forever #10 clock = ~clock;
end

initial begin 

    BusMuxOut = 32'hBEEFBEEF;
    Mdatain = 32'hFEEDFEED;
	 clear = 0;

    //TEST - Correct output for q = BusMuxOut
    read = 0;
    MDRin = 1;
    @ (posedge clock); #5
        if(q == 32'hBEEFBEEF) begin
            $display("Correct Test for Read low");
        end
		  else begin
				$display("Incorrect Test for Read low %b", q);
		  end
		/*
    //TEST - Correct output for q = Mdatain
    read = 1;
     @ (posedge clock); #5
        if(q == 32'hFEEDFEED) begin
            $display("Correct Test for Read high");
        end

    //TEST - Correct output for q = Mdatain
    MDRin = 0;
     @ (posedge clock); #5
        if(q == 32'b0) begin
            $display("Correct Test for MDRin low");
        end
		*/
end


endmodule