`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:29:50 11/06/2017 
// Design Name: 
// Module Name:    chuankou
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
module chuankou(
    input CLK,
    input RST,
	 
    inout [7:0] RamData,
	 output [7:0] output_data,
	 
    output RamOE,
    output RamWE,
    output RamEN,
	 
    input data_ready_read,
	 input data_ready_write,
	 
    output rdn,
    output tbre,
    output tsre,
    output wrn,
	 
	 input start,
	 output done
    );
	 
	 reg[3:0] status;
	 reg[3:0] next_status;
	 
	 reg[15:0] local_data;
	 
	 localparam INIT_STATUS = 4'b0000;
	 localparam W11=4'b0001,W12=4'b0010,W13=4'b0011;
	 localparam W21=4'b0101,W22=4'b0110,W23=4'b0111;
	 localparam R11=4'b1001,R12=4'b1010,R13=4'b1011;
	 localparam R21=4'b1101,R22=4'b1110,R23=4'b1111;
	 localparam STOP = 4'b0100;
	 
	 always @(posedge CLK or negedge RST) begin
		if (!RST) begin
			status = INIT_STATUS;
		end else begin
			if (start == 1'b1) status = next_status;
			else status = INIT_STATUS;
		end
	 end
	 
	 always @(status,data_ready_read,data_ready_write,reading) begin
		if (reading == 1'b1) begin
			case (status)
				INIT_STATUS:
					next_status = R11;
				R11: begin
					if (data_ready_read == 1'b1) next_status = R12;
					else next_status = R11;
				end
				R12:
					next_status = R13;
				R13:
					next_status = R21;
				R21: begin
					if (data_ready_read == 1'b1) next_status = R22;
					else next_status = R21;
				end
				R22:
					next_status = R23;
				R23:
					next_status = STOP;
				default:
					next_status = INIT_STATUS;
			endcase
		end
		else begin
			case (status)
				INIT_STATUS:
					next_status = W11;
				W11: begin
					if (data_ready_write == 1'b1) next_status=W12;
					else next_status = W11;
				end
				W12:
					next_status = W13;
				W13:
					next_status = W21;
				W21: begin
					if (data_ready_write == 1'b1) next_status = W22;
					else next_status = W21;
				end
				W22:
					next_status = W23;
				W23:
					next_status = STOP;
				default:
					next_status = INIT_STATUS;
			endcase
		end
	 end
	 
	 always @(*) begin
		RamEN = 1'b1;
		RamOE = 1'b1;
		RamWE = 1'b1;
		case (status)
			INIT_STATUS: begin
				wrn = 1'b1;
				rdn = 1'b1;
				done = 1'b0;
			end
			R11: begin
				done = 1'b0;
				rdn = 1'b1;
			end
			R12: begin
				rdn = 1'b0;
			end
			R13: begin
				rdn = 1'b1;
				local_data[15:8] = RamData;
			end
			R21: begin
				rdn = 1'b1;
			end
			R22: begin
			end
			R23: begin
				rdn = 1'b1;
				local_data[7:0] = RamData;
			end
			W11: begin
				done = 1'b0;
				wrn = 1'b1;
			end
			W12: begin
				wrn = 1'b0;
			end
			W13: begin
				wrn = 1'b1;
				output_data = local_data[15:8];
			end
			W21: begin
				wrn = 1'b1;
			end
			W22: begin
				wrn = 1'b0;
			end
			W23: begin
				wrn = 1'b1;
				output_data = local_data[7:0];
			end
			STOP: bein
				done = 1'b1;
			end
		endcase
	 end


endmodule
