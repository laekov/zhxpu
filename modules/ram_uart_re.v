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
	localparam UART_WRITE5 = 5'b01100;
	localparam RAM1_READ1 = 5'b01001;
	localparam RAM1_READ2 = 5'b01010;
	localparam RAM1_READ3 = 5'b01011;
	localparam RAM1_WRITE1 = 5'b01101;
	localparam RAM1_WRITE2 = 5'b01110;
	localparam RAM1_WRITE3 = 5'b01111;
	localparam UART_READ_QUEUE1 = 5'b10001;
	localparam UART_READ_QUEUE2 = 5'b10000;

	reg [4:0] next_status;
	reg [4:0] status;

	assign Ram1Data = status[4:4] == 1'b0 && status[2:2] == 1'b0 ? 16'bZZZZZZZZZZZZZZZZ : mem_value;
	assign Ram1Addr = mem_addr;

	initial begin
		status <= IDLE;
	end

	assign status_out = { status, next_status, 4'b0, status == 5'bZZZZZ, status == 5'b00000 };

	always @(negedge rst or posedge clk) begin
		if (!rst) begin
			local_act <= mem_act;
			status <= IDLE;
			queue_front <= 0;
			queue_tail <= 0;
		end else begin
			status <= next_status | 5'b00000;
			case (status)
				IDLE: begin
					Ram1EN <= 1'b1;
					Ram1OE <= 1'b1;
					Ram1WE <= 1'b1;
					rdn <= 1'b1;
					wrn <= 1'b1;
				end

				UART_READ1: begin
					rdn <= 1'b0;
				end
				UART_READ2: begin
					queue[queue_tail] <= Ram1Data;
				end
				UART_READ3: begin
					{ add_flag, queue_tail } <= queue_tail + 1;
				end

				UART_WRITE1: begin
					work_done <= 1'b0;
					wrn <= 1'b1;
				end
				UART_WRITE2: begin
					wrn <= 1'b0;
				end
				UART_WRITE3: begin
					work_done <= 1'b1;
					wrn <= 1'b1;
					local_act <= mem_act;
				end

				RAM1_READ1: begin
					work_done <= 1'b0;
					Ram1EN <= 1'b0;
				end
				RAM1_READ2: begin
					Ram1OE <= 1'b0;
				end
				RAM1_READ3: begin
					work_done <= 1'b1;
					result <= Ram1Data;
					local_act <= mem_act;
				end

				RAM1_WRITE1: begin
					work_done <= 1'b0;
					Ram1EN <= 1'b0;
				end
				RAM1_WRITE2: begin
					Ram1WE <= 1'b0;
				end
				RAM1_WRITE3: begin
					work_done <= 1'b1;
					Ram1WE <= 1'b1;
					local_act <= mem_act;
				end

				UART_READ_QUEUE1: begin
					result <= queue[queue_front];
					work_done <= 1'b0;
					local_act <= mem_act;
				end
				UART_READ_QUEUE2: begin
					work_done <= 1'b1;
					{ add_flag, queue_front } <= queue_front + 1;
				end
			endcase
		end
	end

	always @(*) begin
		case (status)
			IDLE: begin
				if (data_ready) begin
					next_status <= UART_READ1;
				end
				else if (act_done || !need_to_work) begin
					next_status <= IDLE;
				end 
				else if (mem_addr == `UartAddr) begin
					next_status <= mem_wr ? UART_WRITE1 : UART_READ_QUEUE1;
				end
				else begin
					next_status <= mem_wr ? RAM1_WRITE1 : RAM1_READ1;
				end
			end
			ERROR: next_status <= ERROR;
			UART_READ1: next_status <= UART_READ2;
			UART_READ2: next_status <= UART_READ3;
			UART_READ3: next_status <= IDLE;
			UART_WRITE1: next_status <= UART_WRITE2;
			UART_WRITE2: next_status <= tbre ? UART_WRITE2 : UART_WRITE3;
			UART_WRITE3: next_status <= UART_WRITE4;
			UART_WRITE4: next_status <= tbre ? UART_WRITE5 : UART_WRITE4;
			UART_WRITE5: next_status <= tsre ? IDLE : UART_WRITE5;
			RAM1_READ1: next_status <= RAM1_READ2;
			RAM1_READ2: next_status <= RAM1_READ3;
			RAM1_READ3: next_status <= IDLE;
			RAM1_WRITE1: next_status <= RAM1_WRITE2;
			RAM1_WRITE2: next_status <= RAM1_WRITE3;
			RAM1_WRITE3: next_status <= IDLE;
			UART_READ_QUEUE1: next_status <= UART_READ_QUEUE2;
			UART_READ_QUEUE2: next_status <= RAM1_WRITE2;
			default: next_status <= ERROR;
		endcase
	end
endmodule

