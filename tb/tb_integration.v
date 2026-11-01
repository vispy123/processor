`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Comprehensive Integration Testbench for 7-stage Pipelined RV32IM Processor
//
// Pipeline: IF1 -> IF2 -> ID -> EX1 -> EX2 -> MEM1 -> MEM2 -> WB
//
// Tests:
//   1. Basic ALU (ADDI, ADD, SUB) with NOP padding (no hazards)
//   2. LUI and AUIPC
//   3. Data forwarding (back-to-back dependent instructions)
//   4. Load/Store (SW, LW)
//   5. Branch (BEQ taken)
//   6. JAL / JALR
//   7. Load-use stall (LW followed by dependent ADD)
//   8. Byte/half load/store (SB, LBU, LB)
//////////////////////////////////////////////////////////////////////////////////

module tb_integration;

    //=========================================================================
    // Clock and reset
    //=========================================================================
    reg clk;
    reg reset;

    localparam CLK_PERIOD = 10;

    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    //=========================================================================
    // DUT instantiation
    //=========================================================================
    processor uut (
        .clk(clk),
        .reset(reset)
    );

    //=========================================================================
    // Score tracking
    //=========================================================================
    integer pass_count;
    integer fail_count;
    integer test_num;

    //=========================================================================
    // NOP encoding: ADDI x0, x0, 0
    //=========================================================================
    localparam [31:0] NOP = 32'h00000013;

    //=========================================================================
    // Helper tasks
    //=========================================================================

    // Apply reset for `n` clock cycles
    task apply_reset;
        input integer n;
        integer i;
        begin
            reset = 1;
            for (i = 0; i < n; i = i + 1) @(posedge clk);
            @(negedge clk);
            reset = 0;
        end
    endtask

    // Run the clock for `n` cycles
    task run_clocks;
        input integer n;
        integer i;
        begin
            for (i = 0; i < n; i = i + 1) @(posedge clk);
        end
    endtask

    // Clear instruction memory (first 256 words)
    task clear_imem;
        integer i;
        begin
            for (i = 0; i < 256; i = i + 1)
                uut.u_instr_mem.mem[i] = NOP;
        end
    endtask

    // Clear data memory (first 64 words)
    task clear_dmem;
        integer i;
        begin
            for (i = 0; i < 64; i = i + 1)
                uut.u_data_mem.mem[i] = 32'h00000000;
        end
    endtask

    // Check a register value
    task check_reg;
        input [4:0] reg_num;
        input [31:0] expected;
        begin
            if (uut.u_reg_file.rf[reg_num] === expected) begin
                $display("  [PASS] x%0d = 0x%08h (expected 0x%08h)", reg_num, uut.u_reg_file.rf[reg_num], expected);
                pass_count = pass_count + 1;
            end else begin
                $display("  [FAIL] x%0d = 0x%08h (expected 0x%08h)", reg_num, uut.u_reg_file.rf[reg_num], expected);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Check a data memory word
    task check_dmem;
        input [9:0] addr;
        input [31:0] expected;
        begin
            if (uut.u_data_mem.mem[addr] === expected) begin
                $display("  [PASS] dmem[%0d] = 0x%08h (expected 0x%08h)", addr, uut.u_data_mem.mem[addr], expected);
                pass_count = pass_count + 1;
            end else begin
                $display("  [FAIL] dmem[%0d] = 0x%08h (expected 0x%08h)", addr, uut.u_data_mem.mem[addr], expected);
                fail_count = fail_count + 1;
            end
        end
    endtask

    //=========================================================================
    // Instruction encoding reference (verified by hand):
    //
    // ADDI rd, rs1, imm12:
    //   {imm[11:0], rs1[4:0], 3'b000, rd[4:0], 7'b0010011}
    //
    // ADD rd, rs1, rs2:
    //   {7'b0000000, rs2[4:0], rs1[4:0], 3'b000, rd[4:0], 7'b0110011}
    //
    // SUB rd, rs1, rs2:
    //   {7'b0100000, rs2[4:0], rs1[4:0], 3'b000, rd[4:0], 7'b0110011}
    //
    // LUI rd, imm20:
    //   {imm[31:12], rd[4:0], 7'b0110111}
    //
    // AUIPC rd, imm20:
    //   {imm[31:12], rd[4:0], 7'b0010111}
    //
    // SW rs2, imm(rs1):   S-type, funct3=010
    //   {imm[11:5], rs2[4:0], rs1[4:0], 3'b010, imm[4:0], 7'b0100011}
    //
    // LW rd, imm(rs1):    I-type, funct3=010
    //   {imm[11:0], rs1[4:0], 3'b010, rd[4:0], 7'b0000011}
    //
    // SB rs2, imm(rs1):   S-type, funct3=000
    //   {imm[11:5], rs2[4:0], rs1[4:0], 3'b000, imm[4:0], 7'b0100011}
    //
    // LBU rd, imm(rs1):   I-type, funct3=100
    //   {imm[11:0], rs1[4:0], 3'b100, rd[4:0], 7'b0000011}
    //
    // LB rd, imm(rs1):    I-type, funct3=000
    //   {imm[11:0], rs1[4:0], 3'b000, rd[4:0], 7'b0000011}
    //
    // BEQ rs1, rs2, offset: B-type, funct3=000
    //   {imm[12], imm[10:5], rs2, rs1, 3'b000, imm[4:1], imm[11], 7'b1100011}
    //
    // JAL rd, offset:  J-type
    //   {imm[20], imm[10:1], imm[11], imm[19:12], rd[4:0], 7'b1101111}
    //
    // JALR rd, rs1, imm: I-type
    //   {imm[11:0], rs1[4:0], 3'b000, rd[4:0], 7'b1100111}
    //=========================================================================

    //=========================================================================
    // Main test sequence
    //=========================================================================
    initial begin
        $dumpfile("tb/tb_integration.vcd");
        $dumpvars(0, tb_integration);

        pass_count = 0;
        fail_count = 0;

        //=====================================================================
        // TEST 1: Basic ALU (no hazards, NOP-padded)
        //=====================================================================
        test_num = 1;
        $display("\n=== TEST %0d: Basic ALU (ADDI, ADD, SUB) with NOP padding ===", test_num);
        clear_imem;
        clear_dmem;

        // Program:
        //  0: ADDI x1, x0, 10     -> x1 = 10
        //  1-8: NOP (x8)           -> 7 NOPs + 1 more to let WB write land
        //  9: ADDI x2, x0, 20     -> x2 = 20
        // 10-17: NOP (x8)
        // 18: ADD  x3, x1, x2     -> x3 = 30
        // 19-26: NOP (x8)
        // 27: SUB  x4, x2, x1     -> x4 = 10
        // 28-35: NOP (x8)

        // ADDI x1, x0, 10: imm=10=12'h00A, rs1=0, funct3=000, rd=1, op=0010011
        // {12'h00A, 5'd0, 3'b000, 5'd1, 7'b0010011}
        uut.u_instr_mem.mem[0]  = 32'h00A00093; // ADDI x1, x0, 10
        // NOPs at 1..8 (already NOP from clear_imem)

        // ADDI x2, x0, 20: imm=20=12'h014, rs1=0, funct3=000, rd=2, op=0010011
        // {12'h014, 5'd0, 3'b000, 5'd2, 7'b0010011}
        uut.u_instr_mem.mem[9]  = 32'h01400113; // ADDI x2, x0, 20

        // ADD x3, x1, x2: {7'b0000000, rs2=2, rs1=1, 3'b000, rd=3, 7'b0110011}
        // = {0000000, 00010, 00001, 000, 00011, 0110011}
        uut.u_instr_mem.mem[18] = 32'h002081B3; // ADD x3, x1, x2

        // SUB x4, x2, x1: {7'b0100000, rs2=1, rs1=2, 3'b000, rd=4, 7'b0110011}
        // = {0100000, 00001, 00010, 000, 00100, 0110011}
        uut.u_instr_mem.mem[27] = 32'h40110233; // SUB x4, x2, x1

        apply_reset(3);

        // Run: 36 instructions * 1 cycle each + 8 pipeline drain = ~44 cycles
        run_clocks(50);

        $display("  Checking registers:");
        check_reg(5'd1, 32'd10);
        check_reg(5'd2, 32'd20);
        check_reg(5'd3, 32'd30);
        check_reg(5'd4, 32'd10);

        //=====================================================================
        // TEST 2: LUI and AUIPC
        //=====================================================================
        test_num = 2;
        $display("\n=== TEST %0d: LUI and AUIPC ===", test_num);
        clear_imem;
        clear_dmem;

        // LUI x1, 0xDEADB: {20'hDEADB, 5'd1, 7'b0110111}
        // = DEADB_0_B7 -> 0xDEADB0B7
        uut.u_instr_mem.mem[0]  = 32'hDEADB0B7; // LUI x1, 0xDEADB

        // AUIPC x2, 0x00001: {20'h00001, 5'd2, 7'b0010111}
        // = 00001_1_17 -> 0x00001117
        // This instruction is at address 9*4 = 36 = 0x24
        // So x2 = 0x24 + 0x1000 = 0x1024
        uut.u_instr_mem.mem[9]  = 32'h00001117; // AUIPC x2, 1

        apply_reset(3);

        run_clocks(30);

        $display("  Checking registers:");
        check_reg(5'd1, 32'hDEADB000);
        check_reg(5'd2, 32'h00001024); // PC=0x24 + 0x1000

        //=====================================================================
        // TEST 3: Data forwarding (back-to-back dependent instructions)
        //=====================================================================
        test_num = 3;
        $display("\n=== TEST %0d: Data Forwarding ===", test_num);
        clear_imem;
        clear_dmem;

        // ADDI x1, x0, 5:  {12'h005, 5'd0, 3'b000, 5'd1, 7'b0010011} = 0x00500093
        uut.u_instr_mem.mem[0] = 32'h00500093; // ADDI x1, x0, 5

        // ADDI x2, x0, 3:  {12'h003, 5'd0, 3'b000, 5'd2, 7'b0010011} = 0x00300113
        uut.u_instr_mem.mem[1] = 32'h00300113; // ADDI x2, x0, 3

        // ADD x3, x1, x2:  {7'b0000000, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011} = 0x002081B3
        uut.u_instr_mem.mem[2] = 32'h002081B3; // ADD x3, x1, x2

        apply_reset(3);

        // Lots of NOPs to drain pipeline
        run_clocks(30);

        $display("  Checking registers:");
        check_reg(5'd1, 32'd5);
        check_reg(5'd2, 32'd3);
        check_reg(5'd3, 32'd8);

        //=====================================================================
        // TEST 4: Load/Store (SW then LW)
        //=====================================================================
        test_num = 4;
        $display("\n=== TEST %0d: Load/Store (SW, LW) ===", test_num);
        clear_imem;
        clear_dmem;

        // ADDI x1, x0, 42: 0x02A00093
        uut.u_instr_mem.mem[0] = 32'h02A00093;
        // 7 NOPs (1..7)

        // SW x1, 0(x0): S-type {imm[11:5]=0, rs2=1, rs1=0, funct3=010, imm[4:0]=0, op=0100011}
        // = {7'b0000000, 5'd1, 5'd0, 3'b010, 5'b00000, 7'b0100011}
        // = 0000000_00001_00000_010_00000_0100011 = 0x00102023
        uut.u_instr_mem.mem[8] = 32'h00102023; // SW x1, 0(x0)
        // 7 NOPs (9..15)

        // LW x2, 0(x0): I-type {imm=0, rs1=0, funct3=010, rd=2, op=0000011}
        // = {12'h000, 5'd0, 3'b010, 5'd2, 7'b0000011} = 0x00002103
        uut.u_instr_mem.mem[16] = 32'h00002103; // LW x2, 0(x0)

        apply_reset(3);

        run_clocks(40);

        $display("  Checking registers and memory:");
        check_reg(5'd1, 32'd42);
        check_dmem(10'd0, 32'd42);
        check_reg(5'd2, 32'd42);

        //=====================================================================
        // TEST 5: Branch (BEQ taken)
        //=====================================================================
        test_num = 5;
        $display("\n=== TEST %0d: Branch (BEQ taken) ===", test_num);
        clear_imem;
        clear_dmem;

        // Program layout (word addresses):
        //  0: ADDI x1, x0, 5    = 0x00500093
        //  1-8: NOP
        //  9: ADDI x2, x0, 5    = 0x00500113
        // 10-17: NOP
        // 18: BEQ x1, x2, +8    (branch to PC+8 = addr 18*4+8 = 80 = word 20)
        // 19: ADDI x3, x0, 99   (should be flushed) = 0x06300193
        // 20: ADDI x4, x0, 42   (branch target)     = 0x02A00213
        // 21-28: NOP

        uut.u_instr_mem.mem[0]  = 32'h00500093; // ADDI x1, x0, 5
        uut.u_instr_mem.mem[9]  = 32'h00500113; // ADDI x2, x0, 5

        // BEQ x1, x2, +8:
        // B-type offset = 8 -> imm[12:1] = 8 >> 1 bits = 4 = 12'b000000000100
        // imm[12]=0, imm[11]=0, imm[10:5]=000000, imm[4:1]=0100
        // {imm[12], imm[10:5], rs2=2, rs1=1, funct3=000, imm[4:1], imm[11], op=1100011}
        // {0, 000000, 00010, 00001, 000, 0100, 0, 1100011}
        // = 0_000000_00010_00001_000_0100_0_1100011
        // = 0000000 00010 00001 000 01000 1100011
        // = 00208463
        uut.u_instr_mem.mem[18] = 32'h00208463; // BEQ x1, x2, +8

        uut.u_instr_mem.mem[19] = 32'h06300193; // ADDI x3, x0, 99 (should be flushed)
        uut.u_instr_mem.mem[20] = 32'h02A00213; // ADDI x4, x0, 42 (branch target)

        apply_reset(3);

        run_clocks(45);

        $display("  Checking registers:");
        check_reg(5'd1, 32'd5);
        check_reg(5'd2, 32'd5);
        check_reg(5'd3, 32'd0);   // Should NOT have been executed
        check_reg(5'd4, 32'd42);  // Branch target

        //=====================================================================
        // TEST 6: JAL / JALR
        //=====================================================================
        test_num = 6;
        $display("\n=== TEST %0d: JAL ===", test_num);
        clear_imem;
        clear_dmem;

        // Program layout:
        //  0: JAL x1, +8        -> x1 = PC(0)+4 = 4, jump to PC(0)+8 = 8 (word 2)
        //  1: ADDI x5, x0, 99   (flushed)
        //  2: ADDI x2, x0, 7    (jump target) = 0x00700113
        //  3-10: NOP

        // JAL x1, +8:
        // J-type offset = +8 -> imm[20:1] = 8 >> 1 = 4 = 20'b00000000000000000100
        // imm[20]=0, imm[10:1]=0000000100, imm[11]=0, imm[19:12]=00000000
        // {imm[20], imm[10:1], imm[11], imm[19:12], rd=1, op=1101111}
        // {0, 0000000100, 0, 00000000, 00001, 1101111}
        // = 0_0000000100_0_00000000_00001_1101111
        // = 00800_0EF
        uut.u_instr_mem.mem[0] = 32'h008000EF; // JAL x1, +8

        uut.u_instr_mem.mem[1] = 32'h06300293; // ADDI x5, x0, 99 (should be flushed)
        uut.u_instr_mem.mem[2] = 32'h00700113; // ADDI x2, x0, 7  (jump target)

        apply_reset(3);

        run_clocks(30);

        $display("  Checking registers:");
        check_reg(5'd1, 32'h00000004); // return address = PC+4
        check_reg(5'd2, 32'd7);       // jump target executed
        check_reg(5'd5, 32'd0);       // should NOT have executed

        //=====================================================================
        // TEST 7: Load-use stall
        //=====================================================================
        test_num = 7;
        $display("\n=== TEST %0d: Load-use stall ===", test_num);
        clear_imem;
        clear_dmem;

        uut.u_instr_mem.mem[0]  = 32'h06400093; // ADDI x1, x0, 100
        uut.u_instr_mem.mem[9]  = 32'h00102023; // SW x1, 0(x0)
        uut.u_instr_mem.mem[18] = 32'h00002103; // LW x2, 0(x0)
        uut.u_instr_mem.mem[19] = 32'h000101B3; // ADD x3, x2, x0

        apply_reset(3);

        run_clocks(50);

        $display("  Checking registers:");
        check_reg(5'd1, 32'd100);
        check_reg(5'd2, 32'd100);
        check_reg(5'd3, 32'd100);

        //=====================================================================
        // TEST 8: Byte/Half Load/Store (SB, LBU, LB)
        //=====================================================================
        test_num = 8;
        $display("\n=== TEST %0d: Byte/Half Load/Store ===", test_num);
        apply_reset(3);
        clear_imem;
        clear_dmem;

        // Program:
        //  0: ADDI x1, x0, 255   imm=0xFF=12'h0FF -> x1 = 255
        //     {12'h0FF, 5'd0, 3'b000, 5'd1, 7'b0010011}
        //     = 0x0FF00093
        //  1-8: NOP
        //  9: SB x1, 0(x0)       store byte
        //     S-type: {imm[11:5]=0, rs2=1, rs1=0, funct3=000, imm[4:0]=0, op=0100011}
        //     = {7'b0000000, 5'd1, 5'd0, 3'b000, 5'b00000, 7'b0100011}
        //     = 0000000_00001_00000_000_00000_0100011 = 0x00100023
        // 10-17: NOP
        // 18: LBU x2, 0(x0)      load byte unsigned -> x2 = 255
        //     I-type: {imm=0, rs1=0, funct3=100, rd=2, op=0000011}
        //     = {12'h000, 5'd0, 3'b100, 5'd2, 7'b0000011} = 0x00004103
        // 19-26: NOP
        // 27: LB x3, 0(x0)       load byte signed -> x3 = -1 = 0xFFFFFFFF
        //     I-type: {imm=0, rs1=0, funct3=000, rd=3, op=0000011}
        //     = {12'h000, 5'd0, 3'b000, 5'd3, 7'b0000011} = 0x00000183

        uut.u_instr_mem.mem[0]  = 32'h0FF00093; // ADDI x1, x0, 255
        uut.u_instr_mem.mem[9]  = 32'h00100023; // SB x1, 0(x0)
        uut.u_instr_mem.mem[18] = 32'h00004103; // LBU x2, 0(x0)
        uut.u_instr_mem.mem[27] = 32'h00000183; // LB  x3, 0(x0)

        run_clocks(55);

        $display("  Checking registers:");
        check_reg(5'd1, 32'd255);
        check_reg(5'd2, 32'd255);           // LBU: zero-extended
        check_reg(5'd3, 32'hFFFFFFFF);      // LB: sign-extended 0xFF -> -1

        //=====================================================================
        // Summary
        //=====================================================================
        $display("\n============================================================");
        $display("  INTEGRATION TEST SUMMARY");
        $display("============================================================");
        $display("  PASSED: %0d", pass_count);
        $display("  FAILED: %0d", fail_count);
        $display("  TOTAL:  %0d", pass_count + fail_count);
        if (fail_count == 0)
            $display("  *** ALL TESTS PASSED ***");
        else
            $display("  *** SOME TESTS FAILED ***");
        $display("============================================================\n");

        $finish;
    end

endmodule
