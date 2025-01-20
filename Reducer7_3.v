module Reducer3_2 (
	input enable,
	input [63:0] a1,
	input [63:0] a2,
	input [63:0] a3,
	input [63:0] a4,
	input [63:0] a5,
	input [63:0] a6,
	input [63:0] a7,
	output reg [65:2] out_c2,
	output reg [64:1] out_c1,
	output reg [63:0] out_s,
	output reg done
);

reg [7:0] concat;
integer i;
integer j;
initial begin
	done='0';
	if(enable) begin
		for(i=0;i<64;i=i+1)begin
			concat={a7[i],a6[i],a5[i],a4[i],a3[i],a2[i],a1[i]};

			out_s[i]='0';
			out_c1[i]='0';
			out_c2[i]='0';
			for(j=0;j<7;j=j+1)begin
				if(out_s[i]&concat[j]=='1')begin
					if(out_c1[i]=='1')begin
						out_c2[i]='1';
					end
					out_c1[i]=out_c1[i]^'1';
				end
				out_s[i]=out_s[i]^concat[j];
			end

			done<='1';
			// out_s[i]<=a1[i]^a2[i]^a3[i]^
			// 	a4[i]^a5[i]^a6[i]^a7[i];
			
			
			// out_c1[i+1]<=
			// 	(a1[i]&a2[i])^
			// 	(a1[i]&a3[i])^
			// 	(a1[i]&a4[i])^
			// 	(a1[i]&a5[i])^
			// 	(a1[i]&a6[i])^
			// 	(a1[i]&a7[i])^
				
			// 	(a2[i]&a3[i])^
			// 	(a2[i]&a4[i])^
			// 	(a2[i]&a5[i])^
			// 	(a2[i]&a6[i])^
			// 	(a2[i]&a7[i])^
				
			// 	(a3[i]&a4[i])^
			// 	(a3[i]&a5[i])^
			// 	(a3[i]&a6[i])^
				
			// 	(a4[i]&a5[i])^
			// 	(a4[i]&a6[i])^
				
			// 	(a5[i]&a6[i]);
			
		end
	end
end

endmodule