`timescale 1ns / 1ps
`include "define.v"
// A version for demonstration 
module inst_mem_ctrl(
	input [`RegValue]addr,
	output reg [`RegValue] data,

	output reg ram_need_to_work,

	input ram_work_done,
	input ram_feed_back
	);

	reg [`RegValue] done_pc;

	always @(*) begin
		if (ram_work_done == 1'b1) begin
			if (addr == done_pc) begin
				data <= ram_feed_back;
				ram_need_to_work <= 1'b0;
			end
			else begin
				ram_need_to_work <= 1'b1;
				data <= 16'h0800;
			end
		end
		else begin
			ram_need_to_work <= 1'b1;
			data <= 16'h0800;
		end
	end

	always @(posedge ram_work_done) begin
		done_pc <= addr;
	end
endmodule
