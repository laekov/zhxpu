`timescale 1ns / 1ps

module ram_uart(
	input clk,
	input rst,

	input need_to_work,
	input mem_rd,
	input mem_wr,

	input [`MemAddr] mem_addr,
	input [`MemValue] mem_value,

	output wire [`MemAddr] Ram1Addr,
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

	output wire work_done,
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
	wire act_done;
	assign act_done = mem_act == local_act;

	reg [`QueueSize] queue_front;
	reg [`QueueSize] queue_tail;
	reg [`RegValue] queue [`QueueSizeH];

	initial begin
		queue_front = 0;
		queue_tail = 0;
		local_act = 16'hffff;
	end

	assign front = queue_front;
	assign tail = queue_tail;
	assign queue_front_v = queue[queue_front];

	reg work_done;
	assign uart_work_done = work_done && act_done;

	wire [3:0] work_flags;
	assign work_flags = { mem_addr == `UartAddr, mem_wr, mem_rd };

	assign flags_out = { act_done, work_flags };

	reg add_flag;

	localparam IDLE = 5'b11110;
	localparam ERROR = 5'b11101;
	localparam UART_READ1 = 5'b00001;
	localparam UART_READ2 = 5'b00010;
	localparam UART_READ3 = 5'b00011;
	localparam UART_WRITE1 = 5'b00100;
	localparam UART_WRITE2 = 5'b00101;
	localparam UART_WRITE3 = 5'b00110;
	localparam UART_WRITE4 = 5'b00111;
	localparam UART_WRITE5 = 5'b01000;
	localparam RAM1_READ1 = 5'b01001;
	localparam RAM1_READ2 = 5'b01010;
	localparam RAM1_READ3 = 5'b01011;
	localparam RAM1_WRITE1 = 5'b01001;
	localparam RAM1_WRITE2 = 5'b01010;
	localparam RAM1_WRITE3 = 5'b01011;
	localparam UART_READ_QUEUE1 = 5'b01111;
	localparam UART_READ_QUEUE2 = 5'b10000;

	reg [4:0] next_status;
	reg [4:0] status;

	initial begin
		status <= IDLE;
	end

	always @(*) begin
		case (status)
			IDLE:
			ERROR:
			UART_READ1:
			UART_READ2:
			UART_READ3:
			UART_WRITE1:
			UART_WRITE2:
			UART_WRITE3:
			UART_WRITE4:
			UART_WRITE5:
			RAM1_READ1:
			RAM1_READ2:
			RAM1_READ3:
			RAM1_WRITE1:
			RAM1_WRITE2:
			RAM1_WRITE3:
			UART_READ_QUEUE1:
			UART_READ_QUEUE2:
		endcase
	end
endmodule

