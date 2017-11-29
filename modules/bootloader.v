`timescale 1ns / 1ps
module bootloader(
	input clk,
	input next,
	output reg [22:0] flash_addr,
	inout wire [15:0] flash_data,
	output reg flash_byte,
	output reg flash_vpen,
	output reg flash_ce,
	output reg flash_oe,
	output reg flash_we,
	output reg flash_rp,
	output reg [15:0] data
);

	reg [22:0] caddr = 23'b0;
	reg [22:0] tmp;
	reg initialized = 1'b0;

	reg [15:0] temp_data;
	assign flash_data = temp_data;

	always @(*) begin
		if (!initialized) begin
			flash_byte <= 1'b1;
			flash_vpen <= 1'b1;
			flash_rp <= 1'b1;
			initialized <= 1'b1;
		end
	end

	reg write_flash = 1'b0;
	reg [15:0] flash_data_r;
	assign flash_data = write_flash ? flash_data_r : 'bz;

	localparam FLASH_IDLE = 8'h01;
	localparam FLASH_READ1 = 8'h11;
	localparam FLASH_READ2 = 8'h12;
	localparam FLASH_READ3 = 8'h13;
	localparam FLASH_READ4 = 8'h14;

	reg [7:0] status = FLASH_IDLE;
	reg [7:0] next_status;

	always @(*) begin
		case (status)
			FLASH_IDLE: next_status <= FLASH_IDLE;
			FLASH_READ1: next_status <= FLASH_READ2;
			FLASH_READ2: next_status <= FLASH_READ3;
			FLASH_READ3: next_status <= FLASH_READ4;
			FLASH_READ4: next_status <= FLASH_IDLE;
		endcase
	end

	always @(negedge clk) begin
		status <= next_status;
	end

	always @(posedge clk or posedge next) begin
		if (next) begin
			status <= FLASH_READ1;
			caddr <= caddr + 23'h1;
		end else begin
			case (status)
				FLASH_IDLE: begin
					flash_oe <= 1'b1;
					flash_we <= 1'b1;
				end
				FLASH_READ1: begin
					flash_we <= 1'b0;
					temp_data <= 16'h00ff;
				end
				FLASH_READ2: begin
					flash_we <= 1'b1;
				end
				FLASH_READ3: begin
					flash_oe <= 1'b0;
					flash_addr <= caddr;
					temp_data <= 16'bZ;
				end
				FLASH_READ4: begin
					data <= temp_data;
				end
				default: begin
					flash_oe <= 1'b1;
					flash_we <= 1'b1;
				end
			endcase
		end
	end
endmodule

