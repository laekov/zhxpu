`timescale 1ns / 1ps
`include "define.v"

module jmp_ctrl(
	input [`RegValue] op1,
	input [`RegValue] op2,
	input [`RegValue] pc_in,
	input [`RegValue] opn,
	output reg set_pc,
	output reg [`RegValue] set_pc_value,
	output reg write_RA,
	output reg [`RegValue] write_RA_value
);
	always @(*) begin
		case (opn[15:11])
			5'b00010: begin //B
				set_pc <= 1'b1;
				set_pc_value <= pc_in + { ((opn[10:10] == 1'b1) ? 5'b11111 : 5'b00000), opn[10:0] } + 16'b1; 
				write_RA <= 1'b0;
			end
			5'b00101: begin //BNEZ
				if (op1 != 0) begin
					set_pc <= 1'b1;
					set_pc_value <= pc_in + { ((opn[7:7] == 1'b1) ? 8'hff : 8'h00), opn[7:0] } + 16'b1; 
				end else begin
					set_pc <= 1'b0;
					set_pc_value <= 16'b0;
				end
				write_RA <= 1'b0;
			end
			5'b01100: begin
				if (opn[10:8] == 3'b000) begin // BTEQZ
					if (op1 == 0) begin
						set_pc <= 1'b1;
						set_pc_value <= pc_in + { ((opn[7:7] == 1'b1) ? 8'hff : 8'h00), opn[7:0] } + 16'b1; 
					end else begin
						set_pc <= 1'b0;
						set_pc_value <= 16'b0;
					end
				end else if (opn[10:8] == 3'b001) begin // BTNEZ
					if (op1 != 0) begin
						set_pc <= 1'b1;
						set_pc_value <= pc_in + { ((opn[7:7] == 1'b1) ? 8'hff : 8'h00), opn[7:0] } + 16'b1; 
					end else begin
						set_pc <= 1'b0;
						set_pc_value <= 16'b0;
					end
				end
				else begin
					set_pc <= 1'b0;
					set_pc_value <= 16'b0;
				end
				write_RA <= 1'b0;
			end
			5'b11101: begin
				if (opn[7:0] == 8'b00000000) begin // JR
					set_pc <= 1'b1;
					set_pc_value <= op1 + 16'b1;
					write_RA <= 1'b0;
				end else if (opn[7:0] == 8'b11000000) begin //JALR
					set_pc <= 1'b1;
					set_pc_value <= op1;

					write_RA <= 1'b1;
					write_RA_value <= pc_in + 1;
				end
				else if (opn[10:0] == 11'b00000100000) begin //JRRA
					set_pc <= 1'b1;
					set_pc_value <= op1;

					write_RA <= 1'b0;
				end
				else begin
					set_pc <= 1'b0;
					set_pc_value <= 1'b0;
					write_RA <= 1'b0;
				end
			end
			5'b00100: begin //BEQZ
				if (op1 == 0) begin
					set_pc <= 1'b1;
					set_pc_value <= pc_in + { ((opn[7:7] == 1'b1) ? 8'hff : 8'h00), opn[7:0] } + 16'b1;
					write_RA <= 1'b0;
				end
				else begin
					set_pc <= 1'b0;
					set_pc_value <= 16'b0;
					write_RA <= 1'b0;
				end
			end
			default: begin
				set_pc <= 1'b0;
				set_pc_value <= 16'b1;
				write_RA <= 1'b0;
			end
		endcase
	end
endmodule
