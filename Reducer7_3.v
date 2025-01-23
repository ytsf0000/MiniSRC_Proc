module Reducer7_3 (
	input [31:0] a1,
	input [31:0] a2,
	input [31:0] a3,
	input [31:0] a4,
	input [31:0] a5,
	input [31:0] a6,
	input [31:0] a7,
	output reg [33:0] out_c2,
	output reg [32:0] out_c1,
	output reg [31:0] out_s,
	output reg done
);

reg [7:0] concat;
integer i;
integer j;
always @ (*) begin
	done=1'b0;
	out_c2[1:0]=2'b00;
	out_c1[0]=1'b0;
	for(i=0;i<32;i=i+1)begin
		concat={a7[i],a6[i],a5[i],a4[i],a3[i],a2[i],a1[i]};

		out_s[i]<=1'b0;
		out_c1[i+1]<=1'b0;
		out_c2[i+2]<=1'b0;
		for(j=0;j<7;j=j+1)begin
			if(out_s[i]&concat[j])begin
				if(out_c1[i+1])begin
					out_c2[i+2]<=1'b1;
				end
				out_c1[i+1]<=out_c1[i+1]^1'b1;
			end
			out_s[i]<=out_s[i]^concat[j];
		end

		done=1'b1;			
	end
end

endmodule