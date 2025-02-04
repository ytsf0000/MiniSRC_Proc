`timescale 1ns / 1ps

module Bus_tb();
    // Inputs
    reg R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out;
    reg R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out;
    reg HIout, LOout, Zhighout, Zlowout, PCout, MDRout, InPortout, Cout;
    
    reg [31:0] BusMuxInR0, BusMuxInR1, BusMuxInR2, BusMuxInR3, BusMuxInR4;
    reg [31:0] BusMuxInR5, BusMuxInR6, BusMuxInR7, BusMuxInR8, BusMuxInR9;
    reg [31:0] BusMuxInR10, BusMuxInR11, BusMuxInR12, BusMuxInR13, BusMuxInR14;
    reg [31:0] BusMuxInR15, BusMuxInHi, BusMuxInLo, BusMuxInZhi, BusMuxInZlo;
    reg [31:0] BusMuxInPC, BusMuxInMDR, BusMuxInPort, BusMuxInCin;

    // Output
    wire [31:0] BusMuxOut;

    // Instantiate Bus
    Bus bustest (
        .R0out(R0out), .R1out(R1out), .R2out(R2out), .R3out(R3out), .R4out(R4out),
        .R5out(R5out), .R6out(R6out), .R7out(R7out), .R8out(R8out), .R9out(R9out),
        .R10out(R10out), .R11out(R11out), .R12out(R12out), .R13out(R13out), .R14out(R14out),
        .R15out(R15out), .HIout(HIout), .LOout(LOout), .Zhighout(Zhighout), .Zlowout(Zlowout),
        .PCout(PCout), .MDRout(MDRout), .InPortout(InPortout), .Cout(Cout),
        .BusMuxInR0(BusMuxInR0), .BusMuxInR1(BusMuxInR1), .BusMuxInR2(BusMuxInR2), 
        .BusMuxInR3(BusMuxInR3), .BusMuxInR4(BusMuxInR4), .BusMuxInR5(BusMuxInR5),
        .BusMuxInR6(BusMuxInR6), .BusMuxInR7(BusMuxInR7), .BusMuxInR8(BusMuxInR8), 
        .BusMuxInR9(BusMuxInR9), .BusMuxInR10(BusMuxInR10), .BusMuxInR11(BusMuxInR11), 
        .BusMuxInR12(BusMuxInR12), .BusMuxInR13(BusMuxInR13), .BusMuxInR14(BusMuxInR14), 
        .BusMuxInR15(BusMuxInR15), .BusMuxInHi(BusMuxInHi), .BusMuxInLo(BusMuxInLo), 
        .BusMuxInZhi(BusMuxInZhi), .BusMuxInZlo(BusMuxInZlo), .BusMuxInPC(BusMuxInPC), 
        .BusMuxInMDR(BusMuxInMDR), .BusMuxInPort(BusMuxInPort), .BusMuxInCin(BusMuxInCin),
        .BusMuxOut(BusMuxOut)
    );

    initial begin
		 // Initialize inputs
		 {R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, 
		  R10out, R11out, R12out, R13out, R14out, R15out, HIout, LOout, 
		  Zhighout, Zlowout, PCout, MDRout, InPortout, Cout} = 24'b0;

		 // Set test values for 32-bit inputs
		 BusMuxInR0  = 32'hAAAA_0000;
		 BusMuxInR1  = 32'hBBBB_1111;
		 BusMuxInR2  = 32'hCCCC_2222;
		 BusMuxInR3  = 32'hDDDD_3333;
		 BusMuxInR4  = 32'hEEEE_4444;
		 BusMuxInR5  = 32'hFFFF_5555;
		 BusMuxInR6  = 32'h1111_6666;
		 BusMuxInR7  = 32'h2222_7777;
		 BusMuxInR8  = 32'h3333_8888;
		 BusMuxInR9  = 32'h4444_9999;
		 BusMuxInR10 = 32'h5555_AAAA;
		 BusMuxInR11 = 32'h6666_BBBB;
		 BusMuxInR12 = 32'h7777_CCCC;
		 BusMuxInR13 = 32'h8888_DDDD;
		 BusMuxInR14 = 32'h9999_EEEE;
		 BusMuxInR15 = 32'hAAAA_FFFF;
		 BusMuxInHi  = 32'hBBBB_1111;
		 BusMuxInLo  = 32'hCCCC_2222;
		 BusMuxInZhi = 32'hDDDD_3333;
		 BusMuxInZlo = 32'hEEEE_4444;
		 BusMuxInPC  = 32'hFFFF_5555;
		 BusMuxInMDR = 32'h1111_6666;
		 BusMuxInPort= 32'h2222_7777;
		 BusMuxInCin = 32'h3333_8888;

		 // Test Cases
		 #5 R0out = 1;  // Select input R0 (Expect BusMuxOut = BusMuxInR0)
		 #5 R0out = 0; R1out = 1;  // Select input R1 (Expect BusMuxOut = BusMuxInR1)
		 #5 R1out = 0; R5out = 1;  // Select input R5 (Expect BusMuxOut = BusMuxInR5)
		 #5 R5out = 0; Zlowout = 1; // Select input Zlow (Expect BusMuxOut = BusMuxInZlow)
		 #5 Zlowout = 0; PCout = 1; // Select input PC (Expect BusMuxOut = BusMuxInPC)
		 #5 PCout = 0; MDRout = 1; // Select input MDR (Expect BusMuxOut = BusMuxInMDR)
		 #5 MDRout = 0; Cout = 1; // Select input Cin (Expect BusMuxOut = BusMuxInCin)
		 #5 Cout = 0; // Reset all
		 
		 #5;
		 $stop; // End simulation
end

endmodule
