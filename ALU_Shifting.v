module ALU_Shifting (
	input [31:0] a,
	input [31:0] b,
	input SHR,
	input SHRA,
	input SHL,
	input ROR,
	input ROL,
	output reg [32:0] c
);

	reg [31:0] SHR_out;
	reg [31:0] SHRA_out;
	reg [31:0] SHL_out;
	reg [31:0] ROR_out;
	reg [31:0] ROL_out;

	always @(*) begin
		if (SHR) c = SHR_out;
		if (SHRA) c = SHRA_out;
		if (SHL) c = SHL_out;
		if (ROR) c = ROR_out;
		if (ROL) c = ROL_out;
		else c = 32'b0;
	end
	
	/* I sincerely apologize beforehand if this will be difficult to read but i will be providing a structural implementation
	since I am paranoid that we aren't allowed to use the << and >> operators, also it is pretty fun. --Jim
	*/
	
	//Shift Right
	always @(*) begin
		if (SHR) begin
			SHR_out = b;
			// shift 1 pos
			if (b[0]) begin
				SHR_out = {1'b0, b[31:1]};
			end
			// shift 2 pos
			if (b[1]) begin
				SHR_out = {2'b0, b[31:2]};
			end
			//shift 4 pos
			if (b[2]) begin
				SHR_out = {4'b0, b[31:4]};
			end
			//shift 8 pos
			if (b[3]) begin
				SHR_out = {8'b0, b[31:8]};
			end
			//shift 16 pos
			if (b[4]) begin
				SHR_out = {16'b0, b[31:16]};
			end
			//shift 32 pos, if any of the bits from bit 5 to 31 are 1
			if (b[31:5]) begin
				SHR_out = 32'b0;
			end
		end
	end
	
	//Shift Right Arithmetic (basically sign extend MSB)
	always @(*) begin
		if (SHRA) begin
			SHRA_out = b;
			// shift 1 pos
			if (b[0]) begin
				SHRA_out = {1'b0, b[31:1]};
			end
			// shift 2 pos
			if (b[1]) begin
				SHRA_out = {2'b0, b[31:2]};
			end
			//shift 4 pos
			if (b[2]) begin
				SHRA_out = {4'b0, b[31:4]};
			end
			//shift 8 pos
			if (b[3]) begin
				SHRA_out = {8'b0, b[31:8]};
			end
			//shift 16 pos
			if (b[4]) begin
				SHRA_out = {16'b0, b[31:16]};
			end
			//shift 32 pos, if any of the bits from bit 5 to 31 are 1
			if (b[31:5]) begin
				SHRA_out = 32'b0;
			end
		end
	end
	
	//Rotate Right
	always @(*) begin
		if (ROR) begin
			ROR_out = b;
			// shift 1 pos
			if (b[0]) begin
				ROR_out = {b[0], b[31:1]};
			end
			// shift 2 pos
			if (b[1]) begin
				ROR_out = {b[1:0], b[31:2]};
			end
			//shift 4 pos
			if (b[2]) begin
				ROR_out = {b[3:0], b[31:4]};
			end
			//shift 8 pos
			if (b[3]) begin
				ROR_out = {b[7:0], b[31:8]};
			end
			//shift 16 pos
			if (b[4]) begin
				ROR_out = {b[15:0], b[31:16]};
			end
			//anything after this rotates a multiple of 32 so there is essentially no difference
		end
	end
	
	//Shift Left
	always @(*) begin
		if (SHL) begin
			SHL_out = b;
			// shift 1 pos
			if (b[0]) begin
				SHL_out = {b[30:0],1'b0};
			end
			// shift 2 pos
			if (b[1]) begin
				SHL_out = {b[29:0],2'b0};
			end
			//shift 4 pos
			if (b[2]) begin
				SHL_out = {b[27:0],4'b0};
			end
			//shift 8 pos
			if (b[3]) begin
				SHL_out = {b[23:0],8'b0};
			end
			//shift 16 pos
			if (b[4]) begin
				SHL_out = {b[15:0],16'b0};
			end
			//shift 32 pos, if any of the bits from bit 5 to 31 are 1
			if (b[31:5]) begin
				SHL_out = 32'b0;
			end
		end
	end
	
	//Rotate Left
	always @(*) begin
		if (ROL) begin
			ROL_out = b;
			// shift 1 pos
			if (b[0]) begin
				ROL_out = {b[30:0],b[31]};
			end
			// shift 2 pos
			if (b[1]) begin
				ROL_out = {b[29:0],b[31:30]};
			end
			//shift 4 pos
			if (b[2]) begin
				ROL_out = {b[27:0],b[31:28]};
			end
			//shift 8 pos
			if (b[3]) begin
				ROL_out = {b[23:0],b[31:24]};
			end
			//shift 16 pos
			if (b[4]) begin
				ROL_out = {b[15:0],b[31:16]};
			end
			//anything after this rotates a multiple of 32 so there is essentially no difference
		end
	end

endmodule