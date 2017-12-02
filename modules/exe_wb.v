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
	output wire write_reg_ctrl,
	output wire [`RegAddr] write_reg_addr,
	output reg [`RegValue] write_reg_data,
	input [`RegValue] mem_read_value
);

	reg write_reg_ctrl_c;
	reg [`RegAddr] write_reg_addr_c;

	assign write_reg_ctrl = write_reg_ctrl_c;
	assign write_reg_addr = write_reg_addr_c;

	always @(posedge clk) begin
		if (hold) begin
		end else begin
			write_reg_ctrl_c <= reg_wr;
			write_reg_addr_c <= reg_addr;
			write_reg_data <= alu_res;
		end
	end
	endmodule
