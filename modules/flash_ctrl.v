`timescale 1ns / 1ps

`define CLK_CNT 22:0

module flash_ctrl(
	input clk,
	input rst,
	input [22:1] addr,
	input read_ctrl,
	inout wire [15:0] flash_data,
	output reg [22:0] flash_addr,
	output wire flash_byte,
	output wire flash_vpen,
	output wire flash_ce,
	output wire flash_rp,
	output reg flash_oe,
	output reg flash_we,
	output reg [15:0] data,
	output reg flash_ready,
	output wire [7:0] status_out
);
	localparam FLASH_IDLE = 8'b00000001;
	localparam FLASH_READ1 = 8'b00001001;
	localparam FLASH_READ2 = 8'b00001010;
	localparam FLASH_READ3 = 8'b00001011;
	localparam FLASH_READ4 = 8'b00001100;
	localparam FLASH_READ5 = 8'b00001101;

	assign flash_byte = 1'b1;
	assign flash_vpen = 1'b1;
	assign flash_ce = 1'b0;
	assign flash_rp = 1'b1;

	reg last_ctrl = 1'b0;

	reg [`CLK_CNT] clkc = 0;

	reg [7:0] status = FLASH_IDLE;
	reg [7:0] next_status;
	assign status_out = { next_status[3:0], status[3:0] };

	always @(*) begin
		case (status)
			FLASH_IDLE: next_status <= FLASH_IDLE;
			FLASH_READ1: next_status <= FLASH_READ2;
			FLASH_READ2: next_status <= FLASH_READ3;
			FLASH_READ3: next_status <= FLASH_READ4;
			FLASH_READ4: next_status <= FLASH_READ5;
			FLASH_READ5: next_status <= FLASH_IDLE;
			default: next_status <= 8'hff;
		endcase
	end

	reg [15:0] temp_data;
	assign flash_data = (status == FLASH_READ3 || status == FLASH_READ4) ? 16'bZ : temp_data;

	always @(posedge clk) begin
		if (!rst) begin
			status <= FLASH_IDLE;
			flash_ready <= 1'b0;
		end else begin
			clkc <= clkc + 1;
			if (status == FLASH_IDLE) begin
				if (read_ctrl) begin
					status <= FLASH_READ1;
					flash_we <= 1'b0;
					flash_ready <= 1'b0;
				end else begin
					flash_we <= 1'b1;
					status <= FLASH_IDLE;
				end
			end else if (clkc == 0) begin
				case (status)
					FLASH_READ1: begin
						flash_we <= 1'b0;
						temp_data <= 16'h00ff;
						flash_addr <= { addr, 1'b0 };
						status <= next_status;
					end
					FLASH_READ2: begin
						flash_we <= 1'b1;
						status <= next_status;
					end
					FLASH_READ3: begin
						flash_oe <= 1'b0;
						status <= next_status;
					end
					FLASH_READ4: begin
						flash_oe <= 1'b0;
						flash_addr <= { addr, 1'b0 };
						data <= flash_data;
						status <= next_status;
					end
					FLASH_READ5: begin
						flash_oe <= 1'b0;
						flash_ready <= 1'b1;
						status <= next_status;
					end
					default: begin
						flash_oe <= 1'b1;
						flash_we <= 1'b1;
						status <= 8'hff;
					end
				endcase
			end
		end
	end
endmodule

