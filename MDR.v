module MDR #(parameter DATA_WIDTH_IN = 32, DATA_WIDTH_OUT = 32, INIT = 32'h0)(
    input clear, clock, MDRin,
    input [31:0] BusMuxOut, input [31:0] Mdatain,
    input read
);

//Input Register value (D)
reg [31:0]d;
//Mux
always @ (*) begin
    if(~read) begin
        d <= BusMuxOut;
    end
    else begin
        d <= Mdatain;
    end
end  

//Output Register Value (Q)
reg[31:0]q;
always @ (posedge clock) begin
    if (clear) begin
        q <= {DATA_WIDTH_IN{1'b0}};
    end
    else if (MDRin) begin
        q <= d;
    end
end
endmodule 