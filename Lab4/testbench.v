`timescale 1ns / 1ps

`define CYCLE_TIME 10

module testbench;


reg         CLK;
reg         RST;
integer     count;
integer     i;
integer     handle;


Pipelined_CPU cpu(
    .clk_i(CLK),
    .rst_i(RST)
);


always #(`CYCLE_TIME/2) CLK = ~CLK;	


initial begin
    CLK = 0;
    RST = 0;
    count = 0;

    // Instruction Memory
    for(i = 0; i < 32; i = i + 1)
    begin
        cpu.IM.instruction_file[i] = 32'b0;
    end
    // Read instruction from file
    $readmemb("CO_P4_test_1.txt", cpu.IM.instruction_file);  /*** Modify this line to try different testcases ***/

    // Data Memory
    for(i = 0; i < 128; i = i + 1)
    begin
        cpu.DM.Mem[i] = 8'b0;
    end
    
    #(`CYCLE_TIME * 3) RST = 1;
end


// Print result
always@(posedge CLK) begin
    count = count + 1;
    $display("%4d.  PC = %d", count, cpu.PC.pc_out_o);
    
    // Show specific signal
    // $display("v0 = %d", cpu.RF.Reg_File[2]);
    // $display("\n");
    
    // Show register file while processing
    /* $display("- Register File -\n r0 =%6d\t r1 =%6d\t r2 =%6d\t r3 =%6d\n r4 =%6d\t r5 =%6d\t r6 =%6d\t r7 =%6d\n r8 =%6d\t r9 =%6d\tr10 =%6d\tr11 =%6d\nr12 =%6d\tr13 =%6d\tr14 =%6d\tr15 =%6d\nr16 =%6d\tr17 =%6d\tr18 =%6d\tr19 =%6d\nr20 =%6d\tr21 =%6d\tr22 =%6d\tr23 =%6d\nr24 =%6d\tr25 =%6d\tr26 =%6d\tr27 =%6d\nr28 =%6d\tr29 =%6d\tr30 =%6d\tr31 =%6d\n",
            cpu.RF.Reg_File[0], cpu.RF.Reg_File[1], cpu.RF.Reg_File[2], cpu.RF.Reg_File[3], 
            cpu.RF.Reg_File[4], cpu.RF.Reg_File[5], cpu.RF.Reg_File[6], cpu.RF.Reg_File[7], 
            cpu.RF.Reg_File[8], cpu.RF.Reg_File[9], cpu.RF.Reg_File[10],cpu.RF.Reg_File[11], 
            cpu.RF.Reg_File[12], cpu.RF.Reg_File[13], cpu.RF.Reg_File[14], cpu.RF.Reg_File[15], 
            cpu.RF.Reg_File[16], cpu.RF.Reg_File[17], cpu.RF.Reg_File[18], cpu.RF.Reg_File[19],
            cpu.RF.Reg_File[20], cpu.RF.Reg_File[21], cpu.RF.Reg_File[22], cpu.RF.Reg_File[23], 
            cpu.RF.Reg_File[24], cpu.RF.Reg_File[25], cpu.RF.Reg_File[26], cpu.RF.Reg_File[27], 
            cpu.RF.Reg_File[28], cpu.RF.Reg_File[29], cpu.RF.Reg_File[30], cpu.RF.Reg_File[31]
    ); */
    // Show memory data while processing
    /* $display("- Memory Data -\n m0 =%6d\t m1 =%6d\t m2 =%6d\t m3 =%6d\n m4 =%6d\t m5 =%6d\t m6 =%6d\t m7 =%6d\n m8 =%6d\t m9 =%6d\tm10 =%6d\tm11 =%6d\nm12 =%6d\tm13 =%6d\tm14 =%6d\tm15 =%6d\nm16 =%6d\tm17 =%6d\tm18 =%6d\tm19 =%6d\nm20 =%6d\tm21 =%6d\tm22 =%6d\tm23 =%6d\nm24 =%6d\tm25 =%6d\tm26 =%6d\tm27 =%6d\nm28 =%6d\tm29 =%6d\tm30 =%6d\tm31 =%6d\n",
            cpu.DM.memory[0], cpu.DM.memory[1], cpu.DM.memory[2], cpu.DM.memory[3], 
            cpu.DM.memory[4], cpu.DM.memory[5], cpu.DM.memory[6], cpu.DM.memory[7], 
            cpu.DM.memory[8], cpu.DM.memory[9], cpu.DM.memory[10],cpu.DM.memory[11], 
            cpu.DM.memory[12], cpu.DM.memory[13], cpu.DM.memory[14], cpu.DM.memory[15],
            cpu.DM.memory[16], cpu.DM.memory[17], cpu.DM.memory[18], cpu.DM.memory[19], 
            cpu.DM.memory[20], cpu.DM.memory[21], cpu.DM.memory[22], cpu.DM.memory[23], 
            cpu.DM.memory[24], cpu.DM.memory[25], cpu.DM.memory[26], cpu.DM.memory[27], 
            cpu.DM.memory[28], cpu.DM.memory[29], cpu.DM.memory[30], cpu.DM.memory[31]
    ); */
    
    // Show Result
    if(cpu.PC.pc_in_i > 128) begin
        $display("\n===============  Final Result  ===============");
        // Display result in console
        $display("- Register File -\n r0 =%6d\t r1 =%6d\t r2 =%6d\t r3 =%6d\n r4 =%6d\t r5 =%6d\t r6 =%6d\t r7 =%6d\n r8 =%6d\t r9 =%6d\tr10 =%6d\tr11 =%6d\nr12 =%6d\tr13 =%6d\tr14 =%6d\tr15 =%6d\nr16 =%6d\tr17 =%6d\tr18 =%6d\tr19 =%6d\nr20 =%6d\tr21 =%6d\tr22 =%6d\tr23 =%6d\nr24 =%6d\tr25 =%6d\tr26 =%6d\tr27 =%6d\nr28 =%6d\tr29 =%6d\tr30 =%6d\tr31 =%6d\n",
                cpu.RF.Reg_File[0], cpu.RF.Reg_File[1], cpu.RF.Reg_File[2], cpu.RF.Reg_File[3], 
                cpu.RF.Reg_File[4], cpu.RF.Reg_File[5], cpu.RF.Reg_File[6], cpu.RF.Reg_File[7], 
                cpu.RF.Reg_File[8], cpu.RF.Reg_File[9], cpu.RF.Reg_File[10],cpu.RF.Reg_File[11], 
                cpu.RF.Reg_File[12], cpu.RF.Reg_File[13], cpu.RF.Reg_File[14], cpu.RF.Reg_File[15], 
                cpu.RF.Reg_File[16], cpu.RF.Reg_File[17], cpu.RF.Reg_File[18], cpu.RF.Reg_File[19],
                cpu.RF.Reg_File[20], cpu.RF.Reg_File[21], cpu.RF.Reg_File[22], cpu.RF.Reg_File[23], 
                cpu.RF.Reg_File[24], cpu.RF.Reg_File[25], cpu.RF.Reg_File[26], cpu.RF.Reg_File[27], 
                cpu.RF.Reg_File[28], cpu.RF.Reg_File[29], cpu.RF.Reg_File[30], cpu.RF.Reg_File[31]
        );
        $display("- Memory Data -\n m0 =%6d\t m1 =%6d\t m2 =%6d\t m3 =%6d\n m4 =%6d\t m5 =%6d\t m6 =%6d\t m7 =%6d\n m8 =%6d\t m9 =%6d\tm10 =%6d\tm11 =%6d\nm12 =%6d\tm13 =%6d\tm14 =%6d\tm15 =%6d\nm16 =%6d\tm17 =%6d\tm18 =%6d\tm19 =%6d\nm20 =%6d\tm21 =%6d\tm22 =%6d\tm23 =%6d\nm24 =%6d\tm25 =%6d\tm26 =%6d\tm27 =%6d\nm28 =%6d\tm29 =%6d\tm30 =%6d\tm31 =%6d\n",
                cpu.DM.memory[0], cpu.DM.memory[1], cpu.DM.memory[2], cpu.DM.memory[3], 
                cpu.DM.memory[4], cpu.DM.memory[5], cpu.DM.memory[6], cpu.DM.memory[7], 
                cpu.DM.memory[8], cpu.DM.memory[9], cpu.DM.memory[10],cpu.DM.memory[11], 
                cpu.DM.memory[12], cpu.DM.memory[13], cpu.DM.memory[14], cpu.DM.memory[15],
                cpu.DM.memory[16], cpu.DM.memory[17], cpu.DM.memory[18], cpu.DM.memory[19], 
                cpu.DM.memory[20], cpu.DM.memory[21], cpu.DM.memory[22], cpu.DM.memory[23], 
                cpu.DM.memory[24], cpu.DM.memory[25], cpu.DM.memory[26], cpu.DM.memory[27], 
                cpu.DM.memory[28], cpu.DM.memory[29], cpu.DM.memory[30], cpu.DM.memory[31]
        );

        // Write result into file
        handle = $fopen("CO_P4_Result.txt");
        $fdisplay(handle, "r0 =%6d\tr1 =%6d\tr2 =%6d\tr3 =%6d\tr4 =%6d\tr5 =%6d\tr6 =%6d\tr7 =%6d\tr8 =%6d\tr9 =%6d\tr10 =%6d\tr11 =%6d\tr12 =%6d\tr13 =%6d\tr14 =%6d\tr15 =%6d\tr16 =%6d\tr17 =%6d\tr18 =%6d\tr19 =%6d\tr20 =%6d\tr21 =%6d\tr22 =%6d\tr23 =%6d\tr24 =%6d\tr25 =%6d\tr26 =%6d\tr27 =%6d\tr28 =%6d\tr29 =%6d\tr30 =%6d\tr31=%6d",
                cpu.RF.Reg_File[0], cpu.RF.Reg_File[1], cpu.RF.Reg_File[2], cpu.RF.Reg_File[3], 
                cpu.RF.Reg_File[4], cpu.RF.Reg_File[5], cpu.RF.Reg_File[6], cpu.RF.Reg_File[7], 
                cpu.RF.Reg_File[8], cpu.RF.Reg_File[9], cpu.RF.Reg_File[10],cpu.RF.Reg_File[11], 
                cpu.RF.Reg_File[12], cpu.RF.Reg_File[13], cpu.RF.Reg_File[14], cpu.RF.Reg_File[15], 
                cpu.RF.Reg_File[16], cpu.RF.Reg_File[17], cpu.RF.Reg_File[18], cpu.RF.Reg_File[19],
                cpu.RF.Reg_File[20], cpu.RF.Reg_File[21], cpu.RF.Reg_File[22], cpu.RF.Reg_File[23], 
                cpu.RF.Reg_File[24], cpu.RF.Reg_File[25], cpu.RF.Reg_File[26], cpu.RF.Reg_File[27], 
                cpu.RF.Reg_File[28], cpu.RF.Reg_File[29], cpu.RF.Reg_File[30], cpu.RF.Reg_File[31]
        );
        $fdisplay(handle, "m0 =%6d\tm1 =%6d\tm2 =%6d\tm3 =%6d\tm4 =%6d\tm5 =%6d\tm6 =%6d\tm7 =%6d\tm8 =%6d\tm9 =%6d\tm10 =%6d\tm11 =%6d\tm12 =%6d\tm13 =%6d\tm14 =%6d\tm15 =%6d\tm16 =%6d\tm17 =%6d\tm18 =%6d\tm19 =%6d\tm20 =%6d\tm21 =%6d\tm22 =%6d\tm23 =%6d\tm24 =%6d\tm25 =%6d\tm26 =%6d\tm27 =%6d\tm28 =%6d\tm29 =%6d\tm30 =%6d\tm31=%d",
                cpu.DM.memory[0], cpu.DM.memory[1], cpu.DM.memory[2], cpu.DM.memory[3], 
                cpu.DM.memory[4], cpu.DM.memory[5], cpu.DM.memory[6], cpu.DM.memory[7], 
                cpu.DM.memory[8], cpu.DM.memory[9], cpu.DM.memory[10],cpu.DM.memory[11], 
                cpu.DM.memory[12], cpu.DM.memory[13], cpu.DM.memory[14], cpu.DM.memory[15],
                cpu.DM.memory[16], cpu.DM.memory[17], cpu.DM.memory[18], cpu.DM.memory[19], 
                cpu.DM.memory[20], cpu.DM.memory[21], cpu.DM.memory[22], cpu.DM.memory[23], 
                cpu.DM.memory[24], cpu.DM.memory[25], cpu.DM.memory[26], cpu.DM.memory[27], 
                cpu.DM.memory[28], cpu.DM.memory[29], cpu.DM.memory[30], cpu.DM.memory[31]
        );    
        $fclose(handle);

        $finish;
    end
end

endmodule
