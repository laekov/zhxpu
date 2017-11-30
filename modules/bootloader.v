`timescale 1ns / 1ps

`include "define.v"

module bootloader(
	input wire flash_ready,
	input wire [15:0] flash_data,
	input rst,
	output reg [`MemValue] data,
	output wire read_ctrl,
	output wire [22:1] caddr_out,
	output reg write_ctrl,
	output wire boot_done_out,
	output [`RegValue] maddr_out
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
		new_caddr <= caddr + 22'b1;
	end

	always @(posedge flash_ready or negedge rst) begin
		if (!rst) begin
			caddr <= 22'b0;
			maddr <= 18'b111111111111111111;
			boot_done <= 1'b0;
			read_c <= !read_c;
		end else begin
			if(boot_done==1'b0)begin
				maddr <= maddr + 18'b1;
				caddr <= new_caddr;
				read_c <= !read_c;
				data <= flash_data;
				write_ctrl <= 1'b1;
			end
			if(caddr > 22'h219)begin
				write_ctrl <= 1'b0;
				boot_done <= 1'b1;
			end
		end
	end
endmodule

