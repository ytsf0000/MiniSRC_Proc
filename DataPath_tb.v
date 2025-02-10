`timescale 1ns/10ps
module DataPath_tb();

	reg PCout, Zlowout, Zhighout, MDRout, LOout, HIout, R2out, R3out, R6out, R7out; // add any other signals to see in your simulation
	reg MARin, Zin, PCin, MDRin, IRin, Yin, LOin, HIin;
	reg IncPC, Read, R2in, R3in, R4in, R6in, R7in;
	reg AND, OR, ADD, SUB, MUL, DIV;
	reg Clock;
	reg [31:0] Mdatain;
	
	parameter AND_s = 4'h0,OR_s=4'h1,ADD_s=4'h2,
				SUB_s=4'h3,MUL_s=4'h4,DIV_s=4'h6,
				SHR_s=4'h7,SHRA_s=4'h8,SHL_s=4'h9,
				ROR_s=4'hA,ROL_s=4'hB,NEG_s=4'hC,
				NOT_s=4'hD;

	parameter Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
				Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
				T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100, T6 = 4'b1101, Done = 4'b1110;
				
	reg [3:0] operation_state;
	reg [3:0] next_operation_state;
	
	reg [3:0] next_state;
	reg [3:0] present_state;
	
	DataPath DataPath_DUT (
		.PCout(PCout), 
		.Zlowout(Zlowout),
		.Zhighout(Zhighout),
		.MDRout(MDRout), 
		.LOout(LOout),
		.HIout(HIout),
		.R2out(R2out),
		.R3out(R3out),
		.R6out(R6out),
		.R7out(R7out), 
		.IncPC(IncPC), 
		.Read(Read), 
		.AND(AND),
		.OR(OR),
		.ADD(ADD),
		.SUB(SUB), // this is to stop the alu from z values
		.MUL(MUL),
		.DIV(DIV),
		.MARin(MARin), 
		.Zin(Zin), 
		.PCin(PCin), 
		.MDRin(MDRin), 
		.IRin(IRin), 
		.Yin(Yin), 
		.LOin(LOin),
		.HIin(HIin),
		.R2in(R2in),
		.R3in(R3in),
		.R4in(R4in),
		.R6in(R6in),
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
		operation_state <= MUL_s;
	end
	
	always @ (negedge Clock) begin
		#5;
		present_state <= next_state;
		if (present_state == Done) begin
			operation_state <= next_operation_state;
			present_state <= Default;
		end
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
			T5 : begin
				if ((operation_state == MUL_s) || (operation_state == DIV_s)) next_state = T6;
				else next_state = Done;
			end 
			T6: next_state = Done;
		endcase
		case (operation_state)
			AND_s : next_operation_state = OR_s;
			OR_s : next_operation_state = ADD_s;
			ADD_s : next_operation_state = SUB_s;
			SUB_s : next_operation_state = MUL_s;
			MUL_s : next_operation_state = DIV_s;
			DIV_s : next_operation_state = SHR_s;
			SHR_s : next_operation_state = SHRA_s;
			SHRA_s : next_operation_state = SHL_s;
			SHL_s : next_operation_state = ROR_s;
			ROR_s : next_operation_state = ROL_s;
			ROL_s : next_operation_state = NEG_s;
			NEG_s : next_operation_state = NOT_s;
			NOT_s : next_operation_state = AND_s;
		endcase
	end
	
	always @ (*) begin
		case (present_state)
			Default : begin
				PCout = 1'b0;
				Zlowout = 1'b0;
				Zhighout = 1'b0;
				MDRout = 1'b0;
				// TODO set all reg to 0 for other ops
				R2out = 1'b0;
				R3out = 1'b0;
				R6out = 1'b0;
				R7out = 1'b0;
				LOout = 1'b0;
				HIout = 1'b0;
				MARin = 1'b0;
				Zin = 1'b0;
				PCin = 1'b0;
				MDRin = 1'b0;
				IRin = 1'b0;
				Yin = 1'b0;
				IncPC = 1'b0;
				Read = 1'b0;
				// TODO set all alu inputs to 0
				AND = 1'b0;
				OR = 1'b0;
				ADD = 1'b0;
				SUB = 1'b0;
				MUL = 1'b0;
				DIV = 1'b0;
				// TODO set all register in to 0
				R2in = 1'b0;
				R3in = 1'b0;
				R4in = 1'b0;
				R6in = 1'b0;
				R7in = 1'b0;
				LOin = 1'b0;
				HIin = 1'b0;
				Clock = 1'b0;
				Mdatain = 32'b0;
			end
			Reg_load1a: begin
				case(operation_state)
					MUL_s: begin
						Mdatain = 32'h0F000022;
						Read = 1; 
						MDRin = 1;
					end
					default: begin
						Mdatain = 32'h00000022;
						Read = 1; 
						MDRin = 1;
					end
				endcase
			end
			Reg_load1b: begin
				case(operation_state)
					MUL_s: begin
						Read = 0; 
						MDRin = 0;
						// Blocking assignment so timing is not a concern for this state machine implementation
						MDRout = 1; 
						// TODO change this to specific register depending on operation state
						R2in = 1;
					end
					default: begin
						Read = 0; 
						MDRin = 0;
						// Blocking assignment so timing is not a concern for this state machine implementation
						MDRout = 1; 
						// TODO change this to specific register depending on operation state
						R3in = 1;
					end
				endcase
			end
			Reg_load2a: begin
				case(operation_state)
					MUL_s: begin
						MDRout = 0;
						// change this to specific register depending on operation state
						R2in = 0;
						
						Mdatain = 32'h88800024;
						Read = 1; 
						MDRin = 1;
					end
					default: begin
						MDRout = 0;
						// change this to specific register depending on operation state
						R3in = 0;
						
						Mdatain = 32'h00000024;
						Read = 1; 
						MDRin = 1;
					end
				endcase
			end
			Reg_load2b: begin
				case(operation_state)
					MUL_s: begin
						Read = 0; 
						MDRin = 0;
				
						MDRout = 1; 
						// TODO change this to specific register depending on operation state
						R6in = 1;
					end
					default: begin
						Read = 0; 
						MDRin = 0;
				
						MDRout = 1; 
						// TODO change this to specific register depending on operation state
						R7in = 1;
					end
				endcase
			end
			Reg_load3a: begin
				case(operation_state)
					MUL_s: begin
						MDRout = 0;
						// TODO change this to specific register depending on operation state
						R6in = 0;
					end
					default: begin
						MDRout = 0;
						// TODO change this to specific register depending on operation state
						R7in = 0;
						
						Mdatain = 32'h00000028;
						Read = 1; 
						MDRin = 1;
					end
				endcase
			end
			Reg_load3b: begin
				case(operation_state)
					MUL_s: begin
					
					end
					default: begin
						Read = 0; 
						MDRin = 0;
						
						MDRout = 1;
						// TODO change this to specific register depending on operation state
						R4in = 1;
					end
				endcase
			end
			T0: begin
				MDRout = 0;
				// TODO change this to specific register depending on operation state
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
				// TODO change this to specific register depending on operation state
				case (operation_state)
					AND_s : Mdatain = 32'h2A2B8000;
					OR_s : Mdatain = 32'h322b8000;
					ADD_s : Mdatain = 32'h1a2b8000;
					SUB_s : Mdatain = 32'h222b8000;
					MUL_s: Mdatain = 32'h79300000;
				endcase
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
				case(operation_state)
					MUL_s: begin
						R2out = 1;
						Yin = 1;
					end
					default: begin
						// TODO change this to specific register depending on operation state
						R3out = 1;
						Yin = 1;
					end
				endcase
			end
			T4: begin
				// TODO change this to specific register depending on operation state
				case(operation_state)
					MUL_s: begin
						R2out = 0;
						R6out = 1;
					end
					default: begin
						R3out = 0;
						R7out = 1; 
					end
				endcase
				Yin = 0;
				// TODO change this to specific register depending on operation state
				case (operation_state)
					AND_s : AND = 1;
					OR_s : OR = 1;
					ADD_s : ADD = 1;
					SUB_s : SUB = 1;
					MUL_s : MUL = 1;
				endcase
				Zin = 1;
			end
			T5: begin
				// TODO change this to specific register depending on operation state
				R6out = 0;
				R7out = 0; 
				AND = 1'b0;
				OR = 1'b0;
				ADD = 1'b0;
				SUB = 1'b0;
				MUL = 0;
				Zin = 0;
				
				Zlowout = 1; 
				// TODO change this to specific register depending on operation state
				case(operation_state)
					MUL_s: begin
						LOin = 1;
					end
					default: begin
						R4in = 1;
					end
				endcase
			end
			T6: begin
				LOin = 0;
				Zlowout = 0;
				
				Zhighout = 1;
				HIin = 1;
			end
			Done: begin
				if (operation_state==MUL_s)begin
					$stop;
				end
			end
		endcase
	end
	
	//logic to double check values for each state
	// TODO change this to specific register depending on operation state
	/*
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
	*/
endmodule