`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:07:52 11/08/2017 
// Design Name: 
// Module Name:    ramController 
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
	module ramController(
		 input CLK,
		 input RST,
		 output rdn,
		 output wrn,
		 
		 output [17:0] Ram1Addr,
		 inout [15:0] Ram1Data,
		 output Ram1OE,
		 output Ram1WE,
		 output Ram1EN,
		 
		 output [17:0] Ram2Addr,
		 inout [15:0] Ram2Data,
		 output Ram2OE,
		 output Ram2WE,
		 output Ram2EN,
		 
		 output wire [6:0] led1,
		 output wire [6:0] led2,
		 output reg [15:0] light,
		 
		 input [15:0] data
		 );
		 
		 reg reading1;
		 reg reading2;
		 reg [17:0] addr1;
		 reg [15:0] data1;
		 reg [17:0] addr2;
		 reg [15:0] data2;
		 reg [4:0] show1;
		 reg [4:0] show2;
		 
		 reg [17:0] addrtemp;
		 reg [15:0] datatemp;
		 
		 reg [4:0] status;
		 reg [4:0] next_status;
		 reg [4:0] already_done;
		 
		 localparam how_many = 4'b0011;
		 localparam INIT_STATUS = 4'b0000;
		 localparam RAM1_ADDR_READ = 4'b0001;
		 localparam RAM1_VALUE_READ = 4'b0010;
		 localparam RAM1_WRITE = 4'b0011;
		 localparam RAM1_READ = 4'b0100;
		 localparam RAM2_WRITE = 4'b0101;
		 localparam RAM2_READ = 4'b0110;
		 localparam RAM1_GG = 4'b1111;
		 
		 assign rdn = 1'b1;
		 assign wrn = 1'b1;
		 
		 assign Ram1Addr = addr1;		 
		 assign Ram2Addr = addr2;
		 assign Ram1Data = (reading1 == 1'b1)?data1:16'bz;
		 assign Ram2Data = (reading2 == 1'b1)?data2:16'bz;

		 ram ram1(
			//.data(data1),
			//.addr(addr1),
			.reading(reading1),
			.RamAddr(RamAddr1),
			.RamData(RamData1),
			.RamOE(Ram1OE),
			.RamWE(Ram1WE),
			.RamEN(Ram1EN)
		 );
		 
		 ram ram2(
			 //.data(data2),
			 //.addr(addr2),
			.reading(reading2),
			.RamAddr(RamAddr2),
			.RamData(RamData2),
			.RamOE(Ram2OE),
			.RamWE(Ram2WE),
			.RamEN(Ram2EN)
		 );
		 
		 translator trans1(
			.value(show1),
			.led(led1)
		 );
		 
		 translator trans2(
			.value(show2),
			.led(led2)
		 );
		 
		 always @(posedge CLK or negedge RST) begin
			if (!RST) status = INIT_STATUS;
			else begin
				case (status)
					INIT_STATUS: status=next_status;
					RAM1_ADDR_READ: status = next_status;
					RAM1_VALUE_READ: begin
						status = next_status;
						already_done = 4'b0000;
					end
					RAM1_WRITE: begin
						if (already_done == how_many) begin
							already_done = 4'b0000;
							status = next_status;
						end
						else begin
							already_done = already_done + 1;
							status = RAM1_GG;
							//reading1 = 1'b1;
						end
					end
					RAM1_GG : status = next_status;
					RAM1_READ: begin
						if (already_done == how_many) begin
							status = next_status;
							already_done = 4'b0000;
						end
						else already_done = already_done + 1;
					end
					default : status=INIT_STATUS;
				endcase
			end
		 end
		 
		 always @(status,RST) begin
			if (!RST) next_status = RAM1_ADDR_READ;
			else begin
				case (status)
					INIT_STATUS: next_status = RAM1_ADDR_READ;
					RAM1_ADDR_READ: next_status = RAM1_VALUE_READ;
					RAM1_VALUE_READ: next_status = RAM1_WRITE;
					RAM1_WRITE: next_status = RAM1_READ;
					RAM1_READ: next_status = INIT_STATUS;
					RAM1_GG: next_status = RAM1_WRITE;
					default: next_status = INIT_STATUS;
				endcase
			end
		 end
		 
		 always @(*) begin
			case (status)
				default: begin
					show1 = 4'b0;
					show2 = 4'b0;
					light = 16'b0;
					reading1 = 1'b0;
					reading2 = 1'b0;
				end
				RAM1_ADDR_READ: begin
					addrtemp = {2'b00,data};
					light = addrtemp[15:0];
				end
				RAM1_VALUE_READ: begin
					datatemp = data;
					show1 = datatemp[7:4];
					show2 = datatemp[3:0];
				end
				RAM1_WRITE: begin
					data2 = datatemp+already_done;
					addr2 = addrtemp+already_done;
					show1 = data2[7:4];
					show2 = data2[3:0];
					light = addr2[15:0];
					reading2 = 1'b1;
				end
				RAM1_GG : reading1 = 1'b0;
				RAM1_READ: begin
					addr2 = addrtemp+already_done;
					reading2 = 1'b0;
					show1 = Ram2Data[7:4];
					show2 = Ram2Data[3:0];
					light = Ram2Data[15:0];
				end
			endcase
		 end


endmodule
