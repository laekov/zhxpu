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
module ram2(
	input clk,
	input rst,

	input need_to_work_if,
	input need_to_work_exe,
	input mem_rd,
	input exe_mem_wr,
	input mem_wr,
	
	input [`MemAddr] mem_addr_if,
	input [`MemAddr] mem_addr_exe,
	input [`MemValue] mem_value_exe,

	output wire [`MemAddr] Ram2Addr,
	inout wire [`MemValue] Ram2Data,
	output reg Ram2OE,
	output reg Ram2WE,
	output reg Ram2EN,

	output wire if_work_done_out,
	output wire exe_work_done_out,
	output reg [`MemValue] if_result,
	output reg [`MemValue] exe_result,

	input wire [31:0] mem_act,
	output [31:0] mem_act_out,

	output wire [15:0] status_out,
	output wire [15:0] cnt_out

    );

	reg if_work_done;
	reg exe_work_done;


	reg [31:0] local_act;
	assign mem_act_out = local_act;
	
	assign if_work_done_out = if_work_done && local_act == mem_act;
	assign exe_work_done_out = exe_work_done && local_act == mem_act;
	 
	reg Ram2Writing;

	assign Ram2Data = Ram2Writing?mem_value_exe:16'bz;
	assign Ram2Addr = need_to_work_exe?mem_addr_exe:mem_addr_if;

	localparam IDLE = 8'b00000000;

	localparam RAM2_READ1 = 8'b10010001;
	localparam RAM2_READ2 = 8'b10010010;
	localparam RAM2_READ3 = 8'b10010011;

	localparam RAM2_READ4 = 8'b10010100;
	localparam RAM2_READ5 = 8'b10010101;
	localparam RAM2_READ6 = 8'b10010110;
	
	localparam RAM2_WRITE1 = 8'b10100001;
	localparam RAM2_WRITE2 = 8'b10100010;
	localparam RAM2_WRITE3 = 8'b10100011;
	localparam ERROR = 8'b11111101;
	
	reg [7:0] status;
	reg [7:0] next_status;
	assign status_out = { status, next_status };

	reg [`RamFrequency] cnt;
	reg [`RamFrequency] next_cnt;

	assign cnt_out = { cnt, 7'b0, next_cnt, 7'b0 };

	initial begin
		exe_work_done <= 1'b0;
		if_work_done <= 1'b0;
	end

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			status <= IDLE;
		end else begin
			case (status)
				IDLE: begin
					Ram2EN <= 1'b0;
					Ram2OE <= 1'b1;
					Ram2WE <= 1'b1;
					if (need_to_work_exe == 1'b1) begin
						if (mem_act === local_act) status <= IDLE;
						else if (mem_rd == 1'b1) begin
							status <= RAM2_READ1;
						end else if (exe_mem_wr == 1'b1) begin
							status <= RAM2_WRITE1;
						end else begin
							status <= IDLE;
						end
					end
					else if (need_to_work_if == 1'b1) begin
						if (mem_act === local_act) status <= IDLE;
						else status <= RAM2_READ4;
					end
				end

	always @(*) begin
		case (status)
			IDLE: begin
				if (need_to_work_exe == 1'b1) begin
					if (mem_act == local_act) next_status <= IDLE;
					else if (mem_rd == 1'b1) begin
						next_status <= RAM2_READ1;
					end else if (exe_mem_wr == 1'b1 || mem_wr) begin
						next_status <= RAM2_WRITE1;
					end else begin
						next_status <= IDLE;
					end
				end
			end
			RAM2_READ1: begin
				Ram2Writing <= 1'b0;
				exe_work_done <= 1'b0;
				status <= RAM2_READ2;
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;
			end
			RAM2_READ2: begin
				status <= RAM2_READ3;
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b0;
				Ram2WE <= 1'b1;
			end
			RAM2_READ3: begin
				exe_work_done <= 1'b1;
				exe_result <= Ram2Data;
				local_act <= mem_act;
				status <= IDLE;
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;
			end

			RAM2_READ4: begin
				Ram2Writing <= 1'b0;
				if_work_done <= 1'b0;
				status <= RAM2_READ5;
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;
			end
			RAM2_READ5: begin
				status <= RAM2_READ6;
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b0;
				Ram2WE <= 1'b1;
			end
			RAM2_READ6: begin
				if_work_done <= 1'b1;
				if_result <= Ram2Data;
				local_act <= mem_act;
				status <= IDLE;
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;
			end

			RAM2_WRITE1: begin
				Ram2Writing <= 1'b1;
				exe_work_done <= 1'b0;
				status <= RAM2_WRITE2;
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;
			end
			RAM2_WRITE2: begin
				status <= RAM2_WRITE3;
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b0;
			end
			RAM2_WRITE3: begin
				exe_work_done <= 1'b1;
				exe_result <= Ram2Data;
				local_act <= mem_act;
				status <= IDLE;
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b0;
			end

		endcase
	end

endmodule

