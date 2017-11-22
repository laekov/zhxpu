`timescale 1ns / 1ps
module if_id(
	input hold,
	input [15:0] pc_in,
	input clk,
	input [15:0] inst_in,
	output [15:0] pc_out,
	output [15:0] inst_out,
);
	always @(posedge clk) begin
		if (!hold) begin
			pc_out <= pc_in;
			inst_out <= inst_in;
		end else begin
			pc_out <= 16'b0;
			inst_out <= 16'b0000100000000000;
		end
	end
endmodule
