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

	output wire [`MemAddr] Ram2Addr,
	// output reg [`MemAddr] Ram2Addr,
	inout wire [`MemValue] Ram2Data,
	output reg Ram2OE,
	output reg Ram2WE,
	output reg Ram2EN,

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
//	reg Ram2Working;
//	reg UartWorking;

	reg work_done;
	assign uart_work_done = work_done;
	reg Ram1Writing;
	reg Ram2Writing;
	reg UartWriting;

	reg [`UartValue] temp_data;
	reg [`UartValue] temp_data1;
	reg [`UartValue] temp_data2;
	
	assign Ram1Data = Ram1Writing?mem_value:16'bz;
	assign Ram1Addr = mem_addr;
	assign Ram2Data = Ram2Writing?mem_value:16'bz;
	assign Ram2Addr = mem_addr;
	assign UartData = UartWriting?temp_data:8'bz;

	localparam IDLE = 8'b00000000;
	
	localparam UART_READ1 = 8'b11010001;
	localparam UART_READ2 = 8'b11010010;
	localparam UART_READ3 = 8'b11010011;
	localparam UART_READ4 = 8'b11010100;
	localparam UART_READ5 = 8'b11010101;
	localparam UART_READ6 = 8'b11010110;

	localparam UART_WRITE1 = 8'b11100001;
	localparam UART_WRITE2 = 8'b11100010;
	localparam UART_WRITE3 = 8'b11100011;
	localparam UART_WRITE4 = 8'b11100100;
	localparam UART_WRITE5 = 8'b11100101;
	localparam UART_WRITE6 = 8'b11100110;
	localparam UART_WRITE7 = 8'b11100111;
	localparam UART_WRITE8 = 8'b11101000;
	localparam UART_WRITE9 = 8'b11101001;
	localparam UART_WRITE10 = 8'b11101010;

	localparam RAM1_READ1 = 8'b01010001;
	localparam RAM1_READ2 = 8'b01010010;
	localparam RAM1_READ3 = 8'b01010011;
	
	localparam RAM1_WRITE1 = 8'b01100001;
	localparam RAM1_WRITE2 = 8'b01100010;
	localparam RAM1_WRITE3 = 8'b01100011;
	localparam RAM1_WRITE4 = 8'b01100100;

	localparam RAM2_READ1 = 8'b10010001;
	localparam RAM2_READ2 = 8'b10010010;
	localparam RAM2_READ3 = 8'b10010011;
	
	localparam RAM2_WRITE1 = 8'b10100001;
	localparam RAM2_WRITE2 = 8'b10100010;
	localparam RAM2_WRITE3 = 8'b10100011;
	localparam RAM2_WRITE4 = 8'b10100100;
	
	reg [7:0] status;
	assign status_out = status;
	reg [7:0] next_status;

	reg [`RamFrequency] cnt;
	reg [`RamFrequency] next_cnt;

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			status <= IDLE;
		end
		else begin
			cnt <= next_cnt;
			if (cnt == 0) begin
				status <= next_status;
			end
		end
	end

	always @(*) begin
		next_cnt <= cnt + 1;
		case (status)
			IDLE: begin
				next_status <= UART_READ1;
			end

			UART_READ1: begin
				if (need_to_work == 1'b1) begin
					if (mem_addr == `UartAddr) begin
						if (mem_wr == 1'b1) next_status <= UART_WRITE1;
						else begin
							if (data_ready == 1'b1) next_status <= UART_READ2;
							else next_status <= UART_READ1;
						end
					end
					else if (mem_addr[15:15] == 1'b1) begin
						if (mem_wr == 1'b1) next_status <= RAM1_WRITE1;
						else next_status <= RAM1_READ1;
					end
					else begin
						if (mem_wr == 1'b1) next_status <= RAM2_WRITE1;
						else next_status <= RAM2_READ1;
					end
				end
				else begin
					if (data_ready == 1'b1) next_status <= UART_READ2;
					else next_status <= UART_READ1;
				end
			end
			UART_READ2: next_status <= UART_READ3;
			UART_READ3: next_status <= UART_READ4;
			UART_READ4: begin
				if (data_ready == 1'b1) next_status <= UART_READ5;
				else next_status <= UART_READ4;
			end
			UART_READ5: next_status <= UART_READ6;
			UART_READ6: next_status <= IDLE;

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
			UART_WRITE5: next_status <= UART_WRITE6;
			UART_WRITE6: next_status <= UART_WRITE7;
			UART_WRITE7: next_status <= UART_WRITE8;
			UART_WRITE8: begin
				if (tbre == 1'b1) next_status <= UART_WRITE9;
				else next_status <= UART_WRITE8;
			end
			UART_WRITE9: begin
				if (tsre == 1'b1) next_status <= UART_WRITE10;
				else next_status <= UART_WRITE9;
			end
			UART_WRITE10: next_status <= IDLE;

			RAM1_READ1: next_status <= RAM1_READ2;
			RAM1_READ2: next_status <= RAM1_READ3;
			RAM1_READ3: next_status <= IDLE;

			RAM1_WRITE1 : next_status <= RAM1_WRITE2;
			RAM1_WRITE2 : next_status <= RAM1_WRITE3;
			RAM1_WRITE3 : next_status <= RAM1_WRITE4;
			RAM1_WRITE4 : next_status <= IDLE;

			RAM2_READ1: next_status <= RAM2_READ2;
			RAM2_READ2: next_status <= RAM2_READ3;
			RAM2_READ3: next_status <= IDLE;

			RAM2_WRITE1 : next_status <= RAM2_WRITE2;
			RAM2_WRITE2 : next_status <= RAM2_WRITE3;
			RAM2_WRITE3 : next_status <= RAM2_WRITE4;
			RAM2_WRITE4 : next_status <= IDLE;

			default: next_status <= IDLE;
		endcase
	end

	always @(posedge need_to_work) begin
	/*	if (mem_rd == 1'b1 || mem_wr == 1'b1) begin
			if (mem_addr == `UartAddr) begin
				UartWorking <= 1'b1;
				Ram1Working <= 1'b0;
				Ram2Working <= 1'b0;
			end
			else begin
				UartWorking <= 1'b0;
				if (1'b1 == 1'b1) begin//how to check ram1
					Ram1Working <= 1'b1;
					Ram2Working <= 1'b0;
				end
				else begin
					Ram1Working <= 1'b0;
					Ram2Working <= 1'b1;
				end
			end
		end
		else begin
			Ram1Working <= 1'b0;
			Ram2Working <= 1'b0;
			UartWorking <= 1'b0;
		end*/
	end

	always @(*) begin
		case (status)
			IDLE: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
			end
			UART_READ1: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;

//				UartWorking <= 1'b0;
			end
			UART_READ2: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b0;
				wrn <= 1'b1;
				work_done <= 1'b0;
			end
			UART_READ3: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;

				temp_data1 <= UartData;
			end
			UART_READ4: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;

//				UartWorking <= 1'b0;
			end
			UART_READ5: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b0;
				wrn <= 1'b1;
			end
			UART_READ6: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;

				result <= {temp_data1,UartData};
				work_done <= 1'b1;
//				UartWorking <= 1'b0;
			end

			UART_WRITE1: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;

				temp_data <= mem_value[15:8];
				work_done <= 1'b0;
			end
			UART_WRITE2: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b0;

				UartWriting <= 1'b1;
			end
			UART_WRITE3: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
			end
			UART_WRITE4: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
			end
			UART_WRITE5: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
			end
			UART_WRITE6: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;

				temp_data <= mem_value[7:0];
			end
			UART_WRITE7: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b0;

				UartWriting <= 1'b1;
			end
			UART_WRITE8: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
			end
			UART_WRITE9: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
			end
			UART_WRITE10: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;

				work_done <= 1'b1;
//				UartWorking <= 1'b0;
			end

			RAM1_READ1: begin
				Ram1EN <= 1'b0;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
				
				work_done <= 1'b0;
				Ram1Writing <= 1'b0;
				// Ram1Addr <= mem_addr;
			end
			RAM1_READ2: begin
				Ram1EN <= 1'b0;
				Ram1OE <= 1'b0;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
			end
			RAM1_READ3: begin
				Ram1EN <= 1'b0;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
				
				result <= Ram1Data;
				work_done <= 1'b1;
//				Ram1Working <= 1'b0;
			end

			RAM1_WRITE1: begin
				Ram1EN <= 1'b0;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
				
				work_done <= 1'b0;
				Ram1Writing <= 1'b1;
				// Ram1Addr <= mem_addr;
			end
			RAM1_WRITE2: begin
				Ram1EN <= 1'b0;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b0;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
			end
			RAM1_WRITE3: begin
				Ram1EN <= 1'b0;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
				
				work_done <= 1'b1;
//				Ram1Working <= 1'b0;
			end
			RAM1_WRITE4: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
			end

			RAM2_READ1: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b0;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
				
				work_done <= 1'b0;
				Ram2Writing <= 1'b0;
				// Ram2Addr <= mem_addr;
			end
			RAM2_READ2: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b0;
				Ram2OE <= 1'b0;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
			end
			RAM2_READ3: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b0;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
				
				result <= Ram2Data;
				work_done <= 1'b1;
//				Ram2Working <= 1'b0;
			end

			RAM2_WRITE1: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b0;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
				
				work_done <= 1'b0;
				Ram2Writing <= 1'b1;
				// Ram2Addr <= mem_addr;
			end
			RAM2_WRITE2: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b0;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b0;

				rdn <= 1'b1;
				wrn <= 1'b1;
			end
			RAM2_WRITE3: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b0;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
				
				work_done <= 1'b1;
//				Ram2Working <= 1'b0;
			end
			RAM2_WRITE4: begin
				Ram1EN <= 1'b1;
				Ram1OE <= 1'b1;
				Ram1WE <= 1'b1;

				Ram2EN <= 1'b1;
				Ram2OE <= 1'b1;
				Ram2WE <= 1'b1;

				rdn <= 1'b1;
				wrn <= 1'b1;
			end


		endcase
	end



endmodule
