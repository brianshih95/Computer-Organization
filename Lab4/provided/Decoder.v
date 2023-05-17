// 110550108
//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o
	);

//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [2-1:0] ALU_op_o;
output         ALUSrc_o;
output 		   RegDst_o;
output         Branch_o;
output		   MemRead_o;
output		   MemWrite_o;
output 		   MemtoReg_o;

//Internal Signals
reg    [2-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg    		   RegDst_o;
reg            Branch_o;
reg		       MemRead_o;
reg		       MemWrite_o;
reg    		   MemtoReg_o;

//Main function
always @(instr_op_i) begin
	case (instr_op_i)	 
		6'b000000: begin	// r-format(add, sub, and, or, slt, xor, mult)
			RegWrite_o <= 1'b1;
			ALU_op_o <= 2'b10;
			ALUSrc_o <= 1'b0;
			RegDst_o <= 1'b1;
			Branch_o <= 1'b0;
			MemRead_o <= 1'b0;
			MemWrite_o <= 1'b0;
			MemtoReg_o <= 1'b0;
			end
		6'b001000: begin	// addi
			RegWrite_o <= 1'b1;
			ALU_op_o <= 2'b00;  
			ALUSrc_o <= 1'b1; 
			RegDst_o <= 1'b0; 
			Branch_o <= 1'b0;
			MemRead_o <= 1'b0;
			MemWrite_o <= 1'b0;
			MemtoReg_o <= 1'b0;
		end
		6'b001010: begin	// slti
			RegWrite_o <= 1'b1;
			ALU_op_o <= 2'b11;  
			ALUSrc_o <= 1'b1; 
			RegDst_o <= 1'b0; 
			Branch_o <= 1'b0;
			MemRead_o <= 1'b0;
			MemWrite_o <= 1'b0;
			MemtoReg_o <= 1'b0;
		end
		6'b000100: begin	// beq
			RegWrite_o <= 1'b0;
			ALU_op_o <= 2'b01;  
			ALUSrc_o <= 1'b0; 
			RegDst_o <= 1'b0;
			Branch_o <= 1'b1;
			MemRead_o <= 1'b0;
			MemWrite_o <= 1'b0;
			MemtoReg_o <= 1'b0;
		end
		6'b100011: begin	// lw
			RegWrite_o <= 1'b1;
			ALU_op_o <= 2'b00;  
			ALUSrc_o <= 1'b1; 
			RegDst_o <= 1'b0; 
			Branch_o <= 1'b0; 
			MemRead_o <= 1'b1;
			MemWrite_o <= 1'b0;
			MemtoReg_o <= 1'b1;
		end
		6'b101011: begin	// sw
			RegWrite_o <= 1'b0;
			ALU_op_o <= 2'b00;  
			ALUSrc_o <= 1'b1; 
			RegDst_o <= 1'b0;
			Branch_o <= 1'b0; 
			MemRead_o <= 1'b0;
			MemWrite_o <= 1'b1;
			MemtoReg_o <= 1'b0;
		end
		default: begin
			{RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o, Branch_o, MemRead_o, MemWrite_o, MemtoReg_o} <= 9'bxxxxxxxxx;
		end
	endcase
end

endmodule