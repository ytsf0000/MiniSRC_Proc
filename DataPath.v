module DataPath(
	input PCout, //done
	input Zlowout, //done
	input Zhighout,
	input MDRout, 
	input LOout,
	input HIout,
	input IncPC, 
	input Read, //Read is for MDR read signal, done
	input AND, 
	input ADD,
	input SUB, 
	input MUL, 
	input DIV, 
	input SHR,
	input SHRA,
	input SHL, 
	input ROR, 
	input ROL, 
	input OR, 
	input NEG, 
	input NOT,
	input MARin, 
	input Zin, //done
	input PCin, //done
	input MDRin, //done
	input IRin, //done
	input Yin, //done
	input Write,
	input LOin,
	input HIin,
	input Clock, //done
	input Clear,
	input [31:0] INPort_In, //done
	input Rin,
	input Rout,
	input Gra,
	input Grb,
	input Grc,
	input Cout,
	input BAout,
	input CONin,
	input Strobe, // This is the ready signal for the output port, asserted by testbench
	input OutPortIn,
	output [31:0] OutPort_Out,
	output BranchOut
);
	//Input Reg.
	wire R0in;
	wire R1in;
	wire R2in;
	wire R3in;
	wire R4in;
	wire R5in;
	wire R6in;
	wire R7in;
	wire R8in;
	wire R9in;
	wire R10in;
	wire R11in;
	wire R12in;
	wire R13in;
	wire R14in;
	wire R15in;
	wire RINout;

	//Output Reg.
	wire R0out;
	wire R1out;
	wire R2out;
	wire R3out;
	wire R4out;
	wire R5out;
	wire R6out;
	wire R7out;
	wire R8out;
	wire R9out;
	wire R10out;
	wire R11out;
	wire R12out;
	wire R13out;
	wire R14out;
	wire R15out;
	wire ROutOut;

	wire [31:0] Y_Out;
	wire [31:0] ALU_A;
	wire [31:0] ALU_B;
	wire [63:0] ALU_Out;
	wire [31:0] BusMuxInPC, BusMuxInR0, BusMuxInR1, 
					BusMuxInR2, BusMuxInR3, BusMuxInR4, 
					BusMuxInR5, BusMuxInR6, BusMuxInR7, 
					BusMuxInR8, BusMuxInR9, BusMuxInR10,
					BusMuxInR11, BusMuxInR12, BusMuxInR13, 
					BusMuxInR14, BusMuxInR15, BusMuxInZlo, 
					BusMuxInZhi, BusMuxInMDR, BusMuxInIR,
					BusMuxInLO, BusMuxInHI, BusMuxIn_In;
			
	wire [31:0] BusMuxOut; 
	wire [31:0] Mdatain;
	wire [31:0] C_Sign_Extended;
	
	assign ALU_A = (IncPC) ? 32'b1 : Y_Out;
	assign ALU_B = (Cout) ? C_Sign_Extended : BusMuxOut;
	assign C_Sign_Extended = {{13{BusMuxInIR[18]}},BusMuxInIR[18:0]};
	
	// Register File
	Register PC(.Clear(Clear), .Clock(Clock), .Enable(PCin), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInPC));
	
	Register IR(.Clear(Clear), .Clock(Clock), .Enable(IRin), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInIR));
	Register RY(.Clear(Clear), .Clock(Clock), .Enable(Yin), .BusMuxOut(BusMuxOut), .BusMuxIn(Y_Out));
	
	Register_r0 R0(.Clear(Clear), .Clock(Clock), .Enable(R0in), .BusMuxOut(BusMuxOut), .BusMuxInR0(BusMuxInR0), .BAout(BAout));
	Register R1(.Clear(Clear), .Clock(Clock), .Enable(R1in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR1));
	Register R2(.Clear(Clear), .Clock(Clock), .Enable(R2in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR2));
	Register R3(.Clear(Clear), .Clock(Clock), .Enable(R3in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR3));
	Register R4(.Clear(Clear), .Clock(Clock), .Enable(R4in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR4));
	Register R5(.Clear(Clear), .Clock(Clock), .Enable(R5in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR5));
	Register R6(.Clear(Clear), .Clock(Clock), .Enable(R6in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR6));
	Register R7(.Clear(Clear), .Clock(Clock), .Enable(R7in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR7));
	Register R8(.Clear(Clear), .Clock(Clock), .Enable(R8in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR8));
	Register R9(.Clear(Clear), .Clock(Clock), .Enable(R9in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR9));
	Register R10(.Clear(Clear), .Clock(Clock), .Enable(R10in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR10));
	Register R11(.Clear(Clear), .Clock(Clock), .Enable(R11in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR11));
	Register R12(.Clear(Clear), .Clock(Clock), .Enable(R12in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR12));
	Register R13(.Clear(Clear), .Clock(Clock), .Enable(R13in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR13));
	Register R14(.Clear(Clear), .Clock(Clock), .Enable(R14in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR14));
	Register R15(.Clear(Clear), .Clock(Clock), .Enable(R15in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR15));

	Register LO(.Clear(Clear), .Clock(Clock), .Enable(LOin), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInLO));
	Register HI(.Clear(Clear), .Clock(Clock), .Enable(HIin), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInHI));
	Register Zlo(.Clear(Clear), .Clock(Clock), .Enable(Zin), .BusMuxOut(ALU_Out[31:0]), .BusMuxIn(BusMuxInZlo));
	Register Zhi(.Clear(Clear), .Clock(Clock), .Enable(Zin), .BusMuxOut(ALU_Out[63:32]), .BusMuxIn(BusMuxInZhi));
	
	wire [31:0]MAROut;
	
	Register MAR(.Clear(Clear), .Clock(Clock), .Enable(MARin), .BusMuxOut(BusMuxOut),.BusMuxIn(MAROut));
	MDR MDR(.Clear(Clear), .Clock(Clock), .MDRin(MDRin), .BusMuxOut(BusMuxOut), .Mdatain(Mdatain), .Read(Read), .BusMuxIn(BusMuxInMDR));
	RAM RAM(.read(Read),.write(Write),.address(MAROut),.data_in(BusMuxOut),.data_out(Mdatain));
	
	ALU ALU_DUT (
		.a(ALU_A),
		.b(ALU_B),
		.ADD(ADD | IncPC), 
		.SUB(SUB), 
		.MUL(MUL), 
		.DIV(DIV), 
		.SHR(SHR),
		.SHRA(SHRA),
		.SHL(SHL), 
		.ROR(ROR), 
		.ROL(ROL), 
		.AND(AND), 
		.OR(OR), 
		.NEG(NEG), 
		.NOT(NOT),
		.c(ALU_Out)
	);
	
	//Bus
	Bus Bus_DUT(
		.BusMuxInPC(BusMuxInPC),
		.BusMuxInZlo(BusMuxInZlo),
		.BusMuxInZhi(BusMuxInZhi),
		.BusMuxInR0(BusMuxInR0),
		.BusMuxInR1(BusMuxInR1),
		.BusMuxInR2(BusMuxInR2),
		.BusMuxInR3(BusMuxInR3),
		.BusMuxInR4(BusMuxInR4),
		.BusMuxInR5(BusMuxInR5),
		.BusMuxInR6(BusMuxInR6),
		.BusMuxInR7(BusMuxInR7),
		.BusMuxInR8(BusMuxInR8),
		.BusMuxInR9(BusMuxInR9),
		.BusMuxInR10(BusMuxInR10),
		.BusMuxInR11(BusMuxInR11),
		.BusMuxInR12(BusMuxInR12),
		.BusMuxInR13(BusMuxInR13),
		.BusMuxInR14(BusMuxInR14),
		.BusMuxInR15(BusMuxInR15),
		.BusMuxInMDR(BusMuxInMDR),
		.BusMuxIn_In(BusMuxIn_In), // data from input port
		.PCout(PCout), 
		.R0out(R0out),
		.R1out(R1out),
		.R2out(R2out),
		.R3out(R3out),
		.R4out(R4out),
		.R5out(R5out),
		.R6out(R6out),
		.R7out(R7out),
		.R8out(R8out),
		.R9out(R9out),
		.R10out(R10out),
		.R11out(R11out),
		.R12out(R12out),
		.R13out(R13out),
		.R14out(R14out),
		.R15out(R15out),
		.RINout(RINout), // input port control signal to output register contents 
		.Zlowout(Zlowout),
		.Zhighout(Zhighout),
		.LOout(LOout),
		.HIout(HIout),
		.MDRout(MDRout),
		.BusMuxOut(BusMuxOut)
	);
	
	//Select and Encoder Block:
	SelectEncoderBlock SEB(
		.Rin_Sig({R15in,R14in,R13in,R12in,R11in,R10in,R9in,R8in,R7in,R6in,R5in,R4in,R3in,R2in,R1in,R0in}),
		.Rout_Sig({R15out,R14out,R13out,R12out,R11out,R10out,R9out,R8out,R7out,R6out,R5out,R4out,R3out,R2out,R1out,R0out}), 
		.IR(BusMuxInIR), 
		.Gra(Gra),
		.Grb(Grb), 
		.Grc(Grc), 
		.Rin(Rin),
		.BAout(BAout)
	);
	
	ConFF ConFF_DUT(
		.CONin(CONin),
		.IR(BusMuxInIR[20:19]), // only bits 20 and 19 from the IR register should be input here.
		.Bus(BusMuxOut),
		.BranchOut(BranchOut)
	);

	InPort InPort_DUT(
		.Clear(Clear), 
		.Clock(Clock), 
		.Strobe(Strobe),
		.Input(INPort_In),
		.BusMuxIn(BusMuxIn_In)
	);
	
	Register OutPort_DUT(.Clear(Clear), .Clock(Clock), .Enable(OutPortIn), .BusMuxOut(BusMuxOut), .BusMuxIn(OutPort_Out));
	
endmodule 