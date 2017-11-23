`timescale 1ns / 1ps
`include "alu.v"
`include "alu_out_ctrl.v"
`include "bootloader.v"
`include "clock_ctrl.v"
`include "decoder.v"
`include "define.v"
`include "dig_ctrl.v"
`include "exe_wb.v"
`include "id_exe.v"
`include "if_id.v"
`include "inst_mem_ctrl.v"
`include "led_ctrl.v"
`include "pc_reg.v"
`include "register.v"
`include "stall_ctrl.v"

module zhxpu(
    input raw_clk,
    input raw_clk2,
	output wire [6:0] seg1,
	output wire [6:0] seg2,
	output wire [15:0] led,
	//output wire [22:0] flash_addr,
	//inout [15:0] flash_data,
	//output wire flash_byte,
	//output wire flash_vpen,
	//output wire flash_ce,
	//output wire flash_oe,
	//output wire flash_we,
	//output wire flash_rp,
	// output wire [3:0] fpga_key,
	//inout [15:0] ram1_data,
	//inout [15:0] ram2_data,
	//output wire ram1_en,
	//output wire ram1_oe,
	//output wire ram1_rw,
	//output wire ram2_en,
	//output wire ram2_oe,
	//output wire ram2_rw,
	//output wire [17:0] ram1_addr,
	//output wire [17:0] ram2_addr,
	//input [15:0] sw,
	input rst,
	input manual_clk
);
// Clock module
	wire clk;
	wire pclk;

	clock_ctrl __clock_ctrl(
		.raw_clk(raw_clk),
		.manual_clk(manual_clk),
		.auto_en(rst),
		.clk(clk),
		.pclk(pclk)
	);

// Dig 
	wire [3:0] dig1_data;
	wire [3:0] dig2_data;

	dig_ctrl __dig_ctrl_1(
		.dig(dig1_data),
		.light(seg1)
	);
	dig_ctrl __dig_ctrl_2(
		.dig(dig1_data),
		.light(seg2)
	);

// LED
	wire [15:0] led_data;

	led_ctrl __led_ctrl(
		.data(led_data),
		.light(led)
	);

// Stall ctrl module
	wire hold;
	wire stall_writable;
	wire [`RegAddr] stall_write_addr;
	wire stall_readable1;
	wire [`RegAddr] stall_readable1_addr;
	wire stall_readable2;
	wire [`RegAddr] stall_readable2_addr;
	wire stall_writed;
	wire [`RegAddr] stall_writed_addr;

	stall_ctrl __stall_ctrl(
		.writable(stall_writable),
		.write_addr(stall_write_addr),
		.readable1(stall_readable1),
		.read_addr1(stall_readable1_addr),
		.readable2(stall_readable2),
		.read_addr2(stall_readable2_addr),
		.writed(stall_writed),
		.writed_addr(stall_writed_addr),
		.hold(hold)
	);

// Register module
	wire reg_writable;
	wire [`RegAddr] reg_write_addr;
	wire [`RegValue] reg_write_value;
	wire reg_readable1;
	wire [`RegAddr] reg_read_addr1;
	wire [`RegValue] reg_read_value1;
	wire reg_readable2;
	wire [`RegAddr] reg_read_addr2;
	wire [`RegValue] reg_read_value2;

	register __register(
		.clk(clk),
		.writable(reg_writable),
		.write_addr(reg_write_addr),
		.write_value(reg_write_value),
		.readable1(reg_readable1),
		.read_addr1(reg_read_addr1),
		.read_value1(reg_read_value1),
		.readable2(reg_readable2),
		.read_addr2(reg_read_addr2),
		.read_value2(reg_read_value2)
	);

// IF stage modules
	wire set_pc;
	wire [15:0] set_pc_addr;
	//wire pc_enabled;
	reg pc_enabled = 1'b1;
	wire [`RegValue] if_pc;

	pc_reg __pc_reg(	
		.clk(clk),
		.hold(hold),
		.set_pc(set_pc),
		.set_pc_addr(set_pc_addr),
		.pc_enabled(pc_enabled),
		.pc(if_pc)
	);

	assign dig1_data = if_pc[3:0];
	assign dig2_data = if_pc[7:4];

	wire [`RegValue] if_inst;

	inst_mem_ctrl __inst_mem_ctrl(
		.addr(if_pc),
		.data(if_inst)
	);

// ID stage modules
	wire [`RegValue] id_inst;
	wire [`RegValue] id_pc;
	wire id_mem_read;
	wire id_mem_write;
	wire id_reg_write;
	wire [`RegAddr] id_reg_addr;

	decoder __decoder(
		.opn(id_inst),
		.readable1(stall_readable1),
		.read_addr1(stall_readable1_addr),
		.readable2(stall_readable2),
		.read_addr2(stall_readable2_addr),
		.mem_read(id_mem_read),
		.mem_write(id_mem_write),
		.reg_write(id_reg_write),
		.reg_addr(id_reg_addr)
	);

// EXE stage modules
	wire [`RegValue] exe_pc;
	wire [`RegValue] exe_inst;
	wire exe_reg_write;
	wire [`RegAddr] exe_reg_addr;
	wire [15:0] alu_op1;
	wire [15:0] alu_op2;
	wire [15:0] alu_res;
	wire alu_flag;

	alu __alu(
		.opn(exe_inst),
		.op1(alu_op1),
		.op2(alu_op2),
		.res(alu_res),
		.flag(alu_flag)
	);

	wire exe_memwr_ctrl;
	wire exe_memrd_ctrl;
	wire [17:0] exe_mem_addr;

	wire [15:0] wb_res;
	wire wb_flag;
	
	alu_out_ctrl __alu_out_ctrl(
		.res(alu_res),
		.flag(alu_flag),
		.res_out(wb_res),
		.flag_out(wb_flag)
	);

// WB stage modules
	wire flush;

// IF/ID
	if_id __if_id(
		.hold(hold),
		.pc_in(if_pc),
		.clk(clk),
		.inst_in(if_inst),
		.pc_out(id_pc),
		.inst_out(id_inst)
	);

// ID/EXE
	id_exe __id_exe(
		.clk(clk),
		.pclk(pclk),
		.mem_write(id_mem_write),
		.mem_read(id_mem_read),
		.reg_write(id_reg_write),
		.reg_addr(id_reg_addr),
		.mem_write_out(exe_memwr_ctrl),
		.mem_read_out(exe_memrd_ctrl),
		.reg_write_out(exe_reg_write),
		.reg_addr_out(exe_reg_addr),
		.read_value1(reg_read_value1),
		.read_value2(reg_read_value2),
		.hold(hold),
		.pc(id_pc),
		.opn(id_inst),
		.pc_out(exe_pc),
		.opn_out(exe_inst),
		.op1(alu_op1),
		.op2(alu_op2)
	); // TODO mem write value not attached

// EXE/WB
	exe_wb __exe_wb(
		.alu_res(wb_res),
		.alu_flag(wb_flag),
		.reg_wr(exe_reg_write),
		.reg_addr(exe_reg_addr),
		.opn(exe_inst),
		.pc_input(exe_pc),
		.clk(clk),
		.pclk(pclk),
		.pc_switch_ctrl(set_pc),
		.new_pc(set_pc_addr),
		.clear_flow(flush),
		//.unlock_reg(stall_writed),
		//.unlock_reg_addr(stall_writed_addr),
		.write_reg_ctrl(reg_writable),
		.write_reg_addr(reg_write_addr),
		.write_reg_data(reg_write_data)
	);

	assign led_data = if_inst;

endmodule

