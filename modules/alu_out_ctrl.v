`timescale 1ns / 1ps

// This module is not completed. RAM not supported

module alu_out_ctrl(
	input res[15:0],
	input flag,
	input memwr_ctrl,
	input memrd_ctrl,
	input mem_addr[17:0],
	output reg mem_read,
	output reg mem_addrl[17:0],
	output reg mem_datal[17:0],
	output reg res_out[15:0],
	output reg flag_out
);
	always @(*) begin
		if (mem_wr) begin
			mem_read <= 1'b0;
		end else if (mem_rd) begin
			mem_read <= 1'b1;
		end
		res_out <= res;
		flag_out <= flag;
	end
endmodule

