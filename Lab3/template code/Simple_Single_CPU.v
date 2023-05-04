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

module Simple_Single_CPU(
			clk_i,
			rst_i
			);

//I/O port
input       clk_i;
input       rst_i;

//Internal Signals
// PC
wire [31:0] pc_in;
wire [31:0] pc_out;
// Adder1
wire [31:0] sum_1;
// IM
wire [31:0] instr;
// Mux_Write_Reg
wire [1:0]  reg_dst;
wire [4:0]  RDaddr;
// Registers
wire        reg_write;
wire [31:0] write_data;
wire [31:0] RSdata;
wire [31:0] RTdata;
// Decoder
wire [2:0]  ALU_op;
wire        ALU_src;
wire        branch;
wire [1:0]	mem_to_reg;
wire [1:0]  branch_type;
wire     	jump;
wire 		mem_read;
wire        mem_write;
// AC
wire [3:0]  ctrl;
// SE
wire [31:0] extended;
// Mux_ALUSrc
wire [31:0] src2;
// ALU
wire        zero;
wire [31:0] result;
// Data_Memory
wire [31:0] read_data;
// Adder2
wire [31:0] shifted_1;
wire [31:0] sum_2;
// Mux_source
wire [31:0] mux_out_2;
wire [31:0] mux_out_3;
// Shifter2
wire [31:0] shifted_2;
// Mux_ALU_o
wire        mux_out_1;


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

MUX_3to1 #(.size(5)) Mux_Write_Reg(
		.data0_i(instr[20:16]),
		.data1_i(instr[15:11]),
		.data2_i(5'd31),	
		.select_i(reg_dst),
		.data_o(RDaddr)
		);	

Reg_File Registers(
		.clk_i(clk_i),      
		.rst_i(rst_i),     
		.RSaddr_i(instr[25:21]),  
		.RTaddr_i(instr[20:16]),  
		.RDaddr_i(RDaddr),  
		.RDdata_i(write_data), 
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
		.Branch_o(branch),
		.MemtoReg_o(mem_to_reg),
		.BranchType_o(branch_type),
		.Jump_o(jump),
		.MemRead_o(mem_read),
		.MemWrite_o(mem_write)
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

Data_Memory Data_Memory(
        .clk_i(clk_i),
        .addr_i(result),
        .data_i(RTdata),
        .MemRead_i(mem_read),
        .MemWrite_i(mem_write),
        .data_o(read_data)
        );

Adder Adder2(
		.src1_i(sum_1),     
		.src2_i(shifted_1),     
		.sum_o(sum_2)      
		);

Shift_Left_Two_32 Shifter1(
		.data_i(extended),
		.data_o(shifted_1)
		); 		

MUX_2to1 #(.size(32)) Mux_source(
		.data0_i({sum_1[31:28], shifted_2[27:0]}),
		.data1_i(mux_out_2),
		.select_i(jump),
		.data_o(mux_out_3)
		);	


Shift_Left_Two_32 Shifter2(
		.data_i(instr[31:0]),
		.data_o(shifted_2)
		);

MUX_4to1 #(.size(32)) Mux_mem_to_reg(
		.data0_i(result),
		.data1_i(read_data),
		.data2_i(extended),
		.data3_i(sum_1),
		.select_i(mem_to_reg),
		.data_o(write_data)
		);	

MUX_4to1 #(.size(1)) Mux_ALU_o(
		.data0_i(zero),
		.data1_i(~(result[31] | zero)),
		.data2_i(~(result[31])),
		.data3_i(~zero),
		.select_i(branch_type),
		.data_o(mux_out_1)
		);

MUX_2to1 #(.size(32)) Mux_sum(
		.data0_i(sum_1),
		.data1_i(sum_2),
		.select_i(branch & mux_out_1),
		.data_o(mux_out_2)
		);	

MUX_2to1 #(.size(32)) Mux_PC_Source(
		.data0_i(mux_out_3),
		.data1_i(RSdata),
		.select_i((~ALU_op[0] & ALU_op[1] & ~ALU_op[2]) & (~instr[0] & ~instr[1] & ~instr[2] & instr[3] & ~instr[4] & ~instr[5])),
		.data_o(pc_in)
		);

endmodule
