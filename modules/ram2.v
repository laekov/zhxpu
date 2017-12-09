`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:47:00 11/08/2017 
// Design Name: 
// Module Name:    ram2
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
`include "cache.v"

module ram2(
	input clk,
	input rst,

	input need_to_work_if,
	input need_to_work_exe,
	input mem_rd,
	input exe_mem_wr,
	input init_mem_wr,
	
	input [`MemAddr] mem_addr_if,
	input [`MemAddr] mem_addr_exe,
	input [`MemValue] mem_value_exe,

	output reg [`MemAddr] Ram2Addr,
	inout wire [`MemValue] Ram2Data,
	output reg Ram2OE,
	output reg Ram2WE,
	output reg Ram2EN,

	output wire if_work_done_out,
	output wire exe_work_done_out,
	output reg [`MemValue] if_result,
	output reg [`MemValue] exe_result,

	input wire [`ActBit] mem_act,
	output [`ActBit] mem_act_out,

	output wire [15:0] status_out,
	output wire [15:0] cnt_out,
	output reg [15:0] inst_read_done_pc,

	output wire ram2_writing_out

    );

	reg [`ActBit] local_act;
	assign mem_act_out = local_act;

	reg work_done_if;
	reg work_done_exe;

	wire act_exe;
	assign act_exe = mem_act !== local_act;
	wire act_if;
	assign act_if = mem_addr_if[15:0] !== inst_read_done_pc;

	
	assign if_work_done_out = work_done_if && !act_if;
	assign exe_work_done_out = work_done_exe && !act_exe;
	 

	reg [`MemValue] cache_write_value;
	reg cache_wr;
	wire [`MemValue] cache_res;
	wire present;
	wire dirty;
	wire [`MemAddr] wb_addr;
	wire [`MemValue] wb_value;
	wire wb_need;
	wire [`MemAddr] cache_addr;
	reg work_on_if = 1'b0;
	assign Ram2Data = wb_need?wb_value:16'bz;

	localparam IDLE = 3'b000;
	localparam RD1 = 3'b001;
	localparam RD2 = 3'b010;
	localparam RD3 = 3'b011;
	localparam RD4 = 3'b100;
	localparam WB1 = 3'b101;
	localparam WB2 = 3'b110;
	localparam WB3 = 3'b111;
	
	reg [3:0] status;
	assign cache_addr = need_to_work_exe && !work_on_if ? mem_addr_exe : mem_addr_if;

	assign status_out = { status, 13'b0 };

	cache __cache(
		.clk(clk),
		.rst(rst),
		.addr(cache_addr),
		.write_value(cache_write_value),
		.wr_ctrl(cache_wr),
		.feedback(cache_res),
		.present(present),
		.dirty(dirty),
		.wb_addr(wb_addr),
		.wb_value(wb_value),
		.wb_need(wb_need)
	);

	initial begin
		work_done_exe <= 1'b0;
		work_done_if <= 1'b0;
		local_act <= 32'hffffffff;
	end

	always @(posedge clk) begin
		if (!rst) begin
			status <= IDLE;
			inst_read_done_pc <= 16'hffff;
			local_act <= 32'hffffffff;
		end
		else begin
			case (status)
				IDLE: begin
					Ram2EN <= 1'b0;
					Ram2OE <= 1'b1;
					Ram2WE <= 1'b1;
					if (need_to_work_exe && act_exe) begin
						work_on_if <= 1'b0;
						Ram2Addr <= mem_addr_exe;
						if (mem_rd) begin
							if (present) begin
								exe_result <= cache_res;
								cache_wr <= 1'b0;
								work_done_exe <= 1'b1;
								local_act <= mem_act;
								status <= IDLE;
							end
							else begin
								cache_wr <= 1'b0;
								work_done_exe <= 1'b0;
								status <= RD1;
							end
						end
						else begin
							cache_wr <= 1'b1;
							cache_write_value <= mem_value_exe;
							work_done_exe <= 1'b0;
							status <= WB1;
						end
					end
					else if (need_to_work_if && act_if) begin
						work_on_if <= 1'b1;
						Ram2Addr <= mem_addr_if;
						if (present) begin
							if_result <= cache_res;
							cache_wr <= 1'b0;
							inst_read_done_pc <= mem_addr_if[15:0];
							work_done_if <= 1'b1;
							status <= IDLE;
						end
						else begin
							work_done_if <= 1'b0;
							cache_wr <= 1'b0;
							status <= RD1;
						end
					end
					else begin
						work_on_if <= 1'b0;
					end
				end
				RD1: begin
					Ram2OE <= 1'b0;
					status <= RD2;
				end
				RD2: begin
					Ram2OE <= 1'b1;
					if (need_to_work_exe) begin
						exe_result <= Ram2Data;
					end else begin
						if_result <= Ram2Data;
					end
					cache_wr <= 1'b1;
					cache_write_value <= Ram2Data;
					status <= WB1;
				end
				/*WB1: begin
					status <= WB2;
				end*/
				WB1: begin
					if (wb_need) begin
						cache_wr <= 1'b0;
						Ram2Addr <= wb_addr;
						Ram2WE <= 1'b0;
						status <= WB2;
					end 
					else begin
						cache_wr <= 1'b0;
						if (need_to_work_exe) begin
							work_done_exe <= 1'b1;
							local_act <= mem_act;
						end
						else begin
							inst_read_done_pc <= mem_addr_if[15:0];
							work_done_if <= 1'b1;
						end
						status <= IDLE;
					end
				end
				WB2: begin
					if (need_to_work_exe) begin
						work_done_exe <= 1'b1;
						local_act <= mem_act;
					end
					else begin
						inst_read_done_pc <= mem_addr_if[15:0];
						work_done_if <= 1'b1;
					end
					status <= IDLE;
					Ram2WE <= 1'b1;
				end
			endcase
			// end
		end
	end


	endmodule


