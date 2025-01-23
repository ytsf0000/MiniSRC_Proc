module Reducer3_2 (
	input [31:0] a,
	input [31:0] b,
	input [31:0] c,
	output reg [32:0] out_c,
	output reg [31:0] out_s,
	output reg done
);

integer i;
always @ (*) begin
	done=1'b0;
	out_c[0]=1'b0;
	for(i=0;i<32;i=i+1)begin
		out_s[i]<=a[i]^b[i]^c[i];
		out_c[i+1]<=
			(a[i]&&b[i])||
			(a[i]&&c[i])||
			(b[i]&&c[i]);
	end
	done=1'b1;
end

endmodule