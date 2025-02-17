module Div (
    input  [31:0] a,
    input  [31:0] b,
    output reg [31:0] q,
    output reg [31:0] r
);

   reg sign_a;
	reg sign_b;
   reg [31:0] abs_a, abs_b;
   reg [31:0] unsigned_q, unsigned_r;
   reg [31:0] r_temp, a_shift;
   integer i;

   always @(*) begin
       // handle division by zero
       if (!b) begin
           q  = 32'hFFFFFFFF;
           r = 32'hFFFFFFFF;
       end else begin
           // sign of divisor, dividend
           sign_a = a[31];
           sign_b = b[31];

           // find absolute values
           abs_a = sign_a ? (~a + 1) : a;
           abs_b = sign_b  ? (~b + 1) : b;

           // Initialize q and r
           unsigned_q = 0;
           unsigned_r = 0;
           r_temp = 0;
           a_shift = abs_a;

           // Non-restoring division algorithm
           for (i = 31; i >= 0; i = i - 1) begin
               r_temp = {r_temp[30:0], a_shift[31]};
               a_shift = {a_shift[30:0], 1'b0};
					if (r_temp >= abs_b) begin
                   r_temp = r_temp - abs_b;
                   unsigned_q[i] = 1'b1;
               end
           end

           // Assign final values
           unsigned_r = r_temp;

           // Restore signs
           q = (sign_a ^ sign_b) ? (~unsigned_q + 1) : unsigned_q;
           r = sign_a ? (~unsigned_r + 1) : unsigned_r;
       end
   end

endmodule