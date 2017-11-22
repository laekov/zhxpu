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
module pc_reg(
		input clk,
		inout rst,
		output [`RegValue] pc
    );

	always @(posedge clk) begin
		if (rst == `Reseting) begin
			pc <= `ZeroValue;
		end
		else begin
			pc <= pc + `SizePerIns;
		end
	end


endmodule
