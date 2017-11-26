`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:27:51 11/07/2017 
// Design Name: 
// Module Name:    work 
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
module work(
    input CLK,
    input RST,
	 
	 inout 
	 output Ram1OE,
	 output Ram1WE,
	 output Ram1En,
	 
	 output [17:0] Ram2Addr,
	 inout [15:0] Ram2Data,
	 output Ram2OE,
	 output Ram2WE,
	 output Ram2EN,
	 
	 output data_ready,
	 output tbre,
	 output tsre,
	 output rdn,
	 output wrn,
	 
	 output [15:0] led,
	 output [7:0] led1,
	 output [7:0] led2
    );
	 
	 localparam INIT_STATUS = 4'b0000;
	 localparam W1=4'b0001,W2=4'b0010,W3=4'b0011,W4=4'b0100,W5=4'b0101;
	 localparam R1=4'b1001,R2=4'b1010,R3=4'b1011,R4=4'b1100,R5=4'b1101;
	 localparam STOP = 4'b1000;
	 
	 always @(posedge CLK or negedge RST) begin
		if (!RST) status = INIT_STATUS;
		else begin
			if 
		end
	 end
	 
	 always @(status,RST) begin
		if (!RST) next_status = INIT_STATUS;
		else begin
			case (status)
				INIT_STATUS: next_status = R1;
				R1: next_status = R2;
				R2: next_status = R3;
				R3: next_status = R4;
				R4: next_status = R5;
				R5: next_status = W1;
				W1: next_status = W2;
				W2: next_status = W3;
				W3: next_status = W4;
				W4: next_status = W5;
				W5: next_status = INIT_STATUS;
				default: next_status = INIT_STATUS;
			endcase
		end
	 end
	 
	 always @(*) begin
		if (!RST) begin
		end
		else begin
			case (status)
				INIT_STATUS:
				R1:
				R2:
				R3:
				R4:
				R5:
				W1:
				W2:
				W3:
				W4:
				W5:
			endcase
		end
	 end
	 


endmodule
