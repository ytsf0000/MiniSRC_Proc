`timescale 1ns / 1ps

module SelectEncoderBlock_tb;
    reg [31:0] IR;
    reg Gra, Grb, Grc, Rin, Rout, BAout;
    wire [15:0] Rin_Sig, Rout_Sig;
    integer i;  // Loop variable

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
        Gra = 0; Grb = 0; Grc = 0; Rin = 0; Rout = 0; BAout = 0;
        IR = 32'b0;
        #10;

        // Iterate through all register values (R0 to R15)
        for (i = 0; i < 16; i = i + 1) begin
            // Reset signals
            Gra = 0; Grb = 0; Grc = 0; Rin = 0; Rout = 0;

            // Check Ra selection
            IR = i << 23;
            Gra = 1; Rin = 1; Rout = 1;
            #10;
            if (Rin_Sig == (1 << i) && Rout_Sig == (1 << i))
                $display("PASS: Ra selection successful for R%0d", i);
            else
                $display("FAIL: Ra selection incorrect for R%0d | Expected = %b, Got = %b", i, (1 << i), Rin_Sig);

            // Reset signals
            Gra = 0; Grb = 0; Grc = 0; Rin = 0; Rout = 0;

            // Check Rb selection
            IR = i << 19;
            Grb = 1; Rin = 1;
            #10;
            if (Rin_Sig == (1 << i))
                $display("PASS: Rb selection successful for R%0d", i);
            else
                $display("FAIL: Rb selection incorrect for R%0d | Expected = %b, Got = %b", i, (1 << i), Rin_Sig);

            // Reset signals
            Gra = 0; Grb = 0; Grc = 0; Rin = 0; Rout = 0;

            // Check Rc selection
            IR = i << 15;
            Grc = 1; Rin = 1;
            #10;
            if (Rin_Sig == (1 << i))
                $display("PASS: Rc selection successful for R%0d", i);
            else
                $display("FAIL: Rc selection incorrect for R%0d | Expected = %b, Got = %b", i, (1 << i), Rin_Sig);
        end

        $display("Test completed.");
        $finish;
    end
endmodule
