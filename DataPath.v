module DataPath(
	input PCout, //done
	input Zlowout, //done
	input MDRout, 
	input R3out, //done
	input R7out, //done
	input MARin, 
	input Zin, //done
	input PCin, //done
	input MDRin, //done
	input IRin, //done
	input Yin, //done
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
	input R3in, //done
	input R4in, //done
	input R7in, //done
	input Clock, //done
	input Clear,
	input [31:0] Mdatain //done
);
	wire [31:0] Y_Out;
	wire [31:0] ALU_A;
	wire [63:0] ALU_Out;
	wire [31:0] BusMuxInPC, BusMuxInR3, BusMuxInR4, BusMuxInR7, BusMuxInZlo, BusMuxInZhi, BusMuxInMDR, BusMuxInIR;
	wire [31:0] BusMuxOut; 

	assign ALU_A = (IncPC) ? 32'b1 : Y_Out;
	
	// Register File
	Register PC(.Clear(Clear), .Clock(Clock), .Enable(PCin), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInPC));
	
	Register IR(.Clear(Clear), .Clock(Clock), .Enable(IRin), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInIR));
	Register RY(.Clear(Clear), .Clock(Clock), .Enable(Yin), .BusMuxOut(BusMuxOut), .BusMuxIn(Y_Out));

	Register R3(.Clear(Clear), .Clock(Clock), .Enable(R3in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR3));
	Register R4(.Clear(Clear), .Clock(Clock), .Enable(R4in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR4));

	Register R7(.Clear(Clear), .Clock(Clock), .Enable(R7in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR7));

	Register Zlo(.Clear(Clear), .Clock(Clock), .Enable(Zin), .BusMuxOut(ALU_Out[31:0]), .BusMuxIn(BusMuxInZlo));
	Register Zhi(.Clear(Clear), .Clock(Clock), .Enable(Zin), .BusMuxOut(ALU_Out[63:32]), .BusMuxIn(BusMuxInZhi));
	
	Register MAR(.Clear(Clear), .Clock(Clock), .Enable(MARin), .BusMuxOut(BusMuxOut)); // connect to memory bus later
	MDR MDR(.Clear(Clear), .Clock(Clock), .MDRin(MDRin), .BusMuxOut(BusMuxOut), .Mdatain(Mdatain), .Read(Read), .BusMuxIn(BusMuxInMDR));
	
	ALU ALU_DUT (
		.a(ALU_A),
		.b(BusMuxOut),
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
		.BusMuxInR3(BusMuxInR3),
		.BusMuxInR4(BusMuxInR4),
		.BusMuxInR7(BusMuxInR7),
		.BusMuxInMDR(BusMuxInMDR),
		.PCout(PCout), 
		.R3out(R3out),
		.R7out(R7out),
		.Zlowout(Zlowout),
		.MDRout(MDRout),
		.BusMuxOut(BusMuxOut)
	);
	

endmodule 
