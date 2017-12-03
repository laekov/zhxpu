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
	inout [15:0] opn,
//	input pclk,

//	output reg //readable1,
	output reg[`RegAddr] read_addr1,

//	output reg //readable2,
	output reg [`RegAddr] read_addr2,

	output reg mem_read,
	output reg mem_write,
	output reg reg_write,
	output reg [`RegAddr] reg_addr,
	output reg decoder_error
    );

	always @(*) begin
		case (opn[15:11])
			5'b01001: begin // ADDIU
				decoder_error <= 1'b0;
				//readable1 <= 1'b1;
				read_addr1 <= {1'b0,opn[10:8]};

				//readable2 <= 1'b0;

				mem_read <= 1'b0;
				mem_write <= 1'b0;
				reg_write <= 1'b1;
				reg_addr <= {1'b0,opn[10:8]};
			end
			5'b01000: begin // ADDIU3
				decoder_error <= 1'b0;
				read_addr1 <= {1'b0,opn[10:8]};

				mem_read <= 1'b0;
				mem_write <= 1'b0;
				reg_write <= 1'b1;
				reg_addr <= {1'b0,opn[7:5]};
			end
			5'b01100: begin
				decoder_error <= 1'b0;
				if (opn[10:8] == 3'b011) begin // ADDSP
					read_addr1 <= `SPReg;

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b1;
					reg_addr <= `SPReg;
				end
				else if (opn[10:8] == 3'b000) begin // BTEQZ
					read_addr1 <= `TReg;

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b0;
				end
				else if ((opn[10:8] == 3'b100) && (opn[4:0] == 5'b00000)) begin // MTSP
					read_addr1 <= {1'b0,opn[7:5]};

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b1;
					reg_addr <= `SPReg;
				end else begin
					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b0;
				end
			end
			5'b11100: begin 
				decoder_error <= 1'b0;
				if (opn[1:0] == 2'b01) begin// ADDU
					//readable1 <= 1'b1;
					read_addr1 <= {1'b0,opn[10:8]};

					//readable2 <= 1'b1;
					read_addr2 <= {1'b0,opn[7:5]};

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b1;
					reg_addr <= {1'b0,opn[4:2]};
				end
				else begin //SUBU
					read_addr1 <= {1'b0,opn[10:8]};
					read_addr2 <= {1'b0,opn[7:5]};

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b1;
					reg_addr <= {1'b0,opn[4:2]};
				end
			end
			5'b11101: begin
				decoder_error <= 1'b0;
				if (opn[4:0] == 5'b01100) begin // AND
					read_addr1 <= {1'b0,opn[10:8]};
					read_addr2 <= {1'b0,opn[7:5]};

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b1;
					reg_addr <= {1'b0,opn[10:8]};
				end
				else if (opn[7:0] == 8'b00000000) begin // JR
					read_addr1 <= {1'b0,opn[10:8]};

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b0;
				end	
				else if (opn[4:0] == 5'b01010) begin //CMP
					read_addr1 <= {1'b0,opn[10:8]};
					read_addr2 <= {1'b0,opn[7:5]};

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b1;
					reg_addr <= `TReg;
				end
				else if (opn[7:0] == 8'b01000000) begin //MFPC
					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b1;
					reg_addr <= {1'b0,opn[10:8]};
				end
				else if (opn[4:0] == 5'b01101) begin //OR
					read_addr1 <= {1'b0,opn[10:8]};
					read_addr2 <= {1'b0,opn[7:5]};

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b1;
					reg_addr <= {1'b0,opn[10:8]};
				end
				else if (opn[7:0] == 8'b11000000) begin //JALR
					read_addr1 <= {1'b0,opn[10:8]};

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b0;
				end
				else if (opn[10:0] == 11'b00000100000) begin //JRRA
					read_addr1 <= `RAReg;

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b0;
				end
				else if (opn[4:0] == 5'b00111) begin //SRAV
					read_addr1 <= {1'b0,opn[10:8]};
					read_addr2 <= {1'b0,opn[7:5]};

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b1;
					reg_addr <= {1'b0,opn[7:5]};
				end else begin
					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b0;
				end
			end
			5'b00010: begin // B
				decoder_error <= 1'b0;
				mem_read <= 1'b0;
				mem_write <= 1'b0;
				reg_write <= 1'b0;
			end
			5'b00100: begin //BEQZ
				decoder_error <= 1'b0;
				read_addr1 <= {1'b0,opn[10:8]};

				mem_read <= 1'b0;
				mem_write <= 1'b0;
				reg_write <= 1'b0;
			end
			5'b00101: begin //BNEZ
				decoder_error <= 1'b0;
				//readable1 <= 1'b1;
				read_addr1 <= {1'b0,opn[10:8]};

				//readable2 <= 1'b0;

				mem_read <= 1'b0;
				mem_write <= 1'b0;
				reg_write <= 1'b0;
			end
			5'b01101: begin //LI
				decoder_error <= 1'b0;
				//readable1 <= 1'b0;
				//readable2 <= 1'b0;
				mem_read <= 1'b0;
				mem_write <= 1'b0;
				reg_addr <= {1'b0,opn[10:8]};
				reg_write <= 1'b1;
			end
			5'b10011: begin // LW
				decoder_error <= 1'b0;
				read_addr1 <= {1'b0,opn[10:8]};

				mem_read <= 1'b1;
				mem_write <= 1'b0;
				reg_addr <= {1'b0,opn[7:5]};
				reg_write <= 1'b1;
			end
			5'b10010: begin //LW_SP
				decoder_error <= 1'b0;
				read_addr1 <= `SPReg;

				mem_read <= 1'b1;
				mem_write <= 1'b0;
				reg_write <= 1'b1;
				reg_addr <= {1'b0,opn[10:8]};
			end
			5'b11110: begin
				decoder_error <= 1'b0;
				if (opn[7:0] == 8'b00000000) begin //MFIH
					read_addr1 <= `IHReg;

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b1;
					reg_addr <= {1'b1,opn[10:8]};
				end
				else if (opn[4:0] == 8'b00000001) begin //MTIH
					read_addr1 <= {1'b0,opn[10:8]};

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b1;
					reg_addr <= `IHReg;
				end else begin
					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b0;
				end
			end
			5'b00001: begin
				decoder_error <= 1'b0;
				if (opn[10:0] == 11'b10000000000) begin //NOP
					//readable1 <= 1'b0;

					//readable2 <= 1'b0;

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b0;
				end else begin
					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b0;
				end
			end
			5'b00110: begin
				decoder_error <= 1'b0;
				if (opn[1:0] == 2'b00) begin //SLL
					//readable1 <= 1'b0;

					//readable2 <= 1'b1;
					read_addr2 <= {1'b0,opn[7:5]};

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b1;
					reg_addr <= {1'b0,opn[10:8]};
				end
				else if (opn[1:0] == 2'b11) begin //SRA
					read_addr2 <= {1'b0,opn[7:5]};

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b1;
					reg_addr <= {1'b0,opn[10:8]};
				end
				else if (opn[1:0] == 2'b10) begin //SRL
					read_addr2 <= {1'b0,opn[7:5]};

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b1;
					reg_addr <= {1'b0,opn[10:8]};
				end else begin
					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b0;
				end
			end
			5'b11011: begin //SW
				read_addr1 <= {1'b0,opn[10:8]};
				read_addr2 <= {1'b0,opn[7:5]};

				mem_read <= 1'b0;
				mem_write <= 1'b1;
				reg_write <= 1'b0;
				decoder_error <= 1'b0;
			end
			5'b11010: begin //SW_SP
				read_addr1 <= {1'b0,opn[10:8]};

				mem_read <= 1'b0;
				mem_write <= 1'b1;
				reg_write <= 1'b0;
				decoder_error <= 1'b0;
			end
			5'b01111: begin
				if (opn[4:0] == 5'b00000) begin //MOVE
					//readable1 <= 1'b0;

					//readable2 <= 1'b1;
					read_addr2 <= {1'b0,opn[7:5]};

					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b1;
					reg_addr <= {1'b0,opn[10:8]};
					decoder_error <= 1'b0;
				end else begin
					decoder_error <= 1'b1;
					mem_read <= 1'b0;
					mem_write <= 1'b0;
					reg_write <= 1'b0;
				end
			end
			default: begin
				mem_read <= 1'b0;
				mem_write <= 1'b0;
				reg_write <= 1'b0;
				decoder_error <= 1'b1;
			end
		endcase
	end

endmodule


