`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:17:24 12/06/2017 
// Design Name: 
// Module Name:    vga 
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

`include "font.v"
module vga(
	input clk,
	input rst,

	input [3:0] data,
	input space,

	output wire [7:0] row_out,
	output wire [7:0] col_out,
	
	output reg r0,
	output reg r1,
	output reg r2,
	output reg g0,
	output reg g1,
	output reg g2,
	output reg b0,
	output reg b1,
	output reg b2,
	output reg hs,
	output reg vs
    );
	 	
	reg [10:0] row;
	reg [10:0] col;
	assign row_out = row[10:3];
	assign col_out = col[10:3];

	reg cnt;
	wire res;

	font __font(
		.row(row[2:0]),
		.col(col[2:0]),
		.data(data),
		.space(space),
		.res(res)
	);


	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			cnt <= 0;
			row <= 1;
			col <= 1;
		end
		else begin
			cnt <= cnt + 1;
			if (cnt == 0) begin
				if (row <= 480 && col <= 640) begin
					r0 <= res;
					r1 <= res;
					r2 <= res;
					g0 <= res;
					g1 <= res;
					g2 <= res;
					b0 <= res;
					b1 <= res;
					b2 <= res;
					/*r0 <= res && col[0:0];
					r1 <= res && col[1:1];
					r2 <= res && col[2:2];
					g0 <= res && row[3:3];
					g1 <= res && row[4:4];
					g2 <= res && row[5:5];
					b0 <= res && col[3:3];
					b1 <= res && col[4:4];
					b2 <= res && row[6:6];*/
				end
				else begin
					r0 <= 0;
					r1 <= 0;
					r2 <= 0;
					g0 <= 0;
					g1 <= 0;
					g2 <= 0;
					b0 <= 0;
					b1 <= 0;
					b2 <= 0;
				end
				if (col>=656 && col<752) hs<=0;
				else hs<=1;
				if (row>=490 && row<=491) vs<=0;
				else vs<=1;

				if (col==800) begin
					if (row == 525) begin
						row <= 1;
						col <= 1;
					end
					else begin
						row <= row + 1;
						col <= 1;
					end
				end
				else col <= col + 1;
			end
		end
	end


endmodule

