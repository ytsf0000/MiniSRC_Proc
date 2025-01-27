module Reducer3_2 (
	input [31:0] a,
	input [31:0] b,
	input [31:0] c,
	output reg [31:0] out_s,
	output reg [31:0] out_c
);

integer i;
always @ (*) begin
	for(i=0;i<32;i=i+1)begin
		out_s[i]=a[i]^b[i]^c[i];
		out_c[i]=
			(a[i]&&b[i])||
			(a[i]&&c[i])||
			(b[i]&&c[i]);
	end
end

endmodule