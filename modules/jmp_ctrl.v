`timescale 1ns / 1ps
`include "define.v"

module jmp_ctrl(
	input [`RegValue] op1,
	input [`RegValue] op2,
	input [`RegValue] pc_in,
	input [`RegValue] opn,
	output reg set_pc,
	output reg [`RegValue] set_pc_value
);
	always @(*) begin
		case (opn[15:11])
			5'b00010: begin //B
				set_pc <= 1'b1;
				set_pc_value <= pc_in + { ((opn[7:7] == 1'b1) ? 8'hff : 8'h00), opn[7:0] }; 
			end
			5'b00101: begin //BNEZ
				if (op1 != 0) begin
					set_pc <= 1'b1;
					set_pc_value <= pc_in + { ((opn[7:7] == 1'b1) ? 8'hff : 8'h00), opn[7:0] }; 
				end else begin
					set_pc <= 1'b0;
					set_pc_value <= 16'b0;
				end
			end
			default: begin
				set_pc <= 1'b0;
				set_pc_value <= 16'b0;
			end
		endcase
	end
endmodule
