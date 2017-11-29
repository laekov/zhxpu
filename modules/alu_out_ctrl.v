`timescale 1ns / 1ps

// This module is not completed. RAM not supported

module alu_out_ctrl(
	input [15:0] res,
	input flag,
	input memwr_ctrl,
	input memrd_ctrl,
	input [17:0] mem_addr,
	input [15:0] mem_res,
	output reg [17:0] mem_addrl,
	output reg [17:0] mem_datal,
	output reg [15:0] res_out,
	output reg flag_out
);
	always @(*) begin
		if (memwr_ctrl) begin
			res_out <= res;
		end else if (memrd_ctrl) begin
			res_out <= mem_res;
		end else begin
			res_out <= res;
		end
		flag_out <= flag;
	end
endmodule

