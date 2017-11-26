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
	 //input [15:0] data,
	 //input [17:0] addr,
	 input reading,
	 output [17:0] RamAddr,
	 inout [15:0] RamData,
	 output reg RamOE,
	 output reg RamWE,
	 output reg RamEN
		
    );
	 
	 //assign RamAddr = addr;
	 //assign RamData = (reading == 1'b1)?16'bz:data;
	 
	 always @(*) begin
		if (reading==1'b0) begin
			RamOE = 1'b0;
			RamWE = 1'b1;
			RamEN = 1'b0;
		end else begin
			RamOE = 1'b1;
			RamWE = 1'b0;
			RamEN = 1'b0;
		end
	 end


endmodule
