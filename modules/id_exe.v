`timescale 1ns / 1ps
// TODO fix pc and pcout
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:46:?? 11/22/1900
// Design Name: 
// Module Name:    id_exe
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

module id_exe(
	input clk,
	input pclk,
	input rst,
	
	input mem_write,
	input mem_read,
	input reg_write,
	input [`RegAddr] reg_addr,

	output reg mem_write_out,
	output reg mem_read_out,
	output reg reg_write_out,
	output reg [`RegAddr] reg_addr_out,

	input [`RegValue] read_value1,
	input [`RegValue] read_value2,

	input hold,
	input flush,
	input [`RegValue] outd,
	input [`RegValue] pc,
	input [`RegValue] opn,
	output reg [`RegValue] pc_out,
	output reg [`RegValue] opn_out,

	output reg [`RegValue] op1,
	output reg [`RegValue] op2,
	output reg [`RegValue] mem_write_value,

	output reg read_value1_output,
	output reg read_value2_output
    );


	always @(posedge clk or posedge flush) begin
		if (hold) begin
		end else if (flush == 1'b1) begin
			op1 <= 16'b0;
			op2 <= 16'b0;
			mem_write_out <= 1'b0;
			mem_read_out <= 1'b0;
			reg_write_out <= 1'b0;
			reg_addr_out <= 'b0;
			opn_out <= 16'b0000100000000000;
		end else begin
			opn_out <= opn;
			pc_out <= pc;
			mem_write_out <= mem_write;
			mem_read_out <= mem_read;
			reg_write_out <= reg_write;
			reg_addr_out <= reg_addr;
			case (opn[15:11])
				5'b01001: begin // ADDIU
					op1 <= read_value1;
					if (opn[7:7] == 1'b1) op2 <= {8'b11111111,opn[7:0]};
					else op2 <= {8'b0,opn[7:0]};
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
						op1 <= read_value1;
						op2 <= read_value2;
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
					op1 <= read_value1;
					op2 <= { ((opn[7:7] == 1'b1) ? 8'hff : 8'h00), opn[7:0] };
				end
				5'b01101: begin //LI
					op1 <= {8'b0,opn[7:0]};
					op2 <= 16'b0;
				end
				5'b10011: begin // LW
					op1 <= read_value1;
					if (opn[7:7] == 1'b1) op2 <= {8'b11111111,opn[7:0]};
					else op2 <= {8'b0,opn[7:0]};
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
						op1 <= 16'b0;
						op2 <= 16'b0;
					end
				end
				5'b00110: begin
					if (opn[1:0] == 2'b00) begin //SLL
						op1 <= read_value2;
						op2 <= {13'b0,opn[4:2]};
					end
					else if (opn[1:0] == 2'b11) begin //SRA
					end
					else if (opn[1:0] == 2'b10) begin //SRL
					end
				end
				5'b11011: begin //SW
					op1 <= read_value1;
					if (opn[7:7] == 1'b1) op2 <= {8'b11111111,opn[7:0]};
					else op2 <= {8'b0,opn[7:0]};
				end
				5'b11010: begin //SW_SP
				end
				5'b01111: begin
					if (opn[4:0] == 5'b00000) begin //MOVE
						op1 <= read_value2;
						op2 <= 16'b0;
					end
				end
			endcase
		end
	end

endmodule
