`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Comprehensive self-checking testbench for:
//   1. load       (rtl/load.v)
//   2. store      (rtl/store.v)
//   3. branch_taken (rtl/branch_taken.v)
//   4. reg_file   (rtl/reg_file.v)
//////////////////////////////////////////////////////////////////////////////

module tb_load_store;

    // -----------------------------------------------------------------------
    // Global counters
    // -----------------------------------------------------------------------
    integer pass_count = 0;
    integer fail_count = 0;

    // =======================================================================
    //  LOAD MODULE SIGNALS
    // =======================================================================
    reg  [31:0] ld_dout;
    reg         ld_mem_read;
    reg  [2:0]  ld_load_op;
    reg  [1:0]  ld_offset;
    wire [31:0] ld_data_out;

    load uut_load (
        .dout     (ld_dout),
        .mem_read (ld_mem_read),
        .load_op  (ld_load_op),
        .offset   (ld_offset),
        .data_out (ld_data_out)
    );

    // =======================================================================
    //  STORE MODULE SIGNALS
    // =======================================================================
    reg         st_mem_write;
    reg  [1:0]  st_store_op;
    reg  [1:0]  st_offset;
    reg  [31:0] st_din;
    wire [3:0]  st_we;
    wire [31:0] st_din_out;

    store uut_store (
        .mem_write (st_mem_write),
        .store_op  (st_store_op),
        .offset    (st_offset),
        .din       (st_din),
        .we        (st_we),
        .din_out   (st_din_out)
    );

    // =======================================================================
    //  BRANCH_TAKEN MODULE SIGNALS
    // =======================================================================
    reg         br_branch;
    reg  [2:0]  br_branch_op;
    reg         br_wb_sel_pc_plus4;
    reg  [31:0] br_rs1_data;
    reg  [31:0] br_rs2_data;
    wire        br_branch_taken;

    branch_taken uut_branch (
        .branch          (br_branch),
        .branch_op       (br_branch_op),
        .wb_sel_pc_plus4 (br_wb_sel_pc_plus4),
        .rs1_data        (br_rs1_data),
        .rs2_data        (br_rs2_data),
        .branch_taken    (br_branch_taken)
    );

    // =======================================================================
    //  REG_FILE MODULE SIGNALS
    // =======================================================================
    reg         rf_write_enable;
    reg  [4:0]  rf_rd;
    reg  [31:0] rf_write_data;
    reg  [4:0]  rf_rs1;
    reg  [4:0]  rf_rs2;
    wire [31:0] rf_read_data1;
    wire [31:0] rf_read_data2;
    reg         rf_clk;
    reg         rf_reset;

    reg_file uut_regfile (
        .write_enable (rf_write_enable),
        .rd           (rf_rd),
        .write_data   (rf_write_data),
        .rs1          (rf_rs1),
        .rs2          (rf_rs2),
        .read_data1   (rf_read_data1),
        .read_data2   (rf_read_data2),
        .clk          (rf_clk),
        .reset        (rf_reset)
    );

    // Clock generation for reg_file
    initial rf_clk = 0;
    always #5 rf_clk = ~rf_clk;

    // -----------------------------------------------------------------------
    // Helper tasks
    // -----------------------------------------------------------------------

    task check_load;
        input [31:0] dout_val;
        input [2:0]  op;
        input [1:0]  off;
        input [31:0] expected;
        input [255:0] label;  // string label
        begin
            ld_dout     = dout_val;
            ld_mem_read = 1;
            ld_load_op  = op;
            ld_offset   = off;
            #1;
            if (ld_data_out === expected) begin
                $display("  PASS: LOAD %0s | dout=%h off=%0d => %h", label, dout_val, off, ld_data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL: LOAD %0s | dout=%h off=%0d => got %h, exp %h", label, dout_val, off, ld_data_out, expected);
                fail_count = fail_count + 1;
            end
        end
    endtask

    task check_store;
        input [1:0]  op;
        input [1:0]  off;
        input [31:0] din_val;
        input [3:0]  exp_we;
        input [31:0] exp_dout;
        input [255:0] label;
        begin
            st_mem_write = 1;
            st_store_op  = op;
            st_offset    = off;
            st_din       = din_val;
            #1;
            if (st_we === exp_we && st_din_out === exp_dout) begin
                $display("  PASS: STORE %0s | din=%h off=%0d => we=%b din_out=%h", label, din_val, off, st_we, st_din_out);
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL: STORE %0s | din=%h off=%0d => we=%b(exp %b) din_out=%h(exp %h)", label, din_val, off, st_we, exp_we, st_din_out, exp_dout);
                fail_count = fail_count + 1;
            end
        end
    endtask

    task check_branch;
        input        branch_val;
        input [2:0]  op;
        input        wb_sel;
        input [31:0] rs1;
        input [31:0] rs2;
        input        expected;
        input [255:0] label;
        begin
            br_branch          = branch_val;
            br_branch_op       = op;
            br_wb_sel_pc_plus4 = wb_sel;
            br_rs1_data        = rs1;
            br_rs2_data        = rs2;
            #1;
            if (br_branch_taken === expected) begin
                $display("  PASS: BRANCH %0s | br=%b op=%b wb=%b rs1=%h rs2=%h => %b", label, branch_val, op, wb_sel, rs1, rs2, br_branch_taken);
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL: BRANCH %0s | br=%b op=%b wb=%b rs1=%h rs2=%h => got %b, exp %b", label, branch_val, op, wb_sel, rs1, rs2, br_branch_taken, expected);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // -----------------------------------------------------------------------
    // Main test
    // -----------------------------------------------------------------------
    initial begin
        $display("============================================================");
        $display(" TESTBENCH START: load, store, branch_taken, reg_file");
        $display("============================================================");

        // ==================================================================
        //  1. LOAD MODULE TESTS
        // ==================================================================
        $display("\n--- LOAD MODULE TESTS ---");

        // ---- LB (load_op = 000) ----
        // Data = 0xDEADBEEF  => bytes: [7:0]=EF, [15:8]=BE, [23:16]=AD, [31:24]=DE
        check_load(32'hDEADBEEF, 3'b000, 2'b00, 32'hFFFFFFEF, "LB off0 DEADBEEF");
        check_load(32'hDEADBEEF, 3'b000, 2'b01, 32'hFFFFFFBE, "LB off1 DEADBEEF");
        check_load(32'hDEADBEEF, 3'b000, 2'b10, 32'hFFFFFFAD, "LB off2 DEADBEEF");
        check_load(32'hDEADBEEF, 3'b000, 2'b11, 32'hFFFFFFDE, "LB off3 DEADBEEF");

        // Data = 0x80FF7F01  => bytes: [7:0]=01, [15:8]=7F, [23:16]=FF, [31:24]=80
        check_load(32'h80FF7F01, 3'b000, 2'b00, 32'h00000001, "LB off0 80FF7F01");
        check_load(32'h80FF7F01, 3'b000, 2'b01, 32'h0000007F, "LB off1 80FF7F01");
        check_load(32'h80FF7F01, 3'b000, 2'b10, 32'hFFFFFFFF, "LB off2 80FF7F01");
        check_load(32'h80FF7F01, 3'b000, 2'b11, 32'hFFFFFF80, "LB off3 80FF7F01");

        // ---- LH (load_op = 001) ----
        // Data = 0xDEADBEEF => half[15:0]=BEEF (sign bit=1), half[31:16]=DEAD (sign bit=1)
        check_load(32'hDEADBEEF, 3'b001, 2'b00, 32'hFFFFBEEF, "LH off0 DEADBEEF");
        check_load(32'hDEADBEEF, 3'b001, 2'b10, 32'hFFFFDEAD, "LH off2 DEADBEEF");
        // Misaligned offsets => 0
        check_load(32'hDEADBEEF, 3'b001, 2'b01, 32'h00000000, "LH off1 DEADBEEF (misalign)");
        check_load(32'hDEADBEEF, 3'b001, 2'b11, 32'h00000000, "LH off3 DEADBEEF (misalign)");

        // Data = 0x80FF7F01 => half[15:0]=7F01 (sign bit=0), half[31:16]=80FF (sign bit=1)
        check_load(32'h80FF7F01, 3'b001, 2'b00, 32'h00007F01, "LH off0 80FF7F01");
        check_load(32'h80FF7F01, 3'b001, 2'b10, 32'hFFFF80FF, "LH off2 80FF7F01");

        // ---- LW (load_op = 010) ----
        check_load(32'hDEADBEEF, 3'b010, 2'b00, 32'hDEADBEEF, "LW off0 DEADBEEF");
        check_load(32'h80FF7F01, 3'b010, 2'b00, 32'h80FF7F01, "LW off0 80FF7F01");
        check_load(32'h00000000, 3'b010, 2'b00, 32'h00000000, "LW off0 00000000");
        check_load(32'hFFFFFFFF, 3'b010, 2'b00, 32'hFFFFFFFF, "LW off0 FFFFFFFF");

        // ---- LBU (load_op = 011) ----
        check_load(32'hDEADBEEF, 3'b011, 2'b00, 32'h000000EF, "LBU off0 DEADBEEF");
        check_load(32'hDEADBEEF, 3'b011, 2'b01, 32'h000000BE, "LBU off1 DEADBEEF");
        check_load(32'hDEADBEEF, 3'b011, 2'b10, 32'h000000AD, "LBU off2 DEADBEEF");
        check_load(32'hDEADBEEF, 3'b011, 2'b11, 32'h000000DE, "LBU off3 DEADBEEF");

        check_load(32'h80FF7F01, 3'b011, 2'b00, 32'h00000001, "LBU off0 80FF7F01");
        check_load(32'h80FF7F01, 3'b011, 2'b01, 32'h0000007F, "LBU off1 80FF7F01");
        check_load(32'h80FF7F01, 3'b011, 2'b10, 32'h000000FF, "LBU off2 80FF7F01");
        check_load(32'h80FF7F01, 3'b011, 2'b11, 32'h00000080, "LBU off3 80FF7F01");

        // ---- LHU (load_op = 100) ----
        check_load(32'hDEADBEEF, 3'b100, 2'b00, 32'h0000BEEF, "LHU off0 DEADBEEF");
        check_load(32'hDEADBEEF, 3'b100, 2'b10, 32'h0000DEAD, "LHU off2 DEADBEEF");
        check_load(32'hDEADBEEF, 3'b100, 2'b01, 32'h00000000, "LHU off1 DEADBEEF (misalign)");
        check_load(32'hDEADBEEF, 3'b100, 2'b11, 32'h00000000, "LHU off3 DEADBEEF (misalign)");

        check_load(32'h80FF7F01, 3'b100, 2'b00, 32'h00007F01, "LHU off0 80FF7F01");
        check_load(32'h80FF7F01, 3'b100, 2'b10, 32'h000080FF, "LHU off2 80FF7F01");

        // ---- mem_read=0 should output 0 ----
        ld_dout = 32'hDEADBEEF; ld_mem_read = 0; ld_load_op = 3'b010; ld_offset = 2'b00;
        #1;
        if (ld_data_out === 32'h0) begin
            $display("  PASS: LOAD mem_read=0 => 0"); pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: LOAD mem_read=0 => got %h, exp 0", ld_data_out); fail_count = fail_count + 1;
        end

        // ==================================================================
        //  2. STORE MODULE TESTS
        // ==================================================================
        $display("\n--- STORE MODULE TESTS ---");

        // ---- SB (store_op = 00) ----
        // din = 0xDEADBEEF => din[7:0] = 0xEF => replicated = {EF,EF,EF,EF}
        check_store(2'b00, 2'b00, 32'hDEADBEEF, 4'b0001, 32'hEFEFEFEF, "SB off0 DEADBEEF");
        check_store(2'b00, 2'b01, 32'hDEADBEEF, 4'b0010, 32'hEFEFEFEF, "SB off1 DEADBEEF");
        check_store(2'b00, 2'b10, 32'hDEADBEEF, 4'b0100, 32'hEFEFEFEF, "SB off2 DEADBEEF");
        check_store(2'b00, 2'b11, 32'hDEADBEEF, 4'b1000, 32'hEFEFEFEF, "SB off3 DEADBEEF");

        // din = 0x80FF7F01 => din[7:0] = 0x01 => replicated = {01,01,01,01}
        check_store(2'b00, 2'b00, 32'h80FF7F01, 4'b0001, 32'h01010101, "SB off0 80FF7F01");
        check_store(2'b00, 2'b01, 32'h80FF7F01, 4'b0010, 32'h01010101, "SB off1 80FF7F01");
        check_store(2'b00, 2'b10, 32'h80FF7F01, 4'b0100, 32'h01010101, "SB off2 80FF7F01");
        check_store(2'b00, 2'b11, 32'h80FF7F01, 4'b1000, 32'h01010101, "SB off3 80FF7F01");

        // ---- SH (store_op = 01) ----
        // din = 0xDEADBEEF => din[15:0] = 0xBEEF => replicated = {BEEF,BEEF}
        check_store(2'b01, 2'b00, 32'hDEADBEEF, 4'b0011, 32'hBEEFBEEF, "SH off0 DEADBEEF");
        check_store(2'b01, 2'b10, 32'hDEADBEEF, 4'b1100, 32'hBEEFBEEF, "SH off2 DEADBEEF");
        // Misaligned offsets => we=0000
        check_store(2'b01, 2'b01, 32'hDEADBEEF, 4'b0000, 32'hBEEFBEEF, "SH off1 DEADBEEF (misalign)");
        check_store(2'b01, 2'b11, 32'hDEADBEEF, 4'b0000, 32'hBEEFBEEF, "SH off3 DEADBEEF (misalign)");

        // din = 0x80FF7F01 => din[15:0] = 0x7F01 => replicated = {7F01,7F01}
        check_store(2'b01, 2'b00, 32'h80FF7F01, 4'b0011, 32'h7F017F01, "SH off0 80FF7F01");
        check_store(2'b01, 2'b10, 32'h80FF7F01, 4'b1100, 32'h7F017F01, "SH off2 80FF7F01");

        // ---- SW (store_op = 10) ----
        check_store(2'b10, 2'b00, 32'hDEADBEEF, 4'b1111, 32'hDEADBEEF, "SW off0 DEADBEEF");
        check_store(2'b10, 2'b00, 32'h80FF7F01, 4'b1111, 32'h80FF7F01, "SW off0 80FF7F01");
        check_store(2'b10, 2'b00, 32'h00000000, 4'b1111, 32'h00000000, "SW off0 00000000");
        check_store(2'b10, 2'b00, 32'hFFFFFFFF, 4'b1111, 32'hFFFFFFFF, "SW off0 FFFFFFFF");

        // ---- mem_write=0 should output we=0, din_out=0 ----
        st_mem_write = 0; st_store_op = 2'b10; st_offset = 2'b00; st_din = 32'hDEADBEEF;
        #1;
        if (st_we === 4'b0000 && st_din_out === 32'h0) begin
            $display("  PASS: STORE mem_write=0 => we=0 din_out=0"); pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: STORE mem_write=0 => we=%b(exp 0000) din_out=%h(exp 0)", st_we, st_din_out); fail_count = fail_count + 1;
        end

        // ---- default store_op = 11 ----
        check_store(2'b11, 2'b00, 32'hDEADBEEF, 4'b0000, 32'h00000000, "default store_op=11");

        // ==================================================================
        //  3. BRANCH_TAKEN MODULE TESTS
        // ==================================================================
        $display("\n--- BRANCH_TAKEN MODULE TESTS ---");

        // --- JAL/JALR: wb_sel_pc_plus4=1 always taken regardless of branch/op ---
        check_branch(0, 3'b000, 1, 32'h0, 32'h0, 1, "JAL wb_sel=1 branch=0");
        check_branch(1, 3'b000, 1, 32'h0, 32'h0, 1, "JAL wb_sel=1 branch=1");
        check_branch(0, 3'b001, 1, 32'h5, 32'h5, 1, "JALR wb_sel=1 equal vals");

        // --- branch=0, wb_sel=0 => not taken ---
        check_branch(0, 3'b000, 0, 32'h5, 32'h5, 0, "no branch no wb");

        // --- BEQ (000) ---
        check_branch(1, 3'b000, 0, 32'h00000005, 32'h00000005, 1, "BEQ equal");
        check_branch(1, 3'b000, 0, 32'h00000005, 32'h00000006, 0, "BEQ not equal");
        check_branch(1, 3'b000, 0, 32'hFFFFFFFF, 32'hFFFFFFFF, 1, "BEQ equal FFFFFFFF");
        check_branch(1, 3'b000, 0, 32'h00000000, 32'h00000000, 1, "BEQ equal 0");

        // --- BNE (001) ---
        check_branch(1, 3'b001, 0, 32'h00000005, 32'h00000006, 1, "BNE not equal");
        check_branch(1, 3'b001, 0, 32'h00000005, 32'h00000005, 0, "BNE equal");

        // --- BLT (100) signed ---
        check_branch(1, 3'b100, 0, 32'h00000001, 32'h00000002, 1, "BLT 1<2 signed");
        check_branch(1, 3'b100, 0, 32'h00000002, 32'h00000001, 0, "BLT 2<1 signed false");
        check_branch(1, 3'b100, 0, 32'h00000001, 32'h00000001, 0, "BLT 1<1 signed false");
        // -1 < 1  (signed)
        check_branch(1, 3'b100, 0, 32'hFFFFFFFF, 32'h00000001, 1, "BLT -1<1 signed");
        // 0x80000000 (-2^31) < 0x7FFFFFFF (2^31-1) signed => true
        check_branch(1, 3'b100, 0, 32'h80000000, 32'h7FFFFFFF, 1, "BLT 80000000<7FFFFFFF signed");
        // 0x7FFFFFFF < 0x80000000 signed => false
        check_branch(1, 3'b100, 0, 32'h7FFFFFFF, 32'h80000000, 0, "BLT 7FFFFFFF<80000000 signed false");

        // --- BGE (101) signed ---
        check_branch(1, 3'b101, 0, 32'h00000002, 32'h00000001, 1, "BGE 2>=1 signed");
        check_branch(1, 3'b101, 0, 32'h00000001, 32'h00000001, 1, "BGE 1>=1 signed");
        check_branch(1, 3'b101, 0, 32'h00000001, 32'h00000002, 0, "BGE 1>=2 signed false");
        check_branch(1, 3'b101, 0, 32'h7FFFFFFF, 32'h80000000, 1, "BGE 7FFFFFFF>=80000000 signed");
        check_branch(1, 3'b101, 0, 32'h80000000, 32'h7FFFFFFF, 0, "BGE 80000000>=7FFFFFFF signed false");

        // --- BLTU (110) unsigned ---
        check_branch(1, 3'b110, 0, 32'h00000001, 32'h00000002, 1, "BLTU 1<2 unsigned");
        check_branch(1, 3'b110, 0, 32'h00000002, 32'h00000001, 0, "BLTU 2<1 unsigned false");
        check_branch(1, 3'b110, 0, 32'h00000001, 32'h00000001, 0, "BLTU 1<1 unsigned false");
        // 0x7FFFFFFF < 0x80000000 unsigned => true
        check_branch(1, 3'b110, 0, 32'h7FFFFFFF, 32'h80000000, 1, "BLTU 7FFFFFFF<80000000 unsigned");
        // 0x80000000 < 0x7FFFFFFF unsigned => false
        check_branch(1, 3'b110, 0, 32'h80000000, 32'h7FFFFFFF, 0, "BLTU 80000000<7FFFFFFF unsigned false");
        // 0xFFFFFFFF < 0x00000001 unsigned => false
        check_branch(1, 3'b110, 0, 32'hFFFFFFFF, 32'h00000001, 0, "BLTU FFFFFFFF<1 unsigned false");
        // 0x00000000 < 0xFFFFFFFF unsigned => true
        check_branch(1, 3'b110, 0, 32'h00000000, 32'hFFFFFFFF, 1, "BLTU 0<FFFFFFFF unsigned");

        // --- BGEU (111) unsigned ---
        check_branch(1, 3'b111, 0, 32'h00000002, 32'h00000001, 1, "BGEU 2>=1 unsigned");
        check_branch(1, 3'b111, 0, 32'h00000001, 32'h00000001, 1, "BGEU 1>=1 unsigned");
        check_branch(1, 3'b111, 0, 32'h00000001, 32'h00000002, 0, "BGEU 1>=2 unsigned false");
        check_branch(1, 3'b111, 0, 32'h80000000, 32'h7FFFFFFF, 1, "BGEU 80000000>=7FFFFFFF unsigned");
        check_branch(1, 3'b111, 0, 32'hFFFFFFFF, 32'h00000000, 1, "BGEU FFFFFFFF>=0 unsigned");
        check_branch(1, 3'b111, 0, 32'h00000000, 32'hFFFFFFFF, 0, "BGEU 0>=FFFFFFFF unsigned false");

        // --- default branch_op (010, 011) => 0 ---
        check_branch(1, 3'b010, 0, 32'h0, 32'h0, 0, "default op 010");
        check_branch(1, 3'b011, 0, 32'h0, 32'h0, 0, "default op 011");

        // ==================================================================
        //  4. REG_FILE MODULE TESTS
        // ==================================================================
        $display("\n--- REG_FILE MODULE TESTS ---");

        // ---- Reset ----
        rf_reset = 1; rf_write_enable = 0; rf_rd = 0; rf_write_data = 0;
        rf_rs1 = 0; rf_rs2 = 0;
        @(posedge rf_clk); #1;
        @(posedge rf_clk); #1;  // hold reset for 2 cycles
        rf_reset = 0;

        // After reset, all registers should read 0
        begin : check_reset_block
            integer r;
            reg reset_pass;
            reset_pass = 1;
            for (r = 0; r < 32; r = r + 1) begin
                rf_rs1 = r[4:0]; rf_rs2 = r[4:0];
                #1;
                if (rf_read_data1 !== 32'h0 || rf_read_data2 !== 32'h0) begin
                    $display("  FAIL: REGFILE reset x%0d => rd1=%h rd2=%h (exp 0)", r, rf_read_data1, rf_read_data2);
                    fail_count = fail_count + 1;
                    reset_pass = 0;
                end
            end
            if (reset_pass) begin
                $display("  PASS: REGFILE all 32 regs read 0 after reset");
                pass_count = pass_count + 1;
            end
        end

        // ---- Write to x0 should be ignored ----
        rf_write_enable = 1; rf_rd = 0; rf_write_data = 32'hDEADBEEF;
        @(posedge rf_clk); #1;
        rf_write_enable = 0;
        rf_rs1 = 0; rf_rs2 = 0;
        #1;
        if (rf_read_data1 === 32'h0 && rf_read_data2 === 32'h0) begin
            $display("  PASS: REGFILE x0 stays 0 after write attempt"); pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: REGFILE x0 = %h (exp 0)", rf_read_data1); fail_count = fail_count + 1;
        end

        // ---- Write and read registers x1 through x31 ----
        begin : write_read_block
            integer r;
            reg wr_pass;
            wr_pass = 1;
            // Write distinct values to x1..x31
            for (r = 1; r < 32; r = r + 1) begin
                rf_write_enable = 1;
                rf_rd = r[4:0];
                rf_write_data = 32'hA0000000 + r;
                @(posedge rf_clk); #1;
            end
            rf_write_enable = 0;

            // Read back all
            for (r = 1; r < 32; r = r + 1) begin
                rf_rs1 = r[4:0]; rf_rs2 = r[4:0];
                #1;
                if (rf_read_data1 !== (32'hA0000000 + r)) begin
                    $display("  FAIL: REGFILE x%0d = %h (exp %h)", r, rf_read_data1, 32'hA0000000 + r);
                    fail_count = fail_count + 1;
                    wr_pass = 0;
                end
            end
            if (wr_pass) begin
                $display("  PASS: REGFILE x1-x31 write/read correct"); pass_count = pass_count + 1;
            end
        end

        // ---- x0 should still read 0 ----
        rf_rs1 = 0; rf_rs2 = 0;
        #1;
        if (rf_read_data1 === 32'h0) begin
            $display("  PASS: REGFILE x0 still 0 after writing x1-x31"); pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: REGFILE x0 = %h (exp 0)", rf_read_data1); fail_count = fail_count + 1;
        end

        // ---- Write-through / bypass test ----
        // While writing to x5, reading x5 should return write_data immediately
        rf_write_enable = 1; rf_rd = 5; rf_write_data = 32'hCAFEBABE;
        rf_rs1 = 5; rf_rs2 = 5;
        #1;  // combinational bypass, no clock edge needed
        if (rf_read_data1 === 32'hCAFEBABE && rf_read_data2 === 32'hCAFEBABE) begin
            $display("  PASS: REGFILE write-through bypass x5 = CAFEBABE"); pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: REGFILE write-through x5 rd1=%h rd2=%h (exp CAFEBABE)", rf_read_data1, rf_read_data2); fail_count = fail_count + 1;
        end

        // ---- Bypass should NOT apply to x0 ----
        rf_write_enable = 1; rf_rd = 0; rf_write_data = 32'hBAADF00D;
        rf_rs1 = 0; rf_rs2 = 0;
        #1;
        if (rf_read_data1 === 32'h0 && rf_read_data2 === 32'h0) begin
            $display("  PASS: REGFILE bypass does NOT affect x0"); pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: REGFILE bypass x0 rd1=%h rd2=%h (exp 0)", rf_read_data1, rf_read_data2); fail_count = fail_count + 1;
        end
        @(posedge rf_clk); #1;
        rf_write_enable = 0;

        // ---- Bypass: rd != rs should read old value ----
        // x10 was written 0xA000000A earlier
        rf_write_enable = 1; rf_rd = 15; rf_write_data = 32'h12345678;
        rf_rs1 = 10; rf_rs2 = 15;
        #1;
        if (rf_read_data1 === 32'hA000000A) begin
            $display("  PASS: REGFILE no-bypass rd!=rs1 x10=%h", rf_read_data1); pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: REGFILE no-bypass x10=%h (exp A000000A)", rf_read_data1); fail_count = fail_count + 1;
        end
        if (rf_read_data2 === 32'h12345678) begin
            $display("  PASS: REGFILE bypass rd==rs2 x15=%h", rf_read_data2); pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: REGFILE bypass x15=%h (exp 12345678)", rf_read_data2); fail_count = fail_count + 1;
        end
        @(posedge rf_clk); #1;
        rf_write_enable = 0;

        // ---- write_enable=0 should not write ----
        rf_write_enable = 0; rf_rd = 10; rf_write_data = 32'hFFFFFFFF;
        @(posedge rf_clk); #1;
        rf_rs1 = 10; rf_rs2 = 10;
        #1;
        if (rf_read_data1 === 32'hA000000A) begin
            $display("  PASS: REGFILE write_enable=0 no write x10=%h", rf_read_data1); pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: REGFILE write_enable=0 x10=%h (exp A000000A)", rf_read_data1); fail_count = fail_count + 1;
        end

        // ---- Reset clears all ----
        rf_reset = 1;
        @(posedge rf_clk); #1;
        @(posedge rf_clk); #1;
        rf_reset = 0;
        begin : check_reset2_block
            integer r;
            reg reset2_pass;
            reset2_pass = 1;
            for (r = 0; r < 32; r = r + 1) begin
                rf_rs1 = r[4:0]; rf_rs2 = r[4:0];
                #1;
                if (rf_read_data1 !== 32'h0) begin
                    $display("  FAIL: REGFILE 2nd reset x%0d = %h (exp 0)", r, rf_read_data1);
                    fail_count = fail_count + 1;
                    reset2_pass = 0;
                end
            end
            if (reset2_pass) begin
                $display("  PASS: REGFILE all regs 0 after 2nd reset"); pass_count = pass_count + 1;
            end
        end

        // ==================================================================
        //  SUMMARY
        // ==================================================================
        $display("\n============================================================");
        $display(" TESTBENCH COMPLETE");
        $display("   PASSED: %0d", pass_count);
        $display("   FAILED: %0d", fail_count);
        $display("   TOTAL:  %0d", pass_count + fail_count);
        if (fail_count == 0)
            $display("   *** ALL TESTS PASSED ***");
        else
            $display("   *** SOME TESTS FAILED ***");
        $display("============================================================");
        $finish;
    end

endmodule
