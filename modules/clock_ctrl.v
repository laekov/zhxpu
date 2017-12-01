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
	input [15:0] sw,
	output reg clk,
	output reg pclk
    );

	wire clk_interval;
	assign clk_interval = { 8'h00, sw[7:4], 4'h0, sw[3:0], 12'h004 };
	//localparam clk_interval = 32'h00000008;
	reg [31:0] cur_cnt = 32'h0;
	reg cur_status = 1'b0;

	reg [31:0] tmp;

	always @(posedge raw_clk) begin
		if (!auto_en) begin
			tmp = cur_cnt + 32'h00000001;
			if (tmp >= clk_interval) begin
				cur_cnt = 32'h0;
				pclk = 32'h0;
				clk = cur_status;
				cur_status = !cur_status;
			end else begin
				cur_cnt = tmp;
				pclk = 1'b0;
			end
		end 
	end

endmodule
