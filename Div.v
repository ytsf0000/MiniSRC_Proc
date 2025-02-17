module Div (
    input  [31:0] a,
    input  [31:0] b,
    output reg [31:0] quotient,
    output reg [31:0] remainder
);

	wire [31:0] signed_q, signed_r;
   wire [31:0] abs_a, abs_b;
   reg [31:0] unsigned_q, unsigned_r;
   reg [32:0] r_temp;
   integer i;
	
	Complement_32B sign_q(.enable(a[31] ^ b[31]), .in(unsigned_q), .out(signed_q));
	Complement_32B sign_r(.enable(a[31]), .in(unsigned_r), .out(signed_r));
	Complement_32B unsign_a(.enable(a[31]), .in(a), .out(abs_a));
	Complement_32B unsign_b(.enable(b[31]), .in(b), .out(abs_b));
	
   always @(*) begin
       // handle division by zero
       if (!b) begin
           quotient  = 32'hFFFFFFFF;
           remainder = 32'hFFFFFFFF;
       end else begin
           // Initialize q and r
           unsigned_q = abs_a;
           unsigned_r = 32'b0;
           r_temp = 33'b0;

           // Non-restoring division algorithm
           for (i = 31; i >= 0; i = i - 1) begin
					r_temp = {r_temp[31:0], unsigned_q[31]};
					if(~r_temp[32]) begin
						r_temp = r_temp - abs_b;
					end
					else begin
						r_temp = r_temp + abs_b;
					end
					unsigned_q = {unsigned_q[30:0], (~r_temp[32]) ? 1'b1 : 1'b0};
           end
			  
			  if (r_temp[32])
					r_temp = r_temp + abs_b;

           // Assign final values
           unsigned_r = r_temp[31:0];
			  quotient = signed_q;
			  remainder = signed_r;
       end
   end

endmodule