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
	input hold,
	input auto_en,
	input [15:0] sw,
	output wire clk
    );

	wire [31:0] clk_interval;
	assign clk_interval = { 8'h00, sw[7:4], 4'h0, sw[3:2], 12'h000, sw[1:0] };
	//localparam clk_interval = 32'h00000008;
	reg [31:0] cur_cnt = 32'h0;
	wire cur_status;
	assign cur_status = !clk;

	initial clk = 1'b0;

	wire [31:0] tmp;
	assign tmp = cur_cnt + 32'h00000001;

	assign clk = raw_clk && auto_en;

	/*always @(posedge raw_clk) begin
		if (!auto_en) begin
			if (tmp >= clk_interval) begin
				cur_cnt = 32'h0;
				clk = cur_status;
			end else begin
				cur_cnt = tmp;
			end
		end 
	end*/

endmodule
