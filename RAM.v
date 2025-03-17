module RAM #(parameter DATA_WIDTH = 32, ADDRESS_WIDTH = 9,MEM_SIZE=512)(
	input Clock,
	input read, write,
	input [ADDRESS_WIDTH-1:0] address,
	input [DATA_WIDTH-1:0] data_in,
	output reg [DATA_WIDTH-1:0]data_out
);

reg readLatch,writeLatch;
reg [ADDRESS_WIDTH-1:0]addressLatch;
reg [DATA_WIDTH-1:0] dataLatch;

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
			dataLatch,
			words[i]
		);
	end
endgenerate



integer j;
always @ (*)
begin
		readLatch=read;
		writeLatch=write;
		dataLatch=data_in;

		for(j=0;j<(1<<ADDRESS_WIDTH);j=j+1)
		begin
			wordEnableReg[j]=(writeLatch && j[ADDRESS_WIDTH-1:0] == addressLatch);
		end

		if(1)
		begin
			for(j=0;j<(1<<ADDRESS_WIDTH);j=j+1)
			begin
				if(j[ADDRESS_WIDTH-1:0] == addressLatch && readLatch)
				begin
			      data_out = words[j];
				end
			end
		end

		readLatch=0;
		writeLatch=0;
end
endmodule
