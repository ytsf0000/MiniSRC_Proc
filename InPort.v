module InPort #(parameter DATA_WIDTH_IN = 32, DATA_WIDTH_OUT = 32, INIT = 32'h0)(
	input Clear, Clock, Strobe, Strobe,
	input [DATA_WIDTH_IN-1:0] Input,
	output [DATA_WIDTH_OUT-1:0] BusMuxIn
);

reg [DATA_WIDTH_IN-1:0]q;
initial q = INIT;
always @ (posedge Clock)
		begin
			if (Clear) begin
				q <= {DATA_WIDTH_IN{1'b0}};
			end
			else if (Strobe) begin
				q <= BusMuxOut;
			end
		end
	assign BusMuxIn = q[DATA_WIDTH_OUT-1:0];
endmodule
