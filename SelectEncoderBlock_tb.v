`timescale 1ns / 1ps

module SelectEncoderBlock_tb;
    reg [31:0] IR;
    reg Gra, Grb, Grc, Rin, Rout, BAout;
    wire [15:0] Rin_Sig, Rout_Sig;
    reg [3:0] i;  // Register to store loop variable

    // Instantiate the SelectEncoderBlock module
    SelectEncoderBlock uut (
        .Rin_Sig(Rin_Sig),
        .Rout_Sig(Rout_Sig),
        .IR(IR),
        .Gra(Gra),
        .Grb(Grb),
        .Grc(Grc),
        .Rin(Rin),
        .Rout(Rout),
        .BAout(BAout)
    );

    initial begin
        $display("Testing SelectEncoderBlock...");
        $monitor("Time = %0t | IR = %h | Rin_Sig = %b | Rout_Sig = %b", $time, IR, Rin_Sig, Rout_Sig);

        // Initialize signals
        Gra = 0; Grb = 0; Grc = 0; Rin = 0; Rout = 0; BAout = 1;
        IR = 32'b0;
        #10;

        // Iterate through all register values (R0 to R15)
        for (i = 0; i < 16; i = i + 1) begin
            // Check Ra selection
            IR = i << 23;
            Gra = 1; Grb = 0; Grc = 0; Rin = 1; Rout = 1;
            #10;

            // Check Rb selection
            IR = i << 19;
            Gra = 0; Grb = 1; Grc = 0;
            #10;

            // Check Rc selection
            IR = i << 15;
            Gra = 0; Grb = 0; Grc = 1;
            #10;
        end

        $display("Test completed.");
        $finish;
    end
endmodule
