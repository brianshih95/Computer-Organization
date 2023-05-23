// 110550108
module Hazard_Detection(
    Branch_i,
    MemRead_i,
    EX_Rt_i,
    ID_instr_i,
    PCWrite_o,
    IF_ID_write_o,
    IF_flush_o,
    ID_flush_o,
    EX_flush_o
);

input        Branch_i;
input        MemRead_i;
input [ 4:0] EX_Rt_i;
input [31:0] ID_instr_i;

output       PCWrite_o;
output       IF_ID_write_o;
output       IF_flush_o;
output       ID_flush_o;
output       EX_flush_o;

reg          PCWrite_o;
reg          IF_ID_write_o;
reg          IF_flush_o;
reg          ID_flush_o;
reg          EX_flush_o;

always @(*) begin
    // branch hazard
    if (Branch_i) begin
        PCWrite_o <= 1'b1;
        IF_ID_write_o <= 1'b1;
        IF_flush_o <= 1'b1;
        ID_flush_o <= 1'b1;
        EX_flush_o <= 1'b1;
    end
    // load-use hazard 
    else if (MemRead_i && (EX_Rt_i == ID_instr_i[25:21] || EX_Rt_i == ID_instr_i[20:16])) begin
        PCWrite_o <= 1'b0;
        IF_ID_write_o <= 1'b0;
        IF_flush_o <= 1'b0;
        ID_flush_o <= 1'b1;
        EX_flush_o <= 1'b0;
    end
    // no hazard
    else begin
        PCWrite_o <= 1'b1;
        IF_ID_write_o <= 1'b1;
        IF_flush_o <= 1'b0;
        ID_flush_o <= 1'b0;
        EX_flush_o <= 1'b0;
    end
end

endmodule
