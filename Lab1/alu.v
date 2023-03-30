`timescale 1ns/1ps
// 110550108
module alu(
    /* input */
    clk,            // system clock
    rst_n,          // negative reset
    src1,           // 32 bits, source 1
    src2,           // 32 bits, source 2
    ALU_control,    // 4 bits, ALU control input
    /* output */
    result,         // 32 bits, result
    zero,           // 1 bit, set to 1 when the output is 0
    cout,           // 1 bit, carry out
    overflow        // 1 bit, overflow
);

/*==================================================================*/
/*                          input & output                          */
/*==================================================================*/

input clk;
input rst_n;
input [31:0] src1;
input [31:0] src2;
input [3:0] ALU_control;

output [32-1:0] result;
output zero;
output cout;
output overflow;

/*==================================================================*/
/*                            reg & wire                            */
/*==================================================================*/

reg [32-1:0] result;
reg zero, cout, overflow;

wire [31:0] couts;  // store cout of each 1-bit ALU
wire [31:0] tmp_result;
wire set;
assign set = (src1[31] ^ (~src2[31]) ^ couts[30]);  /* if MSB is 1 after addition,
                                                    it means a < b */

/*==================================================================*/
/*                              design                              */
/*==================================================================*/

// LSB
alu_top ALU0(
    .src1(src1[0]),
    .src2(src2[0]), 
    .less(set),
    .A_invert(ALU_control[3]), 
    .B_invert(ALU_control[2]), 
    .cin(ALU_control[3:2]==2'b01),  // set to 1 only when the operation is "sub"
    .operation(ALU_control[1:0]), 
    .result(tmp_result[0]), 
    .cout(couts[0]));

// generate ALU for other bits
generate
    genvar i;
    for(i = 1; i < 32; i = i + 1) begin
        alu_top ALUi(
            .src1(src1[i]), 
            .src2(src2[i]), 
            .less(1'b0),    // set to 0 when the current bit is not LSB 
            .A_invert(ALU_control[3]), 
            .B_invert(ALU_control[2]), 
            .cin(couts[i-1]),   /* the carry in of the current bit is 
                                    the carry out of the previous bit*/
            .operation(ALU_control[1:0]), 
            .result(tmp_result[i]), 
            .cout(couts[i]));
    end
endgenerate

always@(posedge clk or negedge rst_n) 
begin
	if(rst_n) begin
        cout = 0;
        overflow = 0;
        result = tmp_result;
        zero = (result == 0) ? 1 : 0;
        // handle carry out and overflow flags in "add" and "sub" operations
        if(ALU_control[1:0] == 2'b10) begin
            cout = couts[31];
            overflow = couts[30] ^ couts[31];
        end
	end
end

endmodule
