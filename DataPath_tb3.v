module DataPath_tb3();

  reg Clock; 
  reg [1:0]interrupt;
  

  reg Reset,Stop;
  
  wire CON_FF;
  reg BranchOut;
  wire [31:0]IR;
  wire Clear;
  wire Run;

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


  DataPath datapath(
    .OutPort_Out(OutPortData),
    .BranchOut(CON_FF),
    .Clock(Clock),

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
    .Clear(Clear)
  );
  assign IR=datapath.BusMuxInIR;

  ControlUnit ControlUnit_DUT(
    .Clock(Clock),
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
    .RAin(RAin)
  );

  initial begin
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