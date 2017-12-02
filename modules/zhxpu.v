`timescale 1ns / 1ps
`include "alu.v"
`include "alu_out_ctrl.v"
`include "bootloader.v"
`include "flash_ctrl.v"
`include "flash_controller.v"
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
`include "ram2.v"
`include "ram_sel.v"
`include "hja_led_ctrl.v"

module zhxpu(
    input raw_clk,
    input raw_clk2,
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
	output wire flash_rp,
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
		.sw(sw),
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

// Bootloader
	wire initializing;
	wire boot_done_out;
	wire flash_ready;
	wire [15:0] mflash_data;
	wire [22:1] mflash_addr;
	wire [15:0] init_data;
	wire [15:0] init_addr;
	wire flash_read_ctrl;
	wire init_mem_wr;
	wire flash_controller_work_done;
	wire flash_controller_need_to_work;
	bootloader __bootloader(
		.clk(raw_clk),
		.rst(rst),
		.work_done(flash_controller_work_done),
		.flash_data(mflash_data),
		.data(init_data),
		.need_to_work(flash_controller_need_to_work),
		.caddr_out(mflash_addr),
		.write_ctrl(init_mem_wr),
		.boot_done_out(boot_done_out),
		.maddr_out(init_addr)
	);
	assign initializing = !boot_done_out;

	wire flash_i_ready;

	flash_ctrl __flash_ctrl(
		.clk(raw_clk2),
		.rst(rst),
		.addr(mflash_addr),
		.read_ctrl(flash_read_ctrl),
		.flash_addr(flash_addr),
		.flash_data(flash_data),
		.flash_byte(flash_byte),
		.flash_vpen(flash_vpen),
		.flash_ce(flash_ce),
		.flash_rp(flash_rp),
		.flash_oe(flash_oe),
		.flash_we(flash_we),
		.data(mflash_data),
		.flash_ready(flash_i_ready)
	);

	wire flash_done_pc;

	flash_controller __flash_controller(
		.addr(mflash_addr),
		.flash_work_done(flash_i_ready),
		.need_to_work(flash_controller_need_to_work),
		.flash_need_to_work(flash_read_ctrl),
		.work_done(flash_controller_work_done),
		.done_pc_out(flash_done_pc)
	);

// Stall ctrl module
	wire hold;
	wire ram1_work_done;
	wire ram2_work_done;
	wire mem_work_done;
	wire mem_op;

	stall_ctrl __stall_ctrl(
		.mem_op(mem_op),
		.initializing(initializing),
		.mem_done(mem_work_done),
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

	wire [255:0] reg_debug_out;

	register __register(
		.raw_clk(raw_clk),
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
	wire inst_read_done;

	pc_reg __pc_reg(	
		.clk(clk),
		.rst(rst),
		.hold(hold),
		.set_pc(set_pc),
		.set_pc_addr(set_pc_addr),
		.pc_enabled(pc_enabled),
		.pc(if_pc),
		.read_done(inst_read_done)
	);

	wire [`RegValue] if_inst;
	wire ram2_need_to_work_if;
	wire ram2_work_done_if;
	wire [`MemValue] ram2_work_res_if;
	wire [`RegValue] inst_done_pc;

	inst_mem_ctrl __inst_mem_ctrl(
		.addr(if_pc),
		.data(if_inst),
		.ram_need_to_work(ram2_need_to_work_if),
		.ram_work_done(ram2_work_done_if),
		.ram_feed_back(ram2_work_res_if),
		.work_done(inst_read_done),
		.done_pc_out(inst_done_pc)
	);

// ID stage modules
	wire [`RegValue] id_inst;
	wire [`RegValue] id_pc;
	wire id_mem_read;
	wire id_mem_write;
	wire id_reg_write;
	wire [`RegAddr] id_reg_addr;
	wire decoder_error;

	decoder __decoder(
		.opn(id_inst),
		.decoder_error(decoder_error),
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
	wire [`MemValue] mem_work_res;
	
	alu_out_ctrl __alu_out_ctrl(
		.res(alu_res),
		.flag(alu_flag),
		.memwr_ctrl(exe_memwr_ctrl),
		.memrd_ctrl(exe_memrd_ctrl),
		.res_out(wb_res),
		.flag_out(wb_flag),
		.mem_res(mem_work_res)
	);

	assign alu_writable = exe_reg_write;
	assign alu_write_addr = exe_reg_addr;
	assign alu_write_value = wb_res;

	wire ram1_need_to_work;
	wire ram2_need_to_work;
	wire [`MemValue] ram1_work_res;
	wire [`MemValue] ram2_work_res;

	wire [7:0] ram_status;

	wire mem_wr;
	assign mem_wr= init_mem_wr || exe_memwr_ctrl;

	wire [`RegValue] ram_data;
	wire [`RegValue] ram_addr;
	wire [`RegValue] ram_pc;

	ram_sel __ram_sel(
		.initializing(initializing),
		.init_addr(init_addr),
		.init_data(init_data),
		.exe_pc(exe_pc),
		.exe_addr(alu_res),
		.exe_data(exe_read_value2),
		.addr_out(ram_addr),
		.data_out(ram_data),
		.pc_out(ram_pc)
	);

	wire [`QueueSize] qfront;
	wire [`QueueSize] qtail;
	wire [`RegValue] qfrontv;

	ram_uart __ram_uart(
		.clk(raw_clk),
		.rst(rst),
		.need_to_work(ram1_need_to_work),
		.mem_rd(exe_memrd_ctrl),
		.mem_wr(exe_memwr_ctrl),
		.mem_addr({ 2'b0, ram_addr }),
		.mem_value(ram_data),
		.Ram1Addr(ram1_addr),
		.Ram1Data(ram1_data),
		.Ram1OE(ram1_oe),
		.Ram1WE(ram1_rw),
		.Ram1EN(ram1_en),
		.data_ready(data_ready),
		.rdn(rdn),
		.tbre(tbre),
		.tsre(tsre),
		.wrn(wrn),
		.uart_work_done(ram1_work_done),
		.status_out(ram_status),
		.result(ram1_work_res),
		.front(qfront),
		.tail(qtail),
		.queue_front_v(qfrontv)
	);

	wire [7:0] ram2_status;
	ram2 __ram2(
		.clk(raw_clk),
		.rst(rst),
		.need_to_work_if(ram2_need_to_work_if),
		.need_to_work_exe(ram2_need_to_work),
		.mem_rd(exe_memrd_ctrl),
		.mem_wr(mem_wr),
		.mem_addr_if({ 2'b0, if_pc }),
		.mem_addr_exe({2'b0, ram_addr}),
		.mem_value_exe(ram_data),
		.Ram2Addr(ram2_addr),
		.Ram2Data(ram2_data),
		.Ram2OE(ram2_oe),
		.Ram2WE(ram2_rw),
		.Ram2EN(ram2_en),
		.if_work_done(ram2_work_done_if),
		.exe_work_done(ram2_work_done),
		.if_result(ram2_work_res_if),
		.exe_result(ram2_work_res),
		.status_out(ram2_status)
	);

	wire [`RegValue] ram_ctrl_done_pc;
	wire [31:0] mem_act;
	wire [`RegValue] mem_act1;
	wire [`RegValue] mem_act2;
	ram_controller __ram_controller(
		.mem_rd(exe_memrd_ctrl),
		.mem_wr(mem_wr),
		.pc(ram_pc),
		.addr({ 2'b0, ram_addr }),
		.ram1_work_done(ram1_work_done),
		.ram1_feedback(ram1_work_res),
		.ram1_need_to_work(ram1_need_to_work),
		.ram2_work_done(ram2_work_done),
		.ram2_feedback(ram2_work_res),
		.ram2_need_to_work(ram2_need_to_work),
		.work_done(mem_work_done),
		.feedback(mem_work_res),
		.uart_received_data(data_ready),
		.done_pc_out(ram_ctrl_done_pc),
		.mem_act(mem_act),
		.done_act1_out(mem_act1),
		.done_act2_out(mem_act2)
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
		.rst(rst),
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
		.op2(alu_op2),
		.mem_act(mem_act)
	); 
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
	assign dig1_data = initializing ? init_addr[7:4] : if_pc[7:4];
	assign dig2_data = initializing ? init_addr[3:0] : if_pc[3:0];
	//assign led_data = if_inst;
	//
	
	hja_led_ctrl __hja_led_ctrl(
		.sw(sw),
		.led_data(led_data),
		.clk(clk),
		.pclk(pclk),
		.initializing(initializing),
		.boot_done_out(boot_done_out),
		.flash_ready(flash_ready),
		.mflash_data(mflash_data),
		.mflash_addr(mflash_addr),
		.init_data(init_data),
		.init_addr(init_add),
		.flash_read_ctrl(flash_read_ctrl),
		.init_mem_wr(init_mem_wr),
		.hold(hold),
		.ram1_work_done(ram1_work_done),
		.ram2_work_done(ram2_work_done),
		.mem_work_done(mem_work_done),
		.mem_op(mem_op),
		.reg_writable(reg_writable),
		.reg_write_addr(reg_write_addr),
		.reg_write_value(reg_write_value),
		.reg_readable1(reg_readable1),
		.reg_read_addr1(reg_read_addr1),
		.reg_read_value1(reg_read_value1),
		.reg_readable2(reg_readable2),
		.reg_read_addr2(reg_read_addr2),
		.reg_read_value2(reg_read_value2),
		.alu_writable(alu_writable),
		.alu_write_addr(alu_write_addr),
		.alu_write_value(alu_write_value),
		.reg_debug_out(reg_debug_out),
		.set_pc(set_pc),
		.set_pc_addr(set_pc_addr),
		.if_pc(if_pc),
		.if_inst(if_inst),
		.ram2_need_to_work_if(ram2_need_to_work_if),
		.ram2_work_done_if(ram2_work_done_if),
		.ram2_work_res_if(ram2_work_res_if),
		.decoder_error(decoder_error),
		.id_inst(id_inst),
		.id_pc(id_pc),
		.id_mem_read(id_mem_read),
		.id_mem_write(id_mem_write),
		.id_reg_addr(id_reg_addr),
		.exe_pc(exe_pc),
		.exe_inst(exe_inst),
		.exe_reg_write(exe_reg_write),
		.exe_reg_addr(exe_reg_addr),
		.alu_op1(alu_op1),
		.alu_op2(alu_op2),
		.alu_res(alu_res),
		.exe_read_value1(exe_read_value1),
		.exe_read_value2(exe_read_value2),
		.alu_flag(alu_flag),
		.exe_memwr_ctrl(exe_memwr_ctrl),
		.exe_memrd_ctrl(exe_memrd_ctrl),
		.exe_mem_data(exe_mem_data),
		.wb_res(wb_res),
		.wb_flag(wb_flag),
		.mem_work_res(mem_work_res),
		.ram1_need_to_work(ram1_need_to_work),
		.ram2_need_to_work(ram2_need_to_work),
		.ram_status(ram_status),
		.mem_wr(mem_wr),
		.ram_data(ram_data),
		.ram_addr(ram_addr),
		.ram_pc(ram_pc),
		.ram2_status(ram2_status),
		.inst_read_done(inst_read_done),
		.flush(flush),
		.inst_done_pc(inst_done_pc),
		.ram_ctrl_done_pc(ram_ctrl_done_pc),
		.flash_done_pc(flash_done_pc),
		.flash_controller_need_to_work(flash_controller_need_to_work),
		.flash_controller_work_done(flash_controller_work_done),
		.id_reg_write(id_reg_write),
		.data_ready(data_ready),
		.mem_act(mem_act),
		.mem_act1(mem_act1),
		.mem_act2(mem_act2),
		.qfront(qfront),
		.qtail(qtail),
		.qfrontv(qfrontv)
	);

endmodule

