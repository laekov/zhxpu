`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:52:?? 11/17/1900
// Design Name: 
// Module Name:    hja_led_ctrl
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
module hja_led_ctrl(
		input [15:0] sw,
		output reg [15:0] led_data,

		input clk,
		input pclk,
		input initializing,
		input boot_done_out,
		input flash_ready,

		input [15:0] mflash_data,
		input [22:1] mflash_addr,
		input [15:0] init_data,
		input [15:0] init_addr,

		input flash_read_ctrl,
		input init_mem_wr,

		input hold,
		input ram1_work_done,
		input ram2_work_done,
		input mem_work_done,
		input mem_op,

		input reg_writable,
		input [`RegAddr] reg_write_addr,
		input [`RegValue] reg_write_value,
		input reg_readable1,
		input [`RegAddr] reg_read_addr1,
		input [`RegValue] reg_read_value1,
		input reg_readable2,
		input [`RegAddr] reg_read_addr2,
		input [`RegValue] reg_read_value2,
		input alu_writable,
		input [`RegAddr] alu_write_addr,
		input [`RegValue] alu_write_value,

		input [`RegValue] reg_debug_out,

		input set_pc,
		input [15:0] set_pc_addr,
		input [`RegValue] if_pc,

		input [`RegValue] if_inst,
		input ram2_need_to_work_if,
		input ram2_work_done_if,
		input [`MemValue] ram2_work_res_if,

		input [`RegValue] id_inst,
		input [`RegValue] id_pc,
		input id_mem_read,
		input id_mem_write,
		input [`RegAddr] id_reg_addr,
		
		input [`RegValue] exe_pc,
		input [`RegValue] exe_inst,
		input exe_reg_write,
		input [`RegAddr] exe_reg_addr,
		input [15:0] alu_op1,
		input [15:0] alu_op2,
		input [15:0] alu_res,
		input [15:0] exe_read_value1,
		input [15:0] exe_read_value2,
		input alu_flag,

		input exe_memwr_ctrl,
		input exe_memrd_ctrl,
		input [`RegValue] exe_mem_data,

		input [15:0] wb_res,
		input wb_flag,
		input [`MemValue] mem_work_res,

		input ram1_need_to_work,
		input ram2_need_to_work,
		input [`MemValue] ram1_work_res,
		input [`MemValue] ram2_work_res,

		input [7:0] ram_status,
		
		input mem_wr,

		input [`RegValue] ram_data,
		input [`RegValue] ram_addr,
		input [`RegValue] ram_pc,

		input [7:0] ram2_status,
		input decoder_error,

		input flush,
		input inst_read_done,
		input [`RegValue] inst_done_pc
    );

	always @(*) begin
		case (sw)
			16'h0000: led_data <= {clk,1'b0,pclk,1'b0,initializing,1'b0,boot_done_out,1'b0,flash_ready,7'b0};
			16'h0001: led_data <= {mflash_data};
			16'h0002: led_data <= {mflash_addr[16:1]};
			16'h0003: led_data <= {init_data};
			16'h0004: led_data <= {init_addr};
			16'h0005: led_data <= {flash_read_ctrl,1'b0,init_mem_wr,1'b0,hold,1'b0,ram1_work_done,1'b0,ram2_work_done,1'b0,mem_work_done,1'b0,mem_op,3'b0};
			16'h0006: led_data <= {reg_write_addr,reg_read_addr1,reg_read_addr2,alu_write_addr};
			16'h0007: led_data <= {reg_write_value};
			16'h0008: led_data <= {reg_read_value1};
			16'h0009: led_data <= {reg_read_value2};
			16'h000A: led_data <= {alu_write_value};
			16'h000B: led_data <= {reg_debug_out};
			16'h000C: led_data <= {reg_writable,3'b0,reg_readable1,3'b0,reg_readable2,3'b0,alu_writable,3'b0};
			16'h000D: led_data <= {set_pc,7'b0,inst_read_done,7'b0};
			16'h000E: led_data <= {set_pc_addr};
			16'h000F: led_data <= {if_pc};
			16'h0010: led_data <= {if_inst};
			16'h0011: led_data <= {ram2_need_to_work_if,7'b0,ram2_work_done_if,7'b0};
			16'h0012: led_data <= {ram2_work_res_if};
			16'h0013: led_data <= {id_inst};
			16'h0014: led_data <= {id_pc};
			16'h0015: led_data <= {id_mem_read,3'b0,id_mem_write,3'b0,id_reg_addr,3'b0,decoder_error};
			16'h0016: led_data <= {exe_pc};
			16'h0017: led_data <= {exe_inst};
			16'h0018: led_data <= {exe_reg_write,3'b0,alu_flag,3'b0,exe_reg_addr,4'b0};
			16'h0019: led_data <= {alu_op1};
			16'h001A: led_data <= {alu_op2};
			16'h001B: led_data <= {alu_res};
			16'h001C: led_data <= {exe_read_value1};
			16'h001D: led_data <= {exe_read_value2};
			16'h001E: led_data <= {exe_memwr_ctrl,1'b0,exe_memrd_ctrl,1'b0,wb_flag,1'b0,ram1_need_to_work,1'b0,ram2_need_to_work,1'b0,mem_wr,1'b0,flush,1'b0};
			16'h001F: led_data <= {exe_mem_data};
			16'h0020: led_data <= {wb_res};
			16'h0021: led_data <= {mem_work_res};
			16'h0022: led_data <= {ram1_work_res};
			16'h0023: led_data <= {ram2_work_res};
			16'h0024: led_data <= {ram_status,8'b0};
			16'h0025: led_data <= {ram_data};
			16'h0026: led_data <= {ram_addr};
			16'h0027: led_data <= {ram_pc};
			16'h0028: led_data <= {ram2_status,8'b0};
			16'h0029: led_data <= { inst_done_pc };
			default: led_data <= sw;
		endcase
	end


endmodule

