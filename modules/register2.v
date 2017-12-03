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

	input alu_writable,
	input [`RegAddr] alu_write_addr,
	input [`RegValue] alu_write_value,

	input readable1,
	input [`RegAddr] read_addr1,
	output reg [`RegValue] read_value1,

	input readable2,
	input [`RegAddr] read_addr2,
	output reg [`RegValue] read_value2,

	input RA_writable,
	input [`RegValue] RA_value,

	output wire [255:0] debug_out
    );

	reg [`RegValue] reg0;
	reg [`RegValue] reg1;
	reg [`RegValue] reg2;
	reg [`RegValue] reg3;
	reg [`RegValue] reg4;
	reg [`RegValue] reg5;
	reg [`RegValue] reg6;
	reg [`RegValue] reg7;
	reg [`RegValue] reg8;
	reg [`RegValue] reg9;
	reg [`RegValue] reg10;
	reg [`RegValue] reg11;
	reg [`RegValue] reg12;
	reg [`RegValue] reg13;
	reg [`RegValue] reg14;
	reg [`RegValue] reg15;

	//assign debug_out = { regs[1][3:0], regs[2][3:0], regs[3][3:0], regs[4][3:0] };
	assign debug_out = { reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15 };

	always @(clk) begin	
		if ((writable == `Writeable) && (write_addr != `ZeroReg)) begin
			case (write_addr)
				4'b0000: begin reg0 <= write_value; end
				4'b0001: begin reg1 <= write_value; end
				4'b0010: begin reg2 <= write_value; end
				4'b0011: begin reg3 <= write_value; end
				4'b0100: begin reg4 <= write_value; end
				4'b0101: begin reg5 <= write_value; end
				4'b0110: begin reg6 <= write_value; end
				4'b0111: begin reg7 <= write_value; end
				4'b1000: begin reg8 <= write_value; end
				4'b1001: begin reg9 <= write_value; end
				4'b1010: begin reg10 <= write_value; end
				4'b1011: begin reg11 <= write_value; end
				4'b1100: begin reg12 <= write_value; end
				4'b1110: begin reg14 <= write_value; end
				4'b1111: begin reg15 <= write_value; end
			endcase
		end
	end

	always @(*) begin
		if (RA_writable == `Writeable) begin
			reg13 <= RA_value;
		end
	end

	//always @(write_addr, write_value, readable1, readable2, read_addr1, read_addr2) begin
	always @(*) begin
		if (alu_writable && (alu_write_addr == read_addr1)) begin
			read_value1 <= alu_write_value;
		end else if (writable && (write_addr == read_addr1)) begin
			read_value1 <= write_value;
		end else begin
			case (read_addr1)
				4'b0000: begin read_value1 <= reg0; end
				4'b0001: begin read_value1 <= reg1; end
				4'b0010: begin read_value1 <= reg2; end
				4'b0011: begin read_value1 <= reg3; end
				4'b0100: begin read_value1 <= reg4; end
				4'b0101: begin read_value1 <= reg5; end
				4'b0110: begin read_value1 <= reg6; end
				4'b0111: begin read_value1 <= reg7; end
				4'b1000: begin read_value1 <= reg8; end
				4'b1001: begin read_value1 <= reg9; end
				4'b1010: begin read_value1 <= reg10; end
				4'b1011: begin read_value1 <= reg11; end
				4'b1100: begin read_value1 <= reg12; end
				4'b1101: begin read_value1 <= reg13; end
				4'b1110: begin read_value1 <= reg14; end
				4'b1111: begin read_value1 <= reg15; end
			endcase
		end
	end

	always @(*) begin
		if (alu_writable && (alu_write_addr == read_addr2)) begin
			read_value2 <= alu_write_value;
		end else if (writable && (write_addr == read_addr2)) begin
			read_value2 <= write_value;
		end else begin
			case (read_addr2)
				4'b0000: begin read_value2 <= reg0; end
				4'b0001: begin read_value2 <= reg1; end
				4'b0010: begin read_value2 <= reg2; end
				4'b0011: begin read_value2 <= reg3; end
				4'b0100: begin read_value2 <= reg4; end
				4'b0101: begin read_value2 <= reg5; end
				4'b0110: begin read_value2 <= reg6; end
				4'b0111: begin read_value2 <= reg7; end
				4'b1000: begin read_value2 <= reg8; end
				4'b1001: begin read_value2 <= reg9; end
				4'b1010: begin read_value2 <= reg10; end
				4'b1011: begin read_value2 <= reg11; end
				4'b1100: begin read_value2 <= reg12; end
				4'b1101: begin read_value2 <= reg13; end
				4'b1110: begin read_value2 <= reg14; end
				4'b1111: begin read_value2 <= reg15; end
			endcase
		end
	end

endmodule

