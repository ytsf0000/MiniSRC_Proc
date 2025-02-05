module Mult (
		input [31:0] a,
		input [31:0] b,
		output [63:0] result
);
// last 3 bits [i+1,i,i-1]
reg [2:0]sel;
// array of numbers after bit pair
reg [63:0]current[15:0];
// if we need to do 2's complement on current number
reg compl[15:0];
// resulting numbers
wire [63:0]resultArray[15:0];
Fast2complement Complement0(compl[0],current[0],resultArray[0]);
Fast2complement Complement1(compl[1],current[1],resultArray[1]);
Fast2complement Complement2(compl[2],current[2],resultArray[2]);
Fast2complement Complement3(compl[3],current[3],resultArray[3]);
Fast2complement Complement4(compl[4],current[4],resultArray[4]);
Fast2complement Complement5(compl[5],current[5],resultArray[5]);
Fast2complement Complement6(compl[6],current[6],resultArray[6]);
Fast2complement Complement7(compl[7],current[7],resultArray[7]);
Fast2complement Complement8(compl[8],current[8],resultArray[8]);
Fast2complement Complement9(compl[9],current[9],resultArray[9]);
Fast2complement Complement10(compl[10],current[10],resultArray[10]);
Fast2complement Complement11(compl[11],current[11],resultArray[11]);
Fast2complement Complement12(compl[12],current[12],resultArray[12]);
Fast2complement Complement13(compl[13],current[13],resultArray[13]);
Fast2complement Complement14(compl[14],current[14],resultArray[14]);
Fast2complement Complement15(compl[15],current[15],resultArray[15]);

// multiply the current number by 2
reg mult2;

// all the adder stages					
wire [63:0]stage1Vals_s[4:0];
wire [63:0]stage1Vals_c[4:0];

Reducer3_2 Stage1_0_lo(resultArray[3*0][31:0],resultArray[3*0+1][31:0],resultArray[3*0+2][31:0],
stage1Vals_s[0][31:0],stage1Vals_c[0][31:0]);
Reducer3_2 Stage1_0_hi(resultArray[3*0][63:32],resultArray[3*0+1][63:32],resultArray[3*0+2][63:32],
stage1Vals_s[0][63:32],stage1Vals_c[0][63:32]);

Reducer3_2 Stage1_1_lo(resultArray[3*1][31:0],resultArray[3*1+1][31:0],resultArray[3*1+2][31:0],
stage1Vals_s[1][31:0],stage1Vals_c[1][31:0]);
Reducer3_2 Stage1_1_hi(resultArray[3*1][63:32],resultArray[3*1+1][63:32],resultArray[3*1+2][63:32],
stage1Vals_s[1][63:32],stage1Vals_c[1][63:32]);

Reducer3_2 Stage1_2_lo(resultArray[3*2][31:0],resultArray[3*2+1][31:0],resultArray[3*2+2][31:0],
stage1Vals_s[2][31:0],stage1Vals_c[2][31:0]);
Reducer3_2 Stage1_2_hi(resultArray[3*2][63:32],resultArray[3*2+1][63:32],resultArray[3*2+2][63:32],
stage1Vals_s[2][63:32],stage1Vals_c[2][63:32]);

Reducer3_2 Stage1_3_lo(resultArray[3*3][31:0],resultArray[3*3+1][31:0],resultArray[3*3+2][31:0],
stage1Vals_s[3][31:0],stage1Vals_c[3][31:0]);
Reducer3_2 Stage1_3_hi(resultArray[3*3][63:32],resultArray[3*3+1][63:32],resultArray[3*3+2][63:32],
stage1Vals_s[3][63:32],stage1Vals_c[3][63:32]);

Reducer3_2 Stage1_4_lo(resultArray[3*4][31:0],resultArray[3*4+1][31:0],resultArray[3*4+2][31:0],
stage1Vals_s[4][31:0],stage1Vals_c[4][31:0]);
Reducer3_2 Stage1_4_hi(resultArray[3*4][63:32],resultArray[3*4+1][63:32],resultArray[3*4+2][63:32],
stage1Vals_s[4][63:32],stage1Vals_c[4][63:32]);

wire [63:0]stage2Vals_s[2:0];
wire [63:0]stage2Vals_c[2:0];

Reducer3_2 Stage2_0_lo(stage1Vals_s[3*0][31:0],stage1Vals_s[3*0+1][31:0],stage1Vals_s[3*0+2][31:0],
stage2Vals_s[0][31:0],stage2Vals_c[0][31:0]);
Reducer3_2 Stage2_0_hi(stage1Vals_s[3*0][63:32],stage1Vals_s[3*0+1][63:32],stage1Vals_s[3*0+2][63:32],
stage2Vals_s[0][63:32],stage2Vals_c[0][63:32]);

Reducer3_2 Stage2_1_lo({stage1Vals_c[3*0][30:0],1'b0},{stage1Vals_c[3*0+1][30:0],1'b0},{stage1Vals_c[3*0+2][30:0],1'b0},
stage2Vals_s[1][31:0],stage2Vals_c[1][31:0]);
Reducer3_2 Stage2_1_hi(stage1Vals_c[3*0][62:31],stage1Vals_c[3*0+1][62:31],stage1Vals_c[3*0+2][62:31],
stage2Vals_s[1][63:32],stage2Vals_c[1][63:32]);

Reducer3_2 Stage2_2_lo(stage1Vals_s[3][31:0],{stage1Vals_c[3][30:0],1'b0},resultArray[15][31:0],
stage2Vals_s[2][31:0],stage2Vals_c[2][31:0]);
Reducer3_2 Stage2_2_hi(stage1Vals_s[3][63:32],stage1Vals_c[3][62:31],resultArray[15][63:32],
stage2Vals_s[2][63:32],stage2Vals_c[2][63:32]);

wire [63:0]stage3Vals_s[1:0];
wire [63:0]stage3Vals_c[1:0];

Reducer3_2 Stage3_0_lo(stage2Vals_s[0][31:0],{stage2Vals_c[0][30:0],1'b0},stage1Vals_s[4][31:0],
stage3Vals_s[0][31:0],stage3Vals_c[0][31:0]);
Reducer3_2 Stage3_0_hi(stage2Vals_s[0][63:32],stage2Vals_c[0][62:31],stage1Vals_s[4][63:32],
stage3Vals_s[0][63:32],stage3Vals_c[0][63:32]);

Reducer3_2 Stage3_1_lo(stage2Vals_s[1][31:0],{stage2Vals_c[1][30:0],1'b0},{stage1Vals_c[4][30:0],1'b0},
stage3Vals_s[1][31:0],stage3Vals_c[1][31:0]);
Reducer3_2 Stage3_1_hi(stage2Vals_s[1][63:32],stage2Vals_c[1][62:31],stage1Vals_c[4][62:31],
stage3Vals_s[1][63:32],stage3Vals_c[1][63:32]);

wire [63:0]stage4Vals_s[1:0];
wire [63:0]stage4Vals_c[1:0];

Reducer3_2 Stage4_0_lo(stage3Vals_s[0][31:0],{stage3Vals_c[0][30:0],1'b0},stage2Vals_s[2][31:0],
stage4Vals_s[0][31:0],stage4Vals_c[0][31:0]);
Reducer3_2 Stage4_0_hi(stage3Vals_s[0][63:32],stage3Vals_c[0][62:31],stage2Vals_s[2][63:32],
stage4Vals_s[0][63:32],stage4Vals_c[0][63:32]);

Reducer3_2 Stage4_1_lo(stage3Vals_s[1][31:0],{stage3Vals_c[1][30:0],1'b0},{stage2Vals_c[2][30:0],1'b0},
stage4Vals_s[1][31:0],stage4Vals_c[1][31:0]);
Reducer3_2 Stage4_1_hi(stage3Vals_s[1][63:32],stage3Vals_c[1][62:31],stage2Vals_c[2][62:31],
stage4Vals_s[1][63:32],stage4Vals_c[1][63:32]);

wire [63:0]finalStage_s[1:0];
wire [63:0]finalStage_c[1:0];

Reducer3_2 StageFinal_0_lo(stage4Vals_s[0][31:0],stage4Vals_s[1][31:0],{stage4Vals_c[0][30:0],1'b0},
finalStage_s[0][31:0],finalStage_c[0][31:0]);
Reducer3_2 StageFinal_0_hi(stage4Vals_s[0][63:32],stage4Vals_s[1][63:32],stage4Vals_c[0][62:31],
finalStage_s[0][63:32],finalStage_c[0][63:32]);

Reducer3_2 StageFinal_1_lo(finalStage_s[0][31:0],{finalStage_c[0][30:0],1'b0},{stage4Vals_c[1][30:0],1'b0},
finalStage_s[1][31:0],finalStage_c[1][31:0]);
Reducer3_2 StageFinal_1_hi(finalStage_s[0][63:32],finalStage_c[0][62:31],stage4Vals_c[1][62:31],
finalStage_s[1][63:32],finalStage_c[1][63:32]);

CLA_64B CLA(
	.a(finalStage_s[1]),
	.b({finalStage_c[1][62:0],1'b0}),
	.s(result),
	.c_out()
);

integer i;
always @ (*) begin
	sel=3'b000;

	for(i=0;i<16;i=i+1)begin

		compl[i]=1'b0;
		mult2=1'b0;

		sel[2]=b[2*i+1];
		sel[1]=b[2*i];
		current[i]={{32{a[31]}},a};

		case (sel)
			3'b001:	mult2=1'b0;
			3'b010:	mult2=1'b0;
			3'b011:	mult2=1'b1;
			3'b100:	begin
					mult2=1'b1;
					compl[i]=1'b1;
				end
			3'b101:	compl[i]=1'b1;
			3'b110:	compl[i]=1'b1;
			default: current[i]=64'b0;
		endcase
		

		if(mult2)
			current[i]=current[i]<<1;

		current[i]=current[i]<<(2*i);

		sel[0]=b[2*i+1];
		
	end
end


endmodule