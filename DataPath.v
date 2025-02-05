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
	input R3in, //done
	input R4in, //done
	input R7in, //done
	input Clock, //done
	input [31:0] Mdatain //done
);

	wire Clear;
	wire [31:0] ALU_A;
	wire [31:0] BusMuxInPC, BusMuxInR3, BusMuxInR4, BusMuxInR7, BusMuxInZlo, BusMuxInZhi, BusMuxInMDR;
	wire [31:0] BusMuxOut; 

	
	Register PC (.Clear(Clear), .Clock(Clock), .Enable(PCin), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInPC));
	
	Register IR(.Clear(Clear), .Clock(Clock), .Enable(IRin), .BusMuxOut(BusMuxOut));
	Register RY(.Clear(Clear), .Clock(Clock), .Enable(Yin), .BusMuxOut(BusMuxOut), .BusMuxIn(ALU_A));

	Register R3(.Clear(Clear), .Clock(Clock), .Enable(R3in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR3));
	Register R4(.Clear(Clear), .Clock(Clock), .Enable(R4in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR4));

	Register R7(.Clear(Clear), .Clock(Clock), .Enable(R7in), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInR7));

	Register Zlo(.Clear(Clear), .Clock(Clock), .Enable(Zin), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInZlo));
	Register Zhi(.Clear(Clear), .Clock(Clock), .Enable(Zin), .BusMuxOut(BusMuxOut), .BusMuxIn(BusMuxInZhi));
	
	MDR MDR (.Clear(Clear), .Clock(Clock), .MDRin(MDRin), .BusMuxOut(BusMuxOut), .Mdatain(Mdatain), .Read(Read), .BusMuxIn(BusMuxInMDR));
	
	//Bus
	Bus Bus_DUT(
		.BusMuxInPC(BusMuxInPC),
		.BusMuxInZlo(BusMuxInZlo),
		.BusMuxInZhi(BusMuxInZhi),
		.BusMuxInR3(BusMuxInR3),
		.BusMuxInR4(BusMuxInR4),
		.BusMuxInR7(BusMuxInR7),
		.PCout(PCout), 
		.R3out(R3out),
		.R7out(R7out),
		.Zlowout(Zlowout),
		.MDRout(MDRout),
		.BusMuxOut(BusMuxOut)
	);
	

endmodule 
