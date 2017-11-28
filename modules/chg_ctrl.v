`timescale 1ns / 1ps

module chg_ctrl(
	input [33:0] inss,
	output wire outs
);
	reg next_status = 1'b0;
	always @(inss) begin
		next_status <= !next_status;
	end
	assign outs = next_status;
endmodule
