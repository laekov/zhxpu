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
	input clk2,
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

	output wire [`QueueSize] front,
	output wire [`QueueSize] tail,
	output wire [`RegValue] queue_front_v,

	input wire [`ActBit] mem_act,
	output [`ActBit] mem_act_out,

	output wire [15:0] status_out,
	output wire uart_reading,

	output wire [`RegValue] send_cnt,
	output reg [15:0] uart_operating,
	output wire [3:0] flags_out
    );

	reg [`ActBit] local_act;
	assign mem_act_out = local_act;

	reg [`QueueSize] queue_front;
	reg [`QueueSize] queue_tail;
	reg [`RegValue] queue [`QueueSizeH];

	assign front = queue_front;
	assign tail = queue_tail;
	assign queue_front_v = queue[queue_front];

	reg [15:0] send_count;
	assign send_count_out = send_count;


	reg work_done;
	assign uart_work_done = work_done === 1'b1 && mem_act === local_act;
	reg Ram1Writing;
	assign ram1_writing_out = Ram1Writing;
	reg UartReading;
	assign uart_reading = UartReading;
	
	assign Ram1Addr = mem_addr;
	assign Ram1Data = Ram1Writing?mem_value:16'bz;

	localparam IDLE = 5'b11000;
	
	localparam UART_READ1 = 5'b00001;
	localparam UART_READ2 = 5'b00010;
	localparam UART_READ3 = 5'b00011;
	localparam UART_READ4 = 5'b00100;

	localparam UART_WRITE1 = 5'b00101;
	localparam UART_WRITE2 = 5'b00110;
	localparam UART_WRITE3 = 5'b00111;
	localparam UART_WRITE4 = 5'b01000;
	localparam UART_WRITE5 = 5'b01001;

	localparam RAM1_READ1 = 5'b01010;
	localparam RAM1_READ2 = 5'b01011;
	localparam RAM1_READ3 = 5'b01100;
	
	localparam RAM1_WRITE1 = 5'b01101;
	localparam RAM1_WRITE2 = 5'b01110;
	localparam RAM1_WRITE3 = 5'b01111;
	
	localparam UART_READ_FROM_QUEUE1 = 5'b10000;
	localparam UART_READ_FROM_QUEUE2 = 5'b10001;

	localparam ERROR = 5'b11110;

	reg [4:0] status;
	assign status_out = { status, 11'b0 };

	initial begin
		work_done <= 1'b0;
		status <= IDLE;
		uart_operating = 16'h1234;
	end

	assign send_cnt = { 15'b0 };

	wire [3:0] work_flags;

	assign work_flags = { mem_addr == `UartAddr, mem_wr, mem_rd };

	wire act_done;
	assign act_done = mem_act == local_act;

	assign flags_out = { act_done, work_flags };

	reg add_flag;

	always @(posedge clk) begin
		case (status)
			IDLE: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;

				if (data_ready === 1'b1) begin
					status <= UART_READ1;
					uart_operating[7:0] <= 8'hf0;
				end
				else if (need_to_work == 1'b1) begin
					if (act_done) begin
						uart_operating[7:0] <= 8'ha0;
						status <= IDLE;
					end 
					else begin
						case (work_flags)
							3'b110: begin
								uart_operating[7:0] <= 8'h01;
								status <= UART_WRITE1;
								work_done <= 1'b0;
							end
							3'b101: begin
								uart_operating[7:0] <= 8'h02;
								status <= UART_READ_FROM_QUEUE1;
								work_done <= 1'b0;
							end
							3'b010: begin
								uart_operating[7:0] <= 8'h11;
								status <= RAM1_WRITE1;
								work_done <= 1'b0;
							end
							3'b001: begin
								uart_operating[7:0] <= 8'h12;
								status <= RAM1_READ1;
								work_done <= 1'b0;
							end
							default: begin
								uart_operating[7:0] <= 8'h0f;
								status <= ERROR;
							end
						endcase
					end
				end 
				else begin
					uart_operating[7:0] <= 8'hd0;
					status <= IDLE;
				end
			end

			UART_READ_FROM_QUEUE1: begin
				work_done <= 1'b0;
				result <= queue[queue_front];
				status <= UART_READ_FROM_QUEUE2;
				uart_operating[15:8] <= 8'h01;
			end
			UART_READ_FROM_QUEUE2: begin
				work_done <= 1'b1;
				{ add_flag, queue_front } <= queue_front + 1;
				local_act <= mem_act;
				status <= IDLE;
				uart_operating[15:8] <= 8'h02;
			end

			UART_READ1: begin
				Ram1Writing <= 1'b0;
				uart_operating[15:8] <= 8'h11;
				if (data_ready == 1'b1) begin
					status <= UART_READ2;
					rdn <= 1'b0;
				end
				else begin
					status <= IDLE;
				end
			end
			UART_READ2: begin
				uart_operating[15:8] <= 8'h12;
				queue[queue_tail] <= Ram1Data;
				status <= UART_READ3;
			end
			UART_READ3: begin
				uart_operating[15:8] <= 8'h13;
				{ add_flag, queue_tail } <= queue_tail + 1;
				rdn <= 1'b1;
				status <= IDLE;
			end

			UART_WRITE1: begin
				uart_operating[15:8] <= 8'h21;
				wrn <= 1'b1;

				work_done <= 1'b0;
				Ram1Writing <= 1'b1;
				status <= UART_WRITE2;

				// fail_cnt <= 32'h1;
			end
			UART_WRITE2: begin
				uart_operating[15:8] <= 8'h22;
				wrn <= 1'b0;
				if (tbre == 1'b0) status <= UART_WRITE3;
				else status <= UART_WRITE2;
			end
			UART_WRITE3: begin
				uart_operating[15:8] <= 8'h23;
				wrn <= 1'b1;
				status <= UART_WRITE4;
			end
			UART_WRITE4: begin
				uart_operating[15:8] <= 8'h24;
				if (tbre == 1'b1) status <= UART_WRITE5;
				else status <= UART_WRITE4;
			end
			UART_WRITE5: begin
				uart_operating[15:8] <= 8'h25;
				if (tsre == 1'b1) begin
					work_done <= 1'b1;
					local_act <= mem_act;
					status <= IDLE;
					//fail_cnt <= fail_cnt + 1;
				end else begin
					status <= UART_WRITE5;
				end
			end

			RAM1_READ1: begin
				uart_operating[15:8] <= 8'h31;
				Ram1EN <= 1'b0;

				work_done <= 1'b0;
				Ram1Writing <= 1'b0;
				status <= RAM1_READ2;
			end
			RAM1_READ2: begin
				uart_operating[15:8] <= 8'h32;
				Ram1OE <= 1'b0;
				status <= RAM1_READ3;
			end
			RAM1_READ3: begin
				uart_operating[15:8] <= 8'h33;
				result <= Ram1Data;
				work_done <= 1'b1;
				local_act <= mem_act;
				status <= IDLE;
			end

			RAM1_WRITE1: begin
				uart_operating[15:8] <= 8'h41;
				Ram1EN <= 1'b0;

				work_done <= 1'b0;
				Ram1Writing <= 1'b1;
				status <= RAM1_WRITE2;
			end
			RAM1_WRITE2: begin
				uart_operating[15:8] <= 8'h42;
				Ram1WE <= 1'b0;

				status <= RAM1_WRITE3;
			end
			RAM1_WRITE3: begin
				uart_operating[15:8] <= 8'h43;
				Ram1WE <= 1'b1;

				work_done <= 1'b1;
				local_act <= mem_act;
				status <= IDLE;
			end
			default: begin
				uart_operating[15:8] <= 8'hf1;
				status <= ERROR;
			end
		endcase
	end

	endmodule
