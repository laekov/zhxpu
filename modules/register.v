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
	output [`RegValue] read_value1,

	input readble2,
	input [`RegAddr] read_addr2,
	output [`RegValue] read_value2
    );

	reg [`RegValue] regs[0:15];

	always @(posedge clk) begin
		if (rst != `Reseting) begin
			if ((writable == `Writeable) && (write_addr != `ZeroReg)) begin
				regs[write_addr] <= write_value;
			end
		end
	end

	always @(*) begin
		if (rst == `Reseting) begin
			read_value1 <= `ZeroValue;
		end
		else if (readble1 == `Readable) begin
			if (read_addr1 == `ZeroReg) begin
				read_value1 <= `ZeroValue;
			end
			else if ((read_addr1 == write_addr) && (writable == `Writeable)) begin
				read_value1 <= write_value;
			end
			else begin
				read_value1 <= regs[read_addr1];
			end
		end
		else  begin
			read_value1 <= `ZeroValue;
		end
	end

	always @(*) begin
		if (rst == `Reseting) begin
			read_value2 <= `ZeroValue;
		end
		else if (readble2 == `Readable) begin
			if (read_addr2 == `ZeroReg) begin
				read_value2 <= `ZeroValue;
			end
			else if ((read_addr2 == write_addr) && (writable == `Writeable)) begin
				read_value2 <= write_value;
			end
			else begin
				read_value2 <= regs[read_addr1];
			end
		end
		else  begin
			read_value2 <= `ZeroValue;
		end
	end


endmodule

