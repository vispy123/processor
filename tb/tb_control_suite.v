`timescale 1ns / 1ps

module tb_control_suite();
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
        dut.u_instr_mem.mem[1] = 32'h008000ef;
        dut.u_instr_mem.mem[2] = 32'h11100113;
        dut.u_instr_mem.mem[3] = 32'h22200113;
        dut.u_instr_mem.mem[4] = 32'h00000013;
        dut.u_instr_mem.mem[5] = 32'h00000013;
        dut.u_instr_mem.mem[6] = 32'h00000013;
        dut.u_instr_mem.mem[7] = 32'h00000013;
        dut.u_instr_mem.mem[8] = 32'h00000013;
        dut.u_instr_mem.mem[9] = 32'h00000013;
        dut.u_instr_mem.mem[10] = 32'h00000013;
        dut.u_instr_mem.mem[11] = 32'h05400193;
        dut.u_instr_mem.mem[12] = 32'h00000013;
        dut.u_instr_mem.mem[13] = 32'h00000013;
        dut.u_instr_mem.mem[14] = 32'h00000013;
        dut.u_instr_mem.mem[15] = 32'h00000013;
        dut.u_instr_mem.mem[16] = 32'h00000013;
        dut.u_instr_mem.mem[17] = 32'h00000013;
        dut.u_instr_mem.mem[18] = 32'h00000013;
        dut.u_instr_mem.mem[19] = 32'h00018267;
        dut.u_instr_mem.mem[20] = 32'h11100293;
        dut.u_instr_mem.mem[21] = 32'h33300293;
        dut.u_instr_mem.mem[22] = 32'h00000013;
        dut.u_instr_mem.mem[23] = 32'h00000013;
        dut.u_instr_mem.mem[24] = 32'h00000013;
        dut.u_instr_mem.mem[25] = 32'h00000013;
        dut.u_instr_mem.mem[26] = 32'h00000013;
        dut.u_instr_mem.mem[27] = 32'h00000013;
        dut.u_instr_mem.mem[28] = 32'h00000013;
        dut.u_instr_mem.mem[29] = 32'h00a00313;
        dut.u_instr_mem.mem[30] = 32'h00a00393;
        dut.u_instr_mem.mem[31] = 32'h00000013;
        dut.u_instr_mem.mem[32] = 32'h00000013;
        dut.u_instr_mem.mem[33] = 32'h00000013;
        dut.u_instr_mem.mem[34] = 32'h00000013;
        dut.u_instr_mem.mem[35] = 32'h00000013;
        dut.u_instr_mem.mem[36] = 32'h00000013;
        dut.u_instr_mem.mem[37] = 32'h00000013;
        dut.u_instr_mem.mem[38] = 32'h00730463;
        dut.u_instr_mem.mem[39] = 32'h11100413;
        dut.u_instr_mem.mem[40] = 32'h44400413;
        dut.u_instr_mem.mem[41] = 32'h00000013;
        dut.u_instr_mem.mem[42] = 32'h00000013;
        dut.u_instr_mem.mem[43] = 32'h00000013;
        dut.u_instr_mem.mem[44] = 32'h00000013;
        dut.u_instr_mem.mem[45] = 32'h00000013;
        dut.u_instr_mem.mem[46] = 32'h00000013;
        dut.u_instr_mem.mem[47] = 32'h00000013;
        dut.u_instr_mem.mem[48] = 32'h00b00393;
        dut.u_instr_mem.mem[49] = 32'h00000013;
        dut.u_instr_mem.mem[50] = 32'h00000013;
        dut.u_instr_mem.mem[51] = 32'h00000013;
        dut.u_instr_mem.mem[52] = 32'h00000013;
        dut.u_instr_mem.mem[53] = 32'h00000013;
        dut.u_instr_mem.mem[54] = 32'h00000013;
        dut.u_instr_mem.mem[55] = 32'h00000013;
        dut.u_instr_mem.mem[56] = 32'h00730463;
        dut.u_instr_mem.mem[57] = 32'h55500493;
        dut.u_instr_mem.mem[58] = 32'h00000013;
        dut.u_instr_mem.mem[59] = 32'h00000013;
        dut.u_instr_mem.mem[60] = 32'h00000013;
        dut.u_instr_mem.mem[61] = 32'h00000013;
        dut.u_instr_mem.mem[62] = 32'h00000013;
        dut.u_instr_mem.mem[63] = 32'h00000013;
        dut.u_instr_mem.mem[64] = 32'h00000013;
        dut.u_instr_mem.mem[65] = 32'h00000013;
        dut.u_instr_mem.mem[66] = 32'h00731463;
        dut.u_instr_mem.mem[67] = 32'h11100513;
        dut.u_instr_mem.mem[68] = 32'h66600513;
        dut.u_instr_mem.mem[69] = 32'h00000013;
        dut.u_instr_mem.mem[70] = 32'h00000013;
        dut.u_instr_mem.mem[71] = 32'h00000013;
        dut.u_instr_mem.mem[72] = 32'h00000013;
        dut.u_instr_mem.mem[73] = 32'h00000013;
        dut.u_instr_mem.mem[74] = 32'h00000013;
        dut.u_instr_mem.mem[75] = 32'h00000013;
        dut.u_instr_mem.mem[76] = 32'h00a00393;
        dut.u_instr_mem.mem[77] = 32'h00000013;
        dut.u_instr_mem.mem[78] = 32'h00000013;
        dut.u_instr_mem.mem[79] = 32'h00000013;
        dut.u_instr_mem.mem[80] = 32'h00000013;
        dut.u_instr_mem.mem[81] = 32'h00000013;
        dut.u_instr_mem.mem[82] = 32'h00000013;
        dut.u_instr_mem.mem[83] = 32'h00000013;
        dut.u_instr_mem.mem[84] = 32'h00731463;
        dut.u_instr_mem.mem[85] = 32'h66700813;
        dut.u_instr_mem.mem[86] = 32'h00000013;
        dut.u_instr_mem.mem[87] = 32'h00000013;
        dut.u_instr_mem.mem[88] = 32'h00000013;
        dut.u_instr_mem.mem[89] = 32'h00000013;
        dut.u_instr_mem.mem[90] = 32'h00000013;
        dut.u_instr_mem.mem[91] = 32'h00000013;
        dut.u_instr_mem.mem[92] = 32'h00000013;
        dut.u_instr_mem.mem[93] = 32'h00000013;
        dut.u_instr_mem.mem[94] = 32'hffb00593;
        dut.u_instr_mem.mem[95] = 32'h00000013;
        dut.u_instr_mem.mem[96] = 32'h00000013;
        dut.u_instr_mem.mem[97] = 32'h00000013;
        dut.u_instr_mem.mem[98] = 32'h00000013;
        dut.u_instr_mem.mem[99] = 32'h00000013;
        dut.u_instr_mem.mem[100] = 32'h00000013;
        dut.u_instr_mem.mem[101] = 32'h00000013;
        dut.u_instr_mem.mem[102] = 32'h0065c463;
        dut.u_instr_mem.mem[103] = 32'h11100613;
        dut.u_instr_mem.mem[104] = 32'h77700613;
        dut.u_instr_mem.mem[105] = 32'h00000013;
        dut.u_instr_mem.mem[106] = 32'h00000013;
        dut.u_instr_mem.mem[107] = 32'h00000013;
        dut.u_instr_mem.mem[108] = 32'h00000013;
        dut.u_instr_mem.mem[109] = 32'h00000013;
        dut.u_instr_mem.mem[110] = 32'h00000013;
        dut.u_instr_mem.mem[111] = 32'h00000013;
        dut.u_instr_mem.mem[112] = 32'h00b34463;
        dut.u_instr_mem.mem[113] = 32'h77800893;
        dut.u_instr_mem.mem[114] = 32'h00000013;
        dut.u_instr_mem.mem[115] = 32'h00000013;
        dut.u_instr_mem.mem[116] = 32'h00000013;
        dut.u_instr_mem.mem[117] = 32'h00000013;
        dut.u_instr_mem.mem[118] = 32'h00000013;
        dut.u_instr_mem.mem[119] = 32'h00000013;
        dut.u_instr_mem.mem[120] = 32'h00000013;
        dut.u_instr_mem.mem[121] = 32'h00000013;
        dut.u_instr_mem.mem[122] = 32'h00b35463;
        dut.u_instr_mem.mem[123] = 32'h11100693;
        dut.u_instr_mem.mem[124] = 32'h88800693;
        dut.u_instr_mem.mem[125] = 32'h00000013;
        dut.u_instr_mem.mem[126] = 32'h00000013;
        dut.u_instr_mem.mem[127] = 32'h00000013;
        dut.u_instr_mem.mem[128] = 32'h00000013;
        dut.u_instr_mem.mem[129] = 32'h00000013;
        dut.u_instr_mem.mem[130] = 32'h00000013;
        dut.u_instr_mem.mem[131] = 32'h00000013;
        dut.u_instr_mem.mem[132] = 32'h0065d463;
        dut.u_instr_mem.mem[133] = 32'h88900913;
        dut.u_instr_mem.mem[134] = 32'h00000013;
        dut.u_instr_mem.mem[135] = 32'h00000013;
        dut.u_instr_mem.mem[136] = 32'h00000013;
        dut.u_instr_mem.mem[137] = 32'h00000013;
        dut.u_instr_mem.mem[138] = 32'h00000013;
        dut.u_instr_mem.mem[139] = 32'h00000013;
        dut.u_instr_mem.mem[140] = 32'h00000013;
        dut.u_instr_mem.mem[141] = 32'h00000013;
        dut.u_instr_mem.mem[142] = 32'h00b36463;
        dut.u_instr_mem.mem[143] = 32'h11100713;
        dut.u_instr_mem.mem[144] = 32'h99900713;
        dut.u_instr_mem.mem[145] = 32'h00000013;
        dut.u_instr_mem.mem[146] = 32'h00000013;
        dut.u_instr_mem.mem[147] = 32'h00000013;
        dut.u_instr_mem.mem[148] = 32'h00000013;
        dut.u_instr_mem.mem[149] = 32'h00000013;
        dut.u_instr_mem.mem[150] = 32'h00000013;
        dut.u_instr_mem.mem[151] = 32'h00000013;
        dut.u_instr_mem.mem[152] = 32'h0065e463;
        dut.u_instr_mem.mem[153] = 32'h99a00993;
        dut.u_instr_mem.mem[154] = 32'h00000013;
        dut.u_instr_mem.mem[155] = 32'h00000013;
        dut.u_instr_mem.mem[156] = 32'h00000013;
        dut.u_instr_mem.mem[157] = 32'h00000013;
        dut.u_instr_mem.mem[158] = 32'h00000013;
        dut.u_instr_mem.mem[159] = 32'h00000013;
        dut.u_instr_mem.mem[160] = 32'h00000013;
        dut.u_instr_mem.mem[161] = 32'h00000013;
        dut.u_instr_mem.mem[162] = 32'h0065f463;
        dut.u_instr_mem.mem[163] = 32'h11100793;
        dut.u_instr_mem.mem[164] = 32'haaa00793;
        dut.u_instr_mem.mem[165] = 32'h00000013;
        dut.u_instr_mem.mem[166] = 32'h00000013;
        dut.u_instr_mem.mem[167] = 32'h00000013;
        dut.u_instr_mem.mem[168] = 32'h00000013;
        dut.u_instr_mem.mem[169] = 32'h00000013;
        dut.u_instr_mem.mem[170] = 32'h00000013;
        dut.u_instr_mem.mem[171] = 32'h00000013;
        dut.u_instr_mem.mem[172] = 32'h00b37463;
        dut.u_instr_mem.mem[173] = 32'haab00a13;
        dut.u_instr_mem.mem[174] = 32'h00000013;
        dut.u_instr_mem.mem[175] = 32'h00000013;
        dut.u_instr_mem.mem[176] = 32'h00000013;
        dut.u_instr_mem.mem[177] = 32'h00000013;
        dut.u_instr_mem.mem[178] = 32'h00000013;
        dut.u_instr_mem.mem[179] = 32'h00000013;
        dut.u_instr_mem.mem[180] = 32'h00000013;
        dut.u_instr_mem.mem[181] = 32'h00000013;
        dut.u_instr_mem.mem[182] = 32'h00000013;
        dut.u_instr_mem.mem[183] = 32'h00000013;
        dut.u_instr_mem.mem[184] = 32'h00000013;

        for (int i = 185; i < 1024; i = i + 1) begin
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

        #2250;

        $display("----------------------------------------");
        $display("RUNNING SUITE: CONTROL_SUITE");
        $display("----------------------------------------");
        check(5'd1, 32'h00000008, "Reg x1");
        check(5'd2, 32'h00000222, "Reg x2");
        check(5'd4, 32'h00000050, "Reg x4");
        check(5'd5, 32'h00000333, "Reg x5");
        check(5'd8, 32'h00000444, "Reg x8");
        check(5'd9, 32'h00000555, "Reg x9");
        check(5'd10, 32'h00000666, "Reg x10");
        check(5'd12, 32'h00000777, "Reg x12");
        check(5'd13, 32'hfffff888, "Reg x13");
        check(5'd14, 32'hfffff999, "Reg x14");
        check(5'd15, 32'hfffffaaa, "Reg x15");
        check(5'd16, 32'h00000667, "Reg x16");
        check(5'd17, 32'h00000778, "Reg x17");
        check(5'd18, 32'hfffff889, "Reg x18");
        check(5'd19, 32'hfffff99a, "Reg x19");
        check(5'd20, 32'hfffffaab, "Reg x20");

        $display("----------------------------------------");
        if (errors == 0)
            $display(">>> SUITE CONTROL_SUITE PASSED (0 errors) <<<");
        else
            $display(">>> SUITE CONTROL_SUITE FAILED (%0d errors) <<<", errors);
        $display("----------------------------------------\n");
        $finish;
    end
endmodule
