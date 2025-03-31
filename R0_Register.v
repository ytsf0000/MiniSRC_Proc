module Register_r0(
    output [31:0] BusMuxInR0,
    input [31:0] BusMuxOut,
    input Clear, Clock, Enable, BAout
);

reg [31:0] q;

initial begin q <= 32'b0; end

always @ (posedge Clock)
    begin
        if (Clear) begin
            q <= 32'b0;
        end
        else if(Enable)
            q <= BusMuxOut;
    end

assign BusMuxInR0 = q & {32{~BAout}};

endmodule


