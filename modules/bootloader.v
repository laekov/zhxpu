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
	output [`MemAddr] maddr_out
);

	reg [22:1] caddr = 22'b0;
	assign caddr_out = caddr;
	reg read_c = 1'b0;
	assign read_ctrl = read_c;
	reg [`MemAddr] maddr=18'b0;
	assign maddr_out=maddr;
	reg boot_done=1'b0;
	assign boot_done_out=boot_done;

	always @(posedge flash_ready or negedge rst) begin
		if (!rst) begin
			caddr = 22'b0;
			maddr=18'b0;
			boot_done=1'b0;
			read_c=!read_c;
		end else begin
			if(boot_done==1'b0)begin
				write_ctrl=1'b0;
				caddr = caddr + 22'b1;
				read_c = !read_c;
				maddr = maddr + 18'b1;
				data = flash_data;
				write_ctrl = 1'b1;
			end
			if(maddr>18'h218)begin
				boot_done =1'b1;
			end
		end
	end
endmodule

