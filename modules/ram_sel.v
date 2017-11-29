`timescale 1ns / 1ps

`include "define.v"

module ram_sel(
	input initializing,
	input [`RegValue] init_addr,
	input [`RegValue] init_data,
	input [`RegValue] exe_addr,
	input [`RegValue] exe_data,
	input [`RegValue] exe_pc,
	output wire [`RegValue] addr_out,
	output wire [`RegValue] data_out,
	output wire [`RegValue] pc_out
);
	assign addr_out = initializing ? init_addr : exe_addr;
	assign data_out = initializing ? init_data : exe_data;
	assign pc_out = initializing ? init_addr : exe_pc;
endmodule

