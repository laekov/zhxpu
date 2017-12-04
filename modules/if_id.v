`timescale 1ns / 1ps
module if_id(
	input hold,
	input flush,
	input [15:0] pc_in,
	input clk,
	input pclk,
	input [15:0] inst_in,
	output reg [15:0] pc_out,
	output reg [15:0] inst_out
);

	always @(posedge clk) begin
		if (hold == 1'b1) begin
			inst_out <= inst_out;
			pc_out <= pc_out;
		end else begin
			inst_out <= inst_in;
			pc_out <= pc_in;
		end
	end
endmodule
