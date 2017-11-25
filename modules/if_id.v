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
	always @(posedge clk or posedge flush) begin
		if (flush) begin
			inst_out <= 16'b0000100000000000;
			pc_out <= 16'b0;
		end else begin
			if (hold) begin
				inst_out <= 16'b0000100000000000;
				pc_out <= 16'b0;
			end else begin
				inst_out <= inst_in;
				pc_out <= pc_in;
			end
		end
	end
endmodule
