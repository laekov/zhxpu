`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:01:?? 11/21/1900
// Design Name: 
// Module Name:    stall_ctrl
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
`include "define.v"

module stall_ctrl(
	input clk,
	input rst,
	input mem_op,
	input mem_done,
	input initializing,
	input inst_read_done,
	output wire hold
);

	reg hold_in;
	// assign hold = hold_in;
    assign hold = !rst || initializing || (mem_op && !mem_done) || !inst_read_done;

	always @(negedge clk or negedge rst) begin
		if (!rst) begin
			hold_in <= 1'b1;
		end else begin
			hold_in <= initializing || (mem_op && !mem_done) || !inst_read_done;
		end
	end
endmodule
