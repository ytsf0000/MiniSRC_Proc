module ControlUnit #(parameter InterruptsNum=2)(
	input Clock, Reset, Stop, CON_FF,
	input [31:0]IR,
	input [InterruptsNum-1:0]interrupt,
	output reg Run,
	output reg ClearSig,
	output reg RINout, Strobe,
	output reg OutPortIn,
	output reg Read,
	output reg Write,

	output reg ADD,
	output reg SUB,
	output reg AND,
	output reg OR,
	output reg ROR,
	output reg ROL,
	output reg SHR,
	output reg SHRA,
	output reg SHL,
	output reg DIV,
	output reg MUL,
	output reg NEG,
	output reg NOT,

	output reg LOin,
	output reg HIin,
	output reg CONin,
	output reg PCin,
	output reg IRin,
	output reg Yin,
	output reg Zin,
	output reg MARin,
	output reg MDRin,
	output reg OutPortOut,
	output reg Cout,
	output reg BAout,
	output reg IncPC,

	output reg Gra,
	output reg Grb,
	output reg Grc,
	output reg Rin,
	output reg Rout,
	output reg HIout,
	output reg LOout,
	output reg Zhighout,
	output reg Zlowout,
	output reg MDRout,
	output reg PCout,
	output reg RAin
);

	parameter 
		Ld =		5'b00000,
		Ldi =		5'b00001,
		St =		5'b00010,
		Add =		5'b00011,
		Sub =		5'b00100,
		And =		5'b00101,
		Or =		5'b00110,
		Ror =		5'b00111,
		Rol =		5'b01000,
		Shr =		5'b01001,
		Shra =	5'b01010,
		Shl =		5'b01011,
		Addi =	5'b01100,
		Andi =	5'b01101,
		Ori =		5'b01110,
		Div =		5'b01111,
		Mul =		5'b10000,
		Neg =		5'b10001,
		Not =		5'b10010,
		Br =		5'b10011,
		Jal =		5'b10100,
		Jr =		5'b10101,
		In =		5'b10110,
		Out =		5'b10111,
		Mflo =	5'b11000,
		Mfhi =	5'b11001,
		Nop	 =	5'b11010,
		Halt =	5'b11011;

	parameter T0=4'h0,T1=4'h1,T2=4'h2,T3=4'h3,T4=4'h4,T5=4'h5,T6=4'h6,T7=4'h7,Clear = 4'h8,Done=4'h9;
	
	wire [5:0] operation_state;
	assign operation_state=IR[31:27];
	
	reg [3:0] next_state;
	reg [3:0] present_state;
	reg branchOut;
	
	// initial state
	initial begin
		Run <= 1;
		present_state <= Clear;
		branchOut<=0;
	end
	
	// state transition
	always @ (negedge Clock) begin
		#5;
		present_state <= next_state;
		if(Reset)begin
			ClearSig <= 1;
			present_state <= T0;
			Run<=1;
		end
		else if (Stop)begin
			ClearSig <= 1'b0;
			Run <= 0;
		end
		else begin
			ClearSig <= 1'b0;
			Run <= !(operation_state == Halt);
		end
	end
	// prepare next state
	always @(*) begin
		case (present_state)
			Clear : next_state = T0;
			T0 : next_state = T1;
			T1 : next_state = T2;
			T2 : next_state = T3;
			T3 : next_state = T4;
			T4 : next_state = T5;
			T5 : next_state = T6;
			T6 : next_state = T7;
			T7 : next_state = Clear;
			Done: next_state=Done;
		endcase
		if(Reset)
			next_state = Clear;
	end
	
	// logic
	always @ (*) begin
		if(Run)
		begin
			case (present_state)
				Clear : begin
					OutPortIn = 1'b0;
					Read = 1'b0;
					Write = 1'b0;
					ADD = 1'b0;
					SUB = 1'b0;
					AND = 1'b0;
					OR = 1'b0;
					ROR = 1'b0;
					ROL = 1'b0;
					SHR = 1'b0;
					SHRA = 1'b0;
					SHL = 1'b0;
					DIV = 1'b0;
					MUL = 1'b0;
					NEG = 1'b0;
					NOT = 1'b0;
					LOin = 1'b0;
					HIin = 1'b0;
					CONin = 1'b0;
					PCin = 1'b0;
					IRin = 1'b0;
					Yin = 1'b0;
					Zin = 1'b0;
					MARin = 1'b0;
					MDRin = 1'b0;
					OutPortOut = 1'b0;
					Cout = 1'b0;
					BAout = 1'b0;
					IncPC = 1'b0;
					Gra = 1'b0;
					Grb = 1'b0;
					Grc = 1'b0;
					Rin = 1'b0;
					Rout = 1'b0;
					HIout = 1'b0;
					LOout = 1'b0;
					Zhighout = 1'b0;
					Zlowout = 1'b0;
					MDRout = 1'b0;
					PCout = 1'b0;
					branchOut = 1'b0;
					RAin = 1'b0;
				end
				Done:begin
					$stop;
				end
				T0 : 
				begin
					PCout=1;
					MARin=1;
					IncPC=1;
					Zin=1;
				end
				T1 : 
				begin
					PCout=0;
					MARin=0;
					IncPC=0;
					Zin=0;
					Zlowout=1;
					PCin=1;
					Read=1;
					MDRin=1;
				end
				T2 : 
				begin
					Zlowout=0;
					PCin=0;
					Read=0;
					MDRin=0;
					MDRout=1;
					IRin=1;
				end
				T3 : 
				begin
					MDRout=0;
					IRin=0;
					case (operation_state)
						Ld,Ldi,St:begin
							Grb=1;
							BAout=1;
							Yin=1;
						end
						Add,Sub,And,Or,Addi, Andi, Ori, Ror, Rol, Shr, Shra, Shl, Neg, Not: begin
							Grb = 1;
							Rout = 1;
							Yin = 1;
						end
						Div,Mul: begin
							Gra = 1;
							Rout = 1;
							Yin = 1;
						end
						Br:begin
							Gra = 1;
							Rout = 1;
							CONin = 1;
							branchOut = CON_FF;
						end
						Jr:begin
							Gra = 1;
							Rout = 1;
							PCin = 1;
						end
						Jal: begin
							RAin = 1;
							Rin = 1;
							PCout = 1;
						end
						Mfhi:begin
							Gra=1;
							Rin=1;
							HIout=1;
						end
						Mflo:begin
							Gra=1;
							Rin=1;
							LOout=1;
						end
						In:begin
							Gra=1;
							Rin=1;
              RINout=1;
							Strobe=1;
						end
						Out:begin
							Gra=1;
							Rout=1;
							OutPortIn=1;
						end
						Halt:begin

						end
					endcase
				end
				T4 : 
				begin
					case(operation_state)
						Ld,Ldi,St:begin
							Grb=0;
							BAout=0;
							Yin=0;
							Cout=1;
							ADD=1;
							Zin=1;
						end
						Add,Sub,And,Or,Ror, Rol, Shr, Shra, Shl: begin
							Grb = 0;
							Yin = 0;

							Rout = 1;
							Grc = 1;
							ADD	= operation_state == Add;
							SUB	= operation_state == Sub;
							AND	= operation_state == And;
							OR	= operation_state == Or;
							ROR	= operation_state == Ror;
							ROL	= operation_state == Rol;
							SHR	= operation_state == Shr;
							SHRA= operation_state == Shra;
							SHL	= operation_state == Shl;
							Zin = 1;
						end
						Addi: begin
							Grb = 0;
							Rout = 0;
							Yin = 0;
							Cout = 1;
							ADD = 1;
							Zin = 1;
						end
						Andi: begin
							Grb = 0;
							Rout = 0;
							Yin = 0;
							Cout = 1;
							AND = 1;
							Zin = 1;
						end
						Ori: begin
							Grb = 0;
							Rout = 0;
							Yin = 0;
							Cout = 1;
							OR = 1;
							Zin = 1;
						end
						Div,Mul: begin
							Gra = 0;
							Yin = 0;

							Rout = 1;
							Grb = 1;
							MUL = operation_state == Mul;
							DIV = operation_state == Div;
							Zin = 1;
						end
						Neg,Not: begin
							NEG = operation_state == Neg;
							NOT = operation_state == Not;
							Zin = 1;
						end
						Br: begin
							Gra=0;
							Rout=0;
							CONin = 0;
							PCout = 1;
							Yin = 1;
						end
						Jr:begin
							Gra = 0;
							Rout = 0;
							PCin = 0;
						end
						Jal: begin
							RAin = 0;
							Rin = 0;
							PCout = 0;
							Gra = 1;
							Rout = 1;
							PCin = 1;
						end
						Mfhi:begin
							Gra=0;
							Rin=0;
							HIout=0;
						end
						Mflo:begin
							Gra=0;
							Rin=0;
							LOout=0;
						end
						In:begin
							Gra=0;
							Rin=0;
              RINout=0;
							Strobe=0;
						end
						Out:begin
							Gra=0;
							Rout=0;
							OutPortIn=0;
						end
					endcase
				end
				T5 : 
				begin
					case(operation_state)
						Ld:begin
							Cout=0;
							ADD=0;
							Zin=0;
							Zlowout=1;
							MARin=1;
						end
						Ldi:begin
							Cout=0;
							ADD=0;
							Zin=0;
							Zlowout=1;
							Gra=1;
							Rin=1;
						end
						St:begin
							Cout=0;
							ADD=0;
							Zin=0;
							Zlowout=1;
							MARin=1;
						end
						Add,Sub,And,Or,Addi, Andi, Ori,Ror, Rol, Shr, Shra, Shl, Neg, Not: begin
							Rout = 0;
							Grc = 0;
							ADD = 0;
							SUB = 0;
							AND = 0;
							OR = 0;
							ROR = 0;
							ROL = 0;
							SHR = 0;
							SHRA = 0;
							SHL = 0;
							NEG = 0;
							NOT = 0;
							Zin = 0;

							Zlowout = 1;
							Gra = 1;
							Rin = 1;
						end
						Div,Mul: begin
							Rout = 0;
							Grb = 0;
							MUL = 0;
							DIV = 0;
							Zin = 0;

							Zlowout = 1;
							LOin = 1;
						end
						Br:begin
							PCout = 0;
							Yin = 0;
							ADD = 1;
							Cout = 1;
							Zin = 1;
						end
						Jal: begin
							Gra = 0;
							Rout = 0;
							PCin = 0;
						end
					endcase
				end
				T6 : 
				begin
					case(operation_state)
						Ld:begin
							Zlowout=0;
							MARin=0;
							Read=1;
							MDRin=1;
						end
						Ldi:begin
							Zlowout=0;
							Gra=0;
							Rin=0;
						end
						St:begin
							Zlowout=0;
							MARin=0;
							Gra=1;
							Rout=1;
							Write=1;
						end
						Add,Sub,And,Or,Addi, Andi, Ori,Ror, Rol, Shr, Shra, Shl, Neg, Not: begin
							Zlowout = 0;
							Gra = 0;
							Rin = 0;
						end
						Div,Mul: begin
							Zlowout = 0;
							LOin = 0;
							Zhighout = 1;
							HIin = 1;
						end

						Br:begin
							Cout = 0;
							Zin = 0;
							ADD = 0;
							Zlowout = 1;
							PCin = branchOut;
							branchOut = 0;
							end
					endcase
				end
				T7 : 
				begin
					case(operation_state)
						Div,Mul: begin
							Zhighout = 0;
							HIin = 0;
						end
						Br:begin
							Zlowout = 0;
							PCin = 0;
						end
						Ld:begin
							Read=0;
							MDRin=0;
							MDRout=1;
							Gra=1;
							Rin=1;
						end
						St:begin
							Gra=0;
							Rout=0;
							Write=0;
						end
					endcase
				end

			endcase
		end
	end	
endmodule