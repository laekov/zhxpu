`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:52:04 11/22/2017 
// Design Name: 
// Module Name:    dig_ctrl 
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
module dig_ctrl(
    input [3:0] dig,
    output reg [6:0] light
    );

	always @(*) begin
		case (dig)
			4'b0000: light <= 7'b1111110;
			4'b0001: light <= 7'b0110000;
			4'b0010: light <= 7'b1101101;
			4'b0011: light <= 7'b1111001;
			4'b0100: light <= 7'b0110011;
			4'b0101: light <= 7'b1011011;
			4'b0110: light <= 7'b1011111;
			4'b0111: light <= 7'b1110000;
			4'b1000: light <= 7'b1111111;
			4'b1001: light <= 7'b1111011;
			4'b1010: light <= 7'b1110111;
			4'b1011: light <= 7'b0011111;
			4'b1100: light <= 7'b1001110;
			4'b1101: light <= 7'b0111101;
			4'b1110: light <= 7'b1001111;
			4'b1111: light <= 7'b1000111;
		endcase
	 end

endmodule
