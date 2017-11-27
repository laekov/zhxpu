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
`include "jmp_ctrl.v"
`include "led_ctrl.v"
`include "pc_reg.v"
`include "register.v"
`include "stall_ctrl.v"
`include "ram_controller.v"
`include "ram_uart.v"

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
	inout [15:0] ram1_data,
	inout [15:0] ram2_data,
	output wire ram1_en,
	output wire ram1_oe,
	output wire ram1_rw,
	output wire ram2_en,
	output wire ram2_oe,
	output wire ram2_rw,
	output wire [17:0] ram1_addr,
	output wire [17:0] ram2_addr,
	input [15:0] sw,
	input rst,
	input manual_clk,
	input data_ready,
	output rdn,
	input tbre,
	input tsre,
	output wrn
);
// Clock module
	wire clk;
	wire pclk;

	clock_ctrl __clock_ctrl(
		.raw_clk(raw_clk),
		//.manual_clk(manual_clk),
		.auto_en(manual_clk),
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
		.dig(dig2_data),
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
	wire uart_work_done;
	wire mem_op;

	stall_ctrl __stall_ctrl(
		.mem_op(mem_op),
		.mem_done(uart_work_done),
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
	wire alu_writable;
	wire [`RegAddr] alu_write_addr;
	wire [`RegValue] alu_write_value;

	wire [`RegValue] reg_debug_out;

	register __register(
		.clk(clk),
		.writable(reg_writable),
		.write_addr(reg_write_addr),
		.write_value(reg_write_value),
		.alu_writable(alu_writable),
		.alu_write_addr(alu_write_addr),
		.alu_write_value(alu_write_value),
		.readable1(reg_readable1),
		.read_addr1(reg_read_addr1),
		.read_value1(reg_read_value1),
		.readable2(reg_readable2),
		.read_addr2(reg_read_addr2),
		.read_value2(reg_read_value2),
		.debug_out(reg_debug_out)
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
	//	.readable1(stall_readable1),
		.read_addr1(reg_read_addr1),
	//	.readable2(stall_readable2),
		.read_addr2(reg_read_addr2),
		.mem_read(id_mem_read),
		.mem_write(id_mem_write),
		.reg_write(id_reg_write),
		.reg_addr(id_reg_addr)
	);

	jmp_ctrl __jmp_ctrl(
		.op1(reg_read_value1),
		.op2(reg_read_value2),
		.pc_in(id_pc),
		.opn(id_inst),
		.set_pc(set_pc),
		.set_pc_value(set_pc_addr)
	);

// EXE stage modules
	wire [`RegValue] exe_pc;
	wire [`RegValue] exe_inst;
	wire exe_reg_write;
	wire [`RegAddr] exe_reg_addr;
	wire [15:0] alu_op1;
	wire [15:0] alu_op2;
	wire [15:0] alu_res;
	wire [15:0] exe_read_value1;
	wire [15:0] exe_read_value2;
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
	wire [`RegValue] exe_mem_data;

	wire [15:0] wb_res;
	wire wb_flag;
	
	alu_out_ctrl __alu_out_ctrl(
		.res(alu_res),
		.flag(alu_flag),
		.res_out(wb_res),
		.flag_out(wb_flag)
	);

	assign alu_writable = exe_reg_write;
	assign alu_write_addr = exe_reg_addr;
	assign alu_write_value = wb_res;

	wire mem_work_done;
	wire uart_need_to_work;
	wire [`MemValue] uart_work_res;
	wire [`MemValue] mem_work_res;

	ram_uart __ram_uart(
		.clk(raw_clk),
		.rst(rst),
		.need_to_work(uart_need_to_work),
		.mem_rd(exe_memrd_ctrl),
		.mem_wr(exe_memwr_ctrl),
		.mem_addr({ 2'b0, alu_res }),
		.mem_value(exe_read_value2),
		.Ram1Addr(ram1_addr),
		.Ram1Data(ram1_data),
		.Ram1OE(ram1_oe),
		.Ram1WE(ram1_rw),
		.Ram1EN(ram1_en),
		.Ram2Addr(ram2_addr),
		.Ram2Data(ram2_data),
		.Ram2OE(ram2_oe),
		.Ram2WE(ram2_rw),
		.Ram2EN(ram2_en),
		.data_ready(data_ready),
		.rdn(rdn),
		.tbre(tbre),
		.tsre(tsre),
		.wrn(wrn),
		.work_done(uart_work_done),
		.result(uart_work_res)
	);

	ram_controller __ram_controller(
		.mem_rd(exe_memrd_ctrl),
		.mem_wr(exe_memwr_ctrl),
		.addr(alu_res),
		.data(exe_read_value2),
		.ram_work_done(uart_work_done),
		.ram_feedback(uart_work_res),
		.ram_need_to_work(uart_need_to_work),
		.work_done(mem_work_done),
		.feedback(mem_work_res)
	);

// WB stage modules
	wire flush;

// IF/ID
	if_id __if_id(
		.hold(hold),
		//.flush(flush),
		.pc_in(if_pc),
		.clk(clk),
		.pclk(pclk),
		.inst_in(if_inst),
		.pc_out(id_pc),
		.inst_out(id_inst)
	);

// ID/EXE
	id_exe __id_exe(
		.clk(clk),
		.pclk(pclk),
		//.flush(flush),
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
		.read_value1_output(exe_read_value1),
		.read_value2_output(exe_read_value2),
		.hold(hold),
		.pc(id_pc),
		.opn(id_inst),
		.pc_out(exe_pc),
		.opn_out(exe_inst),
		.op1(alu_op1),
		.op2(alu_op2)
	); // TODO mem write value not attached
	assign mem_op = exe_memwr_ctrl || exe_memrd_ctrl;

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
		.hold(hold),
		.write_reg_ctrl(reg_writable),
		.write_reg_addr(reg_write_addr),
		.write_reg_data(reg_write_value),
		.mem_read_value(mem_work_res)
	);

	// assign dig1_data = reg_debug_out[7:4];
	assign dig1_data = exe_pc; 
	assign dig2_data = alu_op2[3:0];
	// assign led_data = { reg_debug_out[11:0], wb_res[3:0] };
	// assign led_data = { reg_read_value1[3:0], reg_read_value2[3:0], reg_read_addr1, reg_readable2, wb_res[3:0] };
	// assign led_data = { reg_writable, reg_write_addr, reg_write_value[3:0], reg_debug_out[7:0] };
	// assign led_data = { 1'b0, id_reg_addr, 1'b0, exe_reg_addr, 1'b0, reg_write_addr, reg_write_value[3:0] };
	// assign led_data = if_inst;
	// assign led_data = { reg_read_value1[3:0], reg_read_value2[3:0], reg_write_value[3:0], hold, if_pc[3:0] };
	// assign led_data = reg_debug_out;
	// assign led_data = { if_pc[2:0], if_inst[15:11], reg_read_value1[3:0], reg_read_value2[3:0]  };
	assign led_data = { exe_read_value2[7:0], mem_work_res[3:0], uart_work_done, mem_work_done, hold, uart_need_to_work };

endmodule

