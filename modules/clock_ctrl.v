`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:48:07 11/22/2017 
// Design Name: 
// Module Name:    clock_ctrl 
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
module clock_ctrl(
    input raw_clk,
	input manual_clk,
	input auto_en,
	output reg clk,
	output reg pclk
    );

	localparam CLK_INTERVAL = 32'h001AF080;
	reg [31:0] cur_cnt = 32'h0;
	reg cur_status = 1'b0;

	reg [31:0] tmp;

	always @(posedge raw_clk) begin
		if (!auto_en) begin
			tmp = cur_cnt + 32'h00000001;
			if (tmp >= CLK_INTERVAL) begin
				cur_cnt = 32'h0;
				pclk = 32'h0;
				clk = cur_status;
				cur_status = !cur_status;
			end else begin
				cur_cnt = tmp;
				pclk = ((tmp > (CLK_INTERVAL >> 2)) && (tmp < (CLK_INTERVAL >> 1)));
			end
		end else begin
			clk = manual_clk;
		end
	end

endmodule
