`timescale 1ns / 1ps

// This module is not completed. RAM not supported

module alu_out_ctrl(
	input [15:0] res,
	input flag,
	input memwr_ctrl,
	input memrd_ctrl,
	input [17:0] mem_addr,
	output reg mem_read,
	output reg [17:0] mem_addrl,
	output reg [17:0] mem_datal,
	output reg [15:0] res_out,
	output reg flag_out
);
	always @(*) begin
		if (memwr_ctrl) begin
			mem_read <= 1'b0;
		end else if (memrd_ctrl) begin
			mem_read <= 1'b1;
		end
		res_out <= res;
		flag_out <= flag;
	end
endmodule

