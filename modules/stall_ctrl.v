`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:01:?? 11/21/1900
// Design Name: 
// Module Name:    stall_ctrl
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

module stall_ctrl(
	    input wire writable,
	    input wire[`RegAddr] write_addr,

	    input wire readable1,
	    input wire[`RegAddr] read_addr1,
	
    	input wire readable2,
	    input wire[`RegAddr] read_addr2,
        
        input wire writed,
        input wire[`RegAddr] writed_addr,
        
        output wire hold
        );

		assign hold = 1'b0;
endmodule
