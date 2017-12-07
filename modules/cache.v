`timescale 1ns / 1ps

`include "define.v"

module cache(
	input clk,
	input rst,
	input [`MemAddr] addr,
	input [`MemValue] write_value,
	input wr_ctrl,
	output wire [`MemValue] feedback,
	output wire present,
	output wire dirty,
	output reg [`MemAddr] wb_addr,
	output reg [`MemValue] wb_value,
	output reg wb_need
);

	reg [`MemValue] cache [`CacheSize];
	reg [`MemAddr] caddr [`CacheSize];
	reg [`CacheSize] fpre = 0;
	reg [`CacheSize] fdir;

	assign hash_addr = { addr[14], addr[8:0] };

	always @(posedge clk) begin
		if (wr_ctrl) begin
			if (!fpre[hash_addr] || addr != caddr[hash_addr]) begin
				wb_need <= fpre[hash_addr] && fdir[hash_addr];
				wb_addr <= caddr[hash_addr];
				wb_value <= cache[hash_addr];
				cache[hash_addr] <= write_value;
				caddr[hash_addr] <= addr;
				fpre[hash_addr] <= 1'b1;
				fdir[hash_addr] <= 1'b0;
			end 
			else begin
				cache[hash_addr] <= write_value;
				fdir[hash_addr] <= 1'b1;
			end
		end
	end

	assign present = addr == caddr[hash_addr] && fpre[hash_addr];
	assign dirty = fdir[hash_addr];
	assign feedback = cache[hash_addr];
endmodule

