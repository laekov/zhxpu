`timescale 1ns / 1ps
module if_id(
	input hold,
	input [15:0] pc_in,
	input clk,
	input pclk,
	input [15:0] inst_in,
	output reg [15:0] pc_out,
	output reg [15:0] inst_out
);
	always @(posedge clk or posedge pclk) begin
		if (pclk) begin
			inst_out <= inst_in;
		end else if (!hold) begin
			pc_out <= pc_in;
		end else begin
			pc_out <= 16'b0;
			inst_out <= 16'b0000100000000000;
		end
	end
endmodule
