`timescale 1ns/10ps
module DataPath_tb();

	reg PCout, Zlowout, MDRout, R3out, R7out; // add any other signals to see in your simulation
	reg MARin, Zin, PCin, MDRin, IRin, Yin;
	reg IncPC, Read, AND, R3in, R4in, R7in;
	reg Clock;
	reg [31:0] Mdatain;
	
	parameter Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
				Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
				T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100, Done = 4'b1101;
	
	reg [3:0] Present_state = Default;
	
	DataPath DUT (
		.PCout(PCout), 
		.Zlowout(Zlowout), 
		.MDRout(MDRout), 
		.R3out(R3out), 
		.R7out(R7out), 
		.MARin(MARin), 
		.Zin(Zin), 
		.PCin(PCin), 
		.MDRin(MDRin), 
		.IRin(IRin), 
		.Yin(Yin), 
		.IncPC(IncPC), 
		.Read(Read), 
		.AND(AND), 
		.R3in(R3in),
		.R4in(R4in), 
		.R7in(R7in), 
		.Clock(Clock), 
		.Mdatain(Mdatain)
	);
	
	// add test logic here
	initial begin
		Clock = 0;
		forever #10 Clock = ~ Clock;
	end
	
	always @(posedge Clock) begin
		case (Present_state)
			Default : Present_state = Reg_load1a;
			Reg_load1a : Present_state = Done;
			Reg_load1b : Present_state = Reg_load2a;
			Reg_load2a : Present_state = Reg_load2b;
			Reg_load2b : Present_state = Reg_load3a;
			Reg_load3a : Present_state = Reg_load3b;
			Reg_load3b : Present_state = T0;
			T0 : Present_state = T1;
			T1 : Present_state = T2;
			T2 : Present_state = T3;
			T3 : Present_state = T4;
			T4 : Present_state = T5;
			T5 : Present_state = Done;
		endcase
	end
	
	always @(Present_state) begin
		case (Present_state) // assert the required signals in each clock cycle
			Default: begin
				PCout <= 0; Zlowout <= 0; MDRout <= 0; // initialize the signals
				R3out <= 0; R7out <= 0; MARin <= 0; Zin <= 0;
				PCin <=0; MDRin <= 0; IRin <= 0; Yin <= 0;
				IncPC <= 0; Read <= 0; AND <= 0;
				R3in <= 0; R4in <= 0; R7in <= 0; Mdatain <= 32'h00000000;
			end
			Reg_load1a: begin
				Mdatain <= 32'h00000022;
				Read = 0; MDRin = 0; // the first zero is there for completeness
				Read <= 1; MDRin <= 1; // Took out #10 for '1', as it may not be needed
				#15 Read <= 0; MDRin <= 0; // for your current implementation
			end
			Reg_load1b: begin
				MDRout <= 1; R3in <= 1;
				#15 MDRout <= 0; R3in <= 0; // initialize R3 with the value 0x22
			end
			Reg_load2a: begin
				Mdatain <= 32'h00000024;
				Read <= 1; MDRin <= 1;
				#15 Read <= 0; MDRin <= 0;
			end
			Reg_load2b: begin
				MDRout <= 1; R7in <= 1;
				#15 MDRout <= 0; R7in <= 0; // initialize R7 with the value 0x24
			end
			Reg_load3a: begin
				Mdatain <= 32'h00000028;
				Read <= 1; MDRin <= 1;
				#15 Read <= 0; MDRin <= 0;
			end
			Reg_load3b: begin
				MDRout <= 1; R4in <= 1;
				#15 MDRout <= 0; R4in <= 0; // initialize R4 with the value 0x28
			end
			
			T0: begin // see if you need to de-assert these signals
				PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
			end
			
			T1: begin
				Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
				Mdatain <= 32'h2A2B8000; // opcode for “and R4, R3, R7”
			end
			
			T2: begin
				MDRout <= 1; IRin <= 1;
			end
			
			T3: begin
				R3out <= 1; Yin <= 1;
			end
			
			T4: begin
				R7out <= 1; AND <= 1; Zin <= 1;
			end
			
			T5: begin
				Zlowout <= 1; R4in <= 1;
			end
			
			Done: begin
				$finish;
			end
			
		endcase
	end
endmodule