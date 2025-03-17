`timescale 1ns/10ps
module RAM_tb();


wire clck;
reg read,write;
reg [8:0]addr;
reg [31:0]data_in;
wire [31:0]data_out;


RAM ram_DUT(clck,read,write,addr,data_in,data_out);

assign clck=read || write;

initial begin
  addr=0;
  read=1;
  #10;
  read=0;
  if(data_out != 32'b0)
  begin
    $display("Initial value incorrect");
    $finish;
  end
  #10;

  data_in=86;
  write=1;
  #10;
  write=0;

  #10;

  read=1;
  #10;
  read=0;
  if(data_out!=86)
  begin
    $display("incorrect value stored");
    $finish;
  end
  #10;

  addr=511;
  data_in=2;
  write=1;
  #10;
  write=0;
  #10;
  
  
  read=1;
  #10;
  read=0;
  if(data_out!=2)
  begin
    $display("incorrect value stored");
    $finish;
  end

  addr=0; 
  read=1;
  #10;
  read=0;
  if(data_out!=86)
  begin
    $display("incorrect value stored");
    $finish;
  end

end

endmodule