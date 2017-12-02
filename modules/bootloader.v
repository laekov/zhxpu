`timescale 1ns / 1ps

`include "define.v"

module bootloader(
	input clk,
	input rst,
	input wire work_done,
	input wire [15:0] flash_data,

	output reg need_to_work,
	output reg [`MemValue] data,
	output wire read_ctrl,

	output wire [22:1] caddr_out,
	output reg write_ctrl,

	output wire boot_done_out,
	output [`MemAddr] maddr_out
);

	reg [22:1] caddr = 22'b0;
	assign caddr_out = caddr;
	reg read_c = 1'b0;
	assign read_ctrl = read_c;
	reg [`MemAddr] maddr=18'b0;
	assign maddr_out=maddr[15:0];
	reg boot_done=1'b0;
	assign boot_done_out=boot_done;
	reg [22:1] new_caddr;
	
	always @(*) begin
		caddr = {4'b0, maddr + 18'b1};
	end
	
	always @(posedge clk) begin
		if (!rst) begin
			maddr <= 18'b0;
			boot_done <= 1'b0;
		end else if (boot_done) begin
			need_to_work <= 1'b0;
		end else if (work_done == 1'b1) begin
			maddr <= caddr[18:1];
			data <= flash_data;
			write_ctrl <= 1'b1;
			if(caddr > 22'h219)begin
				write_ctrl <= 1'b0;
				boot_done <= 1'b1;
			end
		end else begin
			need_to_work <= 1'b1;
		end
	end
endmodule

