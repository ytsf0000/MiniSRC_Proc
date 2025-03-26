module ControlUnit #(parameter InterruptsNum=1)(
  input Clock, Clear, Stop, CON_FF,
	input [31:0]IR,
	input interrupt[InterruptsNum-1:0],
	output reg Run,
	output reg Clear,

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
	output reg PCout
);

	wire BranchOut;

	parameter 
		Ld =		5'b00000,// done
		Ldi =		5'b00001,// done
		St =		5'b00010,// done
		Add =		5'b00011,
		Sub =		5'b00100,
		And =		5'b00101,
		Or =		5'b00110,
		Ror =		5'b00111,
		Rol =		5'b01000,
		Shr =		5'b01001,
		Shra =	5'b01010,
		Shl =		5'b01011,
		Addi =	5'b01100,// done
		Andi =	5'b01101,// done
		Ori =		5'b01110,// done
		Div =		5'b01111,
		Mul =		5'b10000,
		Neg =		5'b10001,
		Not =		5'b10010,
		Br =		5'b10011,// done
		Jal =		5'b10100,// done
		Jr =		5'b10101,// done
		In =		5'b10110,// done
		Out =		5'b10111,// done
		Mflo =	5'b11000,// done
		Mfhi =	5'b11001;// done



	parameter T0=4'h0,T1=4'h1,T2=4'h2,T3=4'h3,T4=4'h4,T5=4'h5,T6=4'h6,T7=4'h7,ClearState = 4'h8,Done=4'h9;
  
	wire [5:0] operation_state;
	assign operation_state=IR[31:27];
	
	reg [3:0] next_state;
	reg [3:0] present_state;
	
	// initial state
	initial begin
		present_state <= ClearState;
		operation_state <= Ld;
	end
	
	// state transition
	always @ (negedge Clock) begin
		#5;
		present_state <= next_state;
	end
	
	// prepare next state
	always @(*) begin
		case (present_state)
			ClearState : next_state = T0;
			T0 : next_state = T1;
			T1 : next_state = T2;
			T2 : next_state = T3;
			T3 : next_state = T4;
			T4 : next_state = T5;
			T5 : next_state = T6;
			T6 : next_state = ClearState;
      T7 : next_state = T0;
			Done: next_state=Done;
		endcase
		if(Clear)
			next_state = ClearState;
	end
	
	// logic
	always @ (*) begin
		case (present_state)
			Clear : begin
				Run = 1'b0;
				Clear = 1'b0;
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
					Addi, Andi, Ori: begin
						Grb = 1;
						Rout = 1;
						Yin = 1;
					end
					Br:begin
						Gra = 1;
						Rout = 1;
						CONin = 1;
						BranchTaken = BranchOut;// TODO see significance of this
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
						OutPortOut=1;
					end
					Out:begin
						Gra=1;
						Rout=1;
						OutPortIn=1;
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
						OutPortOut=0;
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
				
				Addi, Andi, Ori: begin
					Cout = 0;
					AND = 0;
					ADD = 0;
					OR = 0;
					Zin = 0;
					Zlowout = 1;
					Gra = 1;
					Rin = 1;
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
					Br:begin
						Cout = 0;
						Zin = 0;
						ADD = 0;
						Zlowout = 1;
						if (BranchTaken)
							PCin = 1;
					end
        endcase
      end
      T7 : 
      begin
        case(operation_state)
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
endmodule