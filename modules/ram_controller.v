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
	inout [`MemAddr] addr,
	inout [`MemValue] data,

	input ram_work_done,
	input [`MemValue] ram_feedback,

	output reg ram_need_to_work,
	output reg work_done,
	output reg [`MemValue] feedback
    );

	always @(*) begin
		if (mem_rd == 1'b1 || mem_wr == 1'b1) begin
			if (ram_work_done == 1'b1) begin
				feedback <= ram_feedback;
				work_done <= 1'b1;
				ram_need_to_work <= 1'b0;
			end
			else begin
				work_done <= 1'b0;
				ram_need_to_work <= 1'b1;
			end
		end
		else begin
			ram_need_to_work <= 1'b0;
		end
	end



endmodule


