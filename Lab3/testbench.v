`timescale 1ns / 1ps

`define CYCLE_TIME 5
`define test_data1_end 56
`define test_data2_end 100

module testbench;
reg clk, Start;
integer     count;
integer     handle;

Simple_Single_CPU CPU(clk, Start);

initial begin
    clk = 0;
    Start = 0;
    count = 0;
    #(`CYCLE_TIME) Start = 1;
end

always #(`CYCLE_TIME/2) clk = ~clk;	

always@(posedge clk) begin
    if(Start) begin
        count = count + 1;
        $display("%4d.  PC = %d", count, CPU.PC.pc_out_o);
        
        // Show specific signal
        // $display("v0 = %d", CPU.Registers.REGISTER_BANK[2]);
        // $display("\n");
        
        // Show register file while processing
        /* $display("- Register File -\n r0 =%6d\t r1 =%6d\t r2 =%6d\t r3 =%6d\n r4 =%6d\t r5 =%6d\t r6 =%6d\t r7 =%6d\n r8 =%6d\t r9 =%6d\tr10 =%6d\tr11 =%6d\nr12 =%6d\tr13 =%6d\tr14 =%6d\tr15 =%6d\nr16 =%6d\tr17 =%6d\tr18 =%6d\tr19 =%6d\nr20 =%6d\tr21 =%6d\tr22 =%6d\tr23 =%6d\nr24 =%6d\tr25 =%6d\tr26 =%6d\tr27 =%6d\nr28 =%6d\tr29 =%6d\tr30 =%6d\tr31 =%6d\n",
            CPU.Registers.REGISTER_BANK[0], CPU.Registers.REGISTER_BANK[1], CPU.Registers.REGISTER_BANK[2], CPU.Registers.REGISTER_BANK[3], CPU.Registers.REGISTER_BANK[4], 
            CPU.Registers.REGISTER_BANK[5], CPU.Registers.REGISTER_BANK[6], CPU.Registers.REGISTER_BANK[7], CPU.Registers.REGISTER_BANK[8], CPU.Registers.REGISTER_BANK[9], 
            CPU.Registers.REGISTER_BANK[10],CPU.Registers.REGISTER_BANK[11], CPU.Registers.REGISTER_BANK[12], CPU.Registers.REGISTER_BANK[13], CPU.Registers.REGISTER_BANK[14],
            CPU.Registers.REGISTER_BANK[15],CPU.Registers.REGISTER_BANK[16], CPU.Registers.REGISTER_BANK[17], CPU.Registers.REGISTER_BANK[18], CPU.Registers.REGISTER_BANK[19],
            CPU.Registers.REGISTER_BANK[20],CPU.Registers.REGISTER_BANK[21], CPU.Registers.REGISTER_BANK[22], CPU.Registers.REGISTER_BANK[23], CPU.Registers.REGISTER_BANK[24],
            CPU.Registers.REGISTER_BANK[25],CPU.Registers.REGISTER_BANK[26], CPU.Registers.REGISTER_BANK[27], CPU.Registers.REGISTER_BANK[28], CPU.Registers.REGISTER_BANK[29],
            CPU.Registers.REGISTER_BANK[30],CPU.Registers.REGISTER_BANK[31]
            ); */
        // Show memory data while processing
        /* $display("- Memory Data -\n m0 =%6d\t m1 =%6d\t m2 =%6d\t m3 =%6d\n m4 =%6d\t m5 =%6d\t m6 =%6d\t m7 =%6d\n m8 =%6d\t m9 =%6d\tm10 =%6d\tm11 =%6d\nm12 =%6d\tm13 =%6d\tm14 =%6d\tm15 =%6d\nm16 =%6d\tm17 =%6d\tm18 =%6d\tm19 =%6d\nm20 =%6d\tm21 =%6d\tm22 =%6d\tm23 =%6d\nm24 =%6d\tm25 =%6d\tm26 =%6d\tm27 =%6d\nm28 =%6d\tm29 =%6d\tm30 =%6d\tm31 =%6d\n",
            CPU.Data_Memory.memory[0], CPU.Data_Memory.memory[1], CPU.Data_Memory.memory[2], CPU.Data_Memory.memory[3], CPU.Data_Memory.memory[4], 
            CPU.Data_Memory.memory[5], CPU.Data_Memory.memory[6], CPU.Data_Memory.memory[7], CPU.Data_Memory.memory[8], CPU.Data_Memory.memory[9], 
            CPU.Data_Memory.memory[10],CPU.Data_Memory.memory[11], CPU.Data_Memory.memory[12], CPU.Data_Memory.memory[13], CPU.Data_Memory.memory[14],
            CPU.Data_Memory.memory[15],CPU.Data_Memory.memory[16], CPU.Data_Memory.memory[17], CPU.Data_Memory.memory[18], CPU.Data_Memory.memory[19],
            CPU.Data_Memory.memory[20],CPU.Data_Memory.memory[21], CPU.Data_Memory.memory[22], CPU.Data_Memory.memory[23], CPU.Data_Memory.memory[24],
            CPU.Data_Memory.memory[25],CPU.Data_Memory.memory[26], CPU.Data_Memory.memory[27], CPU.Data_Memory.memory[28], CPU.Data_Memory.memory[29],
            CPU.Data_Memory.memory[30],CPU.Data_Memory.memory[31]
            ); */

        // Show Result
        if(CPU.PC.pc_in_i > `test_data1_end) begin
            // Display result in console
            $display("- Register File -\n r0 =%6d\t r1 =%6d\t r2 =%6d\t r3 =%6d\n r4 =%6d\t r5 =%6d\t r6 =%6d\t r7 =%6d\n r8 =%6d\t r9 =%6d\tr10 =%6d\tr11 =%6d\nr12 =%6d\tr13 =%6d\tr14 =%6d\tr15 =%6d\nr16 =%6d\tr17 =%6d\tr18 =%6d\tr19 =%6d\nr20 =%6d\tr21 =%6d\tr22 =%6d\tr23 =%6d\nr24 =%6d\tr25 =%6d\tr26 =%6d\tr27 =%6d\nr28 =%6d\tr29 =%6d\tr30 =%6d\tr31 =%6d\n",
                CPU.Registers.REGISTER_BANK[0], CPU.Registers.REGISTER_BANK[1], CPU.Registers.REGISTER_BANK[2], CPU.Registers.REGISTER_BANK[3], CPU.Registers.REGISTER_BANK[4], 
                CPU.Registers.REGISTER_BANK[5], CPU.Registers.REGISTER_BANK[6], CPU.Registers.REGISTER_BANK[7], CPU.Registers.REGISTER_BANK[8], CPU.Registers.REGISTER_BANK[9], 
                CPU.Registers.REGISTER_BANK[10],CPU.Registers.REGISTER_BANK[11], CPU.Registers.REGISTER_BANK[12], CPU.Registers.REGISTER_BANK[13], CPU.Registers.REGISTER_BANK[14],
                CPU.Registers.REGISTER_BANK[15],CPU.Registers.REGISTER_BANK[16], CPU.Registers.REGISTER_BANK[17], CPU.Registers.REGISTER_BANK[18], CPU.Registers.REGISTER_BANK[19],
                CPU.Registers.REGISTER_BANK[20],CPU.Registers.REGISTER_BANK[21], CPU.Registers.REGISTER_BANK[22], CPU.Registers.REGISTER_BANK[23], CPU.Registers.REGISTER_BANK[24],
                CPU.Registers.REGISTER_BANK[25],CPU.Registers.REGISTER_BANK[26], CPU.Registers.REGISTER_BANK[27], CPU.Registers.REGISTER_BANK[28], CPU.Registers.REGISTER_BANK[29],
                CPU.Registers.REGISTER_BANK[30],CPU.Registers.REGISTER_BANK[31]
                );
            $display("- Memory Data -\n m0 =%6d\t m1 =%6d\t m2 =%6d\t m3 =%6d\n m4 =%6d\t m5 =%6d\t m6 =%6d\t m7 =%6d\n m8 =%6d\t m9 =%6d\tm10 =%6d\tm11 =%6d\nm12 =%6d\tm13 =%6d\tm14 =%6d\tm15 =%6d\nm16 =%6d\tm17 =%6d\tm18 =%6d\tm19 =%6d\nm20 =%6d\tm21 =%6d\tm22 =%6d\tm23 =%6d\nm24 =%6d\tm25 =%6d\tm26 =%6d\tm27 =%6d\nm28 =%6d\tm29 =%6d\tm30 =%6d\tm31 =%6d\n",
                CPU.Data_Memory.memory[0], CPU.Data_Memory.memory[1], CPU.Data_Memory.memory[2], CPU.Data_Memory.memory[3], CPU.Data_Memory.memory[4], 
                CPU.Data_Memory.memory[5], CPU.Data_Memory.memory[6], CPU.Data_Memory.memory[7], CPU.Data_Memory.memory[8], CPU.Data_Memory.memory[9], 
                CPU.Data_Memory.memory[10],CPU.Data_Memory.memory[11], CPU.Data_Memory.memory[12], CPU.Data_Memory.memory[13], CPU.Data_Memory.memory[14],
                CPU.Data_Memory.memory[15],CPU.Data_Memory.memory[16], CPU.Data_Memory.memory[17], CPU.Data_Memory.memory[18], CPU.Data_Memory.memory[19],
                CPU.Data_Memory.memory[20],CPU.Data_Memory.memory[21], CPU.Data_Memory.memory[22], CPU.Data_Memory.memory[23], CPU.Data_Memory.memory[24],
                CPU.Data_Memory.memory[25],CPU.Data_Memory.memory[26], CPU.Data_Memory.memory[27], CPU.Data_Memory.memory[28], CPU.Data_Memory.memory[29],
                CPU.Data_Memory.memory[30],CPU.Data_Memory.memory[31]
                );

            // Write result into file
            handle = $fopen("CO_P3_Result.txt");
            $fdisplay(handle, "2022_CO_Lab3_P3_Result");
            $fdisplay(handle, "r0 =%6d\tr1 =%6d\tr2 =%6d\tr3 =%6d\tr4 =%6d\tr5 =%6d\tr6 =%6d\tr7 =%6d\tr8 =%6d\tr9 =%6d\tr10 =%6d\tr11 =%6d\tr12 =%6d\tr13 =%6d\tr14 =%6d\tr15 =%6d\tr16 =%6d\tr17 =%6d\tr18 =%6d\tr19 =%6d\tr20 =%6d\tr21 =%6d\tr22 =%6d\tr23 =%6d\tr24 =%6d\tr25 =%6d\tr26 =%6d\tr27 =%6d\tr28 =%6d\tr29 =%6d\tr30 =%6d\tr31=%6d",
                CPU.Registers.REGISTER_BANK[0], CPU.Registers.REGISTER_BANK[1], CPU.Registers.REGISTER_BANK[2], CPU.Registers.REGISTER_BANK[3], CPU.Registers.REGISTER_BANK[4], 
                CPU.Registers.REGISTER_BANK[5], CPU.Registers.REGISTER_BANK[6], CPU.Registers.REGISTER_BANK[7], CPU.Registers.REGISTER_BANK[8], CPU.Registers.REGISTER_BANK[9], 
                CPU.Registers.REGISTER_BANK[10],CPU.Registers.REGISTER_BANK[11], CPU.Registers.REGISTER_BANK[12], CPU.Registers.REGISTER_BANK[13], CPU.Registers.REGISTER_BANK[14],
                CPU.Registers.REGISTER_BANK[15],CPU.Registers.REGISTER_BANK[16], CPU.Registers.REGISTER_BANK[17], CPU.Registers.REGISTER_BANK[18], CPU.Registers.REGISTER_BANK[19],
                CPU.Registers.REGISTER_BANK[20],CPU.Registers.REGISTER_BANK[21], CPU.Registers.REGISTER_BANK[22], CPU.Registers.REGISTER_BANK[23], CPU.Registers.REGISTER_BANK[24],
                CPU.Registers.REGISTER_BANK[25],CPU.Registers.REGISTER_BANK[26], CPU.Registers.REGISTER_BANK[27], CPU.Registers.REGISTER_BANK[28], CPU.Registers.REGISTER_BANK[29],
                CPU.Registers.REGISTER_BANK[30],CPU.Registers.REGISTER_BANK[31]
                );
            $fdisplay(handle, "m0 =%6d\tm1 =%6d\tm2 =%6d\tm3 =%6d\tm4 =%6d\tm5 =%6d\tm6 =%6d\tm7 =%6d\tm8 =%6d\tm9 =%6d\tm10 =%6d\tm11 =%6d\tm12 =%6d\tm13 =%6d\tm14 =%6d\tm15 =%6d\tm16 =%6d\tm17 =%6d\tm18 =%6d\tm19 =%6d\tm20 =%6d\tm21 =%6d\tm22 =%6d\tm23 =%6d\tm24 =%6d\tm25 =%6d\tm26 =%6d\tm27 =%6d\tm28 =%6d\tm29 =%6d\tm30 =%6d\tm31=%d",
                CPU.Data_Memory.memory[0], CPU.Data_Memory.memory[1], CPU.Data_Memory.memory[2], CPU.Data_Memory.memory[3], CPU.Data_Memory.memory[4], 
                CPU.Data_Memory.memory[5], CPU.Data_Memory.memory[6], CPU.Data_Memory.memory[7], CPU.Data_Memory.memory[8], CPU.Data_Memory.memory[9], 
                CPU.Data_Memory.memory[10],CPU.Data_Memory.memory[11], CPU.Data_Memory.memory[12], CPU.Data_Memory.memory[13], CPU.Data_Memory.memory[14],
                CPU.Data_Memory.memory[15],CPU.Data_Memory.memory[16], CPU.Data_Memory.memory[17], CPU.Data_Memory.memory[18], CPU.Data_Memory.memory[19],
                CPU.Data_Memory.memory[20],CPU.Data_Memory.memory[21], CPU.Data_Memory.memory[22], CPU.Data_Memory.memory[23], CPU.Data_Memory.memory[24],
                CPU.Data_Memory.memory[25],CPU.Data_Memory.memory[26], CPU.Data_Memory.memory[27], CPU.Data_Memory.memory[28], CPU.Data_Memory.memory[29],
                CPU.Data_Memory.memory[30],CPU.Data_Memory.memory[31]
                );    
            $fclose(handle);

            $finish;
        end
    end
end

endmodule