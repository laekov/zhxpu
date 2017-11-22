`timescale 1ns / 1ps
module bootloader(
	input clk,
	input pclk,
	output reg [22:0] flash_addr,
	inout [15:0] flash_data,
	output reg flash_byte,
	output reg flash_vpen,
	output reg flash_ce,
	output reg flash_oe,
	output reg flash_we,
	output reg flash_rp,
	output reg [15:0] data
);

	reg [22:0] caddr = 22'b0;
	reg [22:0] tmp;
	reg initialized = 1'b0;

	always @(*) begin
		if (!initialized) begin
			flash_byte <= 1'b1;
			flash_vpen <= 1'b1;
			flash_rp <= 1'b1;
			initialized <= 1'b1;
		end
	end

	reg write_flash = 1'b0;
	reg [15:0] flash_data_r;
	assign flash_data = write_flash ? flash_data_r : 'bz;

	always @(posedge clk) begin
		tmp = caddr + 22'h1;
		flash_we = 1'b0;
		flash_oe = 1'b1;
		flash_addr = caddr;
		flash_data_r = 16'bZ;
		caddr = tmp;
	end

	always @(posedge pclk) begin
		data <= flash_data;
	end
	
endmodule


