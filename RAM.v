module RAM #(parameter DATA_WIDTH = 32, ADDRESS_WIDTH = 9,MEM_SIZE=512)(
	input Clock,
	input read, write,
	input [ADDRESS_WIDTH-1:0] address,
	input [DATA_WIDTH-1:0] data_in,
	output reg [DATA_WIDTH-1:0]data_out
);


	reg [DATA_WIDTH-1:0] q;
	initial q=0;

	wire [DATA_WIDTH-1:0]words[MEM_SIZE-1:0];
	reg wordEnableReg[MEM_SIZE-1:0];

	genvar i;
	generate
		for(i=0;i<MEM_SIZE;i=i+1)
		begin : gen_module
			Register reg_module(
				1'b0,!Clock,wordEnableReg[i],
				data_in,
				words[i]
			);
		end
	endgenerate

	integer j;
	always @ (*)
	begin

			for(j=0;j<(1<<ADDRESS_WIDTH);j=j+1)
			begin
				wordEnableReg[j]=(write && j[ADDRESS_WIDTH-1:0] == address);
			end

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
