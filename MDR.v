module MDR #(parameter DATA_WIDTH_IN = 32, DATA_WIDTH_OUT = 32, INIT = 32'h0)(
    input Clear, Clock, MDRin,
    input [31:0] BusMuxOut, input [31:0] Mdatain,
    input Read,
	 output [31:0] BusMuxIn
);

	//Input Register value (D)
	reg [31:0]d;
	initial d = 32'b0;
	//Mux
	always @ (*) begin
		 if(~Read) begin
			  d = BusMuxOut;
		 end
		 else begin
			  d = Mdatain;
		 end
	end  

	//Output Register Value (Q)
	reg[31:0]q;
	initial q = 32'b0;
	always @ (posedge Clock) begin
		if (Clear) begin
			q <= {DATA_WIDTH_IN{1'b0}};
		end
		else if (MDRin) begin
			q <= d;
		end
	end

	assign BusMuxIn = q;
endmodule 