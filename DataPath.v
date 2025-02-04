module DataPath(
	input PCout, Zlowout, MDRout, 
			R3out, R7out, MARin, 
			Zin, PCin, MDRin, 
			IRin, Yin, IncPC, 
			Read, AND, R3in,
			R4in, R7in, Clock, 
	input [31:0] Mdatain
);

wire [7:0] BusMuxOut, BusMuxInRZ, BusMuxInRA, BusMuxInRB;

wire [7:0] Zregin;

//Program Counter
Register PC(clear, clock, BuxMuxOut, BusMuxIn);

//Devices
Register RA(clear, clock, RAin, RegisterAImmediate, BusMuxInRA);
Register RB(clear, clock, RBin, BusMuxOut, BusMuxInRB);

Register R0(clear, clock, BusMuxOut, BusMuxInR0);
Register R1(clear, clock, BusMuxOut, BusMuxInR1);
Register R2(clear, clock, BusMuxOut, BusMuxInR2);
Register R3(clear, clock, BusMuxOut, BusMuxInR3);
Register R4(clear, clock, BusMuxOut, BusMuxInR4);
Register R5(clear, clock, BusMuxOut, BusMuxInR5);
Register R6(clear, clock, BusMuxOut, BusMuxInR6);
Register R7(clear, clock, BusMuxOut, BusMuxInR7);
Register R8(clear, clock, BusMuxOut, BusMuxInR);
Register R9(clear, clock, BusMuxOut, BusMuxIn);
Register R10(clear, clock, BusMuxOut, BusMuxIn);
Register R11(clear, clock, BusMuxOut, BusMuxIn);
Register R12(clear, clock, BusMuxOut, BusMuxIn);
Register R13(clear, clock, BusMuxOut, BusMuxIn);
Register R14(clear, clock, BusMuxOut, BusMuxIn);
Register R15(clear, clock, BusMuxOut, BusMuxIn);


//adder
adder add(A, BusMuxOut, Zregin);
Register RZ(cler, clock, RZin, Zregin, BusMuxInRz);

//Bus
Bus bus(BusMuxInRZ, BusMuxInRA, BusMuxInRB, RZout, RBout, BusMuxOut);

endmodule 
