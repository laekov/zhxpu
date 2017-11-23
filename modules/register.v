`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:01:?? 11/21/1900
// Design Name: 
// Module Name:    register
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

module register(
	input clk,
	input rst,

	input writable,
	input [`RegAddr] write_addr,
	input [`RegValue] write_value,

	input readable1,
	input [`RegAddr] read_addr1,
	output wire [`RegValue] read_value1,

	input readable2,
	input [`RegAddr] read_addr2,
	output wire [`RegValue] read_value2
    );

	reg [`RegValue] regs[0:15];

	assign read_value1 =  ((read_addr1 == write_addr) && (writable == `Writeable)) ? write_value : regs[read_addr1];

	assign read_value2 =  ((read_addr2 == write_addr) && (writable == `Writeable)) ? write_value : regs[read_addr2];

	always @(posedge writable) begin	
		if ((writable == `Writeable) && (write_addr != `ZeroReg)) begin
			regs[write_addr] <= write_value;
		end
	end

endmodule

