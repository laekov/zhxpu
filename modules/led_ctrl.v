`timescale 1ns / 1ps
module led_ctrl(
	input [15:0] data,
	output reg [15:0] light
);
	always @(*) begin
		light <= data;
	end
endmodule
