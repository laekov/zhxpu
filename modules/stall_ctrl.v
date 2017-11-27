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
	input mem_op,
	output wire hold
);

	assign hold = mem_op;

endmodule
