`include "define.v"

module exe_wb(
	input [15:0] alu_res,
	input alu_flag,
	input mem_feedback,
	input reg_wr,
	input [2:0]reg_addr,
	input mem_wr,
	input mem_rd,
	input [15:0]pc_input,
	input [15:0]opn,
	input clk,
	input pclk,
	input hold,
	output reg unlock_reg,
	output reg [`RegAddr] unlock_reg_addr,
	output reg [`RegValue] sp_reg_data,
	output reg write_reg_ctrl,
	output reg [`RegAddr] write_reg_addr,
	output reg [`RegValue] write_reg_data
);

	always @(posedge clk or posedge pclk) begin
		if (pclk) begin
			write_reg_ctrl <= 1'b0;
			write_reg_addr <= `ZeroReg;
		end else if (hold) begin
		end else begin
			case (opn[15:11])
				5'b01101: begin // LI
					write_reg_ctrl <= 1'b1;
					write_reg_addr <= reg_addr;
					write_reg_data <= alu_res;
				end
				5'b00110: begin
					if (opn[1:0] == 2'b00) begin //SLL
						//unlock_reg <= 1'b1;
						//unlock_reg_addr <= reg_addr;
						write_reg_ctrl <= 1'b1;
						write_reg_addr <= reg_addr;
						write_reg_data <= alu_res;
					end
				end
				5'b11100: begin 
					if (opn[1:0] == 2'b01) begin// ADDU
						//unlock_reg <= 1'b1;
						//unlock_reg_addr <= reg_addr;
						write_reg_ctrl <= 1'b1;
						write_reg_addr <= reg_addr;
						write_reg_data <= alu_res;
					end
				end
				5'b01111: begin
					if (opn[4:0] == 5'b00000) begin //MOVE
						//unlock_reg <= 1'b1;
						//unlock_reg_addr <= reg_addr;
						write_reg_ctrl <= 1'b1;
						write_reg_addr <= reg_addr;
						write_reg_data <= alu_res;
					end
				end
				5'b01001: begin // ADDIU
					//unlock_reg <= 1'b1;
					//unlock_reg_addr <= reg_addr;
					write_reg_ctrl <= 1'b1;
					write_reg_addr <= reg_addr;
					write_reg_data <= alu_res;
				end
				5'b00001: begin
					if (opn[10:0] == 11'b10000000000) begin //NOP
						write_reg_ctrl <= 1'b0;
					end
				end
			endcase
		end
	end
endmodule
