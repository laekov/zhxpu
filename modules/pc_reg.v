`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:19:51 11/13/2017 
// Design Name: 
// Module Name:    pc_reg 
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
module pc_reg(
		input clk,
		input rst,
		input hold,
		input set_pc,
		input [15:0] set_pc_addr,
		input pc_enabled,
		output reg [`RegValue] pc,
		output reg [`ActBit] pc_hold_cnt = 0
    );

	initial pc = 16'b0;

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			pc <= 16'b0;
		end else if (hold === 1'b0) begin
			if (set_pc) begin
				pc <= set_pc_addr;
			end else  begin
				pc <= pc + 1;
			end
		end else begin
			pc <= pc;
			pc_hold_cnt <= pc_hold_cnt + 1;
		end
	end

endmodule
