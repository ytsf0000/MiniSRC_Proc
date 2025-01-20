module Reducer3_2 (
	input enable,
	input [63:0] a,
	input [63:0] b,
	input [63:0] c,
	output reg [64:1] out_c,
	output reg [63:0] out_s,
	output reg done

);

integer i;
initial begin
	done='0';
	if(enable) begin
		for(i=0;i<64;i=i+1)begin
			out_s[i]<=a[i]^b[i]^c[i];
			out_c[i+1]<=
				(a[i]&&b[i])||
				(a[i]&&c[i])||
				(b[i]&&c[i]);
		end
		done='1';
	end
end

endmodule