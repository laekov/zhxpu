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
module hja_led_vga_ctrl(
		input [15:0] sw,
		output reg [15:0] led_data,

		input [7:0] row,
		input [7:0] col,
		output reg vga_space,
		output reg [3:0] vga_data,

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
		input id_reg_write,

		input [255:0] reg_debug_out,
		input flash_i_ready,

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
		input [`ActBit] mem_act,
		input ram2_need_to_work,
		input [`MemValue] ram1_work_res,
		input [`MemValue] ram2_work_res,

		input [15:0] ram_status,
		
		input [`RegValue] ram_data,
		input [`RegValue] ram_addr,
		input [`RegValue] ram_pc,

		input [15:0] ram2_status,
		input decoder_error,

		input flush,
		input inst_read_done,
		input [`RegValue] inst_done_pc,
		input [`RegValue] ram_ctrl_done_pc,

		input [`RegValue] flash_done_pc,
		input flash_controller_work_done,
		input flash_controller_need_to_work,
		input data_ready,
		input [`ActBit] mem_act1,
		input [`ActBit] mem_act2,

		input [`QueueSize] qfront,
		input [`QueueSize] qtail,
		input [`RegValue] qfrontv,
		input uart_ready,
		input [`RegValue] right,
		input uart_flags,
		input [15:0] ram2_cnt,

		input uart_reading,
		input flash_status,
		input [`ActBit] combined_act,
		input [`RegValue] inst_read_done_pc,
		input [`RegValue] send_cnt,
		input [`RegValue] uart_operating,
		input [3:0] ram1_flags
    );

	always @(*) begin
		case (sw[15:8])
			8'h00: led_data <= {clk,1'b0,pclk,1'b0,initializing,1'b0,boot_done_out,1'b0,flash_ready,7'b0};
			8'h01: led_data <= {mflash_data};
			8'h02: led_data <= {mflash_addr[16:1]};
			8'h03: led_data <= {init_data};
			8'h04: led_data <= {init_addr};
			8'h05: led_data <= {flash_read_ctrl,1'b0,init_mem_wr,1'b0,hold,1'b0,ram1_work_done,1'b0,ram2_work_done,1'b0,mem_work_done,1'b0,mem_op,1'b0, 1'b0, 1'b0};
			8'h06: led_data <= {reg_write_addr,reg_read_addr1,reg_read_addr2,alu_write_addr};
			8'h07: led_data <= {reg_write_value};
			8'h08: led_data <= {reg_read_value1};
			8'h09: led_data <= {reg_read_value2};
			8'h0A: led_data <= {alu_write_value};
			8'h0C: led_data <= {reg_writable,3'b0,reg_readable1,3'b0,reg_readable2,3'b0,alu_writable,1'b0,flash_i_ready,1'b0};
			8'h0D: led_data <= {set_pc,7'b0,inst_read_done,7'b0};
			8'h0E: led_data <= {set_pc_addr};
			8'h0F: led_data <= {if_pc};
			8'h10: led_data <= {if_inst};
			8'h11: led_data <= {ram2_need_to_work_if,7'b0,ram2_work_done_if,7'b0};
			8'h12: led_data <= {ram2_work_res_if};
			8'h13: led_data <= {id_inst};
			8'h14: led_data <= {id_pc};
			8'h15: led_data <= {id_mem_read,3'b0,id_mem_write,3'b0,id_reg_addr,3'b0,decoder_error, 1'b0, id_reg_write, 1'b0 };
			8'h16: led_data <= {exe_pc};
			8'h17: led_data <= {exe_inst};
			8'h18: led_data <= {exe_reg_write,3'b0,alu_flag,3'b0,exe_reg_addr,4'b0};
			8'h19: led_data <= {alu_op1};
			8'h1A: led_data <= {alu_op2};
			8'h1B: led_data <= {alu_res};
			8'h1C: led_data <= {exe_read_value1};
			8'h1D: led_data <= {exe_read_value2};
			8'h1E: led_data <= {exe_memwr_ctrl,1'b0,exe_memrd_ctrl,1'b0,wb_flag,1'b0,ram1_need_to_work,1'b0,ram2_need_to_work,1'b0,init_mem_wr,1'b0,flush,1'b0, data_ready, 1'b0};
			8'h1F: led_data <= {exe_mem_data};
			8'h20: led_data <= {wb_res};
			8'h21: led_data <= {mem_work_res};
			8'h22: led_data <= {ram1_work_res};
			8'h23: led_data <= {ram2_work_res};
			8'h24: led_data <= {ram_status};
			8'h25: led_data <= {ram_data};
			8'h26: led_data <= {ram_addr};
			8'h27: led_data <= {ram_pc};
			8'h28: led_data <= {ram2_status};
			8'h29: led_data <= { inst_done_pc };
			8'h2A: led_data <= { ram_ctrl_done_pc };
			8'h2B: led_data <= { flash_done_pc };
			8'h2C: led_data <= { flash_controller_work_done, 7'b0, flash_controller_need_to_work, 7'b0 };
			8'h2D: led_data <= { mem_act1[15:0] };
			8'h2E: led_data <= { mem_act2[15:0] };
			8'h2F: led_data <= { mem_act[15:0] };
			8'h3f: led_data <= {reg_debug_out[15:0]};
			8'h3e: led_data <= {reg_debug_out[31:16]};
			8'h3d: led_data <= {reg_debug_out[47:32]};
			8'h3c: led_data <= {reg_debug_out[63:48]};
			8'h3b: led_data <= {reg_debug_out[79:64]};
			8'h3a: led_data <= {reg_debug_out[95:80]};
			8'h39: led_data <= {reg_debug_out[111:96]};
			8'h38: led_data <= {reg_debug_out[127:112]};
			8'h37: led_data <= {reg_debug_out[143:128]};
			8'h36: led_data <= {reg_debug_out[159:144]};
			8'h35: led_data <= {reg_debug_out[175:160]};
			8'h34: led_data <= {reg_debug_out[191:176]};
			8'h33: led_data <= {reg_debug_out[207:192]};
			8'h32: led_data <= {reg_debug_out[223:208]};
			8'h31: led_data <= {reg_debug_out[239:224]};
			8'h30: led_data <= {reg_debug_out[255:240]};
			8'h40: led_data <= { qfront, qtail };
			8'h41: led_data <= qfrontv;
			8'h42: led_data <= { uart_ready, 3'b0, uart_reading, 7'b0, flash_i_ready, 3'b0 };
			8'h43: led_data <= { uart_flags };
			8'h44: led_data <= { ram2_cnt };
			8'h45: led_data <= { flash_status };
			8'h46: led_data <= { right };
			8'h47: led_data <= { inst_read_done_pc };
			8'h48: led_data <= { combined_act[15:0] };
			8'h49: led_data <= { send_cnt };
			8'h4a: led_data <= { uart_operating };
			8'h4b: led_data <= { ram1_flags, 12'b0 };
			default: led_data <= sw;
		endcase
	end

	reg [15:0] data;

	always @(*) begin
		if (col[2:2] == 1) vga_space = 1'b1;
		else begin
			vga_space = 1'b0;
			if (col < 4) data = {8'b0,row};
			else begin
				if (row == 1) begin
					data = {11'b0,col[7:3]};
				end
				else begin
					case (row)
						2:begin
							case (col[7:3])
								1: data = {clk,1'b0,pclk,1'b0,initializing,1'b0,boot_done_out,1'b0,flash_ready,7'b0};
								2: data = {mflash_data};
								3: data = {mflash_addr[16:1]};
								4: data = {init_data};
								5: data = {init_addr};
								6: data = {flash_read_ctrl,1'b0,init_mem_wr,1'b0,hold,1'b0,ram1_work_done,1'b0,ram2_work_done,1'b0,mem_work_done,1'b0,mem_op,1'b0, 1'b0, 1'b0};
								7: data =  {reg_write_addr,reg_read_addr1,reg_read_addr2,alu_write_addr};
								8: data = {reg_write_value};
								9: data = {reg_read_value1};
								default: vga_space = 1'b1;
							endcase
						end
						3:begin
							case (col[7:3])
								1: data = {reg_read_value2};
								2: data =  {alu_write_value};
								3: data = {reg_writable,3'b0,reg_readable1,3'b0,reg_readable2,3'b0,alu_writable,1'b0,flash_i_ready,1'b0};
								4: data = {set_pc,7'b0,inst_read_done,7'b0};
								5: data = led_data <= {set_pc_addr};
								6: data = led_data <= {if_pc};
								7: data =  led_data <= {if_inst};
								8: data = {ram2_need_to_work_if,7'b0,ram2_work_done_if,7'b0};
								9: data = {ram2_work_res_if};
								default: vga_space = 1'b1;
							endcase
						end
						4:begin
							case (col[7:3])
								1: data = {id_inst};
								2: data = {id_pc};
								3: data ={id_mem_read,3'b0,id_mem_write,3'b0,id_reg_addr,3'b0,decoder_error, 1'b0, id_reg_write, 1'b0 };
								4: data = {exe_pc};
								5: data = {exe_inst};
								6: data = {exe_reg_write,3'b0,alu_flag,3'b0,exe_reg_addr,4'b0};
								7: data = {alu_op1};
								8: data = {alu_op2};
								9: data = {alu_res};
								default: vga_space = 1'b1;
							endcase
						end
						5:begin
							case (col[7:3])
								1: data = {exe_read_value1};
								2: data = {exe_read_value2};
								3: data = {exe_memwr_ctrl,1'b0,exe_memrd_ctrl,1'b0,wb_flag,1'b0,ram1_need_to_work,1'b0,ram2_need_to_work,1'b0,mem_wr,1'b0,flush,1'b0, data_ready, 1'b0};
								4: data = {exe_mem_data};
								5: data = {wb_res};
								6: data = {mem_work_res};
								7: data = {ram1_work_res};
								8: data = {ram2_work_res};
								9: data = {ram_status};
								default: vga_space = 1'b1;
							endcase
						end
						6:begin
							case (col[7:3])
								1: data = {ram_data};
								2: data = {ram_addr};
								3: data = {ram_pc};
								4: data = {ram2_status};
								5: data = { inst_done_pc };
								6: data = { ram_ctrl_done_pc };
								7: data = { flash_done_pc };
								8: data = { flash_controller_work_done, 7'b0, flash_controller_need_to_work, 7'b0 };
								9: data = { mem_act1[15:0] };
								default: vga_space = 1'b1;
							endcase
						end
						7:begin
							case (col[7:3])
								1: data = { mem_act2[15:0] };
								2: data = { mem_act[15:0] };
								3: data = {reg_debug_out[15:0]};
								4: data = {reg_debug_out[31:16]};
								5: data = {reg_debug_out[47:32]};
								6: data = {reg_debug_out[63:48]};
								7: data = {reg_debug_out[79:64]};
								8: data = {reg_debug_out[95:80]};
								9: data = {reg_debug_out[111:96]};
								default: vga_space = 1'b1;
							endcase
						end
						8:begin
							case (col[7:3])
								1: data = {reg_debug_out[127:112]};
								2: data = {reg_debug_out[143:128]};
								3: data = {reg_debug_out[159:144]};
								4: data = {reg_debug_out[175:160]};
								5: data = {reg_debug_out[191:176]};
								6: data = {reg_debug_out[207:192]};
								7: data = {reg_debug_out[223:208]};
								8: data = {reg_debug_out[239:224]};
								9: data = {reg_debug_out[255:240]};
								default: vga_space = 1'b1;
							endcase
						end
						9:begin
							case (col[7:3])
								1: data = { qfront, qtail };
								2: data = qfrontv;
								3: data = { uart_ready, 3'b0, uart_reading, 7'b0, flash_i_ready, 3'b0 };
								4: data = { uart_flags };
								5: data = { ram2_cnt };
								6: data = { flash_status };
								7: data = { right };
								8: data = { inst_read_done_pc };
								9: data = { combined_act[15:0] };
								default: vga_space = 1'b1;
							endcase
						end
						10:begin
							case (col[7:3])
								1: data = { send_cnt };
								2: data = { uart_operating };
								3: data = { ram1_flags, 12'b0 };
								default: vga_space = 1'b1;
							endcase
						end
						default: vga_space = 1;
					endcase
				end
			end
		end
		case (col[1:0])
			2'b00: vga_data = data[15:12];
			2'b01: vga_data = data[11:8];
			2'b10: vga_data = data[7:4];
			2'b11: vga_data = data[3:0];
		endcase
	end

endmodule

