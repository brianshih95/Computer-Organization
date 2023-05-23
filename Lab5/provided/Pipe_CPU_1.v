// 110550108
`timescale 1ns / 1ps

module Pipe_CPU_1(
    clk_i,
    rst_i
);

/*==================================================================*/
/*                          input & output                          */
/*==================================================================*/

input clk_i;
input rst_i;

/*==================================================================*/
/*                            reg & wire                            */
/*==================================================================*/

/**** IF stage ****/
wire [31:0] pc_in;
wire [31:0] pc_out;
wire [31:0] IF_instr;
wire [31:0] IF_pc_add_4;

wire        IF_flush;
wire        IF_ID_write;
wire        PCWrite;
wire        Branch_result;

/**** ID stage ****/
wire [31:0] Write_data;  
wire [31:0] ID_instr;     
wire [31:0] ID_Read_data_1;
wire [31:0] ID_Read_data_2;
wire        ID_RegWrite;
wire  [1:0] ID_ALUOp;
wire        ID_ALUSrc;
wire        ID_RegDst;
wire        ID_Branch;
wire        ID_MemRead;
wire        ID_MemWrite;
wire        ID_MemToReg;
wire [31:0] ID_extended;
wire [31:0] ID_pc_add_4;

wire        ID_flush;
wire  [1:0] ID_Branch_type;

/**** EX stage ****/
wire [ 3:0] ctrl;
wire [31:0] shifted;
wire [31:0] EX_extended;
wire [31:0] EX_Read_data_1;
wire [31:0] EX_ALU_result;
wire        EX_zero;
wire [ 1:0] EX_ALUOp;
wire        EX_ALUSrc;
wire [31:0] EX_instr;
wire        EX_RegDst;
wire  [4:0] EX_Write_register;
wire [31:0] EX_pc_add_4;
wire [31:0] EX_Add_result;
wire        EX_RegWrite;
wire        EX_Branch;
wire        EX_MemRead;
wire        EX_MemWrite;
wire        EX_MemToReg;
wire [31:0] EX_Read_data_2;

wire        EX_flush;
wire  [1:0] EX_Branch_type;
wire [31:0] EX_ForwardB_result;
wire [31:0] ALU_src1;
wire [31:0] ALU_src2;
wire  [1:0] ForwardA;
wire  [1:0] ForwardB;

/**** MEM stage ****/
wire [31:0] MEM_Add_result;
wire        MEM_Branch;
wire        MEM_zero;
wire        MEM_MemRead;
wire        MEM_MemWrite;
wire [31:0] MEM_Read_data;
wire        MEM_RegWrite;
wire        MEM_MemToReg;
wire [31:0] MEM_ALU_result;
wire [ 4:0] MEM_Write_register;

wire  [1:0] MEM_Branch_type;
wire [31:0] MEM_ForwardB_result;

/**** WB stage ****/
wire        WB_RegWrite;
wire        WB_MemToReg;
wire [31:0] WB_Read_data;
wire [31:0] WB_ALU_result;
wire  [4:0] WB_Write_register;

/*==================================================================*/
/*                              design                              */
/*==================================================================*/

//Instantiate the components in IF stage

MUX_2to1 #(.size(32)) Mux0( // Modify N, which is the total length of input/output
    .data0_i(IF_pc_add_4),
    .data1_i(MEM_Add_result),
    .select_i(MEM_Branch & Branch_result),
    .data_o(pc_in)
);

ProgramCounter PC(
    .clk_i(clk_i),
	.rst_i(rst_i),
    .pc_write(PCWrite),
	.pc_in_i(pc_in),
	.pc_out_o(pc_out)
);

Instruction_Memory IM(
    .addr_i(pc_out),
    .instr_o(IF_instr)
);

Adder Add_pc(
    .src1_i(pc_out),
	.src2_i(32'd4),
	.sum_o(IF_pc_add_4)
);

Pipe_Reg #(.size(64)) IF_ID( // Modify N, which is the total length of input/output
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(IF_flush),
    .write(IF_ID_write),
    .data_i({IF_pc_add_4, IF_instr}),
    .data_o({ID_pc_add_4, ID_instr})
);

//Instantiate the components in ID stage

Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RSaddr_i(ID_instr[25:21]),
    .RTaddr_i(ID_instr[20:16]),
    .RDaddr_i(WB_Write_register),
    .RDdata_i(Write_data),
    .RegWrite_i(WB_RegWrite),
    .RSdata_o(ID_Read_data_1),
    .RTdata_o(ID_Read_data_2)
);

Decoder Control(
    .instr_op_i(ID_instr[31:26]),
	.RegWrite_o(ID_RegWrite),
	.ALU_op_o(ID_ALUOp),
	.ALUSrc_o(ID_ALUSrc),
	.RegDst_o(ID_RegDst),
    .Branch_o(ID_Branch),
	.MemRead_o(ID_MemRead),
	.MemWrite_o(ID_MemWrite),
	.MemtoReg_o(ID_MemToReg),
    .BranchType_o(ID_Branch_type)
);

Sign_Extend SE(
    .data_i(ID_instr[15:0]),
    .data_o(ID_extended)
);

Hazard_Detection HD(
    .Branch_i(MEM_Branch & Branch_result),
    .MemRead_i(EX_MemRead),
    .EX_Rt_i(EX_instr[20:16]),
    .ID_instr_i(ID_instr),
    .PCWrite_o(PCWrite),
    .IF_ID_write_o(IF_ID_write),
    .IF_flush_o(IF_flush),
    .ID_flush_o(ID_flush),
    .EX_flush_o(EX_flush)
);

Pipe_Reg #(.size(11 + 32*5)) ID_EX( // Modify N, which is the total length of input/output
    .clk_i(clk_i),
	.rst_i(rst_i),
    .flush(ID_flush),
    .write(1'b1),
    .data_i({ID_RegWrite, ID_ALUOp, ID_ALUSrc, ID_RegDst, ID_Branch, ID_MemRead, ID_MemWrite, ID_MemToReg, ID_Branch_type,
            ID_pc_add_4, ID_Read_data_1, ID_Read_data_2, ID_extended, ID_instr}),
    .data_o({EX_RegWrite, EX_ALUOp, EX_ALUSrc, EX_RegDst, EX_Branch, EX_MemRead, EX_MemWrite, EX_MemToReg, EX_Branch_type,
            EX_pc_add_4, EX_Read_data_1, EX_Read_data_2, EX_extended, EX_instr})
);

//Instantiate the components in EX stage

Shift_Left_Two_32 Shifter(
    .data_i(EX_extended),
    .data_o(shifted)
);

ALU ALU(
    .src1_i(ALU_src1),
	.src2_i(ALU_src2),
	.ctrl_i(ctrl),
	.result_o(EX_ALU_result),
	.zero_o(EX_zero)
);

ALU_Ctrl ALU_Control(
    .funct_i(EX_extended[5:0]),
    .ALUOp_i(EX_ALUOp),
    .ALUCtrl_o(ctrl)
);

MUX_2to1 #(.size(32)) Mux1( // Modify N, which is the total length of input/output
    .data0_i(EX_ForwardB_result),
	.data1_i(EX_extended),
	.select_i(EX_ALUSrc),
    .data_o(ALU_src2)
);

MUX_2to1 #(.size(5)) Mux2( // Modify N, which is the total length of input/output
    .data0_i(EX_instr[20:16]),
	.data1_i(EX_instr[15:11]),
	.select_i(EX_RegDst),
    .data_o(EX_Write_register)
);

Adder Add_pc_branch(
    .src1_i(EX_pc_add_4),
	.src2_i(shifted),
	.sum_o(EX_Add_result)
);

Forwarding Forward(
    .EX_Rs_i(EX_instr[25:21]),
    .EX_Rt_i(EX_instr[20:16]),
    .MEM_RegWrite_i(MEM_RegWrite),
    .MEM_Write_Register_i(MEM_Write_register),
    .WB_RegWrite_i(WB_RegWrite),
    .WB_Write_Register_i(WB_Write_register),
    .forwardA_o(ForwardA),
    .forwardB_o(ForwardB)
);

MUX_3to1 #(.size(32)) Mux_ForwardA(
	.data0_i(EX_Read_data_1),
	.data1_i(MEM_ALU_result),
	.data2_i(Write_data),
	.select_i(ForwardA),
	.data_o(ALU_src1)
);

MUX_3to1 #(.size(32)) Mux_ForwardB(
	.data0_i(EX_Read_data_2),
	.data1_i(MEM_ALU_result),
	.data2_i(Write_data),
	.select_i(ForwardB),
	.data_o(EX_ForwardB_result)
);

Pipe_Reg #(.size(7 + 1 + 32*3 + 5)) EX_MEM( // Modify N, which is the total length of input/output
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(EX_flush),
    .write(1'b1),
    .data_i({EX_RegWrite, EX_Branch, EX_MemRead, EX_MemWrite, EX_MemToReg, EX_Branch_type,
            EX_zero, EX_Add_result, EX_ALU_result, EX_ForwardB_result, EX_Write_register}),
    .data_o({MEM_RegWrite, MEM_Branch, MEM_MemRead, MEM_MemWrite, MEM_MemToReg, MEM_Branch_type,
            MEM_zero, MEM_Add_result, MEM_ALU_result, MEM_ForwardB_result, MEM_Write_register})
);

//Instantiate the components in MEM stage

Data_Memory DM(
    .clk_i(clk_i),
    .addr_i(MEM_ALU_result),
    .data_i(MEM_ForwardB_result),
    .MemRead_i(MEM_MemRead),
    .MemWrite_i(MEM_MemWrite),
    .data_o(MEM_Read_data)
);

MUX_4to1 #(.size(1)) Mux_branch(
	.data0_i(MEM_zero),
	.data1_i(~(MEM_ALU_result[31] | MEM_zero)),
	.data2_i(~(MEM_ALU_result[31])),
	.data3_i(~MEM_zero),
	.select_i(MEM_Branch_type),
	.data_o(Branch_result)
);

Pipe_Reg #(.size(2 + 32*2 + 5)) MEM_WB( // Modify N, which is the total length of input/output
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(1'b0),
    .write(1'b1),
    .data_i({MEM_RegWrite, MEM_MemToReg, MEM_Read_data, MEM_ALU_result, MEM_Write_register}),
    .data_o({WB_RegWrite, WB_MemToReg, WB_Read_data, WB_ALU_result, WB_Write_register})
);

//Instantiate the components in WB stage

MUX_2to1 #(.size(32)) Mux3( // Modify N, which is the total length of input/output
	.data0_i(WB_ALU_result),
    .data1_i(WB_Read_data),
	.select_i(WB_MemToReg),
    .data_o(Write_data)
);

endmodule
