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

	output reg [`RegValue] read_value1_output,
	output reg [`RegValue] read_value2_output,
	output reg [31:0] mem_act,

	output reg mem_trig
    );

	initial begin
		mem_write_out = 1'b0;
		mem_read_out = 1'b0;
		mem_trig = 1'b0;
	end

	always @(posedge clk) begin
		if (hold) begin
			opn_out <= opn_out;
			pc_out <= pc_out;
			mem_write_out <= mem_write_out;
			mem_read_out <= mem_read_out;
			reg_write_out <= reg_write_out;
			reg_addr_out <= reg_addr_out;
			mem_act <= mem_act;
			read_value1_output <= read_value1_output;
			read_value2_output <= read_value2_output;
			op1 <= op1;
			op2 <= op2;
		end else begin
			opn_out <= opn;
			pc_out <= pc;
			mem_write_out <= mem_write;
			mem_read_out <= mem_read;
			reg_write_out <= reg_write;
			reg_addr_out <= reg_addr;
			mem_act <= mem_act + 32'b1;
			read_value1_output <= read_value1;
			read_value2_output <= read_value2;
			case (opn[15:11])
				5'b01001: begin // ADDIU
					op1 <= read_value1;
					if (opn[7:7] == 1'b1) op2 <= {8'b11111111,opn[7:0]};
					else op2 <= {8'b0,opn[7:0]};
				end
				5'b01000: begin // ADDIU3
					op1 <= read_value1;
					if (opn[3:3] == 1'b1) op2 <= {12'b111111111111,opn[3:0]};
					else op2 <= {12'b000000000000,opn[3:0]};
				end
				5'b01100: begin
					if (opn[10:8] == 3'b011) begin // ADDSP
						op1 <= read_value1;
						if (opn[7:7] == 1'b1) op2 <= {8'b11111111,opn[7:0]};
						else op2 <= {8'b0,opn[7:0]};
					end
					else if (opn[10:8] == 3'b000) begin // BTEQZ
					end
					else if (opn[10:8] == 3'b001) begin // BTNEZ
					end
					else if ((opn[10:8] == 3'b100) && (opn[4:0] == 5'b00000)) begin // MTSP
						op1 <= read_value1;
					end
				end
				5'b11100: begin 
					if (opn[1:0] == 2'b01) begin// ADDU
						op1 <= read_value1;
						op2 <= read_value2;
					end
					else begin //SUBU
						op1 <= read_value1;
						op2 <= read_value2;
					end
				end
				5'b11101: begin
					if (opn[4:0] == 5'b01100) begin // AND
						op1 <= read_value1;
						op2 <= read_value2;
					end
					else if (opn[7:0] == 8'b00000000) begin // JR
					end	
					else if (opn[4:0] == 5'b01010) begin //CMP
						op1 <= read_value1;
						op2 <= read_value2;
					end
					else if (opn[7:0] == 8'b01000000) begin //MFPC
						op1 <= pc + 16'b1;
					end
					else if (opn[4:0] == 5'b01101) begin //OR
						op1 <= read_value1;
						op2 <= read_value2;
					end
					else if (opn[7:0] == 8'b11000000) begin //JALR
					end
					else if (opn[10:0] == 11'b00000100000) begin //JRRA
					end
					else if (opn[4:0] == 5'b00111) begin //SRAV
						op1 <= read_value1;
						op2 <= read_value2;
					end
				end
				5'b00010: begin // B
				end
				5'b00100: begin //BEQZ
				end
				5'b00101: begin //BNEZ
				end
				5'b01101: begin //LI
					op1 <= {8'b0,opn[7:0]};
					op2 <= 16'b0;
				end
				5'b10011: begin // LW
					op1 <= read_value1;
					if (opn[4:4] == 1'b1) op2 <= {11'b11111111111,opn[4:0]};
					else op2 <= {11'b0,opn[4:0]};
				end
				5'b10010: begin //LW_SP
					op1 <= read_value1;
					if (opn[7:7] == 1'b1) op2 <= {8'b11111111,opn[7:0]};
					else op2 <= {8'b0,opn[7:0]};
				end
				5'b11110: begin
					if (opn[7:0] == 8'b00000000) begin //MFIH
						op1 <= read_value1;
					end
					else if (opn[4:0] == 8'b00000001) begin //MTIH
						op1 <= read_value1;
					end
				end
				5'b00001: begin
					if (opn[10:0] == 11'b00000000000) begin //NOP
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
						op1 <= read_value2;
						op2 <= {13'b0,opn[4:2]};
					end
					else if (opn[1:0] == 2'b10) begin //SRL
						op1 <= read_value2;
						op2 <= {13'b0,opn[4:2]};
					end
				end
				5'b11011: begin //SW
					op1 <= read_value1;
					if (opn[4:4] == 1'b1) op2 <= {11'b11111111111,opn[4:0]};
					else op2 <= {11'b0,opn[4:0]};
				end
				5'b11010: begin //SW_SP
					op1 <= read_value1;
					if (opn[7:7] == 1'b1) op2 <= {8'b11111111,opn[7:0]};
					else op2 <= {8'b0,opn[7:0]};
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
