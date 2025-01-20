module DataPath(
	input clock, clear,
	input [7:0] A,
	input [7:0] RegisterAImmediate,
	input RZout, RAAout, RBout,
	input RAin, RBin, RZin
);

wire [7:0] BusMuxOut, BusMuxInRZ, BusMuxInRA, BusMuxInRB;

wire [7:0] Zregin;

//Devices
register RA(clear, clock, RAin, RegisterAImmediate, BusMuxInRA);
register RB(clear, clock, RBin, BusMuxOut, BusMuxInRB);

register r0(clear, clock, BusMuxOut, BusMuxIn);
register r1(clear, clock, BusMuxOut, BusMuxIn);
register r2(clear, clock, BusMuxOut, BusMuxIn);
register r3(clear, clock, BusMuxOut, BusMuxIn);
register r4(clear, clock, BusMuxOut, BusMuxIn);
register r5(clear, clock, BusMuxOut, BusMuxIn);
register r6(clear, clock, BusMuxOut, BusMuxIn);
register r7(clear, clock, BusMuxOut, BusMuxIn);
register r8(clear, clock, BusMuxOut, BusMuxIn);
register r9(clear, clock, BusMuxOut, BusMuxIn);
register r10(clear, clock, BusMuxOut, BusMuxIn);
register r11(clear, clock, BusMuxOut, BusMuxIn);
register r12(clear, clock, BusMuxOut, BusMuxIn);
register r13(clear, clock, BusMuxOut, BusMuxIn);
register r14(clear, clock, BusMuxOut, BusMuxIn);
register r15(clear, clock, BusMuxOut, BusMuxIn);


//adder
adder add(A, BusMuxOut, Zregin);
register RZ(cler, clock, RZin, Zregin, BusMuxInRz);

//Bus
Bus bus(BusMuxInRZ, BusMuxInRA, BusMuxInRB, RZout, RBout, BusMuxOut);

endmodule 
