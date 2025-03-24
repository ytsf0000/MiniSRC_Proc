module RAM #(parameter DATA_WIDTH = 32, ADDRESS_WIDTH = 9,MEM_SIZE=512)(
	input read, write,
	input [ADDRESS_WIDTH-1:0] address,
	input [DATA_WIDTH-1:0] data_in,
	output reg [DATA_WIDTH-1:0]data_out
);


	// loading memory file
	reg [DATA_WIDTH-1:0]MEMORY[MEM_SIZE-1:0];
	initial begin
		$readmemh("C:\\Users\\Jim\\Desktop\\MIPS_Proc\\output.mem", MEMORY);
	end

	integer j;
	always @ (*)
	begin
			for(j=0;j<(1<<ADDRESS_WIDTH);j=j+1)
			begin
				if(write && j[ADDRESS_WIDTH-1:0] == address)
					MEMORY[j]=data_in;
			end

			if(read)
			begin
				for(j=0;j<(1<<ADDRESS_WIDTH);j=j+1)
				begin
					if(j[ADDRESS_WIDTH-1:0] == address)
					begin
						data_out = MEMORY[j];
					end
				end
			end
	end
endmodule
