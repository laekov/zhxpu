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
		input read_done,
		output reg [`RegValue] pc
    );

	reg [`RegValue] new_pc;

	always @(*) begin
		new_pc <= pc + 16'b1;
	end

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			pc <= 16'b0;
		end else if (!hold) begin
			if (set_pc) begin
				pc <= set_pc_addr + 16'b1;
			end else if (read_done) begin
				pc <= new_pc;
			end
		end
	end

endmodule
