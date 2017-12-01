`include "define.v"

module exe_wb(
	input [`RegValue] alu_res,
	input alu_flag,
	input mem_feedback,
	input reg_wr,
	input [`RegAddr]reg_addr,
	input mem_wr,
	input mem_rd,
	input [15:0]pc_input,
	input [15:0]opn,
	input clk,
	input pclk,
	input hold,
	output reg unlock_reg,
	output reg [`RegAddr] unlock_reg_addr,
	output reg [`RegValue] sp_reg_data,
	output reg write_reg_ctrl,
	output reg [`RegAddr] write_reg_addr,
	output reg [`RegValue] write_reg_data,
	input [`RegValue] mem_read_value
);

	always @(clk) begin
		if (hold) begin
		end else begin
			write_reg_ctrl <= reg_wr && clk;
			write_reg_addr <= clk ? reg_addr : `ZeroReg;
			write_reg_data <= alu_res;
		end
	end
	endmodule
