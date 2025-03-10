module RAM #(parameter DATA_WIDTH = 32, ADDRESS_WIDTH = 9,MEM_SIZE=512)(
	input Clock,
	input read, write,
	input [ADDRESS_WIDTH-1:0] address,
	input [DATA_WIDTH-1:0] data_in,
	output [DATA_WIDTH-1:0]data_out,
	output complete
);

reg readLatch,writeLatch;
reg [ADDRESS_WIDTH-1:0]addressLatch;
reg [DATA_WIDTH-1:0] dataLatch;

reg [DATA_WIDTH-1:0] q;
initial q={DATA_WIDTH{0}};


wire [DATA_WIDTH-1:0]words[MEM_SIZE-1:0];
wire wordEnable[MEM_SIZE-1:0];
reg wordEnableReg[MEM_SIZE-1:0];
assign wordEnable = wordEnableReg;

reg regModComplete[MEM_SIZE-1:0];
genvar i;
generate
	for(i=0;i<MEM_SIZE;i=i+1)
	begin
		Register reg_module(
			1'b0,!Clock,wordEnable[i],
			dataLatch,
			words[i]
		);
	end
endgenerate


RAM_Register_Mod_controller #(DATA_WIDTH,ADDRESS_WIDTH,MEM_SIZE) controller(readLatch,writeLatch,dataLatch,addressLatch,regModComplete,data_out,wordEnable,complete);

integer j;
always @ (posedge read or posedge write)
begin
	if(!complete)
	begin
		readLatch<=read;
		writeLatch<=write;
		dataLatch<=data_in;

		for(j=0;j<(1<<ADDRESS_WIDTH);j=j+1)
		begin
			wordEnableReg[j]=(writeLatch && j[ADDRESS_WIDTH-1:0] == addressLatch)
		end

		// wait for memory to stabilize, current register module structure has no complete signal so it is simulated
		if(1)
		begin
			for(j=0;j<(1<<ADDRESS_WIDTH);j=j+1)
			begin
				if(j[ADDRESS_WIDTH-1:0] == addressLatch)
				begin
					regModComplete[j]=1;
					#1
					regModComplete[j]=0;
				end
			end
		end

		readLatch=0;
		writeLatch=0;
	end

end
endmodule
