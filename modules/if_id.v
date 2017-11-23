`timescale 1ns / 1ps
module if_id(
	input hold,
	input [15:0] pc_in,
	input clk,
	input pclk,
	input [15:0] inst_in,
	output reg [15:0] pc_out,
	output reg [15:0] inst_out,
	output reg readable1,
	output reg readable2
);
	always @(posedge clk or posedge pclk) begin
		if (pclk) begin
			readable1 <= 1'b0;
			readable2 <= 1'b0;
		end else if (!hold) begin
			pc_out <= pc_in;
			inst_out <= inst_in;
			readable1 <= 1'b1;
			readable2 <= 1'b1;
		end else begin
			pc_out <= 16'b0;
			inst_out <= 16'b0000100000000000;
		end
	end
endmodule
