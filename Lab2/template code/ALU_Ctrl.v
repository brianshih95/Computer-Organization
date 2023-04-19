// 110550108
//Subject:     CO project 2 - ALU Controller
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
module ALU_Ctrl(
        funct_i,
        ALUOp_i,
        ALUCtrl_o
        );

//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    

//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Select exact operation
always @(ALUOp_i, funct_i) begin
    case (ALUOp_i)
        3'b000: // r-format
            case (funct_i)
                6'b100000: ALUCtrl_o <= 4'b0010;    // add
                6'b100010: ALUCtrl_o <= 4'b0110;    // sub
                6'b100100: ALUCtrl_o <= 4'b0000;    // and
                6'b100101: ALUCtrl_o <= 4'b0001;    // or
                6'b101010: ALUCtrl_o <= 4'b0111;    // slt
                default: ALUCtrl_o <= 4'bxxxx;
            endcase
        3'b001: ALUCtrl_o <= 4'b0010;   // addi
        3'b010: ALUCtrl_o <= 4'b0111;   // slti
        3'b011: ALUCtrl_o <= 4'b0110;   // beq
        default: ALUCtrl_o <= 4'bxxxx;
    endcase
end

endmodule     
