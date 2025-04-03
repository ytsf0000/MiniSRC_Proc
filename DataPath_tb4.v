module DataPath_tb4();

  reg Clock; 
  wire Operating_CLK;
  reg [1:0]interrupt;
  reg [31:0] INPort_In;

  reg Reset,Stop;
  
  wire CON_FF;
  wire [31:0]IR;
  wire Clear;
  wire Run;
  wire RINout;
  wire Strobe;
  wire OutPortIn;
  wire Read;
  wire Write;
  wire ADD;
  wire SUB;
  wire AND;
  wire OR;
  wire ROR;
  wire ROL;
  wire SHR;
  wire SHRA;
  wire SHL;
  wire DIV;
  wire MUL;
  wire NEG;
  wire NOT;
  wire LOin;
  wire HIin;
  wire CONin;
  wire PCin;
  wire IRin;
  wire Yin;
  wire Zin;
  wire MARin;
  wire MDRin;
  wire OutPortOut;
  wire Cout;
  wire BAout;
  wire IncPC;
  wire Gra;
  wire Grb;
  wire Grc;
  wire Rin;
  wire Rout;
  wire HIout;
  wire LOout;
  wire Zhighout;
  wire Zlowout;
  wire MDRout;
  wire PCout;
  wire RAin;

  wire [31:0]OutPortData;
  wire [7:0] seven_seg_1;
  wire [7:0] seven_seg_2;

  DataPath datapath(
    .OutPort_Out(OutPortData),
    .BranchOut(CON_FF),
    .Clock(Operating_CLK),
	 .INPort_In(INPort_In),
    .OutPortIn(OutPortIn),
    .Read(Read),
    .Write(Write),
    .ADD(ADD),
    .SUB(SUB),
    .AND(AND),
    .OR(OR),
    .ROR(ROR),
    .ROL(ROL),
    .SHR(SHR),
    .SHRA(SHRA),
    .SHL(SHL),
    .DIV(DIV),
    .MUL(MUL),
    .NEG(NEG),
    .NOT(NOT),
    .LOin(LOin),
    .HIin(HIin),
    .CONin(CONin),
    .PCin(PCin),
    .IRin(IRin),
    .Yin(Yin),
    .Zin(Zin),
    .MARin(MARin),
    .MDRin(MDRin),
    .OutPortOut(OutPortOut),
    .Cout(Cout),
    .BAout(BAout),
    .IncPC(IncPC),
    .Gra(Gra),
    .Grb(Grb),
    .Grc(Grc),
    .Rin(Rin),
    .Rout(Rout),
    .HIout(HIout),
    .LOout(LOout),
    .Zhighout(Zhighout),
    .Zlowout(Zlowout),
    .MDRout(MDRout),
    .PCout(PCout),
    .RAin(RAin),
    .Clear(Clear),
	 .Strobe(Strobe),
	 .RINout(RINout)
  );
  assign IR=datapath.BusMuxInIR;

  ControlUnit ControlUnit_DUT(
    .Clock(Operating_CLK),
    .Reset(Reset),
    .ClearSig(Clear),
    .Stop(Stop),
    .CON_FF(CON_FF),
    .IR(IR),
    .interrupt(interrupt),
    .Run(Run),
    .OutPortIn(OutPortIn),
    .Read(Read),
    .Write(Write),
    .ADD(ADD),
    .SUB(SUB),
    .AND(AND),
    .OR(OR),
    .ROR(ROR),
    .ROL(ROL),
    .SHR(SHR),
    .SHRA(SHRA),
    .SHL(SHL),
    .DIV(DIV),
    .MUL(MUL),
    .NEG(NEG),
    .NOT(NOT),
    .LOin(LOin),
    .HIin(HIin),
    .CONin(CONin),
    .PCin(PCin),
    .IRin(IRin),
    .Yin(Yin),
    .Zin(Zin),
    .MARin(MARin),
    .MDRin(MDRin),
    .OutPortOut(OutPortOut),
    .Cout(Cout),
    .BAout(BAout),
    .IncPC(IncPC),
    .Gra(Gra),
    .Grb(Grb),
    .Grc(Grc),
    .Rin(Rin),
    .Rout(Rout),
    .HIout(HIout),
    .LOout(LOout),
    .Zhighout(Zhighout),
    .Zlowout(Zlowout),
    .MDRout(MDRout),
    .PCout(PCout),
    .RAin(RAin),
	 .RINout(RINout),
	 .Strobe(Strobe)
  );
  
  ClockDiv ClockDiv_DUT(
		.in_clock(Clock),
		.out_clock(Operating_CLK)
  );
  
  Seven_Seg_Display_Out Seven_Seg_Display_Out_1_DUT(
	.outputt(seven_seg_1),
	.clk(Operating_CLK),
	.data(OutPortData[3:0])
  );
  
  Seven_Seg_Display_Out Seven_Seg_Display_Out_2_DUT(
	.outputt(seven_seg_2),
	.clk(Operating_CLK),
	.data(OutPortData[7:4])
  );
  
  initial begin
	 INPort_In <= 32'hC0;
	 interrupt <= 0;
    Reset<=1;
    Stop<=0;
		Clock <= 1'b1;
		forever #10 Clock <= ~ Clock;
	end

  always @ (negedge Clock)
  begin
    Reset<=0;
    if(!Run)begin
      $stop;
    end
  end



endmodule