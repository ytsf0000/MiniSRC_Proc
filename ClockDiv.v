module ClockDiv(
	input in_clock,
	output reg out_clock
);

	initial begin out_clock = 0; end

	always @(posedge in_clock) begin
		out_clock <= ~out_clock;
	end

endmodule