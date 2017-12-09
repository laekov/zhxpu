`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:14:00 12/06/2017 
// Design Name: 
// Module Name:    font 
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
module font(
	input [2:0] row,
	input [2:0] col,
	input [3:0] data,
	input space,
	output reg res
    );
	
	always @(*) begin
		if (space == 1'b1) res <= 0;
		else begin
			case (data)
				4'b0000: begin
					case (row)
						3'b000: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b001: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b010: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b011: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b100: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b101: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b110: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b111: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
					endcase
				end
				4'b0001: begin
					case (row)
						3'b000: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b001: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 1;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b010: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 1;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b011: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 1;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b100: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 1;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b101: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 1;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b110: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 1;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b111: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
					endcase
				end
				4'b0010: begin
					case (row)
						3'b000: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b001: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b010: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b011: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b100: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b101: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b110: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b111: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
					endcase
				end
				4'b0011: begin
					case (row)
						3'b000: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b001: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b010: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b011: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b100: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b101: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b110: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b111: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
					endcase
				end
				4'b0100: begin
					case (row)
						3'b000: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b001: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b010: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b011: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b100: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b101: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b110: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b111: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
					endcase
				end
				4'b0101: begin
					case (row)
						3'b000: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b001: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b010: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b011: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b100: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b101: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b110: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b111: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
					endcase
				end
				4'b0110: begin
					case (row)
						3'b000: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b001: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b010: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b011: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b100: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b101: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b110: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b111: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
					endcase
				end
				4'b0111: begin
					case (row)
						3'b000: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b001: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b010: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b011: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b100: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b101: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b110: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b111: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
					endcase
				end
				4'b1000: begin
					case (row)
						3'b000: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b001: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b010: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b011: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b100: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b101: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b110: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b111: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
					endcase
				end
				4'b1001: begin
					case (row)
						3'b000: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b001: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b010: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b011: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b100: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b101: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b110: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b111: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
					endcase
				end
				4'b1010: begin
					case (row)
						3'b000: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b001: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b010: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b011: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b100: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b101: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b110: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b111: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
					endcase
				end
				4'b1011: begin
					case (row)
						3'b000: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b001: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b010: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b011: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b100: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b101: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b110: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b111: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
					endcase
				end
				4'b1100: begin
					case (row)
						3'b000: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b001: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b010: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b011: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b100: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b101: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b110: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b111: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
					endcase
				end
				4'b1101: begin
					case (row)
						3'b000: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b001: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b010: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b011: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b100: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b101: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b110: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b111: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
					endcase
				end
				4'b1110: begin
					case (row)
						3'b000: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b001: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b010: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b011: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b100: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b101: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b110: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b111: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
					endcase
				end
				4'b1111: begin
					case (row)
						3'b000: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b001: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b010: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b011: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b100: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 1;
								3'b011: res <= 1;
								3'b100: res <= 1;
								3'b101: res <= 1;
								3'b110: res <= 1;
								3'b111: res <= 0;
							endcase
						end
						3'b101: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b110: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 1;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
						3'b111: begin
							case (col)
								3'b000: res <= 0;
								3'b001: res <= 0;
								3'b010: res <= 0;
								3'b011: res <= 0;
								3'b100: res <= 0;
								3'b101: res <= 0;
								3'b110: res <= 0;
								3'b111: res <= 0;
							endcase
						end
					endcase
				end
			endcase
		end

	end

endmodule

