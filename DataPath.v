module DataPath(
	input clock, clear,
	input [7:0] A,
	input [7:0] RegisterAImmediate,
	input RZout, RAAout, RBout,
	input RAin, RBin, RZin
);


wire [31:0] BusMuxInR0, BusMuxInR1, BusMuxInR2, BusMuxInR3, BusMuxInR4, BusMuxInR5, BusMuxInR6, BusMuxInR7, BusMuxInR8, BusMuxInR9, BusMuxInR10, 
				BusMuxInR11, BusMuxInR12, BusMuxInR13, BusMuxInR14, BusMuxInR15, 
            BusMuxInHI, BusMuxInLO, BusMuxInZhigh, BusMuxInZlow, BusMuxInPC, BusMuxInMDR, 
            BusMuxInPort, BusMuxInCin;

wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,HIout, LOout, Zhighout, Zlowout, PCout, MDRout,InPortout, Cout;

wire [31:0] BusMuxOut, Mdatain;
wire read;
wire MDRin;

//Devices
Register RA(clear, clock, RAin, RegisterAImmediate, BusMuxInRA);
Register RB(clear, clock, RBin, BusMuxOut, BusMuxInRB);

Register r0(clear, clock, enable, BusMuxOut, BusMuxIn);
Register r1(clear, clock, enable, BusMuxOut, BusMuxIn);
Register r2(clear, clock, enable, BusMuxOut, BusMuxIn);
Register r3(clear, clock, enable, BusMuxOut, BusMuxIn);
Register r4(clear, clock, enable, BusMuxOut, BusMuxIn);
Register r5(clear, clock, enable, BusMuxOut, BusMuxIn);
Register r6(clear, clock, enable, BusMuxOut, BusMuxIn);
Register r7(clear, clock, enable, BusMuxOut, BusMuxIn);
Register r8(clear, clock, enable, BusMuxOut, BusMuxIn);
Register r9(clear, clock, enable, BusMuxOut, BusMuxIn);
Register r10(clear, clock, enable, BusMuxOut, BusMuxIn);
Register r11(clear, clock, enable, BusMuxOut, BusMuxIn);
Register r12(clear, clock, enable, BusMuxOut, BusMuxIn);
Register r13(clear, clock, enable, BusMuxOut, BusMuxIn);
Register r14(clear, clock, enable, BusMuxOut, BusMuxIn);
Register r15(clear, clock, enable, BusMuxOut, BusMuxIn);


//adder
Register RZ(clear, clock, RZin, Zregin, BusMuxInRz);

//Bus
Bus bus(BusMuxInR0, BusMuxInR1, BusMuxInR2, BusMuxInR3, BusMuxInR4, BusMuxInR5, BusMuxInR6, BusMuxInR7, BusMuxInR8, BusMuxInR9, BusMuxInR10, BusMuxInR11, BusMuxInR12, BusMuxInR13, BusMuxInR14, BusMuxInR15, BusMuxInHI, BusMuxInLO, BusMuxInZhigh, BusMuxInZlow, BusMuxInPC, BusMuxInMDR, BusMuxInPort, BusMuxInCin, R0out, R10out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out, HIout, LOout, Zhighout, Zlowout, PCout, MDRout, InPortout, Cout, BusMuxOut);

//MDR
MDR mdr(clear, clock, MDRin, BusMuxOut, Mdatain, read);

endmodule 
