`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:47:00 11/08/2017 
// Design Name: 
// Module Name:    ram_uart
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
module ram_uart(
	input clk,
	input rst,

	input need_to_work,
	input mem_rd,
	input mem_wr,
	
	input [`MemAddr] mem_addr,
	input [`MemValue] mem_value,

	output wire [`MemAddr] Ram1Addr,
	// output reg [`MemAddr] Ram1Addr,
	inout wire [`MemValue] Ram1Data,
	output reg Ram1OE,
	output reg Ram1WE,
	output reg Ram1EN,

	inout wire [`UartValue] UartData,
	output reg UartOE,
	output reg UartWE,
	output reg UartEN,
	input data_ready,
	output reg rdn,
	input tbre,
	input tsre,
	output reg wrn,

	output wire uart_work_done,
	output reg [`MemValue] result,

	output wire [7:0] status_out

    );

//	reg Ram1Working;
	reg UartWorking;

	reg work_done;
	assign uart_work_done = work_done;
	reg Ram1Writing;
	reg UartWriting;

	reg [`UartValue] temp_data;
	
	assign Ram1Addr = mem_addr;
	assign UartData = UartWriting?temp_data:8'bz;
	assign Ram1Data = UartWorking?{8'b0, UartData}:(Ram1Writing?mem_value:16'bz);

	localparam IDLE = 8'b00000000;
	
	localparam UART_READ1 = 8'b11010001;
	localparam UART_READ2 = 8'b11010010;
	localparam UART_READ3 = 8'b11010011;

	localparam UART_WRITE1 = 8'b11100001;
	localparam UART_WRITE2 = 8'b11100010;
	localparam UART_WRITE3 = 8'b11100011;
	localparam UART_WRITE4 = 8'b11100100;
	localparam UART_WRITE5 = 8'b11100101;

	localparam RAM1_READ1 = 8'b01010001;
	localparam RAM1_READ2 = 8'b01010010;
	localparam RAM1_READ3 = 8'b01010011;
	
	localparam RAM1_WRITE1 = 8'b01100001;
	localparam RAM1_WRITE2 = 8'b01100010;
	localparam RAM1_WRITE3 = 8'b01100011;

	reg [7:0] status;
	assign status_out = status;
	reg [7:0] next_status;

	reg [`RamFrequency] cnt;
	reg [`RamFrequency] next_cnt;

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			status <= IDLE;
			work_done <= 1'b0;
		end
		else begin
			cnt <= next_cnt;
			if (cnt == 0) begin
				status <= next_status;
				if (status == UART_READ3 || status == UART_WRITE5 || status == RAM1_READ3 || status == RAM1_WRITE3) begin
					work_done <= 1'b1;
				end
				else if (next_status == UART_READ1 || next_status == UART_WRITE1 || next_status == RAM1_READ1 || next_status == RAM1_WRITE1) begin
					work_done <= 1'b0;
				end
			end

			case (status)
				IDLE: begin
					Ram1EN <= 1'b1;
					Ram1OE <= 1'b1;
					Ram1WE <= 1'b1;
	
					rdn <= 1'b1;
					wrn <= 1'b1;
				end

				UART_READ1: begin
					Ram1EN <= 1'b1;
					Ram1OE <= 1'b1;
					Ram1WE <= 1'b1;
	
					rdn <= 1'b1;
					wrn <= 1'b1;
	
					UartWorking <= 1'b1;
					UartWriting <= 1'b0;
				end
				UART_READ2: begin
					Ram1EN <= 1'b1;
					Ram1OE <= 1'b1;
					Ram1WE <= 1'b1;
	
					rdn <= 1'b0;
					wrn <= 1'b1;
				end
				UART_READ3: begin
					Ram1EN <= 1'b1;
					Ram1OE <= 1'b1;
					Ram1WE <= 1'b1;
	
					rdn <= 1'b1;
					wrn <= 1'b1;

					result <= Ram1Data;
					UartWorking <= 1'b0;
				end
	
				UART_WRITE1: begin
					Ram1EN <= 1'b1;
					Ram1OE <= 1'b1;
					Ram1WE <= 1'b1;
	
					rdn <= 1'b1;
					wrn <= 1'b1;
	
					UartWorking <= 1'b1;
					UartWriting <= 1'b1;
					temp_data <= mem_value[7:0];
				end
				UART_WRITE2: begin
					Ram1EN <= 1'b1;
					Ram1OE <= 1'b1;
					Ram1WE <= 1'b1;
	
					rdn <= 1'b1;
					wrn <= 1'b0;
				end
				UART_WRITE3: begin
					Ram1EN <= 1'b1;
					Ram1OE <= 1'b1;
					Ram1WE <= 1'b1;
	
					rdn <= 1'b1;
					wrn <= 1'b1;
				end
				UART_WRITE4: begin
					Ram1EN <= 1'b1;
					Ram1OE <= 1'b1;
					Ram1WE <= 1'b1;
	
					rdn <= 1'b1;
					wrn <= 1'b1;
				end
				UART_WRITE5: begin
					Ram1EN <= 1'b1;
					Ram1OE <= 1'b1;
					Ram1WE <= 1'b1;
	
					rdn <= 1'b1;
					wrn <= 1'b1;

					UartWorking <= 1'b0;
				end
	
				RAM1_READ1: begin
					Ram1EN <= 1'b0;
					Ram1OE <= 1'b0;
					Ram1WE <= 1'b1;
	
					rdn <= 1'b1;
					wrn <= 1'b1;
					
					Ram1Writing <= 1'b0;
				end
				RAM1_READ2: begin
					Ram1EN <= 1'b0;
					Ram1OE <= 1'b0;
					Ram1WE <= 1'b1;
	
					rdn <= 1'b1;
					wrn <= 1'b1;
				end
				RAM1_READ3: begin
					Ram1EN <= 1'b0;
					Ram1OE <= 1'b0;
					Ram1WE <= 1'b1;
	
					rdn <= 1'b1;
					wrn <= 1'b1;
					
					result <= Ram1Data;
				end
	
				RAM1_WRITE1: begin
					Ram1EN <= 1'b0;
					Ram1OE <= 1'b1;
					Ram1WE <= 1'b1;
	
					rdn <= 1'b1;
					wrn <= 1'b1;
					
					Ram1Writing <= 1'b1;
				end
				RAM1_WRITE2: begin
					Ram1EN <= 1'b0;
					Ram1OE <= 1'b1;
					Ram1WE <= 1'b0;
	
					rdn <= 1'b1;
					wrn <= 1'b1;
				end
				RAM1_WRITE3: begin
					Ram1EN <= 1'b0;
					Ram1OE <= 1'b1;
					Ram1WE <= 1'b1;
	
					rdn <= 1'b1;
					wrn <= 1'b1;
					
				end
	
			endcase
	
		end
	end

	always @(*) begin
		next_cnt <= cnt + 1;
		case (status)
			IDLE: begin
				if (need_to_work == 1'b1) begin
					if (mem_addr == `UartAddr) begin
						if (mem_wr == 1'b1) next_status <= UART_WRITE1;
						else if (mem_rd == 1'b1) next_status <= UART_READ1;
						else next_status <= IDLE;
					end
					else begin
						if (mem_wr == 1'b1) next_status <= RAM1_WRITE1;
						else next_status <= RAM1_READ1;
					end
				end
				else next_status <= IDLE;
			end

			UART_READ1: begin
				if (data_ready == 1'b1) next_status <= UART_READ2;
				else next_status <= UART_READ1;
			end
			UART_READ2: next_status <= UART_READ3;
			UART_READ3: next_status <= IDLE;

			UART_WRITE1: next_status <= UART_WRITE2;
			UART_WRITE2: next_status <= UART_WRITE3;
			UART_WRITE3: begin
				if (tbre == 1'b1) next_status <= UART_WRITE4;
				else next_status <= UART_WRITE3;
			end
			UART_WRITE4: begin
				if (tsre == 1'b1) next_status <= UART_WRITE5;
				else next_status <= UART_WRITE4;
			end
			UART_WRITE5: next_status <= IDLE;

			RAM1_READ1: next_status <= RAM1_READ3;
			RAM1_READ2: next_status <= RAM1_READ3;
			RAM1_READ3: next_status <= IDLE;

			RAM1_WRITE1 : next_status <= RAM1_WRITE2;
			RAM1_WRITE2 : next_status <= RAM1_WRITE3;
			RAM1_WRITE3 : next_status <= IDLE;

			default: next_status <= IDLE;
		endcase
	end


endmodule
