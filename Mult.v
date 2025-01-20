module Mult (
		input enable,
		input [63:0] a,
		input [63:0] b,
		output reg [63:0] result,
		output reg done
);
// last 3 bits [i+1,i,i-1]
reg [2:0]sel;

// do we need to do neg of num
wire compl;
// mult by 2
wire mult2;

reg [63:0]current;
reg [63:0]workingVal;
Fast2complement Complement(compl,current,workingVal);


reg [63:0]resultArray[32:0];
wire startFirstStage;

reg [63:0] val0_6[2:0];
wire done0_6;
Reducer7_3 Reduce0_6(startFirstStage,resultArray[0],resultArray[1],resultArray[2],resultArray[3],resultArray[4],resultArray[5],resultArray[6],
										 val0_6[2],val0_6[1],val0_6[0],done0_6);

reg [63:0] val7_13[2:0];
wire done7_13;
Reducer7_3 Reduce7_13(startFirstStage,resultArray[7],resultArray[8],resultArray[9],resultArray[10],resultArray[11],resultArray[12],resultArray[13],
										 val7_13[2],val7_13[1],val7_13[0],done7_13);

reg [63:0] val14_20[2:0];
wire done14_20;
Reducer7_3 Reduce14_20(startFirstStage,resultArray[14],resultArray[15],resultArray[16],resultArray[17],resultArray[18],resultArray[19],resultArray[20],
										 val14_20[2],val14_20[1],val14_20[0],done14_20);

reg [63:0] val21_27[2:0];
wire done21_27;
Reducer7_3 Reduce21_27(startFirstStage,resultArray[21],resultArray[22],resultArray[23],resultArray[24],resultArray[25],resultArray[26],resultArray[27],
										 val21_27[2],val21_27[1],val21_27[0],done21_27);

reg [63:0] val28_30[1:0];
wire done28_30;
Reducer3_2 Reduce28_30(startFirstStage,resultArray[28],resultArray[29],resultArray[30],
											val28_30[1],val28_30[0],done28_30);

reg [63:0] val0_13_31[2:0];
wire done0_13_31;
Reducer7_3 Reduce0_13_31(done0_6 && done7_13,val0_6[0],val0_6[1],val0_6[2],val7_13[0],val7_13[1],val7_13[2],resultArray[31]
											val0_13_31[0],val0_13_31[1],val0_13_31[2],done0_13_31);

reg [63:0] val14_28[2:0];
wire done14_28;
Reducer7_3 Reduce14_28(done14_20 && done21_27 && done28_30, val14_20[0],val14_20[1],val14_20[2],val21_27[0],val14_20[1],val14_20[2],val28_30[0],
											val14_28[2],val14_28[1],val14_28[0],done14_28);

reg [63:0] val0_31[2:0];
wire done0_31;
Reducer7_3 Reduce0_31(done0_13_31 && done14_28,val0_13_31[0],val0_13_31[1],val0_13_31[2],val14_28[0],val14_28[1],val14_28[2],val28_30[1],
											val0_31[2],val0_31[1],val0_31[0],done0_31);

reg [63:0] val0_31_3_2[1:0];
wire done0_31_3_2;
Reducer3_2 Reduce0_31_3_2(done0_31,val0_31[0],val0_31[1],val0_31[2],val0_31_3_2[1],val0_31_3_2[0],done0_31_3_2);

// call Adder 

integer i;
initial begin
	if (enable)	begin
		sel='000';		
		for(i=0;i<32;i=i+1)begin
			compl='0';
			mult2='0';

			sel[2:1]<=b[2*i+1 : 2*i];
			current<=a;
			case (sel)
				3'b001:	mult2<='0';
				3'b010:	mult2<='0';
				3'b011:	mult2<='1';
				3'b100:	begin
						mult2<='1';
						compl<='1';
					end
				3'b101:	compl<='1';
				3'b110:	compl<='1';
				default: current<=0x00000000;
			endcase
			
			if(mult2)
				current<=current<<1;

			current<=current<<2*i;
			sel[0]<=b[2*i+1];
			
			resultArray[i]<=workingVal;
		end
		startFirstStage='1';



	end
end



endmodule