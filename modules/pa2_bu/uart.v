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
	 
	 input [8:0] input_data,
	 output reg [7:0] light,
	 
	 inout wire[7:0] Ram1Data,
	 
	 output reg Ram1OE,
	 output reg Ram1WE,
	 output reg Ram1EN,
	 input data_ready,
	 output reg rdn,
	 output reg tbre,
	 output reg tsre,
	 output reg wrn
    );
	 
	 assign reading = input_data[8];
	 
	 reg [4:0] status;
	 reg [4:0] next_status;
	 reg recevied;
	 
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
	 
	 assign Ram1Data = (reading == 1'b1)?16'bz:input_data[7:0];
	 
	 always @(posedge CLK or negedge RST) begin
		if (!RST) status = INIT_STATUS;
		else begin
		end
	 end
	 
	 always @(status, reading, data_ready, tbre, tsre) begin
		if (reading == 1'b1) begin
			case (status)
				INIT_STATUS: next_status = READ1;
				READ1: next_status = READ2;
				READ2: begin
					if (data_ready == 1'b1) next_status = READ3;
					else next_status = READ1;
				end
				READ3: next_status = READ1;
				default: next_status = INIT_STATUS;
			endcase
		end
		else begin
			case (status)
				INIT_STATUS: next_status = WRITE1;
				WRITE1: next_status = WRITE2;
				WRITE2: next_status = WRITE3;
				WRITE3: next_status = WRITE4;
				WRITE4: begin
					if (tbre == 1'b1) next_status = WRITE4;
					else next_status = WRITE3;
				end
				WRITE5: begin
					if (tsre == 1'b1) next_status = IDLE;
					else next_status = WRITE4;
				end
				default: next_status = IDLE;
			endcase
		end
	 end
	 
	 always @(*) begin
		if (reading == 1'b1) begin
			case (status)
				INIT_STATUS: begin
				end
				READ1: begin
					rdn = 1'b1;
					//Ram1Data = 8'bz;
				end
				READ2: begin
					if (data_ready == 1'b1) begin
						rdn = 1'b0;
					end
				end
				READ3: begin
					light = Ram1Data;
					rdn = 1'b1;
				end
				default: begin
				end
			endcase
		end
		else begin
			case (status)
				INIT_STATUS: begin
					tsre = 1'b0;
					tbre = 1'b0;
				end
				WRITE1: begin
					wrn = 1'b1;
					Ram1EN = 1'b1;
					Ram1OE = 1'b1;
					Ram1WE = 1'b1;
				end
				WRITE2: begin
					wrn = 1'b0;
					//Ram1Data = input_data[7:0];
				end
				WRITE3: begin
					wrn = 1'b1;
				end
				WRITE4: begin
				end
				WRITE5: begin
				end
				default: begin
				end
			endcase
		end
	 end


endmodule
