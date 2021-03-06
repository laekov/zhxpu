`timescale 1ns / 1ps

module ram_uart(
	input clk,
	input rst,

	input need_to_work,
	input mem_rd,
	input mem_wr,

	input [`MemAddr] mem_addr_in,
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

	output reg [`RegValue] send_cnt,
	output reg [15:0] uart_operating,
	output wire [3:0] flags_out
);
	reg [`MemAddr] mem_addr;
	reg [`ActBit] local_act;
	assign mem_act_out = local_act;
	wire act_done;
	assign act_done = mem_act == local_act;

	/*reg [`QueueSize] queue_front;
	reg [`QueueSize] queue_tail;
	reg [`RegValue] queue [`QueueSizeH];*/

	initial begin
//		queue_front = 0;
//		queue_tail = 0;
		send_cnt = 0;
		local_act = 16'hffff;
		uart_operating = 16'b0;
	end

	assign front = 16'b0;
	assign tail = { 15'b0, data_ready };
	// assign queue_front_v = queue[queue_front];

	reg work_done;
	assign uart_work_done = work_done && act_done;

	wire [3:0] work_flags;
	assign work_flags = { mem_addr == `UartAddr, mem_wr, mem_rd };

	assign flags_out = { act_done, work_flags };

	reg add_flag;

	localparam IDLE = 2'b00;
	localparam STG1 = 2'b01;
	localparam STG2 = 2'b10;
	localparam STG3 = 2'b11;

	reg [1:0] next_status;
	reg [1:0] status;

	assign Ram1Data = mem_rd ? 16'bZZZZZZZZZZZZZZZZ : mem_value;
	assign Ram1Addr = mem_addr;

	wire uart_opt;
	assign uart_opt = mem_addr == `UartAddr;

	initial begin
		status <= IDLE;
	end

	reg read_data;

	assign status_out = { status, 14'b0 };

	always @(negedge rst or posedge clk) begin
		if (!rst) begin
			local_act <= mem_act;
			status <= IDLE;
			//queue_front <= 0;
			//queue_tail <= 0;
		end else begin
			case (status)
				IDLE: begin
					Ram1EN <= 1'b1;
					Ram1OE <= 1'b1;
					Ram1WE <= 1'b1;
					rdn <= 1'b1;
					wrn <= 1'b1;
					read_data <= data_ready;
					mem_addr <= mem_addr_in;
					if (need_to_work && !act_done) begin
						status <= STG1;
						work_done <= 1'b0;
					end
				end

				STG1: begin
					if (uart_opt) begin
						if (mem_wr) begin
							{ add_flag, send_cnt } <= send_cnt + 1;
							wrn <= 1'b0;
							status <= STG2;
						end
						else if (data_ready) begin
							rdn <= 1'b0;
							status <= STG2;
						end 
						else begin
							status <= STG1;
						end
					end 
					else begin
						Ram1EN <= 1'b0;
						status <= STG2;
					end
				end

				STG2: begin
					if (uart_opt) begin
						if (mem_wr) begin
							wrn <= 1'b0;
						end
						else begin
							result <= Ram1Data;
						end
					end
					else begin
						if (mem_wr) begin
							Ram1WE <= 1'b0;
						end
						else begin
							Ram1OE <= 1'b0;
						end
					end
					status <= STG3;
				end

				STG3: begin
					if (uart_opt) begin
						if (mem_wr) begin
							wrn <= 1'b1;
							if (tbre && tsre) begin
								local_act <= mem_act;
								work_done <= 1'b1;
								status <= IDLE;
								{ add_flag, uart_operating } <= uart_operating + 1;
							end 
							else begin
								status <= STG3;
							end
						end
						else begin
							rdn <= 1'b1;
							local_act <= mem_act;
							work_done <= 1'b1;
							status <= IDLE;
						end
					end
					else begin
						if (mem_rd) begin
							result <= Ram1Data;
						end
						local_act <= mem_act;
						work_done <= 1'b1;
						status <= IDLE;
					end
				end
			endcase
		end
	end
endmodule

