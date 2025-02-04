module BusEncoder (
    input wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out,
    input wire R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
    input wire HIout, LOout, Zhighout, Zlowout, PCout, MDRout, In_Portout, Cout,
    output reg [4:0] select
);

always @(*) begin
    case (1'b1) // Check which input is active
        R0out:     out = 5'd0;
        R1out:     out = 5'd1;
        R2out:     out = 5'd2;
        R3out:     out = 5'd3;
        R4out:     out = 5'd4;
        R5out:     out = 5'd5;
        R6out:     out = 5'd6;
        R7out:     out = 5'd7;
        R8out:     out = 5'd8;
        R9out:     out = 5'd9;
        R10out:    out = 5'd10;
        R11out:    out = 5'd11;
        R12out:    out = 5'd12;
        R13out:    out = 5'd13;
        R14out:    out = 5'd14;
        R15out:    out = 5'd15;
        HIout:     out = 5'd16;
        LOout:     out = 5'd17;
        Zhighout:  out = 5'd18;
        Zlowout:   out = 5'd19;
        PCout:     out = 5'd20;
        MDRout:    out = 5'd21;
        In_Portout:out = 5'd22;
        Cout:      out = 5'd23;
        default:   out = 5'd0; // Default to 0
    endcase
end

endmodule
