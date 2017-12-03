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
	input mem_wr,
	
	input [`MemAddr] mem_addr_if,
	input [`MemAddr] mem_addr_exe,
	input [`MemValue] mem_value_exe,

	output reg [`MemAddr] Ram2Addr,
	inout wire [`MemValue] Ram2Data,
	output reg Ram2OE,
	output reg Ram2WE,
	output reg Ram2EN,

	output reg if_work_done,
	output reg exe_work_done,
	output reg [`MemValue] if_result,
	output reg [`MemValue] exe_result,

	output wire [15:0] status_out,
	output wire [15:0] cnt_out

    );
	 
	reg Ram2Writing;

	assign Ram2Data = Ram2Writing?mem_value_exe:16'bz;

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

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			status <= IDLE;
			exe_work_done <= 1'b0;
			if_work_done <= 1'b0;
		end
		else begin
			cnt <= next_cnt;
			if (cnt == 0) begin
			// if (1'b1) begin
				status <= next_status;
				if (next_status == RAM2_WRITE1 || next_status == RAM2_READ1) exe_work_done <= 1'b0;
				if (status == RAM2_READ3 || status == RAM2_WRITE3) exe_work_done <= 1'b1;
				if (next_status == RAM2_READ4) if_work_done <= 1'b0;
				if (status == RAM2_READ6) if_work_done <= 1'b1;
			end
		end
	end
	
	always @(posedge clk) begin
		case (status)
			IDLE: begin
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;
			end

			RAM2_READ1: begin
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b0;
				Ram2WE <= 1'b1;

				Ram2Addr <= mem_addr_exe;
				Ram2Writing <= 1'b0;
			end
			RAM2_READ2: begin
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b0;
				Ram2WE <= 1'b1;
			end
			RAM2_READ3: begin
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b0;
				Ram2WE <= 1'b1;

				exe_result <= Ram2Data;
			end

			RAM2_READ4: begin
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b0;
				Ram2WE <= 1'b1;

				Ram2Addr <= mem_addr_if;
				Ram2Writing <= 1'b0;
			end
			RAM2_READ5: begin
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b0;
				Ram2WE <= 1'b1;
			end
			RAM2_READ6: begin
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b0;
				Ram2WE <= 1'b1;

				if_result <= Ram2Data;
			end

			RAM2_WRITE1: begin
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				Ram2Writing <= 1'b1;
				Ram2Addr <= mem_addr_exe;
			end
			RAM2_WRITE2: begin
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b0;

			end
			RAM2_WRITE3: begin
				Ram2EN <= 1'b0;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;
			end

		endcase

	end

	always @(*) begin
		next_cnt <= cnt + 1;
		case (status)
			IDLE: begin
				if (need_to_work_exe == 1'b1) begin
					if (mem_rd == 1'b1) begin
						next_status <= RAM2_READ1;
					end else if (mem_wr == 1'b1) begin
						next_status <= RAM2_WRITE1;
					end else begin
						next_status <= ERROR;
					end
				end
				else if (need_to_work_if == 1'b1) begin
					next_status <= RAM2_READ4;
				end
				else begin
					next_status <= IDLE;
				end
			end

			RAM2_READ1: next_status <= RAM2_READ2;
			RAM2_READ2: next_status <= RAM2_READ3;
			RAM2_READ3: next_status <= IDLE;

			RAM2_READ4: next_status <= RAM2_READ5;
			RAM2_READ5: next_status <= RAM2_READ6;
			RAM2_READ6: next_status <= IDLE;

			RAM2_WRITE1 : next_status <= RAM2_WRITE2;
			RAM2_WRITE2 : next_status <= RAM2_WRITE3;
			RAM2_WRITE3 : next_status <= IDLE;

			default: next_status <= ERROR;
		endcase
	end


	endmodule

