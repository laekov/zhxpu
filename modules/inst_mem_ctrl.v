`timescale 1ns / 1ps
`include "define.v"
// A version for demonstration 
module inst_mem_ctrl(
	input [`RegValue]addr,
	output reg [`RegValue] data,

	output reg ram_need_to_work,

	input ram_work_done,
	input [`MemValue] ram_feed_back,
	
	output reg work_done,
	output wire right,
	output wire [`RegValue] done_pc_out
	);

	reg [`RegValue] done_pc = 16'hffff;
	assign done_pc_out = done_pc;

	reg [`RegValue] suppose;
	assign right = work_done == 1'b1 && addr == done_pc && suppose != ram_feed_back;

	always @(*) begin
		case (addr)
			// {{{
			16'h1: suppose <= 16'h0000;
			16'h2: suppose <= 16'h0000;
			16'h3: suppose <= 16'h0800;
			16'h4: suppose <= 16'h1044;
			16'h5: suppose <= 16'h0800;
			16'h6: suppose <= 16'h0800;
			16'h7: suppose <= 16'h0800;
			16'h8: suppose <= 16'h0800;
			16'h9: suppose <= 16'h6EBF;
			16'ha: suppose <= 16'h36C0;
			16'hb: suppose <= 16'h4E10;
			16'hc: suppose <= 16'hDE00;
			16'hd: suppose <= 16'hDE21;
			16'he: suppose <= 16'hDE42;
			16'hf: suppose <= 16'h9100;
			16'h10: suppose <= 16'h6301;
			16'h11: suppose <= 16'h68FF;
			16'h12: suppose <= 16'hE90C;
			16'h13: suppose <= 16'h9200;
			16'h14: suppose <= 16'h6301;
			16'h15: suppose <= 16'h63FF;
			16'h16: suppose <= 16'hD300;
			16'h17: suppose <= 16'h63FF;
			16'h18: suppose <= 16'hD700;
			16'h19: suppose <= 16'h6B0F;
			16'h1a: suppose <= 16'hEF40;
			16'h1b: suppose <= 16'h4F03;
			16'h1c: suppose <= 16'h0800;
			16'h1d: suppose <= 16'h108A;
			16'h1e: suppose <= 16'h0800;
			16'h1f: suppose <= 16'h6EBF;
			16'h20: suppose <= 16'h36C0;
			16'h21: suppose <= 16'hDE60;
			16'h22: suppose <= 16'h0800;
			16'h23: suppose <= 16'hEF40;
			16'h24: suppose <= 16'h4F03;
			16'h25: suppose <= 16'h0800;
			16'h26: suppose <= 16'h1081;
			16'h27: suppose <= 16'h0800;
			16'h28: suppose <= 16'h6EBF;
			16'h29: suppose <= 16'h36C0;
			16'h2a: suppose <= 16'hDE20;
			16'h2b: suppose <= 16'h0800;
			16'h2c: suppose <= 16'h6B0F;
			16'h2d: suppose <= 16'hEF40;
			16'h2e: suppose <= 16'h4F03;
			16'h2f: suppose <= 16'h0800;
			16'h30: suppose <= 16'h1077;
			16'h31: suppose <= 16'h0800;
			16'h32: suppose <= 16'h6EBF;
			16'h33: suppose <= 16'h36C0;
			16'h34: suppose <= 16'hDE60;
			16'h35: suppose <= 16'h0800;
			16'h36: suppose <= 16'h42C0;
			16'h37: suppose <= 16'hF300;
			16'h38: suppose <= 16'h6880;
			16'h39: suppose <= 16'h3000;
			16'h3a: suppose <= 16'hEB0D;
			16'h3b: suppose <= 16'h6FBF;
			16'h3c: suppose <= 16'h37E0;
			16'h3d: suppose <= 16'h4F10;
			16'h3e: suppose <= 16'h9F00;
			16'h3f: suppose <= 16'h9F21;
			16'h40: suppose <= 16'h9F42;
			16'h41: suppose <= 16'h9700;
			16'h42: suppose <= 16'h6301;
			16'h43: suppose <= 16'h6301;
			16'h44: suppose <= 16'h0800;
			16'h45: suppose <= 16'hF301;
			16'h46: suppose <= 16'hEE00;
			16'h47: suppose <= 16'h93FF;
			16'h48: suppose <= 16'h0800;
			16'h49: suppose <= 16'h6807;
			16'h4a: suppose <= 16'hF001;
			16'h4b: suppose <= 16'h68BF;
			16'h4c: suppose <= 16'h3000;
			16'h4d: suppose <= 16'h4810;
			16'h4e: suppose <= 16'h6400;
			16'h4f: suppose <= 16'h0800;
			16'h50: suppose <= 16'h6EBF;
			16'h51: suppose <= 16'h36C0;
			16'h52: suppose <= 16'h4E10;
			16'h53: suppose <= 16'h6800;
			16'h54: suppose <= 16'hDE00;
			16'h55: suppose <= 16'hDE01;
			16'h56: suppose <= 16'hDE02;
			16'h57: suppose <= 16'hDE03;
			16'h58: suppose <= 16'hDE04;
			16'h59: suppose <= 16'hDE05;
			16'h5a: suppose <= 16'hEF40;
			16'h5b: suppose <= 16'h4F03;
			16'h5c: suppose <= 16'h0800;
			16'h5d: suppose <= 16'h104A;
			16'h5e: suppose <= 16'h6EBF;
			16'h5f: suppose <= 16'h36C0;
			16'h60: suppose <= 16'h684F;
			16'h61: suppose <= 16'hDE00;
			16'h62: suppose <= 16'h0800;
			16'h63: suppose <= 16'hEF40;
			16'h64: suppose <= 16'h4F03;
			16'h65: suppose <= 16'h0800;
			16'h66: suppose <= 16'h1041;
			16'h67: suppose <= 16'h6EBF;
			16'h68: suppose <= 16'h36C0;
			16'h69: suppose <= 16'h684B;
			16'h6a: suppose <= 16'hDE00;
			16'h6b: suppose <= 16'h0800;
			16'h6c: suppose <= 16'hEF40;
			16'h6d: suppose <= 16'h4F03;
			16'h6e: suppose <= 16'h0800;
			16'h6f: suppose <= 16'h1038;
			16'h70: suppose <= 16'h6EBF;
			16'h71: suppose <= 16'h36C0;
			16'h72: suppose <= 16'h680A;
			16'h73: suppose <= 16'hDE00;
			16'h74: suppose <= 16'h0800;
			16'h75: suppose <= 16'hEF40;
			16'h76: suppose <= 16'h4F03;
			16'h77: suppose <= 16'h0800;
			16'h78: suppose <= 16'h102F;
			16'h79: suppose <= 16'h6EBF;
			16'h7a: suppose <= 16'h36C0;
			16'h7b: suppose <= 16'h680D;
			16'h7c: suppose <= 16'hDE00;
			16'h7d: suppose <= 16'h0800;
			16'h7e: suppose <= 16'hEF40;
			16'h7f: suppose <= 16'h4F03;
			16'h80: suppose <= 16'h0800;
			16'h81: suppose <= 16'h1031;
			16'h82: suppose <= 16'h0800;
			16'h83: suppose <= 16'h6EBF;
			16'h84: suppose <= 16'h36C0;
			16'h85: suppose <= 16'h9E20;
			16'h86: suppose <= 16'h6EFF;
			16'h87: suppose <= 16'hE9CC;
			16'h88: suppose <= 16'h0800;
			16'h89: suppose <= 16'h6852;
			16'h8a: suppose <= 16'hE82A;
			16'h8b: suppose <= 16'h6032;
			16'h8c: suppose <= 16'h0800;
			16'h8d: suppose <= 16'h6844;
			16'h8e: suppose <= 16'hE82A;
			16'h8f: suppose <= 16'h604D;
			16'h90: suppose <= 16'h0800;
			16'h91: suppose <= 16'h6841;
			16'h92: suppose <= 16'hE82A;
			16'h93: suppose <= 16'h600E;
			16'h94: suppose <= 16'h0800;
			16'h95: suppose <= 16'h6855;
			16'h96: suppose <= 16'hE82A;
			16'h97: suppose <= 16'h6007;
			16'h98: suppose <= 16'h0800;
			16'h99: suppose <= 16'h6847;
			16'h9a: suppose <= 16'hE82A;
			16'h9b: suppose <= 16'h6009;
			16'h9c: suppose <= 16'h0800;
			16'h9d: suppose <= 16'h17E0;
			16'h9e: suppose <= 16'h0800;
			16'h9f: suppose <= 16'h0800;
			16'ha0: suppose <= 16'h10C0;
			16'ha1: suppose <= 16'h0800;
			16'ha2: suppose <= 16'h0800;
			16'ha3: suppose <= 16'h1082;
			16'ha4: suppose <= 16'h0800;
			16'ha5: suppose <= 16'h0800;
			16'ha6: suppose <= 16'h1103;
			16'ha7: suppose <= 16'h0800;
			16'ha8: suppose <= 16'h0800;
			16'ha9: suppose <= 16'h6EBF;
			16'haa: suppose <= 16'h36C0;
			16'hab: suppose <= 16'h4E01;
			16'hac: suppose <= 16'h9E00;
			16'had: suppose <= 16'h6E01;
			16'hae: suppose <= 16'hE8CC;
			16'haf: suppose <= 16'h20F8;
			16'hb0: suppose <= 16'h0800;
			16'hb1: suppose <= 16'hEF00;
			16'hb2: suppose <= 16'h0800;
			16'hb3: suppose <= 16'h0800;
			16'hb4: suppose <= 16'h6EBF;
			16'hb5: suppose <= 16'h36C0;
			16'hb6: suppose <= 16'h4E01;
			16'hb7: suppose <= 16'h9E00;
			16'hb8: suppose <= 16'h6E02;
			16'hb9: suppose <= 16'hE8CC;
			16'hba: suppose <= 16'h20F8;
			16'hbb: suppose <= 16'h0800;
			16'hbc: suppose <= 16'hEF00;
			16'hbd: suppose <= 16'h0800;
			16'hbe: suppose <= 16'h6906;
			16'hbf: suppose <= 16'h6A06;
			16'hc0: suppose <= 16'h68BF;
			16'hc1: suppose <= 16'h3000;
			16'hc2: suppose <= 16'h4810;
			16'hc3: suppose <= 16'hE22F;
			16'hc4: suppose <= 16'hE061;
			16'hc5: suppose <= 16'h9860;
			16'hc6: suppose <= 16'hEF40;
			16'hc7: suppose <= 16'h4F03;
			16'hc8: suppose <= 16'h0800;
			16'hc9: suppose <= 16'h17DE;
			16'hca: suppose <= 16'h0800;
			16'hcb: suppose <= 16'h6EBF;
			16'hcc: suppose <= 16'h36C0;
			16'hcd: suppose <= 16'hDE60;
			16'hce: suppose <= 16'h3363;
			16'hcf: suppose <= 16'hEF40;
			16'hd0: suppose <= 16'h4F03;
			16'hd1: suppose <= 16'h0800;
			16'hd2: suppose <= 16'h17D5;
			16'hd3: suppose <= 16'h0800;
			16'hd4: suppose <= 16'h6EBF;
			16'hd5: suppose <= 16'h36C0;
			16'hd6: suppose <= 16'hDE60;
			16'hd7: suppose <= 16'h49FF;
			16'hd8: suppose <= 16'h0800;
			16'hd9: suppose <= 16'h29E6;
			16'hda: suppose <= 16'h0800;
			16'hdb: suppose <= 16'h17A2;
			16'hdc: suppose <= 16'h0800;
			16'hdd: suppose <= 16'hEF40;
			16'hde: suppose <= 16'h4F03;
			16'hdf: suppose <= 16'h0800;
			16'he0: suppose <= 16'h17D2;
			16'he1: suppose <= 16'h0800;
			16'he2: suppose <= 16'h6EBF;
			16'he3: suppose <= 16'h36C0;
			16'he4: suppose <= 16'h9EA0;
			16'he5: suppose <= 16'h6EFF;
			16'he6: suppose <= 16'hEDCC;
			16'he7: suppose <= 16'h0800;
			16'he8: suppose <= 16'hEF40;
			16'he9: suppose <= 16'h4F03;
			16'hea: suppose <= 16'h0800;
			16'heb: suppose <= 16'h17C7;
			16'hec: suppose <= 16'h0800;
			16'hed: suppose <= 16'h6EBF;
			16'hee: suppose <= 16'h36C0;
			16'hef: suppose <= 16'h9E20;
			16'hf0: suppose <= 16'h6EFF;
			16'hf1: suppose <= 16'hE9CC;
			16'hf2: suppose <= 16'h0800;
			16'hf3: suppose <= 16'h3120;
			16'hf4: suppose <= 16'hE9AD;
			16'hf5: suppose <= 16'hEF40;
			16'hf6: suppose <= 16'h4F03;
			16'hf7: suppose <= 16'h0800;
			16'hf8: suppose <= 16'h17BA;
			16'hf9: suppose <= 16'h0800;
			16'hfa: suppose <= 16'h6EBF;
			16'hfb: suppose <= 16'h36C0;
			16'hfc: suppose <= 16'h9EA0;
			16'hfd: suppose <= 16'h6EFF;
			16'hfe: suppose <= 16'hEDCC;
			16'hff: suppose <= 16'h0800;
			16'h100: suppose <= 16'hEF40;
			16'h101: suppose <= 16'h4F03;
			16'h102: suppose <= 16'h0800;
			16'h103: suppose <= 16'h17AF;
			16'h104: suppose <= 16'h0800;
			16'h105: suppose <= 16'h6EBF;
			16'h106: suppose <= 16'h36C0;
			16'h107: suppose <= 16'h9E40;
			16'h108: suppose <= 16'h6EFF;
			16'h109: suppose <= 16'hEACC;
			16'h10a: suppose <= 16'h0800;
			16'h10b: suppose <= 16'h3240;
			16'h10c: suppose <= 16'hEAAD;
			16'h10d: suppose <= 16'h9960;
			16'h10e: suppose <= 16'hEF40;
			16'h10f: suppose <= 16'h4F03;
			16'h110: suppose <= 16'h0800;
			16'h111: suppose <= 16'h1796;
			16'h112: suppose <= 16'h0800;
			16'h113: suppose <= 16'h6EBF;
			16'h114: suppose <= 16'h36C0;
			16'h115: suppose <= 16'hDE60;
			16'h116: suppose <= 16'h3363;
			16'h117: suppose <= 16'hEF40;
			16'h118: suppose <= 16'h4F03;
			16'h119: suppose <= 16'h0800;
			16'h11a: suppose <= 16'h178D;
			16'h11b: suppose <= 16'h0800;
			16'h11c: suppose <= 16'h6EBF;
			16'h11d: suppose <= 16'h36C0;
			16'h11e: suppose <= 16'hDE60;
			16'h11f: suppose <= 16'h4901;
			16'h120: suppose <= 16'h4AFF;
			16'h121: suppose <= 16'h0800;
			16'h122: suppose <= 16'h2AEA;
			16'h123: suppose <= 16'h0800;
			16'h124: suppose <= 16'h1759;
			16'h125: suppose <= 16'h0800;
			16'h126: suppose <= 16'hEF40;
			16'h127: suppose <= 16'h4F03;
			16'h128: suppose <= 16'h0800;
			16'h129: suppose <= 16'h1789;
			16'h12a: suppose <= 16'h0800;
			16'h12b: suppose <= 16'h6EBF;
			16'h12c: suppose <= 16'h36C0;
			16'h12d: suppose <= 16'h9EA0;
			16'h12e: suppose <= 16'h6EFF;
			16'h12f: suppose <= 16'hEDCC;
			16'h130: suppose <= 16'h0800;
			16'h131: suppose <= 16'hEF40;
			16'h132: suppose <= 16'h4F03;
			16'h133: suppose <= 16'h0800;
			16'h134: suppose <= 16'h177E;
			16'h135: suppose <= 16'h0800;
			16'h136: suppose <= 16'h6EBF;
			16'h137: suppose <= 16'h36C0;
			16'h138: suppose <= 16'h9E20;
			16'h139: suppose <= 16'h6EFF;
			16'h13a: suppose <= 16'hE9CC;
			16'h13b: suppose <= 16'h0800;
			16'h13c: suppose <= 16'h3120;
			16'h13d: suppose <= 16'hE9AD;
			16'h13e: suppose <= 16'h6800;
			16'h13f: suppose <= 16'hE82A;
			16'h140: suppose <= 16'h601D;
			16'h141: suppose <= 16'h0800;
			16'h142: suppose <= 16'hEF40;
			16'h143: suppose <= 16'h4F03;
			16'h144: suppose <= 16'h0800;
			16'h145: suppose <= 16'h176D;
			16'h146: suppose <= 16'h0800;
			16'h147: suppose <= 16'h6EBF;
			16'h148: suppose <= 16'h36C0;
			16'h149: suppose <= 16'h9EA0;
			16'h14a: suppose <= 16'h6EFF;
			16'h14b: suppose <= 16'hEDCC;
			16'h14c: suppose <= 16'h0800;
			16'h14d: suppose <= 16'hEF40;
			16'h14e: suppose <= 16'h4F03;
			16'h14f: suppose <= 16'h0800;
			16'h150: suppose <= 16'h1762;
			16'h151: suppose <= 16'h0800;
			16'h152: suppose <= 16'h6EBF;
			16'h153: suppose <= 16'h36C0;
			16'h154: suppose <= 16'h9E40;
			16'h155: suppose <= 16'h6EFF;
			16'h156: suppose <= 16'hEACC;
			16'h157: suppose <= 16'h0800;
			16'h158: suppose <= 16'h3240;
			16'h159: suppose <= 16'hEAAD;
			16'h15a: suppose <= 16'hD940;
			16'h15b: suppose <= 16'h0800;
			16'h15c: suppose <= 16'h17C9;
			16'h15d: suppose <= 16'h0800;
			16'h15e: suppose <= 16'h0800;
			16'h15f: suppose <= 16'h171E;
			16'h160: suppose <= 16'h0800;
			16'h161: suppose <= 16'hEF40;
			16'h162: suppose <= 16'h4F03;
			16'h163: suppose <= 16'h0800;
			16'h164: suppose <= 16'h174E;
			16'h165: suppose <= 16'h0800;
			16'h166: suppose <= 16'h6EBF;
			16'h167: suppose <= 16'h36C0;
			16'h168: suppose <= 16'h9EA0;
			16'h169: suppose <= 16'h6EFF;
			16'h16a: suppose <= 16'hEDCC;
			16'h16b: suppose <= 16'h0800;
			16'h16c: suppose <= 16'hEF40;
			16'h16d: suppose <= 16'h4F03;
			16'h16e: suppose <= 16'h0800;
			16'h16f: suppose <= 16'h1743;
			16'h170: suppose <= 16'h0800;
			16'h171: suppose <= 16'h6EBF;
			16'h172: suppose <= 16'h36C0;
			16'h173: suppose <= 16'h9E20;
			16'h174: suppose <= 16'h6EFF;
			16'h175: suppose <= 16'hE9CC;
			16'h176: suppose <= 16'h0800;
			16'h177: suppose <= 16'h3120;
			16'h178: suppose <= 16'hE9AD;
			16'h179: suppose <= 16'hEF40;
			16'h17a: suppose <= 16'h4F03;
			16'h17b: suppose <= 16'h0800;
			16'h17c: suppose <= 16'h1736;
			16'h17d: suppose <= 16'h0800;
			16'h17e: suppose <= 16'h6EBF;
			16'h17f: suppose <= 16'h36C0;
			16'h180: suppose <= 16'h9EA0;
			16'h181: suppose <= 16'h6EFF;
			16'h182: suppose <= 16'hEDCC;
			16'h183: suppose <= 16'h0800;
			16'h184: suppose <= 16'hEF40;
			16'h185: suppose <= 16'h4F03;
			16'h186: suppose <= 16'h0800;
			16'h187: suppose <= 16'h172B;
			16'h188: suppose <= 16'h0800;
			16'h189: suppose <= 16'h6EBF;
			16'h18a: suppose <= 16'h36C0;
			16'h18b: suppose <= 16'h9E40;
			16'h18c: suppose <= 16'h6EFF;
			16'h18d: suppose <= 16'hEACC;
			16'h18e: suppose <= 16'h0800;
			16'h18f: suppose <= 16'h3240;
			16'h190: suppose <= 16'hEAAD;
			16'h191: suppose <= 16'h9960;
			16'h192: suppose <= 16'hEF40;
			16'h193: suppose <= 16'h4F03;
			16'h194: suppose <= 16'h0800;
			16'h195: suppose <= 16'h1712;
			16'h196: suppose <= 16'h0800;
			16'h197: suppose <= 16'h6EBF;
			16'h198: suppose <= 16'h36C0;
			16'h199: suppose <= 16'hDE60;
			16'h19a: suppose <= 16'h3363;
			16'h19b: suppose <= 16'hEF40;
			16'h19c: suppose <= 16'h4F03;
			16'h19d: suppose <= 16'h0800;
			16'h19e: suppose <= 16'h1709;
			16'h19f: suppose <= 16'h0800;
			16'h1a0: suppose <= 16'h6EBF;
			16'h1a1: suppose <= 16'h36C0;
			16'h1a2: suppose <= 16'hDE60;
			16'h1a3: suppose <= 16'h4901;
			16'h1a4: suppose <= 16'h4AFF;
			16'h1a5: suppose <= 16'h0800;
			16'h1a6: suppose <= 16'h2AEA;
			16'h1a7: suppose <= 16'h0800;
			16'h1a8: suppose <= 16'h16D5;
			16'h1a9: suppose <= 16'h0800;
			16'h1aa: suppose <= 16'hEF40;
			16'h1ab: suppose <= 16'h4F03;
			16'h1ac: suppose <= 16'h0800;
			16'h1ad: suppose <= 16'h1705;
			16'h1ae: suppose <= 16'h0800;
			16'h1af: suppose <= 16'h6EBF;
			16'h1b0: suppose <= 16'h36C0;
			16'h1b1: suppose <= 16'h9EA0;
			16'h1b2: suppose <= 16'h6EFF;
			16'h1b3: suppose <= 16'hEDCC;
			16'h1b4: suppose <= 16'h0800;
			16'h1b5: suppose <= 16'hEF40;
			16'h1b6: suppose <= 16'h4F03;
			16'h1b7: suppose <= 16'h0800;
			16'h1b8: suppose <= 16'h16FA;
			16'h1b9: suppose <= 16'h0800;
			16'h1ba: suppose <= 16'h6EBF;
			16'h1bb: suppose <= 16'h36C0;
			16'h1bc: suppose <= 16'h9E40;
			16'h1bd: suppose <= 16'h6EFF;
			16'h1be: suppose <= 16'hEACC;
			16'h1bf: suppose <= 16'h0800;
			16'h1c0: suppose <= 16'h3240;
			16'h1c1: suppose <= 16'hEAAD;
			16'h1c2: suppose <= 16'h42C0;
			16'h1c3: suppose <= 16'h6FBF;
			16'h1c4: suppose <= 16'h37E0;
			16'h1c5: suppose <= 16'h4F10;
			16'h1c6: suppose <= 16'h9FA5;
			16'h1c7: suppose <= 16'h63FF;
			16'h1c8: suppose <= 16'hD500;
			16'h1c9: suppose <= 16'hF500;
			16'h1ca: suppose <= 16'h6980;
			16'h1cb: suppose <= 16'h3120;
			16'h1cc: suppose <= 16'hED2D;
			16'h1cd: suppose <= 16'h9F00;
			16'h1ce: suppose <= 16'h9F21;
			16'h1cf: suppose <= 16'h9F42;
			16'h1d0: suppose <= 16'h9F63;
			16'h1d1: suppose <= 16'h9F84;
			16'h1d2: suppose <= 16'hEF40;
			16'h1d3: suppose <= 16'h4F04;
			16'h1d4: suppose <= 16'hF501;
			16'h1d5: suppose <= 16'hEE00;
			16'h1d6: suppose <= 16'h9500;
			16'h1d7: suppose <= 16'h0800;
			16'h1d8: suppose <= 16'h0800;
			16'h1d9: suppose <= 16'h6301;
			16'h1da: suppose <= 16'h6FBF;
			16'h1db: suppose <= 16'h37E0;
			16'h1dc: suppose <= 16'h4F10;
			16'h1dd: suppose <= 16'hDF00;
			16'h1de: suppose <= 16'hDF21;
			16'h1df: suppose <= 16'hDF42;
			16'h1e0: suppose <= 16'hDF63;
			16'h1e1: suppose <= 16'hDF84;
			16'h1e2: suppose <= 16'hDFA5;
			16'h1e3: suppose <= 16'hF000;
			16'h1e4: suppose <= 16'h697F;
			16'h1e5: suppose <= 16'h3120;
			16'h1e6: suppose <= 16'h6AFF;
			16'h1e7: suppose <= 16'hE94D;
			16'h1e8: suppose <= 16'hE82C;
			16'h1e9: suppose <= 16'hF001;
			16'h1ea: suppose <= 16'h6907;
			16'h1eb: suppose <= 16'hEF40;
			16'h1ec: suppose <= 16'h4F03;
			16'h1ed: suppose <= 16'h0800;
			16'h1ee: suppose <= 16'h16B9;
			16'h1ef: suppose <= 16'h0800;
			16'h1f0: suppose <= 16'h6EBF;
			16'h1f1: suppose <= 16'h36C0;
			16'h1f2: suppose <= 16'hDE20;
			16'h1f3: suppose <= 16'h168A;
			16'h1f4: suppose <= 16'h0800;
			default: suppose <= 16'h0000;
			// }}}
		endcase
	end

	always @(*) begin
		if (ram_work_done == 1'b1) begin
			if (addr == done_pc) begin
				data <= ram_feed_back;
				ram_need_to_work <= 1'b0;
				work_done <= 1'b1;
			end
			else begin
				ram_need_to_work <= 1'b1;
				data <= 16'h0800;
				work_done <= 1'b0;
			end
		end
		else begin
			ram_need_to_work <= 1'b1;
			data <= 16'h0800;
			work_done <= 1'b0;
		end
	end

	always @(posedge ram_work_done) begin
		done_pc <= addr;
	end
	endmodule
