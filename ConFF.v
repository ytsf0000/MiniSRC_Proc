module ConFF (
	input CONin,
	input [1:0] IR, // we only need two bits here
	input [31:0] Bus,
	output reg BranchOut
);

	initial begin BranchOut = 0
	
	wire not_zero; // for the output of nor gate
	
	wire brzr; // branch if 0
	wire brnz; // branch if not 0
	wire brpl; // branch if pos
	wire brmi; // branch if neg
	wire dff_in;
	
	reg [3:0] decoder_out;
	
	OR(not_zero, Bus);
	
	// decoder
	always @ (*) begin
		case(IR)
			2'b00: decoder_out = 4'b0001;
			2'b01: decoder_out = 4'b0010;
			2'b10: decoder_out = 4'b0100;
			2'b11: decoder_out = 4'b1000;
		endcase
	end
	
	assign brzr = (~not_zero) & decoder_out[0]; // branch if 0
	assign brnz = not_zero & decoder_out[1]; // branch if not 0
	assign brpl = (~Bus[31]) & decoder_out[2]; // branch if pos
	assign brmi = Bus[31] & decoder_out[3]; // branch if neg
	
	OR(dff_in, brzr, brnz, brpl, brmi);
	
	always @ (posedge CONin) begin
		BranchOut <= dff_in;
	end
	
endmodule