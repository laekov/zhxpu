`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:47:00 11/08/2017 
// Design Name: 
// Module Name:    flash_controller
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
module flash_controller(
	input [`MemAddr] addr,

	input flash_work_done,
	input need_to_work,

	output reg flash_need_to_work,
	output reg work_done,
	output wire [`RegValue] done_pc_out
    );

	reg [`RegValue] done_pc;
	assign done_pc_out = done_pc;

	always @(*) begin
		if (need_to_work == 1'b1) begin
			if (flash_work_done == 1'b1) begin
				if (addr[15:0] == done_pc) begin
					work_done <= 1'b1;
					flash_need_to_work <= 1'b0;
				end
				else begin
					work_done <= 1'b0;
					flash_need_to_work <= 1'b1;
				end
			end
			else begin
				work_done <= 1'b0;
				flash_need_to_work <= 1'b1;
			end
		end
		else begin
			work_done <= 1'b0;
			flash_need_to_work <= 1'b0;
		end
	end

	always @(posedge flash_work_done) begin
		done_pc <= addr[15:0];
	end

endmodule
