module RAM #(parameter DATA_WIDTH = 32, ADDRESS_WIDTH = 9,MEM_SIZE=512)(
	input read, write,
	input [ADDRESS_WIDTH-1:0] address,
	input [DATA_WIDTH-1:0] data_in,
	output reg [DATA_WIDTH-1:0]data_out
);


	reg [DATA_WIDTH-1:0] q;
	initial q=0;

	wire [DATA_WIDTH-1:0]words[MEM_SIZE-1:0];
	reg wordEnableReg[MEM_SIZE-1:0];

	reg [DATA_WIDTH-1:0]registers_in;
	reg flush;
	genvar i;
	generate
		for(i=0;i<MEM_SIZE;i=i+1)
		begin : gen_module
			Register reg_module(
				1'b0,flush,wordEnableReg[i],
				registers_in,
				words[i]
			);
		end
	endgenerate

	// loading memory file
	integer m;
	reg [DATA_WIDTH-1:0]LOADED_MEMORY[511:0];
	initial begin
		$readmemh("C:\\Users\\antoi\\Documents\\school\\MIPS_Proc\\output.mem", LOADED_MEMORY);
		for(m=0;m<511;m=m+1)
		begin
			flush=0;
			registers_in=LOADED_MEMORY[m];
			flush=1;
			flush=0;
		end
	end

	integer j;
	always @ (*)
	begin
			flush=0;
			registers_in=data_in;
			for(j=0;j<(1<<ADDRESS_WIDTH);j=j+1)
			begin
				wordEnableReg[j]=(write && j[ADDRESS_WIDTH-1:0] == address);
			end
			flush=1;
			flush=0;

			if(read)
			begin
				for(j=0;j<(1<<ADDRESS_WIDTH);j=j+1)
				begin
					if(j[ADDRESS_WIDTH-1:0] == address)
					begin
						data_out = words[j];
					end
				end
			end
	end
endmodule
