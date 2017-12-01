`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:59:55 11/08/2017 
// Design Name: 
// Module Name:    uart 
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
module uart(
	 input CLK,
	 input RST,
	 
	 input [7:0] input_data,
	 output reg [7:0] light,
	 
	 inout wire[7:0] Ram1Data,
	 
	 output [6:0] led1,
	 output [6:0] led2,
	 
	 output reg Ram1OE,
	 output reg Ram1WE,
	 output reg Ram1EN,
	 input data_ready,
	 output reg rdn,
	 input tbre,
	 input tsre,
	 output reg wrn
    );
	 
	 reg [4:0] status;
	 reg [4:0] next_status;
	 reg recevied;
	 reg reading;
	 reg [7:0] data;
	 
	 translator trans1(
		.value(Ram1Data[7:4]),
		.led(led1)
	 );
	 
	 translator trans2(
		.value(Ram1Data[3:0]),
		.led(led2)
	 );
	 
	 localparam IDLE = 4'b1111;
	 localparam INIT_STATUS = 4'b0000;
	 localparam READ1 = 4'b0001;
	 localparam READ2 = 4'b0010;
	 localparam READ3 = 4'b0011;
	 localparam WRITE1 = 4'b1000;
	 localparam WRITE2 = 4'b1001;
	 localparam WRITE3 = 4'b1010;
	 localparam WRITE4 = 4'b1011;
	 localparam WRITE5 = 4'b1100;
	 
	 assign Ram1Data = reading?(data[7:0]+8'b00000001):8'bz;
	 
	 reg [4:0] cnt;
	 
	 always @(posedge CLK or negedge RST) begin
		if (!RST) status = INIT_STATUS;
		else begin
			cnt = cnt + 4'b1;
			if (cnt == 4'b0) 
			begin
			   //if (next_status == WRITE1) data = data + 1;
				status = next_status;
			end
		end
	 end
	 
	 always @(status, data_ready, tbre, tsre) begin
		case (status)
			INIT_STATUS: next_status = READ1;
			READ1: begin
				if (data_ready == 1'b1) next_status = READ2;
				else next_status = READ1;
			end
			READ2: next_status = READ3;
			READ3: next_status = WRITE1;
			WRITE1: next_status = WRITE2;
			WRITE2: next_status = WRITE3;
			WRITE3: begin
				if (tbre == 1'b1) next_status = WRITE4;
				else next_status = WRITE3;
			end
			WRITE4: begin
				if (tsre == 1'b1) next_status = WRITE5;
				else next_status = WRITE4;
			end
			WRITE5: next_status = IDLE;
			default: next_status = IDLE;
		endcase
	 end
	 
	 always @(*) begin
		Ram1EN = 1'b1;
		Ram1OE = 1'b1;
		Ram1WE = 1'b1;
			case (status)
				INIT_STATUS: begin
					rdn = 1'b1;
					wrn = 1'b1;
					reading = 1'b0;
				end
				READ1: begin
					rdn = 1'b1;
					wrn = 1'b1;
					//Ram1Data = 8'bz;
				end
				READ2: begin
					rdn = 1'b0;
					wrn = 1'b1;
					//data = data + 1;
					//reading = 1'b0;
				end
				READ3: begin
					rdn = 1'b1;
					wrn = 1'b1;
					light = Ram1Data;
					data = Ram1Data;
					//rdn = 1'b1;
				end
				WRITE1: begin
					//reading = 1'b0;
					wrn = 1'b1;
					rdn = 1'b1;
				end
				WRITE2: begin
					wrn = 1'b0;
					rdn = 1'b1;
					reading = 1'b1;
				end
				WRITE3: begin
					wrn = 1'b1;
					rdn = 1'b1;
				end
				WRITE4: begin
					wrn = 1'b1;
					rdn = 1'b1;
				end
				WRITE5: begin
					wrn = 1'b1;
					rdn = 1'b1;
				end
				default: begin
				end
			endcase
	 end


endmodule
