`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Comprehensive self-checking testbench for the decoder module
//////////////////////////////////////////////////////////////////////////////

module tb_decoder;

    // ----- DUT signals -----
    reg  [31:0] instr;
    wire        alu_a_src;
    wire        alu_b_src;
    wire [1:0]  wb_sel;
    wire        pc_sel;
    wire        reg_write;
    wire        mem_read;
    wire        mem_write;
    wire        branch;
    wire [2:0]  branch_op;
    wire [2:0]  load_op;
    wire [1:0]  store_op;
    wire [4:0]  alu_op;
    wire        fence;
    wire [1:0]  sys_op;
    wire [31:0] imm;
    wire        lui_check;
    wire [1:0]  available;
    wire        uses_rs1;
    wire        uses_rs2;

    // ----- Counters -----
    integer pass_count;
    integer fail_count;
    integer test_num;

    // ----- DUT instantiation -----
    decoder dut (
        .instr      (instr),
        .alu_a_src  (alu_a_src),
        .alu_b_src  (alu_b_src),
        .wb_sel     (wb_sel),
        .pc_sel     (pc_sel),
        .reg_write  (reg_write),
        .mem_read   (mem_read),
        .mem_write  (mem_write),
        .branch     (branch),
        .branch_op  (branch_op),
        .load_op    (load_op),
        .store_op   (store_op),
        .alu_op     (alu_op),
        .fence      (fence),
        .sys_op     (sys_op),
        .imm        (imm),
        .lui_check  (lui_check),
        .available  (available),
        .uses_rs1   (uses_rs1),
        .uses_rs2   (uses_rs2)
    );

    // ----- ALU op constants (matching RTL) -----
    localparam [4:0] ALU_ADD    = 5'b00000;
    localparam [4:0] ALU_SUB    = 5'b00001;
    localparam [4:0] ALU_SLL    = 5'b00010;
    localparam [4:0] ALU_SLT    = 5'b00011;
    localparam [4:0] ALU_SLTU   = 5'b00100;
    localparam [4:0] ALU_XOR    = 5'b00101;
    localparam [4:0] ALU_SRL    = 5'b00110;
    localparam [4:0] ALU_SRA    = 5'b00111;
    localparam [4:0] ALU_OR     = 5'b01000;
    localparam [4:0] ALU_AND    = 5'b01001;
    localparam [4:0] ALU_MUL    = 5'b01010;
    localparam [4:0] ALU_MULH   = 5'b01011;
    localparam [4:0] ALU_MULHSU = 5'b01100;
    localparam [4:0] ALU_MULHU  = 5'b01101;
    localparam [4:0] ALU_DIV    = 5'b01110;
    localparam [4:0] ALU_DIVU   = 5'b01111;
    localparam [4:0] ALU_REM    = 5'b10000;
    localparam [4:0] ALU_REMU   = 5'b10001;
    localparam [4:0] ALU_DSQ    = 5'b10010;

    // ----- Available constants -----
    localparam [1:0] AVAIL_EX2  = 2'b00;
    localparam [1:0] AVAIL_MEM1 = 2'b01;
    localparam [1:0] AVAIL_MEM2 = 2'b10;
    localparam [1:0] AVAIL_WB   = 2'b11;

    // ----- wb_sel constants -----
    localparam [1:0] WB_ALU     = 2'b00;
    localparam [1:0] WB_MEM     = 2'b01;
    localparam [1:0] WB_PC4     = 2'b10;

    // ----- Helper task: check a single signal -----
    task check_signal;
        input [127:0] sig_name; // up to 16 chars
        input [31:0]  actual;
        input [31:0]  expected;
        begin
            if (actual !== expected) begin
                $display("  FAIL: %0s = 0x%0h, expected 0x%0h", sig_name, actual, expected);
                fail_count = fail_count + 1;
            end else begin
                pass_count = pass_count + 1;
            end
        end
    endtask

    // -----------------------------------------------------------------------
    // Instruction builder helpers (functions)
    // -----------------------------------------------------------------------
    // R-type: funct7[31:25] | rs2[24:20] | rs1[19:15] | funct3[14:12] | rd[11:7] | opcode[6:0]
    function [31:0] r_type;
        input [6:0] funct7;
        input [4:0] rs2;
        input [4:0] rs1;
        input [2:0] funct3;
        input [4:0] rd;
        input [6:0] opcode;
        r_type = {funct7, rs2, rs1, funct3, rd, opcode};
    endfunction

    // I-type: imm[31:20] | rs1[19:15] | funct3[14:12] | rd[11:7] | opcode[6:0]
    function [31:0] i_type;
        input [11:0] imm12;
        input [4:0]  rs1;
        input [2:0]  funct3;
        input [4:0]  rd;
        input [6:0]  opcode;
        i_type = {imm12, rs1, funct3, rd, opcode};
    endfunction

    // S-type: imm[11:5][31:25] | rs2[24:20] | rs1[19:15] | funct3[14:12] | imm[4:0][11:7] | opcode[6:0]
    function [31:0] s_type;
        input [11:0] imm12;
        input [4:0]  rs2;
        input [4:0]  rs1;
        input [2:0]  funct3;
        input [6:0]  opcode;
        s_type = {imm12[11:5], rs2, rs1, funct3, imm12[4:0], opcode};
    endfunction

    // B-type: imm[12][31] | imm[10:5][30:25] | rs2[24:20] | rs1[19:15] | funct3[14:12] | imm[4:1][11:8] | imm[11][7] | opcode[6:0]
    function [31:0] b_type;
        input [12:0] imm13; // imm13[0] is always 0
        input [4:0]  rs2;
        input [4:0]  rs1;
        input [2:0]  funct3;
        input [6:0]  opcode;
        b_type = {imm13[12], imm13[10:5], rs2, rs1, funct3, imm13[4:1], imm13[11], opcode};
    endfunction

    // U-type: imm[31:12] | rd[11:7] | opcode[6:0]
    function [31:0] u_type;
        input [31:0] imm32; // upper 20 bits used (already shifted left by 12)
        input [4:0]  rd;
        input [6:0]  opcode;
        u_type = {imm32[31:12], rd, opcode};
    endfunction

    // J-type: imm[20][31] | imm[10:1][30:21] | imm[11][20] | imm[19:12][19:12] | rd[11:7] | opcode[6:0]
    function [31:0] j_type;
        input [20:0] imm21; // imm21[0] is always 0
        input [4:0]  rd;
        input [6:0]  opcode;
        j_type = {imm21[20], imm21[10:1], imm21[11], imm21[19:12], rd, opcode};
    endfunction

    // -----------------------------------------------------------------------
    // Main test
    // -----------------------------------------------------------------------
    initial begin
        pass_count = 0;
        fail_count = 0;
        test_num   = 0;

        // ==================================================================
        // TEST 1: LUI
        // ==================================================================
        test_num = test_num + 1;
        $display("--- Test %0d: LUI (rd=x1, imm=0xDEADB000) ---", test_num);
        instr = u_type(32'hDEADB000, 5'd1, 7'b0110111);
        #1;
        check_signal("alu_a_src",  alu_a_src,  0);
        check_signal("alu_b_src",  alu_b_src,  1);
        check_signal("wb_sel",     wb_sel,     WB_ALU);
        check_signal("reg_write",  reg_write,  1);
        check_signal("mem_read",   mem_read,   0);
        check_signal("mem_write",  mem_write,  0);
        check_signal("branch",     branch,     0);
        check_signal("lui_check",  lui_check,  1);
        check_signal("imm",        imm,        32'hDEADB000);
        check_signal("available",  available,  AVAIL_EX2);
        check_signal("uses_rs1",   uses_rs1,   0);
        check_signal("uses_rs2",   uses_rs2,   0);

        // ==================================================================
        // TEST 2: LUI with different immediate
        // ==================================================================
        test_num = test_num + 1;
        $display("--- Test %0d: LUI (rd=x15, imm=0x00001000) ---", test_num);
        instr = u_type(32'h00001000, 5'd15, 7'b0110111);
        #1;
        check_signal("alu_b_src",  alu_b_src,  1);
        check_signal("reg_write",  reg_write,  1);
        check_signal("lui_check",  lui_check,  1);
        check_signal("imm",        imm,        32'h00001000);
        check_signal("available",  available,  AVAIL_EX2);

        // ==================================================================
        // TEST 3: AUIPC
        // ==================================================================
        test_num = test_num + 1;
        $display("--- Test %0d: AUIPC (rd=x2, imm=0x12345000) ---", test_num);
        instr = u_type(32'h12345000, 5'd2, 7'b0010111);
        #1;
        check_signal("alu_a_src",  alu_a_src,  1);  // pc
        check_signal("alu_b_src",  alu_b_src,  1);  // imm
        check_signal("wb_sel",     wb_sel,     WB_ALU);
        check_signal("reg_write",  reg_write,  1);
        check_signal("alu_op",     alu_op,     ALU_ADD);
        check_signal("imm",        imm,        32'h12345000);
        check_signal("available",  available,  AVAIL_MEM1);
        check_signal("branch",     branch,     0);
        check_signal("lui_check",  lui_check,  0);
        check_signal("uses_rs1",   uses_rs1,   0);
        check_signal("uses_rs2",   uses_rs2,   0);

        // ==================================================================
        // TEST 4: JAL (positive offset)
        // ==================================================================
        test_num = test_num + 1;
        // JAL x1, +8  => imm21 = 21'b0_0000_0000_0_0000_0_01000 = 21'd8
        $display("--- Test %0d: JAL (rd=x1, offset=+8) ---", test_num);
        instr = j_type(21'd8, 5'd1, 7'b1101111);
        #1;
        check_signal("alu_a_src",  alu_a_src,  1);  // pc
        check_signal("alu_b_src",  alu_b_src,  1);  // imm
        check_signal("pc_sel",     pc_sel,     0);
        check_signal("branch",     branch,     1);
        check_signal("reg_write",  reg_write,  1);
        check_signal("wb_sel",     wb_sel,     WB_PC4);
        check_signal("available",  available,  AVAIL_EX2);
        check_signal("imm",        imm,        32'd8);
        check_signal("uses_rs1",   uses_rs1,   0);
        check_signal("uses_rs2",   uses_rs2,   0);

        // ==================================================================
        // TEST 5: JAL (negative offset)
        // ==================================================================
        test_num = test_num + 1;
        // JAL x3, -20 => imm21 for -20:  two's complement of 20 in 21 bits
        // -20 = 21'h1FFFEC  (but only 21 bits: 1_1111_1111_1_1110_1_01100)
        // The imm is sign-extended to 32 bits: 0xFFFFFFEC
        $display("--- Test %0d: JAL (rd=x3, offset=-20) ---", test_num);
        instr = j_type(-21'd20, 5'd3, 7'b1101111);
        #1;
        check_signal("branch",     branch,     1);
        check_signal("reg_write",  reg_write,  1);
        check_signal("wb_sel",     wb_sel,     WB_PC4);
        check_signal("imm",        imm,        32'hFFFFFFEC); // -20 sign extended

        // ==================================================================
        // TEST 6: JALR
        // ==================================================================
        test_num = test_num + 1;
        $display("--- Test %0d: JALR (rs1=x5, rd=x1, imm=100) ---", test_num);
        instr = i_type(12'd100, 5'd5, 3'b000, 5'd1, 7'b1100111);
        #1;
        check_signal("alu_a_src",  alu_a_src,  0);  // rs1
        check_signal("alu_b_src",  alu_b_src,  1);  // imm
        check_signal("wb_sel",     wb_sel,     WB_PC4);
        check_signal("pc_sel",     pc_sel,     1);  // reg
        check_signal("branch",     branch,     1);
        check_signal("reg_write",  reg_write,  1);
        check_signal("alu_op",     alu_op,     ALU_ADD);
        check_signal("available",  available,  AVAIL_EX2);
        check_signal("uses_rs1",   uses_rs1,   1);
        check_signal("uses_rs2",   uses_rs2,   0);
        check_signal("imm",        imm,        32'd100);

        // ==================================================================
        // TEST 7: JALR (negative imm)
        // ==================================================================
        test_num = test_num + 1;
        $display("--- Test %0d: JALR (rs1=x10, rd=x2, imm=-4) ---", test_num);
        instr = i_type(-12'd4, 5'd10, 3'b000, 5'd2, 7'b1100111);
        #1;
        check_signal("pc_sel",     pc_sel,     1);
        check_signal("branch",     branch,     1);
        check_signal("uses_rs1",   uses_rs1,   1);
        check_signal("imm",        imm,        32'hFFFFFFFC); // -4

        // ==================================================================
        // TEST 8-13: Branch instructions (BEQ, BNE, BLT, BGE, BLTU, BGEU)
        // ==================================================================

        // BEQ
        test_num = test_num + 1;
        $display("--- Test %0d: BEQ (offset=+16) ---", test_num);
        instr = b_type(13'd16, 5'd2, 5'd1, 3'b000, 7'b1100011);
        #1;
        check_signal("alu_a_src",  alu_a_src,  1);
        check_signal("alu_b_src",  alu_b_src,  1);
        check_signal("branch",     branch,     1);
        check_signal("branch_op",  branch_op,  3'b000); // BEQ
        check_signal("reg_write",  reg_write,  0);
        check_signal("mem_read",   mem_read,   0);
        check_signal("mem_write",  mem_write,  0);
        check_signal("uses_rs1",   uses_rs1,   1);
        check_signal("uses_rs2",   uses_rs2,   1);
        check_signal("imm",        imm,        32'd16);

        // BNE
        test_num = test_num + 1;
        $display("--- Test %0d: BNE (offset=-8) ---", test_num);
        instr = b_type(-13'd8, 5'd3, 5'd4, 3'b001, 7'b1100011);
        #1;
        check_signal("branch",     branch,     1);
        check_signal("branch_op",  branch_op,  3'b001); // BNE
        check_signal("uses_rs1",   uses_rs1,   1);
        check_signal("uses_rs2",   uses_rs2,   1);
        check_signal("imm",        imm,        32'hFFFFFFF8); // -8

        // BLT
        test_num = test_num + 1;
        $display("--- Test %0d: BLT (offset=+256) ---", test_num);
        instr = b_type(13'd256, 5'd6, 5'd7, 3'b100, 7'b1100011);
        #1;
        check_signal("branch_op",  branch_op,  3'b100); // BLT
        check_signal("imm",        imm,        32'd256);

        // BGE
        test_num = test_num + 1;
        $display("--- Test %0d: BGE (offset=+4) ---", test_num);
        instr = b_type(13'd4, 5'd8, 5'd9, 3'b101, 7'b1100011);
        #1;
        check_signal("branch_op",  branch_op,  3'b101); // BGE
        check_signal("imm",        imm,        32'd4);

        // BLTU
        test_num = test_num + 1;
        $display("--- Test %0d: BLTU (offset=+2048) ---", test_num);
        instr = b_type(13'd2048, 5'd10, 5'd11, 3'b110, 7'b1100011);
        #1;
        check_signal("branch_op",  branch_op,  3'b110); // BLTU
        check_signal("imm",        imm,        32'd2048);

        // BGEU
        test_num = test_num + 1;
        $display("--- Test %0d: BGEU (offset=-4096) ---", test_num);
        instr = b_type(-13'd4096, 5'd12, 5'd13, 3'b111, 7'b1100011);
        #1;
        check_signal("branch_op",  branch_op,  3'b111); // BGEU
        check_signal("imm",        imm,        32'hFFFFF000); // -4096

        // ==================================================================
        // TEST 14-18: Load instructions (LB, LH, LW, LBU, LHU)
        // ==================================================================

        // LB
        test_num = test_num + 1;
        $display("--- Test %0d: LB (rs1=x1, rd=x2, imm=10) ---", test_num);
        instr = i_type(12'd10, 5'd1, 3'b000, 5'd2, 7'b0000011);
        #1;
        check_signal("alu_a_src",  alu_a_src,  0);
        check_signal("alu_b_src",  alu_b_src,  1);
        check_signal("mem_read",   mem_read,   1);
        check_signal("reg_write",  reg_write,  1);
        check_signal("alu_op",     alu_op,     ALU_ADD);
        check_signal("wb_sel",     wb_sel,     WB_MEM);
        check_signal("available",  available,  AVAIL_WB);
        check_signal("load_op",    load_op,    3'b000); // LB
        check_signal("uses_rs1",   uses_rs1,   1);
        check_signal("uses_rs2",   uses_rs2,   0);
        check_signal("imm",        imm,        32'd10);
        check_signal("mem_write",  mem_write,  0);

        // LH
        test_num = test_num + 1;
        $display("--- Test %0d: LH (imm=-5) ---", test_num);
        instr = i_type(-12'd5, 5'd3, 3'b001, 5'd4, 7'b0000011);
        #1;
        check_signal("load_op",    load_op,    3'b001); // LH
        check_signal("mem_read",   mem_read,   1);
        check_signal("imm",        imm,        32'hFFFFFFFB); // -5

        // LW
        test_num = test_num + 1;
        $display("--- Test %0d: LW (imm=2047) ---", test_num);
        instr = i_type(12'd2047, 5'd5, 3'b010, 5'd6, 7'b0000011);
        #1;
        check_signal("load_op",    load_op,    3'b010); // LW
        check_signal("imm",        imm,        32'd2047);

        // LBU
        test_num = test_num + 1;
        $display("--- Test %0d: LBU (imm=0) ---", test_num);
        instr = i_type(12'd0, 5'd7, 3'b100, 5'd8, 7'b0000011);
        #1;
        check_signal("load_op",    load_op,    3'b011); // LBU = 011 in RTL
        check_signal("imm",        imm,        32'd0);

        // LHU
        test_num = test_num + 1;
        $display("--- Test %0d: LHU (imm=-2048) ---", test_num);
        instr = i_type(12'h800, 5'd9, 3'b101, 5'd10, 7'b0000011);
        #1;
        check_signal("load_op",    load_op,    3'b100); // LHU = 100 in RTL
        check_signal("imm",        imm,        32'hFFFFF800); // -2048

        // ==================================================================
        // TEST 19-21: Store instructions (SB, SH, SW)
        // ==================================================================

        // SB
        test_num = test_num + 1;
        $display("--- Test %0d: SB (rs1=x1, rs2=x2, imm=7) ---", test_num);
        instr = s_type(12'd7, 5'd2, 5'd1, 3'b000, 7'b0100011);
        #1;
        check_signal("alu_b_src",  alu_b_src,  1);
        check_signal("mem_write",  mem_write,  1);
        check_signal("mem_read",   mem_read,   0);
        check_signal("reg_write",  reg_write,  0);
        check_signal("alu_op",     alu_op,     ALU_ADD);
        check_signal("store_op",   store_op,   2'b00); // SB
        check_signal("uses_rs1",   uses_rs1,   1);
        check_signal("uses_rs2",   uses_rs2,   1);
        check_signal("imm",        imm,        32'd7);

        // SH
        test_num = test_num + 1;
        $display("--- Test %0d: SH (imm=-100) ---", test_num);
        instr = s_type(-12'd100, 5'd4, 5'd3, 3'b001, 7'b0100011);
        #1;
        check_signal("store_op",   store_op,   2'b01); // SH
        check_signal("mem_write",  mem_write,  1);
        check_signal("imm",        imm,        32'hFFFFFF9C); // -100

        // SW
        test_num = test_num + 1;
        $display("--- Test %0d: SW (imm=2047) ---", test_num);
        instr = s_type(12'd2047, 5'd6, 5'd5, 3'b010, 7'b0100011);
        #1;
        check_signal("store_op",   store_op,   2'b10); // SW
        check_signal("imm",        imm,        32'd2047);

        // ==================================================================
        // TEST 22-30: ALU immediate instructions
        // ==================================================================

        // ADDI
        test_num = test_num + 1;
        $display("--- Test %0d: ADDI (rs1=x1, rd=x2, imm=42) ---", test_num);
        instr = i_type(12'd42, 5'd1, 3'b000, 5'd2, 7'b0010011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_ADD);
        check_signal("alu_a_src",  alu_a_src,  0);
        check_signal("alu_b_src",  alu_b_src,  1);
        check_signal("reg_write",  reg_write,  1);
        check_signal("wb_sel",     wb_sel,     WB_ALU);
        check_signal("available",  available,  AVAIL_MEM1);
        check_signal("uses_rs1",   uses_rs1,   1);
        check_signal("uses_rs2",   uses_rs2,   0);
        check_signal("imm",        imm,        32'd42);
        check_signal("mem_read",   mem_read,   0);
        check_signal("mem_write",  mem_write,  0);
        check_signal("branch",     branch,     0);

        // ADDI negative
        test_num = test_num + 1;
        $display("--- Test %0d: ADDI (imm=-1) ---", test_num);
        instr = i_type(12'hFFF, 5'd1, 3'b000, 5'd2, 7'b0010011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_ADD);
        check_signal("imm",        imm,        32'hFFFFFFFF); // -1

        // SLTI
        test_num = test_num + 1;
        $display("--- Test %0d: SLTI ---", test_num);
        instr = i_type(12'd5, 5'd3, 3'b010, 5'd4, 7'b0010011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_SLT);
        check_signal("imm",        imm,        32'd5);

        // SLTIU
        test_num = test_num + 1;
        $display("--- Test %0d: SLTIU ---", test_num);
        instr = i_type(12'd255, 5'd5, 3'b011, 5'd6, 7'b0010011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_SLTU);
        check_signal("imm",        imm,        32'd255);

        // XORI
        test_num = test_num + 1;
        $display("--- Test %0d: XORI ---", test_num);
        instr = i_type(12'hABC, 5'd7, 3'b100, 5'd8, 7'b0010011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_XOR);
        // 0xABC sign extended: bit 11 is 1 => 0xFFFFFABC
        check_signal("imm",        imm,        32'hFFFFFABC);

        // ORI
        test_num = test_num + 1;
        $display("--- Test %0d: ORI ---", test_num);
        instr = i_type(12'd123, 5'd9, 3'b110, 5'd10, 7'b0010011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_OR);
        check_signal("imm",        imm,        32'd123);

        // ANDI
        test_num = test_num + 1;
        $display("--- Test %0d: ANDI ---", test_num);
        instr = i_type(12'd0, 5'd11, 3'b111, 5'd12, 7'b0010011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_AND);
        check_signal("imm",        imm,        32'd0);

        // SLLI (shift imm = shamt in lower 5 bits, funct7=0000000)
        test_num = test_num + 1;
        $display("--- Test %0d: SLLI (shamt=5) ---", test_num);
        instr = i_type({7'b0000000, 5'd5}, 5'd1, 3'b001, 5'd2, 7'b0010011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_SLL);
        check_signal("imm",        imm,        32'd5); // zero-extended shamt

        // SRLI
        test_num = test_num + 1;
        $display("--- Test %0d: SRLI (shamt=3) ---", test_num);
        instr = i_type({7'b0000000, 5'd3}, 5'd3, 3'b101, 5'd4, 7'b0010011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_SRL);
        check_signal("imm",        imm,        32'd3);

        // SRAI
        test_num = test_num + 1;
        $display("--- Test %0d: SRAI (shamt=31) ---", test_num);
        instr = i_type({7'b0100000, 5'd31}, 5'd5, 3'b101, 5'd6, 7'b0010011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_SRA);
        check_signal("imm",        imm,        32'd31);

        // ==================================================================
        // TEST 31-48: ALU register instructions (R-type) including M-ext + DSQ
        // ==================================================================

        // ADD
        test_num = test_num + 1;
        $display("--- Test %0d: ADD ---", test_num);
        instr = r_type(7'b0000000, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_ADD);
        check_signal("alu_a_src",  alu_a_src,  0);
        check_signal("alu_b_src",  alu_b_src,  0);  // rs2
        check_signal("reg_write",  reg_write,  1);
        check_signal("wb_sel",     wb_sel,     WB_ALU);
        check_signal("available",  available,  AVAIL_MEM1);
        check_signal("uses_rs1",   uses_rs1,   1);
        check_signal("uses_rs2",   uses_rs2,   1);
        check_signal("mem_read",   mem_read,   0);
        check_signal("mem_write",  mem_write,  0);
        check_signal("branch",     branch,     0);

        // SUB
        test_num = test_num + 1;
        $display("--- Test %0d: SUB ---", test_num);
        instr = r_type(7'b0100000, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_SUB);

        // SLL
        test_num = test_num + 1;
        $display("--- Test %0d: SLL ---", test_num);
        instr = r_type(7'b0000000, 5'd2, 5'd1, 3'b001, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_SLL);

        // SLT
        test_num = test_num + 1;
        $display("--- Test %0d: SLT ---", test_num);
        instr = r_type(7'b0000000, 5'd2, 5'd1, 3'b010, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_SLT);

        // SLTU
        test_num = test_num + 1;
        $display("--- Test %0d: SLTU ---", test_num);
        instr = r_type(7'b0000000, 5'd2, 5'd1, 3'b011, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_SLTU);

        // XOR
        test_num = test_num + 1;
        $display("--- Test %0d: XOR ---", test_num);
        instr = r_type(7'b0000000, 5'd2, 5'd1, 3'b100, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_XOR);

        // SRL
        test_num = test_num + 1;
        $display("--- Test %0d: SRL ---", test_num);
        instr = r_type(7'b0000000, 5'd2, 5'd1, 3'b101, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_SRL);

        // SRA
        test_num = test_num + 1;
        $display("--- Test %0d: SRA ---", test_num);
        instr = r_type(7'b0100000, 5'd2, 5'd1, 3'b101, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_SRA);

        // OR
        test_num = test_num + 1;
        $display("--- Test %0d: OR ---", test_num);
        instr = r_type(7'b0000000, 5'd2, 5'd1, 3'b110, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_OR);

        // AND
        test_num = test_num + 1;
        $display("--- Test %0d: AND ---", test_num);
        instr = r_type(7'b0000000, 5'd2, 5'd1, 3'b111, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_AND);

        // MUL (M-extension, funct7=0000001, funct3=000)
        test_num = test_num + 1;
        $display("--- Test %0d: MUL ---", test_num);
        instr = r_type(7'b0000001, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_MUL);
        check_signal("uses_rs1",   uses_rs1,   1);
        check_signal("uses_rs2",   uses_rs2,   1);

        // MULH
        test_num = test_num + 1;
        $display("--- Test %0d: MULH ---", test_num);
        instr = r_type(7'b0000001, 5'd2, 5'd1, 3'b001, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_MULH);

        // MULHSU
        test_num = test_num + 1;
        $display("--- Test %0d: MULHSU ---", test_num);
        instr = r_type(7'b0000001, 5'd2, 5'd1, 3'b010, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_MULHSU);

        // MULHU
        test_num = test_num + 1;
        $display("--- Test %0d: MULHU ---", test_num);
        instr = r_type(7'b0000001, 5'd2, 5'd1, 3'b011, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_MULHU);

        // DIV
        test_num = test_num + 1;
        $display("--- Test %0d: DIV ---", test_num);
        instr = r_type(7'b0000001, 5'd2, 5'd1, 3'b100, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_DIV);

        // DIVU
        test_num = test_num + 1;
        $display("--- Test %0d: DIVU ---", test_num);
        instr = r_type(7'b0000001, 5'd2, 5'd1, 3'b101, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_DIVU);

        // REM
        test_num = test_num + 1;
        $display("--- Test %0d: REM ---", test_num);
        instr = r_type(7'b0000001, 5'd2, 5'd1, 3'b110, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_REM);

        // REMU
        test_num = test_num + 1;
        $display("--- Test %0d: REMU ---", test_num);
        instr = r_type(7'b0000001, 5'd2, 5'd1, 3'b111, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_REMU);

        // DSQ (custom: funct7=0100000, funct3=001)
        test_num = test_num + 1;
        $display("--- Test %0d: DSQ (custom) ---", test_num);
        instr = r_type(7'b0100000, 5'd2, 5'd1, 3'b001, 5'd3, 7'b0110011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_DSQ);
        check_signal("reg_write",  reg_write,  1);
        check_signal("uses_rs1",   uses_rs1,   1);
        check_signal("uses_rs2",   uses_rs2,   1);

        // ==================================================================
        // TEST 49: FENCE
        // ==================================================================
        test_num = test_num + 1;
        $display("--- Test %0d: FENCE ---", test_num);
        // FENCE: imm[31:28]=0000(fm), imm[27:24]=pred, imm[23:20]=succ, rs1=0, funct3=000, rd=0, opcode=0001111
        instr = i_type(12'b0000_0001_0011, 5'd0, 3'b000, 5'd0, 7'b0001111);
        #1;
        check_signal("fence",      fence,      1);
        check_signal("reg_write",  reg_write,  0);
        check_signal("mem_read",   mem_read,   0);
        check_signal("mem_write",  mem_write,  0);
        check_signal("branch",     branch,     0);

        // FENCE with funct3 != 000 (should NOT set fence)
        test_num = test_num + 1;
        $display("--- Test %0d: FENCE.I (funct3=001, fence should be 0) ---", test_num);
        instr = i_type(12'd0, 5'd0, 3'b001, 5'd0, 7'b0001111);
        #1;
        check_signal("fence",      fence,      0);

        // ==================================================================
        // TEST 51: ECALL
        // ==================================================================
        test_num = test_num + 1;
        $display("--- Test %0d: ECALL ---", test_num);
        // ECALL: imm[31:20]=000000000000, rs1=00000, funct3=000, rd=00000, opcode=1110011
        instr = {12'b000000000000, 5'd0, 3'b000, 5'd0, 7'b1110011};
        #1;
        check_signal("sys_op",     sys_op,     2'b01); // ECALL
        check_signal("reg_write",  reg_write,  0);
        check_signal("fence",      fence,      0);
        check_signal("branch",     branch,     0);

        // ==================================================================
        // TEST 52: EBREAK
        // ==================================================================
        test_num = test_num + 1;
        $display("--- Test %0d: EBREAK ---", test_num);
        // EBREAK: imm[31:20]=000000000001, rs1=00000, funct3=000, rd=00000, opcode=1110011
        instr = {12'b000000000001, 5'd0, 3'b000, 5'd0, 7'b1110011};
        #1;
        check_signal("sys_op",     sys_op,     2'b10); // EBREAK

        // ==================================================================
        // TEST 53: ECALL/EBREAK with non-zero rs1/rd fields (should NOT match)
        // ==================================================================
        test_num = test_num + 1;
        $display("--- Test %0d: SYS with non-zero fields (should be sys_op=0) ---", test_num);
        instr = {12'b000000000000, 5'd1, 3'b000, 5'd0, 7'b1110011}; // rs1=1
        #1;
        check_signal("sys_op",     sys_op,     2'b00);

        // ==================================================================
        // TEST 54: Default / invalid opcode
        // ==================================================================
        test_num = test_num + 1;
        $display("--- Test %0d: Invalid opcode (all zeros) ---", test_num);
        instr = 32'h00000000;
        #1;
        check_signal("alu_a_src",  alu_a_src,  0);
        check_signal("alu_b_src",  alu_b_src,  0);
        check_signal("wb_sel",     wb_sel,     2'b00);
        check_signal("pc_sel",     pc_sel,     0);
        check_signal("reg_write",  reg_write,  0);
        check_signal("mem_read",   mem_read,   0);
        check_signal("mem_write",  mem_write,  0);
        check_signal("branch",     branch,     0);
        check_signal("branch_op",  branch_op,  3'b000);
        check_signal("load_op",    load_op,    3'b000);
        check_signal("store_op",   store_op,   2'b00);
        check_signal("alu_op",     alu_op,     5'b00000);
        check_signal("fence",      fence,      0);
        check_signal("sys_op",     sys_op,     2'b00);
        check_signal("imm",        imm,        32'b0);
        check_signal("lui_check",  lui_check,  0);
        check_signal("available",  available,  2'b00);
        check_signal("uses_rs1",   uses_rs1,   0);
        check_signal("uses_rs2",   uses_rs2,   0);

        // ==================================================================
        // TEST 55: JAL large positive immediate
        // ==================================================================
        test_num = test_num + 1;
        $display("--- Test %0d: JAL large positive offset (0xFFFE = 65534) ---", test_num);
        instr = j_type(21'd65534, 5'd1, 7'b1101111);
        #1;
        check_signal("imm",        imm,        32'd65534);
        check_signal("branch",     branch,     1);

        // ==================================================================
        // TEST 56: B-type immediate edge case (all bits set in positive range)
        // ==================================================================
        test_num = test_num + 1;
        $display("--- Test %0d: BEQ offset=+4094 (max positive B-imm) ---", test_num);
        // Max positive B-imm is +4094 (imm[12]=0, rest=1 except bit0)
        instr = b_type(13'd4094, 5'd0, 5'd0, 3'b000, 7'b1100011);
        #1;
        check_signal("imm",        imm,        32'd4094);

        // ==================================================================
        // TEST 57: S-type immediate reconstruction
        // ==================================================================
        test_num = test_num + 1;
        $display("--- Test %0d: SW imm=-1 (0xFFF) ---", test_num);
        instr = s_type(12'hFFF, 5'd2, 5'd1, 3'b010, 7'b0100011);
        #1;
        check_signal("imm",        imm,        32'hFFFFFFFF); // -1
        check_signal("store_op",   store_op,   2'b10);

        // ==================================================================
        // TEST 58: LUI with max immediate
        // ==================================================================
        test_num = test_num + 1;
        $display("--- Test %0d: LUI max imm (0xFFFFF000) ---", test_num);
        instr = u_type(32'hFFFFF000, 5'd1, 7'b0110111);
        #1;
        check_signal("imm",        imm,        32'hFFFFF000);

        // ==================================================================
        // TEST 59: AUIPC with zero immediate
        // ==================================================================
        test_num = test_num + 1;
        $display("--- Test %0d: AUIPC imm=0 ---", test_num);
        instr = u_type(32'h00000000, 5'd1, 7'b0010111);
        #1;
        check_signal("imm",        imm,        32'h00000000);
        check_signal("alu_a_src",  alu_a_src,  1);

        // ==================================================================
        // TEST 60: SLLI with shamt=0
        // ==================================================================
        test_num = test_num + 1;
        $display("--- Test %0d: SLLI shamt=0 ---", test_num);
        instr = i_type({7'b0000000, 5'd0}, 5'd1, 3'b001, 5'd2, 7'b0010011);
        #1;
        check_signal("alu_op",     alu_op,     ALU_SLL);
        check_signal("imm",        imm,        32'd0);

        // ==================================================================
        // SUMMARY
        // ==================================================================
        $display("");
        $display("============================================");
        $display("  DECODER TESTBENCH SUMMARY");
        $display("============================================");
        $display("  Total checks: %0d", pass_count + fail_count);
        $display("  PASSED:       %0d", pass_count);
        $display("  FAILED:       %0d", fail_count);
        $display("============================================");
        if (fail_count == 0)
            $display("  *** ALL TESTS PASSED ***");
        else
            $display("  *** SOME TESTS FAILED ***");
        $display("============================================");
        $finish;
    end

endmodule
