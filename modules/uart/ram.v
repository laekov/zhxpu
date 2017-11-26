`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:47:00 11/08/2017 
// Design Name: 
// Module Name:    ram 
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
module ram(
	 input reading,
	 output reg RamOE,
	 output reg RamWE,
	 output reg RamEN
		
    );
	 
	 always @(*) begin
		if (reading==1'b1) begin
			RamOE = 1'b0;
			RamWE = 1'b1;
			RamEN = 1'b0;
		end else begin
			RamOE = 1'b0;
			RamWE = 1'b0;
			RamEN = 1'b1;
		end
	 end


endmodule
