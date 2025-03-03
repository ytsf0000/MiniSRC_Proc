module Register_r0(
    output [31:0] BusMuxInR0,
    input [31:0] BusMuxOut,
    input clr, clk, enable, BAout
);

reg [31:0] q;

always @ (posedge clk)
    begin
        if (clr) begin
            q <= 32'b0;
        end
        else if(enable)
            q <= BusMuxOut;
    end

assign BusMuxInR0 = q & {32{~BAout}};

endmodule


