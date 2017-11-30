`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:47:00 11/08/2017 
// Design Name: 
// Module Name:    ram_controller
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ram_controller(
	inout mem_rd,
	inout mem_wr,
	input [`MemAddr] addr,

	input ram1_work_done,
	input [`MemValue] ram1_feedback,
	input ram2_work_done,
	input [`MemValue] ram2_feedback,

	input [`RegValue] pc,

	output reg ram1_need_to_work,
	output reg ram2_need_to_work,
	output reg work_done,
	output reg [`MemValue] feedback,
	output wire [`RegValue] done_pc_out
    );

	reg [`RegValue] done_pc1;
	reg [`RegValue] done_pc2;
	assign done_pc_out = { done_pc1[7:0], done_pc2[7:0] };
	
	assign ram_work_done = ram1_work_done || ram2_work_done;

	always @(*) begin
		if (mem_rd == 1'b1 || mem_wr == 1'b1) begin
			if (addr[15:15] == 1'b1) begin
				if (ram1_work_done == 1'b1) begin
					if (pc == done_pc1) begin
						feedback <= ram1_feedback;
						work_done <= 1'b1;
						ram1_need_to_work <= 1'b0;
						ram2_need_to_work <= 1'b0;
					end else begin
						work_done <= 1'b0;
						ram1_need_to_work <= 1'b1;
						ram2_need_to_work <= 1'b0;
					end
				end
				else begin
					work_done <= 1'b0;
					ram1_need_to_work <= 1'b1;
					ram2_need_to_work <= 1'b0;
				end
			end
			else begin
				if (ram2_work_done == 1'b1) begin
					if (pc == done_pc2) begin
						feedback <= ram2_feedback;
						work_done <= 1'b1;
						ram1_need_to_work <= 1'b0;
						ram2_need_to_work <= 1'b0;
					end else begin
						work_done <= 1'b0;
						ram1_need_to_work <= 1'b0;
						ram2_need_to_work <= 1'b1;
					end
				end
				else begin
					work_done <= 1'b0;
					ram1_need_to_work <= 1'b0;
					ram2_need_to_work <= 1'b1;
				end
			end
		end
		else begin
			ram1_need_to_work <= 1'b0;
			ram2_need_to_work <= 1'b0;
			work_done <= 1'b1;
		end
	end

	always @(posedge ram1_work_done) begin
		done_pc1 <= pc;
	end
	always @(posedge ram2_work_done) begin
		done_pc2 <= pc;
	end

endmodule


