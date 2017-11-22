`timescale 1ns / 1ps

module zhxpu(
    input raw_clk,
	output wire [6:0] seg1,
	output wire [6:0] seg2,
	output wire [15:0] led,
	output wire [22:0] flash_addr,
	inout [15:0] flash_data,
	output wire flash_byte,
	output wire flash_vpen,
	output wire flash_ce,
	output wire flash_oe,
	output wire flash_we,
	output wire flash_rp
);

	wire [15:0] alu_opn;
	wire [15:0] alu_op1;
	wire [15:0] alu_op2;
	wire [15:0] alu_res;
	wire alu_flag;

	alu __alu(
		.opn(alu_opn),
		.op1(alu_op1),
		.op2(alu_op2),
		.res(alu_res),
		.flag(alu_flag)
	);

	wire exe_memwr_ctrl;
	wire exe_memrd_ctrl;
	wire [17:0] exe_mem_addr;
	
	alu_out_ctrl __alu_out_ctrl(
		.res(alu_res),
		.flag(alu_flag),
		.memwr_ctrl

endmodule
