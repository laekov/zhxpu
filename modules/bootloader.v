`timescale 1ns / 1ps

`include "flash.v"

module bootloader(
	input clk,
	input next,
	output wire [15:0] data,
	output wire read_ctrl,
	output wire [22:1] caddr_out
);

	reg [22:1] caddr = 22'b0;
	assign caddr_out = caddr;
	reg read_c;
	assign read_ctrl = read_c;

	always @(posedge next) begin
		caddr <= caddr + 22'b1;
		read_c <= !read_c;
	end
endmodule

