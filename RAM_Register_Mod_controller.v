module RAM_Register_Mod_controller #(parameter DATA_WIDTH = 32, ADDRESS_WIDTH = 9, MEM_SIZE=512)(
	input read, write,
	input [DATA_WIDTH-1:0] data_in,
	input [ADDRESS_WIDTH-1:0] address,
	input doneSignal[MEM_SIZE-1:0],
	output reg [DATA_WIDTH-1:0]data_out,
	output reg wordEnable[MEM_SIZE-1:0],
  output reg complete
)

initial data_out={(DATA_WIDTH-1){0}};

always @(posedge read or posedge write or address)
begin
  complete=0;
end

integer i;
always @(doneSignal)
begin
  for(i=0;i<(1<<ADDRESS_WIDTH);i=i+1)
  begin
    begin
      data_out = words[i];
    end
    wordEnable[i]=0;
  end
  complete=1;
end

endmodule
