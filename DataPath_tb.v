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
				
	reg [3:0] next_state;
	reg [3:0] present_state;
	
	DataPath DataPath_DUT (
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
		.SUB(1'b0), // this is to stop the alu from z values
		.R3in(R3in),
		.R4in(R4in), 
		.R7in(R7in), 
		.Clock(Clock), 
		.Mdatain(Mdatain)
	);
	
	// add test logic here
	initial begin
		Clock <= 1'b1;
		forever #10 Clock <= ~ Clock;
	end
	
	initial begin
		present_state <= Default;
	end
	
	always @ (negedge Clock) begin
		#5;
		present_state <= next_state;
	end
	
	always @(*) begin
		case (present_state)
			Default : next_state = Reg_load1a;
			Reg_load1a : next_state = Reg_load1b;
			Reg_load1b : next_state = Reg_load2a;
			Reg_load2a : next_state = Reg_load2b;
			Reg_load2b : next_state = Reg_load3a;
			Reg_load3a : next_state = Reg_load3b;
			Reg_load3b : next_state = T0;
			T0 : next_state = T1;
			T1 : next_state = T2;
			T2 : next_state = T3;
			T3 : next_state = T4;
			T4 : next_state = T5;
			T5 : next_state = Done;
		endcase
	end
	
	always @ (*) begin
		case (present_state)
			Default : begin
				PCout = 1'b0;
				Zlowout = 1'b0;
				MDRout = 1'b0;
				R3out = 1'b0;
				R7out = 1'b0;
				MARin = 1'b0;
				Zin = 1'b0;
				PCin = 1'b0;
				MDRin = 1'b0;
				IRin = 1'b0;
				Yin = 1'b0;
				IncPC = 1'b0;
				Read = 1'b0;
				AND = 1'b0;
				R3in = 1'b0;
				R4in = 1'b0;
				R7in = 1'b0;
				Clock = 1'b0;
				Mdatain = 32'b0;
			end
			Reg_load1a: begin
				Mdatain = 32'h00000022;
				Read = 1; 
				MDRin = 1;
			end
			Reg_load1b: begin
				Read = 0; 
				MDRin = 0;
				// Blocking assignment so timing is not a concern for this state machine implementation
				MDRout = 1; 
				R3in = 1;
			end
			Reg_load2a: begin
				MDRout = 0;
				R3in = 0;
				
				Mdatain = 32'h00000024;
				Read = 1; 
				MDRin = 1;
			end
			Reg_load2b: begin
				Read = 0; 
				MDRin = 0;
				
				MDRout = 1; 
				R7in = 1;
			end
			Reg_load3a: begin
				MDRout = 0;
				R7in = 0;
				
				Mdatain = 32'h00000028;
				Read = 1; 
				MDRin = 1;
			end
			Reg_load3b: begin
				Read = 0; 
				MDRin = 0;
				
				MDRout = 1;
				R4in = 1;
			end
			T0: begin
				MDRout = 0;
				R4in = 0;
				
				PCout = 1; 
				MARin = 1; 
				IncPC = 1; 
				Zin = 1;
			end
			T1: begin
				PCout = 0; 
				MARin = 0; 
				IncPC = 0; 
				Zin = 0;
				
				Zlowout = 1; 
				PCin = 1; 
				Read = 1; 
				MDRin = 1;
				Mdatain = 32'h2A2B8000; 
			end
			T2: begin
				Zlowout = 0; 
				PCin = 0; 
				Read = 0; 
				MDRin = 0;
				
				MDRout = 1;
				IRin = 1;
			end
			T3: begin
				MDRout = 0;
				IRin = 0;
				
				R3out = 1;
				Yin = 1;
			end
			T4: begin
				R3out = 0;
				Yin = 0;
				
				R7out = 1; 
				AND = 1; 
				Zin = 1;
			end
			T5: begin
				R7out = 0; 
				AND = 0; 
				Zin = 0;
				
				Zlowout = 1; 
				R4in = 1;
			end
			Done: $stop;
			
		endcase
	end
	
	//logic to double check values for each state
	always @ (negedge Clock) begin
		case (present_state)
			Reg_load1a: begin
				$display("At 1a - %t: MDR Output = %b", $time, DataPath_DUT.BusMuxInMDR);
			end
			Reg_load1b: begin
				$display("At 1b - %t: MDR Output = %b, BusMuxOut = %b, R3 = %b", $time, DataPath_DUT.BusMuxInMDR, DataPath_DUT.BusMuxOut, DataPath_DUT.BusMuxInR3);
			end
			Reg_load2a: begin
				$display("At 2a - %t: MDR Output = %b", $time, DataPath_DUT.BusMuxInMDR);
			end
			Reg_load2b: begin
				$display("At 2b - %t: MDR Output = %b, BusMuxOut = %b, R7 = %b", $time, DataPath_DUT.BusMuxInMDR, DataPath_DUT.BusMuxOut, DataPath_DUT.BusMuxInR7);
			end
			Reg_load3a: begin
				$display("At 3a - %t: MDR Output = %b", $time, DataPath_DUT.BusMuxInMDR);
			end
			Reg_load3b: begin
				$display("At 3b - %t: MDR Output = %b, BusMuxOut = %b, R4 = %b", $time, DataPath_DUT.BusMuxInMDR, DataPath_DUT.BusMuxOut, DataPath_DUT.BusMuxInR4);
			end
			T0: begin
				$display("At T0 - %t: PC Output = %b, MAR Output = %b, Z Output = %b", $time, DataPath_DUT.BusMuxInPC, DataPath_DUT.MAR.q, DataPath_DUT.BusMuxInZlo);
			end
			T1: begin
				$display("At T1 - %t: BusMuxOut = %b, PC Output = %b, MDR Output = %h", $time, DataPath_DUT.BusMuxOut, DataPath_DUT.BusMuxInPC, DataPath_DUT.BusMuxInMDR);
			end
			T2: begin
				$display("At T2 - %t: BusMuxOut = %h, IR = %h", $time, DataPath_DUT.BusMuxOut, DataPath_DUT.BusMuxInIR);
			end
			T3: begin
				$display("At T3 - %t: BusMuxOut = %b, R3 = %b, Y = %b", $time, DataPath_DUT.BusMuxOut, DataPath_DUT.BusMuxInR3, DataPath_DUT.Y_Out);
			end
			T4: begin
				$display("At T4 - %t: BusMuxOut = %b, R7 = %b, R3 = %b, Zlow = %b", $time, DataPath_DUT.BusMuxOut, DataPath_DUT.BusMuxInR7, DataPath_DUT.BusMuxInR3, DataPath_DUT.BusMuxInZlo);
			end
			T5: begin
				$display("At T5 - %t: Zlow = %b, BusMuxOut = %b, R4 = %b", $time, DataPath_DUT.BusMuxInZlo, DataPath_DUT.BusMuxOut, DataPath_DUT.BusMuxInR4);
			end
		endcase
	end
	
endmodule