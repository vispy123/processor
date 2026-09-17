`timescale 1ns / 1ps

module tb_mem_suite();
    reg clk;
    reg reset;

    processor dut (
        .clk(clk),
        .reset(reset)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    integer errors = 0;

    task check(input [4:0] idx, input [31:0] exp, input [127:0] desc);
        begin
            if (dut.u_reg_file.rf[idx] !== exp) begin
                $display("  [FAIL] %0s (x%0d): expected 0x%08h, got 0x%08h", desc, idx, exp, dut.u_reg_file.rf[idx]);
                errors = errors + 1;
            end else begin
                $display("  [PASS] %0s (x%0d) == 0x%08h", desc, idx, exp);
            end
        end
    endtask

    initial begin
        dut.u_instr_mem.mem[0] = 32'h00000013;
        dut.u_instr_mem.mem[1] = 32'h00000093;
        dut.u_instr_mem.mem[2] = 32'h12345137;
        dut.u_instr_mem.mem[3] = 32'h00000013;
        dut.u_instr_mem.mem[4] = 32'h00000013;
        dut.u_instr_mem.mem[5] = 32'h00000013;
        dut.u_instr_mem.mem[6] = 32'h00000013;
        dut.u_instr_mem.mem[7] = 32'h00000013;
        dut.u_instr_mem.mem[8] = 32'h00000013;
        dut.u_instr_mem.mem[9] = 32'h00000013;
        dut.u_instr_mem.mem[10] = 32'h67810113;
        dut.u_instr_mem.mem[11] = 32'h00000013;
        dut.u_instr_mem.mem[12] = 32'h00000013;
        dut.u_instr_mem.mem[13] = 32'h00000013;
        dut.u_instr_mem.mem[14] = 32'h00000013;
        dut.u_instr_mem.mem[15] = 32'h00000013;
        dut.u_instr_mem.mem[16] = 32'h00000013;
        dut.u_instr_mem.mem[17] = 32'h00000013;
        dut.u_instr_mem.mem[18] = 32'h0020a023;
        dut.u_instr_mem.mem[19] = 32'h00000013;
        dut.u_instr_mem.mem[20] = 32'h00000013;
        dut.u_instr_mem.mem[21] = 32'h00000013;
        dut.u_instr_mem.mem[22] = 32'h00000013;
        dut.u_instr_mem.mem[23] = 32'h00000013;
        dut.u_instr_mem.mem[24] = 32'h00000013;
        dut.u_instr_mem.mem[25] = 32'h00000013;
        dut.u_instr_mem.mem[26] = 32'h0000a183;
        dut.u_instr_mem.mem[27] = 32'h00000013;
        dut.u_instr_mem.mem[28] = 32'h00000013;
        dut.u_instr_mem.mem[29] = 32'h00000013;
        dut.u_instr_mem.mem[30] = 32'h00000013;
        dut.u_instr_mem.mem[31] = 32'h00000013;
        dut.u_instr_mem.mem[32] = 32'h00000013;
        dut.u_instr_mem.mem[33] = 32'h00000013;
        dut.u_instr_mem.mem[34] = 32'habcd0237;
        dut.u_instr_mem.mem[35] = 32'h123402b7;
        dut.u_instr_mem.mem[36] = 32'h00000013;
        dut.u_instr_mem.mem[37] = 32'h00000013;
        dut.u_instr_mem.mem[38] = 32'h00000013;
        dut.u_instr_mem.mem[39] = 32'h00000013;
        dut.u_instr_mem.mem[40] = 32'h00000013;
        dut.u_instr_mem.mem[41] = 32'h00000013;
        dut.u_instr_mem.mem[42] = 32'h00000013;
        dut.u_instr_mem.mem[43] = 32'h01025213;
        dut.u_instr_mem.mem[44] = 32'h0102d293;
        dut.u_instr_mem.mem[45] = 32'h00000013;
        dut.u_instr_mem.mem[46] = 32'h00000013;
        dut.u_instr_mem.mem[47] = 32'h00000013;
        dut.u_instr_mem.mem[48] = 32'h00000013;
        dut.u_instr_mem.mem[49] = 32'h00000013;
        dut.u_instr_mem.mem[50] = 32'h00000013;
        dut.u_instr_mem.mem[51] = 32'h00000013;
        dut.u_instr_mem.mem[52] = 32'h00409223;
        dut.u_instr_mem.mem[53] = 32'h00509323;
        dut.u_instr_mem.mem[54] = 32'h00000013;
        dut.u_instr_mem.mem[55] = 32'h00000013;
        dut.u_instr_mem.mem[56] = 32'h00000013;
        dut.u_instr_mem.mem[57] = 32'h00000013;
        dut.u_instr_mem.mem[58] = 32'h00000013;
        dut.u_instr_mem.mem[59] = 32'h00000013;
        dut.u_instr_mem.mem[60] = 32'h00000013;
        dut.u_instr_mem.mem[61] = 32'h00409303;
        dut.u_instr_mem.mem[62] = 32'h0040d383;
        dut.u_instr_mem.mem[63] = 32'h00609403;
        dut.u_instr_mem.mem[64] = 32'h0060d483;
        dut.u_instr_mem.mem[65] = 32'h00000013;
        dut.u_instr_mem.mem[66] = 32'h00000013;
        dut.u_instr_mem.mem[67] = 32'h00000013;
        dut.u_instr_mem.mem[68] = 32'h00000013;
        dut.u_instr_mem.mem[69] = 32'h00000013;
        dut.u_instr_mem.mem[70] = 32'h00000013;
        dut.u_instr_mem.mem[71] = 32'h00000013;
        dut.u_instr_mem.mem[72] = 32'h07e00513;
        dut.u_instr_mem.mem[73] = 32'hfce00593;
        dut.u_instr_mem.mem[74] = 32'h00000013;
        dut.u_instr_mem.mem[75] = 32'h00000013;
        dut.u_instr_mem.mem[76] = 32'h00000013;
        dut.u_instr_mem.mem[77] = 32'h00000013;
        dut.u_instr_mem.mem[78] = 32'h00000013;
        dut.u_instr_mem.mem[79] = 32'h00000013;
        dut.u_instr_mem.mem[80] = 32'h00000013;
        dut.u_instr_mem.mem[81] = 32'h00a08423;
        dut.u_instr_mem.mem[82] = 32'h00b084a3;
        dut.u_instr_mem.mem[83] = 32'h00000013;
        dut.u_instr_mem.mem[84] = 32'h00000013;
        dut.u_instr_mem.mem[85] = 32'h00000013;
        dut.u_instr_mem.mem[86] = 32'h00000013;
        dut.u_instr_mem.mem[87] = 32'h00000013;
        dut.u_instr_mem.mem[88] = 32'h00000013;
        dut.u_instr_mem.mem[89] = 32'h00000013;
        dut.u_instr_mem.mem[90] = 32'h00808603;
        dut.u_instr_mem.mem[91] = 32'h0080c683;
        dut.u_instr_mem.mem[92] = 32'h00908703;
        dut.u_instr_mem.mem[93] = 32'h0090c783;
        dut.u_instr_mem.mem[94] = 32'h00000013;
        dut.u_instr_mem.mem[95] = 32'h00000013;
        dut.u_instr_mem.mem[96] = 32'h00000013;
        dut.u_instr_mem.mem[97] = 32'h00000013;
        dut.u_instr_mem.mem[98] = 32'h00000013;
        dut.u_instr_mem.mem[99] = 32'h00000013;
        dut.u_instr_mem.mem[100] = 32'h00000013;
        dut.u_instr_mem.mem[101] = 32'h00000013;
        dut.u_instr_mem.mem[102] = 32'h00000013;
        dut.u_instr_mem.mem[103] = 32'h00000013;

        for (int i = 104; i < 1024; i = i + 1) begin
            dut.u_instr_mem.mem[i] = 32'h00000013;
        end

        force dut.IF1_IF2_en = 1'b1;
        force dut.IF2_ID_en = 1'b1;
        force dut.ID_EX1_en = 1'b1;
        force dut.EX1_EX2_en = 1'b1;
        force dut.EX2_MEM1_en = 1'b1;
        force dut.MEM1_MEM2_en = 1'b1;
        force dut.MEM2_WB_en = 1'b1;

        force dut.EX1_EX2_flush = 1'b0;
        force dut.EX2_MEM1_flush = 1'b0;
        force dut.MEM1_MEM2_flush = 1'b0;
        force dut.MEM2_WB_flush = 1'b0;

        reset = 1;
        #20;
        @(posedge clk);
        #1;
        reset = 0;

        #1440;

        $display("----------------------------------------");
        $display("RUNNING SUITE: MEM_SUITE");
        $display("----------------------------------------");
        check(5'd3, 32'h12345678, "Reg x3");
        check(5'd6, 32'hffffabcd, "Reg x6");
        check(5'd7, 32'h0000abcd, "Reg x7");
        check(5'd8, 32'h00001234, "Reg x8");
        check(5'd9, 32'h00001234, "Reg x9");
        check(5'd12, 32'h0000007e, "Reg x12");
        check(5'd13, 32'h0000007e, "Reg x13");
        check(5'd14, 32'hffffffce, "Reg x14");
        check(5'd15, 32'h000000ce, "Reg x15");

        $display("----------------------------------------");
        if (errors == 0)
            $display(">>> SUITE MEM_SUITE PASSED (0 errors) <<<");
        else
            $display(">>> SUITE MEM_SUITE FAILED (%0d errors) <<<", errors);
        $display("----------------------------------------\n");
        $finish;
    end
endmodule
