// 110550108
module Forwarding(
    EX_Rs_i,
    EX_Rt_i,
    MEM_RegWrite_i,
    MEM_Write_Register_i,
    WB_RegWrite_i,
    WB_Write_Register_i,
    forwardA_o,
    forwardB_o
);

input  [4:0] EX_Rs_i;
input  [4:0] EX_Rt_i;
input        MEM_RegWrite_i;
input  [4:0] MEM_Write_Register_i;
input        WB_RegWrite_i;
input  [4:0] WB_Write_Register_i;

output [1:0] forwardA_o;
output [1:0] forwardB_o;

reg    [1:0] forwardA_o;
reg    [1:0] forwardB_o;

always @(*) begin
    // Rs
    // EX hazard
    if (MEM_RegWrite_i && MEM_Write_Register_i != 0 && MEM_Write_Register_i == EX_Rs_i) begin
        forwardA_o <= 2'b01;
    end
    // MEM hazard
    else if (WB_RegWrite_i && WB_Write_Register_i != 0 && WB_Write_Register_i == EX_Rs_i) begin
        forwardA_o <= 2'b10;
    end
    else begin
        forwardA_o <= 2'b00;
    end

    // Rt
    // EX hazard
    if (MEM_RegWrite_i && MEM_Write_Register_i != 0 && MEM_Write_Register_i == EX_Rt_i) begin
        forwardB_o <= 2'b01;
    end
    // MEM hazard
    else if (WB_RegWrite_i && WB_Write_Register_i != 0 && WB_Write_Register_i == EX_Rt_i) begin
        forwardB_o <= 2'b10;
    end
    else begin
        forwardB_o <= 2'b00;
    end
end

endmodule
