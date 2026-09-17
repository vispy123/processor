`timescale 1ns / 1ps

module tb_alu_suite();
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
        dut.u_instr_mem.mem[1] = 32'h00a00093;
        dut.u_instr_mem.mem[2] = 32'hffb00113;
        dut.u_instr_mem.mem[3] = 32'h00000013;
        dut.u_instr_mem.mem[4] = 32'h00000013;
        dut.u_instr_mem.mem[5] = 32'h00000013;
        dut.u_instr_mem.mem[6] = 32'h00000013;
        dut.u_instr_mem.mem[7] = 32'h00000013;
        dut.u_instr_mem.mem[8] = 32'h00000013;
        dut.u_instr_mem.mem[9] = 32'h00000013;
        dut.u_instr_mem.mem[10] = 32'h00012193;
        dut.u_instr_mem.mem[11] = 32'h0050a213;
        dut.u_instr_mem.mem[12] = 32'h00a13293;
        dut.u_instr_mem.mem[13] = 32'h0140b313;
        dut.u_instr_mem.mem[14] = 32'h00000013;
        dut.u_instr_mem.mem[15] = 32'h00000013;
        dut.u_instr_mem.mem[16] = 32'h00000013;
        dut.u_instr_mem.mem[17] = 32'h00000013;
        dut.u_instr_mem.mem[18] = 32'h00000013;
        dut.u_instr_mem.mem[19] = 32'h00000013;
        dut.u_instr_mem.mem[20] = 32'h00000013;
        dut.u_instr_mem.mem[21] = 32'h0030c393;
        dut.u_instr_mem.mem[22] = 32'h0050e413;
        dut.u_instr_mem.mem[23] = 32'h0060f493;
        dut.u_instr_mem.mem[24] = 32'h00000013;
        dut.u_instr_mem.mem[25] = 32'h00000013;
        dut.u_instr_mem.mem[26] = 32'h00000013;
        dut.u_instr_mem.mem[27] = 32'h00000013;
        dut.u_instr_mem.mem[28] = 32'h00000013;
        dut.u_instr_mem.mem[29] = 32'h00000013;
        dut.u_instr_mem.mem[30] = 32'h00000013;
        dut.u_instr_mem.mem[31] = 32'h00309513;
        dut.u_instr_mem.mem[32] = 32'h00000013;
        dut.u_instr_mem.mem[33] = 32'h00000013;
        dut.u_instr_mem.mem[34] = 32'h00000013;
        dut.u_instr_mem.mem[35] = 32'h00000013;
        dut.u_instr_mem.mem[36] = 32'h00000013;
        dut.u_instr_mem.mem[37] = 32'h00000013;
        dut.u_instr_mem.mem[38] = 32'h00000013;
        dut.u_instr_mem.mem[39] = 32'h00255593;
        dut.u_instr_mem.mem[40] = 32'h40115613;
        dut.u_instr_mem.mem[41] = 32'h00000013;
        dut.u_instr_mem.mem[42] = 32'h00000013;
        dut.u_instr_mem.mem[43] = 32'h00000013;
        dut.u_instr_mem.mem[44] = 32'h00000013;
        dut.u_instr_mem.mem[45] = 32'h00000013;
        dut.u_instr_mem.mem[46] = 32'h00000013;
        dut.u_instr_mem.mem[47] = 32'h00000013;
        dut.u_instr_mem.mem[48] = 32'h123456b7;
        dut.u_instr_mem.mem[49] = 32'h00001717;
        dut.u_instr_mem.mem[50] = 32'h00000013;
        dut.u_instr_mem.mem[51] = 32'h00000013;
        dut.u_instr_mem.mem[52] = 32'h00000013;
        dut.u_instr_mem.mem[53] = 32'h00000013;
        dut.u_instr_mem.mem[54] = 32'h00000013;
        dut.u_instr_mem.mem[55] = 32'h00000013;
        dut.u_instr_mem.mem[56] = 32'h00000013;
        dut.u_instr_mem.mem[57] = 32'h002087b3;
        dut.u_instr_mem.mem[58] = 32'h40208833;
        dut.u_instr_mem.mem[59] = 32'h00000013;
        dut.u_instr_mem.mem[60] = 32'h00000013;
        dut.u_instr_mem.mem[61] = 32'h00000013;
        dut.u_instr_mem.mem[62] = 32'h00000013;
        dut.u_instr_mem.mem[63] = 32'h00000013;
        dut.u_instr_mem.mem[64] = 32'h00000013;
        dut.u_instr_mem.mem[65] = 32'h00000013;
        dut.u_instr_mem.mem[66] = 32'h00f098b3;
        dut.u_instr_mem.mem[67] = 32'h00112933;
        dut.u_instr_mem.mem[68] = 32'h001139b3;
        dut.u_instr_mem.mem[69] = 32'h00f0ca33;
        dut.u_instr_mem.mem[70] = 32'h00000013;
        dut.u_instr_mem.mem[71] = 32'h00000013;
        dut.u_instr_mem.mem[72] = 32'h00000013;
        dut.u_instr_mem.mem[73] = 32'h00000013;
        dut.u_instr_mem.mem[74] = 32'h00000013;
        dut.u_instr_mem.mem[75] = 32'h00000013;
        dut.u_instr_mem.mem[76] = 32'h00000013;
        dut.u_instr_mem.mem[77] = 32'h00f8dab3;
        dut.u_instr_mem.mem[78] = 32'h40f15b33;
        dut.u_instr_mem.mem[79] = 32'h00f0ebb3;
        dut.u_instr_mem.mem[80] = 32'h00f0fc33;
        dut.u_instr_mem.mem[81] = 32'h00000013;
        dut.u_instr_mem.mem[82] = 32'h00000013;
        dut.u_instr_mem.mem[83] = 32'h00000013;
        dut.u_instr_mem.mem[84] = 32'h00000013;
        dut.u_instr_mem.mem[85] = 32'h00000013;
        dut.u_instr_mem.mem[86] = 32'h00000013;
        dut.u_instr_mem.mem[87] = 32'h00000013;
        dut.u_instr_mem.mem[88] = 32'h03008cb3;
        dut.u_instr_mem.mem[89] = 32'h02f84d33;
        dut.u_instr_mem.mem[90] = 32'h02186db3;
        dut.u_instr_mem.mem[91] = 32'h40209e33;
        dut.u_instr_mem.mem[92] = 32'h0200ceb3;
        dut.u_instr_mem.mem[93] = 32'h0200df33;
        dut.u_instr_mem.mem[94] = 32'h0200efb3;
        dut.u_instr_mem.mem[95] = 32'h00000013;
        dut.u_instr_mem.mem[96] = 32'h00000013;
        dut.u_instr_mem.mem[97] = 32'h00000013;
        dut.u_instr_mem.mem[98] = 32'h00000013;
        dut.u_instr_mem.mem[99] = 32'h00000013;
        dut.u_instr_mem.mem[100] = 32'h00000013;
        dut.u_instr_mem.mem[101] = 32'h00000013;
        dut.u_instr_mem.mem[102] = 32'hffe00193;
        dut.u_instr_mem.mem[103] = 32'h00300213;
        dut.u_instr_mem.mem[104] = 32'h00000013;
        dut.u_instr_mem.mem[105] = 32'h00000013;
        dut.u_instr_mem.mem[106] = 32'h00000013;
        dut.u_instr_mem.mem[107] = 32'h00000013;
        dut.u_instr_mem.mem[108] = 32'h00000013;
        dut.u_instr_mem.mem[109] = 32'h00000013;
        dut.u_instr_mem.mem[110] = 32'h00000013;
        dut.u_instr_mem.mem[111] = 32'h024192b3;
        dut.u_instr_mem.mem[112] = 32'h0241b333;
        dut.u_instr_mem.mem[113] = 32'h0241a3b3;
        dut.u_instr_mem.mem[114] = 32'h00000013;
        dut.u_instr_mem.mem[115] = 32'h00000013;
        dut.u_instr_mem.mem[116] = 32'h00000013;
        dut.u_instr_mem.mem[117] = 32'h00000013;
        dut.u_instr_mem.mem[118] = 32'h00000013;
        dut.u_instr_mem.mem[119] = 32'h00000013;
        dut.u_instr_mem.mem[120] = 32'h00000013;
        dut.u_instr_mem.mem[121] = 32'h00000013;
        dut.u_instr_mem.mem[122] = 32'h00000013;
        dut.u_instr_mem.mem[123] = 32'h00000013;

        for (int i = 124; i < 1024; i = i + 1) begin
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

        #1640;

        $display("----------------------------------------");
        $display("RUNNING SUITE: ALU_SUITE");
        $display("----------------------------------------");
        check(5'd0, 32'h00000000, "Reg x0");
        check(5'd1, 32'h0000000a, "Reg x1");
        check(5'd2, 32'hfffffffb, "Reg x2");
        check(5'd3, 32'hfffffffe, "Reg x3");
        check(5'd4, 32'h00000003, "Reg x4");
        check(5'd5, 32'hffffffff, "Reg x5");
        check(5'd6, 32'h00000002, "Reg x6");
        check(5'd7, 32'hffffffff, "Reg x7");
        check(5'd8, 32'h0000000f, "Reg x8");
        check(5'd9, 32'h00000002, "Reg x9");
        check(5'd10, 32'h00000050, "Reg x10");
        check(5'd11, 32'h00000014, "Reg x11");
        check(5'd12, 32'hfffffffd, "Reg x12");
        check(5'd13, 32'h12345000, "Reg x13");
        check(5'd14, 32'h000010c4, "Reg x14");
        check(5'd15, 32'h00000005, "Reg x15");
        check(5'd16, 32'h0000000f, "Reg x16");
        check(5'd17, 32'h00000140, "Reg x17");
        check(5'd18, 32'h00000001, "Reg x18");
        check(5'd19, 32'h00000000, "Reg x19");
        check(5'd20, 32'h0000000f, "Reg x20");
        check(5'd21, 32'h0000000a, "Reg x21");
        check(5'd22, 32'hffffffff, "Reg x22");
        check(5'd23, 32'h0000000f, "Reg x23");
        check(5'd24, 32'h00000000, "Reg x24");
        check(5'd25, 32'h00000096, "Reg x25");
        check(5'd26, 32'h00000003, "Reg x26");
        check(5'd27, 32'h00000005, "Reg x27");
        check(5'd28, 32'h000000e1, "Reg x28");
        check(5'd29, 32'hffffffff, "Reg x29");
        check(5'd30, 32'hffffffff, "Reg x30");
        check(5'd31, 32'h0000000a, "Reg x31");

        $display("----------------------------------------");
        if (errors == 0)
            $display(">>> SUITE ALU_SUITE PASSED (0 errors) <<<");
        else
            $display(">>> SUITE ALU_SUITE FAILED (%0d errors) <<<", errors);
        $display("----------------------------------------\n");
        $finish;
    end
endmodule
