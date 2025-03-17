`timescale 1ns/10ps

module Register_r0_tb();

//I/O setup:
reg [31:0] BusMuxOut;
reg clr, clk, enable, BAout;
wire [31:0] BusMuxInR0;

//instantiate module
Register_r0 r0test(BusMuxInR0, BusMuxOut, clr, clk, enable, BAout);

// Generate clock signal (50% duty cycle, period = 20ns)
always #10 clk = ~clk;

initial begin
    // Initialize clock
    clk = 0;

    // Start monitoring signals
    $monitor("Time: %t | Clear: %b | Enable: %b | BusMuxOut: %h | BusMuxIn: %h | BAout: %b", 
              $time, clr, enable, BusMuxOut, BusMuxInR0, BAout);
    
    // Reset test
    clr = 1; enable = 0; BusMuxOut = 32'hACADACAD;
    @(posedge clk); #5;
    if (BusMuxInR0 === 32'b0) $display("Cleared Properly");
    else $display("Clear failed, BusMuxIn = %h", BusMuxInR0);
	 
	 // Write test w/ BAout = 1;
    clr = 0; enable = 1; BusMuxOut = 32'hACADACAD; BAout = 1;
    @(posedge clk); #5;
    if (BusMuxInR0 === 32'b0) $display("Write Properly w/ BAout = 1");
    else $display("Write  w/ BAout = 1 failed, BusMuxIn = %h", BusMuxInR0);
	 
	 // Write test w/ BAout = 0;
    clr = 0; enable = 1; BusMuxOut = 32'hACADACAD; BAout = 0;
    @(posedge clk); #5;
    if (BusMuxInR0 === 32'hACADACAD) $display("Write Properly w/ BAout = 0");
    else $display("Write w/ BAout = 0 failed, BusMuxIn = %h", BusMuxInR0);
	 
	 // Final cleanup
    $display("Test Completed!");
    $finish;
   
end

endmodule