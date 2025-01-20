module Fast2complement (
	input enable,
	input [63:0]in,
	output reg [63:0]out
);
reg flip='0';

integer i;
initial begin
	if(enable)begin
		for(i = 0; i < 64; i = i + 1)begin
			if (flip=='0') begin
				out[i] <= in[i];
				if(in[i]=='1')begin
					flip='1';
				end
			end else begin
				out[i] <= ~in[i];
			end
		end
	end else begin
		out <= in;
	end
end


endmodule