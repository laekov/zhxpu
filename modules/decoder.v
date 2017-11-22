`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:53:?? 11/21/1900
// Design Name: 
// Module Name:    decoder
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
`include "define.v"

module decoder(
	input rst,
	inout [15:0] op,

	output readable1,
	output wire[`RegAddr] read_addr1,

	output readble2,
	output [`RegAddr] read_addr2,

	output mem_read,
	output mem_write,
	output reg_write,
	output [`RegAddr] reg_addr
    );

	

	always @(*) begin
		case (opn[15:11])
			5'b01001: begin // ADDIU
				readble1 <= 1'b1;
				reg_addr <= opn[10:8];

				readble2 <= 1'b0;

				mem_read <= 1'b0;
				mem_write <= 1'b0;
				reg_write <= 1'b1;
				reg_addr <= opn[10:8];
			end
			5'b01000: begin // ADDIU3
			end
			5'b01100: begin
				if (opn[10:8] == 3'b011) begin // ADDSP
				end
				else if (opn[10:8] == 3'b000) begin // BTEQZ
				end
				else if ((opn[10:8] == 3'b100) && (opn[4:0] == 5'b00000)) begin // MTSP
				end
			end
			5'b11100: begin 
				if (opn[1:0] == 2'b01) begin// ADDU
					readble1 <= 1'b1;
					read_addr1 <= opn[10:8];

					readable2 <= 1'b1;
					read_addr2 <= opn[7:5];

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b1;
					reg_addr <= opn[4:2];
				end
				else begin //SUBU
				end
			end
			5'b11101: begin
				if (opn[4:0] == 5'b01100) begin // AND
				end
				else if (opn[7:0] == 8'b00000000) begin // JR
				end	
				else if (opn[4:0] == 5'b01010) begin //CMP
				end
				else if (opn[7:0] == 8'b01000000) begin //MFPC
				end
				else if (opn[4:0] == 5'b01101) begin //OR
				end
				else if (opn[7:0] == 8'b11000000) begin //JALR
				end
				else if (opn[10:0] == 11'b00000100000) begin //JRRA
				end
				else if (opn[4:0] == 5'b00111) begin //SRAV
				end
			end
			5'b00010: begin // B
			end
			5'b00100: begin //BEQZ
			end
			5'b00101: begin //BNEZ
				readble1 <= 1'b1;
				reg_addr1 <= opn[10:8];

				readble2 <= 1'b0;

				mem_read <= 1'b0;
				mem_write <= 1'b0;
				reg_write <= 1'b0;
			end
			5'b01101: begin //LI
				readable1 <= 1'b0;
				readable2 <= 1'b0;
				mem_read <= 1'b0;
				mem_write <= 1'b0;
				reg_addr <= opn[10:8];
				reg_write <= 1'b1;
			end
			5'b10011: begin // LW
			end
			5'b10010: begin //LW_SP
			end
			5'b11110: begin
				if (opn[7:0] == 8'b00000000) begin //MFIH
				end
				else if (opn[4:0] == 8'b00000001) begin //MTIH
				end
			end
			5'b00001: begin
				if (opn[10:0] == 11'b10000000000) begin //NOP
					readable1 <= 1'b0;

					readable2 <= 1'b0;

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b0;
				end
			end
			5'b00110: begin
				if (opn[1:0] == 2'b00) begin //SLL
					readable1 <= 1'b0;

					readable2 <= 1'b1;
					read_addr2 <= opn[7:5];

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b1;
					reg_addr <= opn[10:8];
				end
				else if (opn[1:0] == 2'b11) begin //SRA
				end
				else if (opn[1:0] == 2'b10) begin //SRL
				end
			end
			5'b11011: begin //SW
			end
			5'b11010: begin //SW_SP
			end
			5'b01111: begin
				if (opn[4:0] == 5'b00000) begin //MOVE
					readable1 <= 1'b0;

					readable2 <= 1'b1;
					read_addr2 <= opn[7:5];

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b1;
					reg_addr <= opn[10:8];
				end
			end
		endcase
	end


endmodule


