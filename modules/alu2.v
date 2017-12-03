`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:53:?? 11/17/1900
// Design Name: 
// Module Name:    alu
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
module alu(
		input [15:0] opn,
		input [15:0] op1,
		input [15:0] op2,

		output reg [15:0] res,
		output reg flag
    );

	always @(*) begin
		case (opn[15:11])
			5'b01001: begin // ADDIU
				{flag,res} <= op1+op2;
			end
			5'b01000: begin // ADDIU3
				{flag,res} <= op1+op2;
			end
			5'b01100: begin
				if (opn[10:8] == 3'b011) begin // ADDSP
					{flag,res} <= op1+op2;
				end
				else if (opn[10:8] == 3'b000) begin // BTEQZ
				end
				else if ((opn[10:8] == 3'b100) && (opn[4:0] == 5'b00000)) begin // MTSP
					{flag,res} <= {1'b0,op1};
				end
			end
			5'b11100: begin 
				if (opn[1:0] == 2'b01) begin// ADDU
					{flag,res} <= op1+op2;
				end
				else begin //SUBU
					{flag,res} <= op1-op2;
				end
			end
			5'b11101: begin
				if (opn[4:0] == 5'b01100) begin // AND
					{flag,res} <= {1'b0,op1&op2};
				end
				else if (opn[7:0] == 8'b00000000) begin // JR
				end	
				else if (opn[4:0] == 5'b01010) begin //CMP
					if (op1 == op2) {flag,res} <= {1'b0,16'b0};
					else {flag,res} <= {1'b0,16'b1};
				end
				else if (opn[7:0] == 8'b01000000) begin //MFPC
					{flag,res} <= {1'b0,op1};
				end
				else if (opn[4:0] == 5'b01101) begin //OR
					{flag,res} <= {1'b0,op1|op2};
				end
				else if (opn[7:0] == 8'b11000000) begin //JALR
				end
				else if (opn[10:0] == 11'b00000100000) begin //JRRA
				end
				else if (opn[4:0] == 5'b00111) begin //SRAV
					{flag,res} <= {1'b0,op2>>>op1};
				end
			end
			5'b00010: begin // B
			end
			5'b00100: begin //BEQZ
			end
			5'b00101: begin //BNEZ
			end
			5'b01101: begin //LI
				{flag,res} <= {1'b0,op1};
			end
			5'b10011: begin // LW
				{flag,res} <= op1+op2;
			end
			5'b10010: begin //LW_SP
				{flag,res} <= op1+op2;
			end
			5'b11110: begin
				if (opn[7:0] == 8'b00000000) begin //MFIH
					{flag,res} <= {1'b0,op1};
				end
				else if (opn[4:0] == 8'b00000001) begin //MTIH
					{flag,res} <= {1'b0,op1};
				end
			end
			5'b00001: begin
				if (opn[10:0] == 11'b10000000000) begin //NOP
					{flag,res} <= {1'b0,16'b0};
				end
			end
			5'b00110: begin
				if (opn[1:0] == 2'b00) begin //SLL
					if (op2 == 0) {flag,res} <= op1 << 8;
					else {flag,res} <= op1 << op2;
				end
				else if (opn[1:0] == 2'b11) begin //SRA
					if (op2 == 0) {flag,res} <= {1'b0,op1 >>> 8};
					else {flag,res} <= {1'b0,op1 >>> op2};
				end
				else if (opn[1:0] == 2'b10) begin //SRL
					if (op2 == 0) {flag,res} <= {1'b0,op1 >> 8};
					else {flag,res} <= {1'b0,op1 >> op2};
				end
			end
			5'b11011: begin //SW
				{flag,res} <= op1+op2;
			end
			5'b11010: begin //SW_SP
				{flag,res} <= op1+op2;
			end
			5'b01111: begin
				if (opn[4:0] == 5'b00000) begin //MOVE
					{flag,res} <= {1'b0,op1};
				end
			end
		endcase
	end


endmodule
