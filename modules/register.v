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
	output reg [`RegValue] read_value1,

	input readable2,
	input [`RegAddr] read_addr2,
	output reg [`RegValue] read_value2,

	output wire [`RegValue] debug_out
    );

	reg [`RegValue] reg0;
	reg [`RegValue] reg1;
	reg [`RegValue] reg2;
	reg [`RegValue] reg3;
	reg [`RegValue] reg4;
	reg [`RegValue] reg5;
	reg [`RegValue] reg6;
	reg [`RegValue] reg7;

	//assign debug_out = { regs[1][3:0], regs[2][3:0], regs[3][3:0], regs[4][3:0] };
	assign debug_out = reg1;

	always @(negedge writable) begin	
		if ((writable == `Writeable) && (write_addr != `ZeroReg)) begin
			case (write_addr)
				3'b001: begin reg1 <= write_value; end
				3'b010: begin reg2 <= write_value; end
				3'b011: begin reg3 <= write_value; end
				3'b100: begin reg4 <= write_value; end
				3'b101: begin reg5 <= write_value; end
				3'b110: begin reg6 <= write_value; end
				3'b111: begin reg7 <= write_value; end
			endcase
		end
	end

	//always @(write_addr, write_value, readable1, readable2, read_addr1, read_addr2) begin
	always @(*) begin
		if (writable && (write_addr == read_addr1)) begin
			read_value1 <= write_value;
		end else begin
			case (read_addr1)
				3'b001: begin read_value1 <= reg1; end
				3'b010: begin read_value1 <= reg2; end
				3'b011: begin read_value1 <= reg3; end
				3'b100: begin read_value1 <= reg4; end
				3'b101: begin read_value1 <= reg5; end
				3'b110: begin read_value1 <= reg6; end
				3'b111: begin read_value1 <= reg7; end
			endcase
		end
	end

	always @(*) begin
		if (writable && (write_addr == read_addr2)) begin
			read_value2 <= write_value;
		end else begin
			case (read_addr2)
				3'b001: begin read_value2 <= reg1; end
				3'b010: begin read_value2 <= reg2; end
				3'b011: begin read_value2 <= reg3; end
				3'b100: begin read_value2 <= reg4; end
				3'b101: begin read_value2 <= reg5; end
				3'b110: begin read_value2 <= reg6; end
				3'b111: begin read_value2 <= reg7; end
			endcase
		end
	end

endmodule

