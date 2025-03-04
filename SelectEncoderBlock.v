module SelectEncoderBlock(
    output [15:0]Rin_Sig, Rout_Sig,
    input [31:0] IR,
    input Gra, Grb, Grc, Rin, Rout, BAout

);

    wire [3:0] Ra,Rb,Rc, Ra_sel, Rb_sel, Rc_sel;
    wire [3:0] decoderIn;
    wire [15:0] decoderOut;

    //Assigning of Ra, Rb, Rc:
    assign Ra = IR[26:23];
    assign Rb = IR[22:19];
    assign Rc = IR[18:15];

    //Bitwise AND of Ra, Rb, Rc w/ their respective Gr:
    assign Ra_sel = Ra & {4{Gra}};
    assign Rb_sel = Rb & {4{Grb}};
    assign Rc_sel = Rc & {4{Grc}};

    //OR all select vals then put in decoder:
    assign decoderIn = Ra_sel | Rb_sel | Rc_sel;

    // 4-to-16 Decoder
    Decoder4to16 decoder (
        .out(decoderOut),
        .in(decoderIn)
    );

    //Generate Rin & Rout Signals:
    assign Rin_Sig = decoderOut & {16{Rin}};
    assign Rout_Sig = decoderOut & {16{Rout & BAout}};

endmodule

module Decoder4to16(
    output reg [15:0] out,  // 16-bit one-hot output
    input [3:0] in          // 4-bit input address
);

    always @(*) begin
        out = 16'b1 << in;  // One-hot encoding: Shift 1 by `in` positions
    end

endmodule
