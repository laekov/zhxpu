`timescale 1ns / 1ps

`include "define.v"

module bootloader(
	input clk,
	input rst,
	input wire flash_work_done,
	input wire ram_work_done,
	input wire [15:0] flash_data,
	input [15:0] flash_done_addr,

	output reg flash_need_to_work,
	output wire [22:1] flash_addr_out,
	output reg ram_need_to_work,
	output wire [`MemValue] data_out,
	output wire [`MemAddr] ram_addr_out,
	output wire boot_done_out
);

	reg [22:1] flash_addr;
	assign flash_addr_out=flash_addr;
	reg [`MemAddr] ram_addr;
	assign ram_addr_out=ram_addr;
	reg [`MemValue] data;
	assign data_out=data;
	reg boot_done;
	assign boot_done_out=boot_done;

	always @(posedge clk)begin
		if (!rst)begin
			flash_addr<=22'b1;
			ram_addr<=18'b0;
			boot_done<=1'b0;
			flash_need_to_work<=1'b1;
			ram_need_to_work<=1'b0;
		end
		else begin
			if(boot_done==1'b0)begin
				if(flash_work_done)begin
					flash_need_to_work<=1'b0;
					data<=flash_data;
					ram_addr <= { 2'b00, flash_done_addr };
					ram_need_to_work<=1'b1;	
				end
				else if(ram_work_done)begin
					ram_need_to_work<=1'b0;
					flash_addr<=flash_addr+22'b1;
					flash_need_to_work<=1'b1;
					if(ram_addr>22'h219)begin
						boot_done<=1'b1;
					end
				end
			end
		end
	end
endmodule

