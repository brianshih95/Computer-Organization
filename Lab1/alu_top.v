`timescale 1ns/1ps
// 110550108
module alu_top(
    /* input */
    src1,       //1 bit, source 1 (A)
    src2,       //1 bit, source 2 (B)
    less,       //1 bit, less
    A_invert,   //1 bit, A_invert
    B_invert,   //1 bit, B_invert
    cin,        //1 bit, carry in
    operation,  //2 bit, operation
    /* output */
    result,     //1 bit, result
    cout        //1 bit, carry out
);

/*==================================================================*/
/*                          input & output                          */
/*==================================================================*/

input src1;
input src2;
input less;
input A_invert;
input B_invert;
input cin;
input [1:0] operation;

output result;
output cout;

/*==================================================================*/
/*                            reg & wire                            */
/*==================================================================*/

reg result, cout;

// handle inverter
wire A, B;
assign A = src1 ^ A_invert;
assign B = src2 ^ B_invert;
/*==================================================================*/
/*                              design                              */
/*==================================================================*/

always@(*) 
begin
    case(operation)
        2'b00: begin
            // AND 
            result = A & B;
            cout = 0;
        end
        2'b01: begin
            // OR 
            result = A | B;
            cout = 0;
        end
        2'b10: begin
            // Adder
            result = A ^ B ^ cin;
            cout = A & B | (A^B) & cin;
        end
        2'b11: begin
            // Set less than
            result = less;
            cout = A & B | (A^B) & cin;
        end
    endcase
end

endmodule
