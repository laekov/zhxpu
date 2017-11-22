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
module stall_ctrl(
	    input wrie writable,
	    input wire[`RegAddr] write_addr,

	    input wire readable1,
	    input wire[`RegAddr] read_addr1,
	
    	input wire readable2,
	    input wire[`RegAddr] read_addr2,
        
        input wire writed,
        input wire[`RegAddr] writed_addr,
        
        output wire hold
        );

        reg[1:0] cnt[`RegAddr];
        reg[0:0] holding[`RegAddr];
        reg flag;
        integer i;

        always @(*) begin
            if (writable==1'b1) begin
                cnt[write_addr]=cnt[write_addr]+1;
            end
            if (writed==1'b1) begin
                cnt[writed_addr]=cnt[writed_addr]-1;
                flag=1'b0;
                for(i=0;i<8;i=i+1)
                    if (holding[i] == 1'b1) begin
                        if (cnt[i] == 2'b00)
                            holding[i] = 1'b0;
                        else
                            flag=1'b1;
                    end
                if (flag==1'b0)
                    hold=1'b0;
            end
            if (readable1==1'b1) begin
                if (cnt[read_addr1] > 2'b00) begin
                    hold=1'b1;
                    holding[read_addr1]=1'b1;
                end
            end
            if (readable2==1'b1) begin
                if (cnt[read_addr2] > 2'b00) begin
                    hold=1'b1;
                    holding[read_addr2]=1'b1;
                end
            end
        end