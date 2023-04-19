// 110550108
//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Simple_Single_CPU(
		clk_i,
		rst_i
		);

//I/O port
input         clk_i;
input         rst_i;

//Internal Signals
// PC
wire [31:0] pc_in;
wire [31:0] pc_out;
// Adder1
wire [31:0] sum_1;
// IM
wire [31:0] instr;
// Mux_Write_Reg
wire        reg_dst;
wire [4:0]  RDaddr;
// RF
wire [31:0] result;
wire        reg_write;
wire [31:0] RSdata;
wire [31:0] RTdata;
// Decoder
wire [2:0]  ALU_op;
wire        ALU_src;
wire        branch;
// AC
wire [3:0]  ctrl;
// SE
wire [31:0] extended;
// Mux_ALUSrc
wire [31:0] src2;
// ALU
wire        zero;
// Adder2
wire [31:0] shifted;
wire [31:0] sum_2;


//Create components
ProgramCounter PC(
		.clk_i(clk_i),      
		.rst_i(rst_i),     
		.pc_in_i(pc_in),   
		.pc_out_o(pc_out) 
		);

Adder Adder1(
		.src1_i(32'd4),     
		.src2_i(pc_out),     
		.sum_o(sum_1)    
		);

Instr_Memory IM(
		.pc_addr_i(pc_out),  
		.instr_o(instr)    
		);

MUX_2to1 #(.size(5)) Mux_Write_Reg(
		.data0_i(instr[20:16]),
		.data1_i(instr[15:11]),
		.select_i(reg_dst),
		.data_o(RDaddr)
		);	

Reg_File RF(
		.clk_i(clk_i),      
		.rst_i(rst_i),     
		.RSaddr_i(instr[25:21]),  
		.RTaddr_i(instr[20:16]),  
		.RDaddr_i(RDaddr),  
		.RDdata_i(result), 
		.RegWrite_i(reg_write),
		.RSdata_o(RSdata),  
		.RTdata_o(RTdata)   
		);

Decoder Decoder(
		.instr_op_i(instr[31:26]), 
		.RegWrite_o(reg_write), 
		.ALU_op_o(ALU_op),   
		.ALUSrc_o(ALU_src),   
		.RegDst_o(reg_dst),   
		.Branch_o(branch)   
		);

ALU_Ctrl AC(
		.funct_i(instr[5:0]),   
		.ALUOp_i(ALU_op),   
		.ALUCtrl_o(ctrl) 
		);
		
Sign_Extend SE(
		.data_i(instr[15:0]),
		.data_o(extended)
		);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
		.data0_i(RTdata),
		.data1_i(extended),
		.select_i(ALU_src),
		.data_o(src2)
		);	
				
ALU ALU(
		.src1_i(RSdata),
		.src2_i(src2),
		.ctrl_i(ctrl),
		.result_o(result),
		.zero_o(zero)
		);

Adder Adder2(
		.src1_i(sum_1),     
		.src2_i(shifted),     
		.sum_o(sum_2)      
		);

Shift_Left_Two_32 Shifter(
		.data_i(extended),
		.data_o(shifted)
		); 		
				
MUX_2to1 #(.size(32)) Mux_PC_Source(
		.data0_i(sum_1),
		.data1_i(sum_2),
		.select_i(branch & zero),
		.data_o(pc_in)
		);	

endmodule
