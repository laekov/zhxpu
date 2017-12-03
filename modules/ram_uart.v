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

	input wire [31:0] mem_act,
	output [31:0] mem_act_out,

	output wire [15:0] status_out,
	output wire uart_reading

    );

	reg [31:0] local_act;
	assign mem_act_out = local_act;

	reg [`QueueSize] queue_front;
	reg [`QueueSize] queue_tail;
	reg [`RegValue] queue [`QueueSizeH];

	assign front = queue_front;
	assign tail = queue_tail;
	assign queue_front_v = queue[queue_front];


	reg work_done;
	assign uart_work_done = work_done && mem_act == local_act;
	reg Ram1Writing;
	reg UartReading;
	assign uart_reading = UartReading;
	
	assign Ram1Addr = mem_addr;
	assign Ram1Data = Ram1Writing?mem_value:16'bz;

	localparam IDLE = 8'b00000000;
	
	localparam UART_READ1 = 8'b11010001;
	localparam UART_READ2 = 8'b11010010;
	localparam UART_READ3 = 8'b11010011;
	localparam UART_READ4 = 8'b11010100;

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
	
	localparam UART_READ_FROM_QUEUE1 = 8'b10000011;
	localparam UART_READ_FROM_QUEUE2 = 8'b10000111;

	localparam ERROR = 8'b11110101;

	reg [7:0] status;
	reg [7:0] next_status;
	assign status_out = { status, next_status };

	reg [`RamFrequency] cnt;
	reg [`RamFrequency] next_cnt;

	initial begin
		work_done <= 1'b0;
	end

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			status <= IDLE;
			queue_front <= 0;
			queue_tail <= 0;
		end
		else begin
			cnt <= cnt + 1;
			if (cnt == 0) begin
			//if (1'b1) begin
				case (status)
					IDLE: begin
						Ram1EN <= 1'b1;
						Ram1OE <= 1'b1;
						Ram1WE <= 1'b1;
						
						rdn <= 1'b1;
						wrn <= 1'b1;

						if (data_ready == 1'b1) begin
							status <= UART_READ1;
						end
						else begin
							if (need_to_work == 1'b1) begin
								if (mem_act == local_act) status <= IDLE;
								else if (mem_addr == `UartAddr) begin
									if (mem_wr == 1'b1) status <= UART_WRITE1;
									else if (mem_rd == 1'b1) status <= UART_READ_FROM_QUEUE1;
									else status <= ERROR;
								end
								else begin
									if (mem_wr == 1'b1) status <= RAM1_WRITE1;
									else if (mem_rd == 1'b1) status <= RAM1_READ1;
									else status <= ERROR;
								end	
							end
						end
						else status <= IDLE;
					end

					UART_READ_FROM_QUEUE1: begin
						work_done <= 1'b0;
						result <= queue[queue_front];
						status <= UART_READ_FROM_QUEUE2;
					end
					UART_READ_FROM_QUEUE2: begin
						work_done <= 1'b1;
						queue_front <= queue_front + 1;
						local_act <= mem_act;
						status <= IDLE;
					end

					UART_READ1: begin
						Ram1Writing <= 1'b0;
						if (data_ready == 1'b1) begin
							status <= UART_READ2;
							rdn <= 1'b0;
						end
						else status <= IDLE;
					end
					UART_READ2: begin
						queue[queue_tail] <= Ram1Data;
						status <= UART_READ3;
					end
					UART_READ3: begin
						queue_tail <= queue_tail + 1;
						rdn = 1'b1;
						status <= IDLE;
					end

					UART_WRITE1: begin
						wrn <= 1'b1;
						work_done <= 1'b0;
						Ram1Writing <= 1'b1;
						status <= UART_WRITE2;
					end
					UART_WRITE2: begin
						wrn <= 1'b0;
						status <= UART_WRITE3;
					end
					UART_WRITE3: begin
						wrn <= 1'b1;
						status <= UART_WRITE4;
					end
					UART_WRITE4: begin
						if (tbre == 1'b1) status <= UART_WRITE5;
					end
					UART_WRITE5: begin
						if (tsre == 1'b1) begin
							work_done <= 1'b1;
							local_act <= mem_act;
							status <= IDLE;
						end
					end

					RAM1_READ1: begin
						work_done <= 1'b0;
						Ram1Writing <= 1'b0;
						status <= RAM1_READ2;
					end
					RAM1_READ2: begin
						status <= RAM1_READ3;
					end
					RAM1_READ3: begin
						result <= Ram1Data;
						work_done <= 1'b1;
						local_act <= mem_act;
						status <= IDLE;
					end

					RAM1_WRITE1: begin
						work_done <= 1'b0;
						Ram1Writing <= 1'b1;
						sttus <= RAM1_WRITE2;
					end
					RAM1_WRITE2: begin
						sttus <= RAM1_WRITE3;
					end
					RAM1_WRITE3: begin
						work_done <= 1'b1;
						local_act <= mem_act;
						sttus <= IDLE;
					end
				endcase
			end
		end
	end

	always @(*) begin
		next_cnt <= cnt + 1;
		case (status)
			IDLE: begin
				if (data_ready == 1'b1) begin
					next_status <= UART_READ1;
				end
				else if (need_to_work == 1'b1) begin
					if (mem_act == local_act) next_status <= IDLE;
					else if (mem_addr == `UartAddr) begin
						if (mem_wr == 1'b1) next_status <= UART_WRITE1;
						else if (mem_rd == 1'b1) next_status <= UART_READ_FROM_QUEUE1;
						else next_status <= ERROR;
					end
					else begin
						if (mem_wr == 1'b1) next_status <= RAM1_WRITE1;
						else if (mem_rd == 1'b1) next_status <= RAM1_READ1;
						else next_status <= ERROR;
					end
				end
				else next_status <= IDLE;
			end

			UART_READ_FROM_QUEUE1: next_status <= UART_READ_FROM_QUEUE2;
			UART_READ_FROM_QUEUE2: next_status <= IDLE;

			UART_READ1: begin
				if (data_ready == 1'b1) next_status <= UART_READ2;
				else next_status <= UART_READ1;
			end
			UART_READ2: next_status <= UART_READ3;
			UART_READ3: next_status <= UART_READ4;
			UART_READ4: next_status <= IDLE;

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

			RAM1_READ1: next_status <= RAM1_READ2;
			RAM1_READ2: next_status <= RAM1_READ3;
			RAM1_READ3: next_status <= IDLE;

			RAM1_WRITE1 : next_status <= RAM1_WRITE2;
			RAM1_WRITE2 : next_status <= RAM1_WRITE3;
			RAM1_WRITE3 : next_status <= IDLE;

			default: next_status <= IDLE;
		endcase
	end

	always @(status) begin
		case (status)
			IDLE: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
				UartReading <= 1'b0;
			end

			UART_READ1: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;

				UartReading <= 1'b1;
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

				rdn <= 1'b0;
				wrn <= 1'b1;
				
				result <= result;
			end
			UART_READ4: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
			end



			UART_WRITE1: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b0;
				UartReading <= 1'b1;
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
				UartReading <= 1'b0;
			end

			RAM1_READ1: begin
				Ram1EN <= 1'b0;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
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
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
			end

			RAM1_WRITE1: begin
				Ram1EN <= 1'b0;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
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
				Ram1WE <= 1'b0;

				rdn <= 1'b1;
				wrn <= 1'b1;
			end

			UART_READ_FROM_QUEUE1: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
			end

			UART_READ_FROM_QUEUE2: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
			end
		endcase
	end


endmodule
