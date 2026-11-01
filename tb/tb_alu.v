`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Comprehensive self-checking testbench for the ALU module
// Tests all 19 operations with normal values, edge cases, and corner cases.
//////////////////////////////////////////////////////////////////////////////

module tb_alu;

    // DUT signals
    reg  [31:0] alu_a;
    reg  [31:0] alu_b;
    reg  [4:0]  control;
    wire [31:0] alu_out;

    // Counters
    integer pass_count;
    integer fail_count;
    integer test_num;

    // Temp for expected calculation
    reg [31:0] expected;
    reg [63:0] prod64;

    // Instantiate DUT
    alu uut (
        .alu_a(alu_a),
        .alu_b(alu_b),
        .control(control),
        .alu_out(alu_out)
    );

    // Task: check result and report
    task check;
        input [31:0] exp;
        input [8*64-1:0] test_name; // string
        begin
            test_num = test_num + 1;
            #1; // allow combinational propagation
            if (alu_out === exp) begin
                $display("  [PASS] Test %0d: %0s | a=0x%08X b=0x%08X ctrl=%05b | out=0x%08X",
                         test_num, test_name, alu_a, alu_b, control, alu_out);
                pass_count = pass_count + 1;
            end else begin
                $display("  [FAIL] Test %0d: %0s | a=0x%08X b=0x%08X ctrl=%05b | out=0x%08X expected=0x%08X",
                         test_num, test_name, alu_a, alu_b, control, alu_out, exp);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        pass_count = 0;
        fail_count = 0;
        test_num   = 0;

        $display("==============================================================");
        $display("  ALU Testbench - Starting");
        $display("==============================================================");

        // ==================================================================
        // ADD (control = 5'b00000)
        // ==================================================================
        $display("\n--- ADD (5'b00000) ---");
        control = 5'b00000;

        alu_a = 32'd10;       alu_b = 32'd20;       check(32'd30,       "ADD: 10+20");
        alu_a = 32'd0;        alu_b = 32'd0;        check(32'd0,        "ADD: 0+0");
        alu_a = 32'hFFFFFFFF; alu_b = 32'd1;        check(32'd0,        "ADD: 0xFFFFFFFF+1 (wrap)");
        alu_a = 32'h7FFFFFFF; alu_b = 32'd1;        check(32'h80000000, "ADD: MAX_POS+1 (overflow)");
        alu_a = 32'h80000000; alu_b = 32'h80000000; check(32'd0,        "ADD: MIN_NEG+MIN_NEG (wrap)");
        alu_a = 32'hFFFFFFFF; alu_b = 32'hFFFFFFFF; check(32'hFFFFFFFE,"ADD: -1+-1");
        alu_a = 32'd100;      alu_b = 32'd0;        check(32'd100,      "ADD: 100+0");

        // ==================================================================
        // SUB (control = 5'b00001)
        // ==================================================================
        $display("\n--- SUB (5'b00001) ---");
        control = 5'b00001;

        alu_a = 32'd30;       alu_b = 32'd10;       check(32'd20,       "SUB: 30-10");
        alu_a = 32'd10;       alu_b = 32'd30;       check(32'hFFFFFFEC, "SUB: 10-30 (neg result)");
        alu_a = 32'd0;        alu_b = 32'd0;        check(32'd0,        "SUB: 0-0");
        alu_a = 32'h80000000; alu_b = 32'd1;        check(32'h7FFFFFFF, "SUB: MIN_NEG-1 (underflow)");
        alu_a = 32'd0;        alu_b = 32'hFFFFFFFF; check(32'd1,        "SUB: 0-(-1)");
        alu_a = 32'hFFFFFFFF; alu_b = 32'hFFFFFFFF; check(32'd0,        "SUB: -1-(-1)");
        alu_a = 32'h7FFFFFFF; alu_b = 32'hFFFFFFFF; check(32'h80000000, "SUB: MAX_POS-(-1)");

        // ==================================================================
        // SLL (control = 5'b00010)
        // ==================================================================
        $display("\n--- SLL (5'b00010) ---");
        control = 5'b00010;

        alu_a = 32'd1;        alu_b = 32'd0;        check(32'd1,        "SLL: 1<<0");
        alu_a = 32'd1;        alu_b = 32'd1;        check(32'd2,        "SLL: 1<<1");
        alu_a = 32'd1;        alu_b = 32'd31;       check(32'h80000000, "SLL: 1<<31");
        alu_a = 32'hFFFFFFFF; alu_b = 32'd4;        check(32'hFFFFFFF0, "SLL: 0xFFFFFFFF<<4");
        alu_a = 32'hDEADBEEF; alu_b = 32'd0;        check(32'hDEADBEEF, "SLL: val<<0 (identity)");
        alu_a = 32'h80000001; alu_b = 32'd16;       check(32'h00010000, "SLL: 0x80000001<<16");
        alu_a = 32'd0;        alu_b = 32'd15;       check(32'd0,        "SLL: 0<<15");

        // ==================================================================
        // SLT (control = 5'b00011) - signed compare
        // ==================================================================
        $display("\n--- SLT (5'b00011) ---");
        control = 5'b00011;

        alu_a = 32'd5;        alu_b = 32'd10;       check(32'd1,  "SLT: 5<10 (true)");
        alu_a = 32'd10;       alu_b = 32'd5;        check(32'd0,  "SLT: 10<5 (false)");
        alu_a = 32'd5;        alu_b = 32'd5;        check(32'd0,  "SLT: 5<5 (equal)");
        alu_a = 32'hFFFFFFFF; alu_b = 32'd0;        check(32'd1,  "SLT: -1<0 (true)");
        alu_a = 32'h80000000; alu_b = 32'h7FFFFFFF; check(32'd1,  "SLT: MIN_NEG<MAX_POS (true)");
        alu_a = 32'h7FFFFFFF; alu_b = 32'h80000000; check(32'd0,  "SLT: MAX_POS<MIN_NEG (false)");
        alu_a = 32'd0;        alu_b = 32'hFFFFFFFF; check(32'd0,  "SLT: 0<-1 (false)");
        alu_a = 32'h80000000; alu_b = 32'h80000000; check(32'd0,  "SLT: MIN_NEG<MIN_NEG (equal)");

        // ==================================================================
        // SLTU (control = 5'b00100) - unsigned compare
        // ==================================================================
        $display("\n--- SLTU (5'b00100) ---");
        control = 5'b00100;

        alu_a = 32'd5;        alu_b = 32'd10;       check(32'd1,  "SLTU: 5<10 (true)");
        alu_a = 32'd10;       alu_b = 32'd5;        check(32'd0,  "SLTU: 10<5 (false)");
        alu_a = 32'd0;        alu_b = 32'hFFFFFFFF; check(32'd1,  "SLTU: 0<0xFFFFFFFF (true)");
        alu_a = 32'hFFFFFFFF; alu_b = 32'd0;        check(32'd0,  "SLTU: 0xFFFFFFFF<0 (false)");
        alu_a = 32'h80000000; alu_b = 32'h7FFFFFFF; check(32'd0,  "SLTU: 0x80000000<0x7FFFFFFF (false)");
        alu_a = 32'd0;        alu_b = 32'd0;        check(32'd0,  "SLTU: 0<0 (equal)");
        alu_a = 32'hFFFFFFFE; alu_b = 32'hFFFFFFFF; check(32'd1,  "SLTU: 0xFFFFFFFE<0xFFFFFFFF (true)");

        // ==================================================================
        // XOR (control = 5'b00101)
        // ==================================================================
        $display("\n--- XOR (5'b00101) ---");
        control = 5'b00101;

        alu_a = 32'hFF00FF00; alu_b = 32'h0F0F0F0F; check(32'hF00FF00F, "XOR: pattern1");
        alu_a = 32'hFFFFFFFF; alu_b = 32'hFFFFFFFF; check(32'd0,        "XOR: all1 ^ all1 = 0");
        alu_a = 32'hFFFFFFFF; alu_b = 32'd0;        check(32'hFFFFFFFF, "XOR: all1 ^ 0 = all1");
        alu_a = 32'd0;        alu_b = 32'd0;        check(32'd0,        "XOR: 0^0");
        alu_a = 32'hAAAAAAAA; alu_b = 32'h55555555; check(32'hFFFFFFFF, "XOR: alternating bits");
        alu_a = 32'hDEADBEEF; alu_b = 32'hDEADBEEF; check(32'd0,       "XOR: same^same=0");

        // ==================================================================
        // SRL (control = 5'b00110) - logical right shift
        // ==================================================================
        $display("\n--- SRL (5'b00110) ---");
        control = 5'b00110;

        alu_a = 32'h80000000; alu_b = 32'd1;        check(32'h40000000, "SRL: 0x80000000>>1");
        alu_a = 32'h80000000; alu_b = 32'd31;       check(32'd1,        "SRL: 0x80000000>>31");
        alu_a = 32'hFFFFFFFF; alu_b = 32'd4;        check(32'h0FFFFFFF, "SRL: 0xFFFFFFFF>>4");
        alu_a = 32'hDEADBEEF; alu_b = 32'd0;        check(32'hDEADBEEF, "SRL: val>>0 (identity)");
        alu_a = 32'd0;        alu_b = 32'd10;       check(32'd0,        "SRL: 0>>10");
        alu_a = 32'hFFFFFFFF; alu_b = 32'd31;       check(32'd1,        "SRL: 0xFFFFFFFF>>31");
        alu_a = 32'd256;      alu_b = 32'd8;        check(32'd1,        "SRL: 256>>8");

        // ==================================================================
        // SRA (control = 5'b00111) - arithmetic right shift
        // ==================================================================
        $display("\n--- SRA (5'b00111) ---");
        control = 5'b00111;

        alu_a = 32'h80000000; alu_b = 32'd1;        check(32'hC0000000, "SRA: 0x80000000>>>1");
        alu_a = 32'h80000000; alu_b = 32'd31;       check(32'hFFFFFFFF, "SRA: 0x80000000>>>31 (all 1s)");
        alu_a = 32'h7FFFFFFF; alu_b = 32'd1;        check(32'h3FFFFFFF, "SRA: 0x7FFFFFFF>>>1");
        alu_a = 32'hFFFFFFFF; alu_b = 32'd4;        check(32'hFFFFFFFF, "SRA: -1>>>4 = -1");
        alu_a = 32'hDEADBEEF; alu_b = 32'd0;        check(32'hDEADBEEF, "SRA: val>>>0 (identity)");
        alu_a = 32'd0;        alu_b = 32'd15;       check(32'd0,        "SRA: 0>>>15");
        alu_a = 32'hFFFFFFF0; alu_b = 32'd4;        check(32'hFFFFFFFF, "SRA: -16>>>4 = -1");

        // ==================================================================
        // OR (control = 5'b01000)
        // ==================================================================
        $display("\n--- OR (5'b01000) ---");
        control = 5'b01000;

        alu_a = 32'hFF00FF00; alu_b = 32'h00FF00FF; check(32'hFFFFFFFF, "OR: complementary");
        alu_a = 32'd0;        alu_b = 32'd0;        check(32'd0,        "OR: 0|0");
        alu_a = 32'hFFFFFFFF; alu_b = 32'd0;        check(32'hFFFFFFFF, "OR: all1|0");
        alu_a = 32'hAAAAAAAA; alu_b = 32'h55555555; check(32'hFFFFFFFF, "OR: alternating");
        alu_a = 32'h12345678; alu_b = 32'h12345678; check(32'h12345678, "OR: same|same");
        alu_a = 32'd0;        alu_b = 32'hFFFFFFFF; check(32'hFFFFFFFF, "OR: 0|all1");

        // ==================================================================
        // AND (control = 5'b01001)
        // ==================================================================
        $display("\n--- AND (5'b01001) ---");
        control = 5'b01001;

        alu_a = 32'hFF00FF00; alu_b = 32'h0F0F0F0F; check(32'h0F000F00, "AND: pattern");
        alu_a = 32'hFFFFFFFF; alu_b = 32'hFFFFFFFF; check(32'hFFFFFFFF, "AND: all1&all1");
        alu_a = 32'hFFFFFFFF; alu_b = 32'd0;        check(32'd0,        "AND: all1&0");
        alu_a = 32'd0;        alu_b = 32'd0;        check(32'd0,        "AND: 0&0");
        alu_a = 32'hAAAAAAAA; alu_b = 32'h55555555; check(32'd0,        "AND: alternating (no overlap)");
        alu_a = 32'hDEADBEEF; alu_b = 32'hFFFFFFFF; check(32'hDEADBEEF, "AND: val & all1 = val");

        // ==================================================================
        // MUL (control = 5'b01010) - lower 32 bits
        // ==================================================================
        $display("\n--- MUL (5'b01010) ---");
        control = 5'b01010;

        alu_a = 32'd6;        alu_b = 32'd7;        check(32'd42,       "MUL: 6*7");
        alu_a = 32'd0;        alu_b = 32'd12345;   check(32'd0,        "MUL: 0*12345");
        alu_a = 32'd1;        alu_b = 32'hDEADBEEF; check(32'hDEADBEEF, "MUL: 1*val");
        alu_a = 32'hFFFFFFFF; alu_b = 32'hFFFFFFFF; check(32'd1,        "MUL: (-1)*(-1)=1 (low32)");
        alu_a = 32'h80000000; alu_b = 32'd2;        check(32'd0,        "MUL: MIN_NEG*2 (overflow low)");
        alu_a = 32'd0;        alu_b = 32'd0;        check(32'd0,        "MUL: 0*0");
        alu_a = 32'd100;      alu_b = 32'd200;      check(32'd20000,    "MUL: 100*200");
        alu_a = 32'h00010000; alu_b = 32'h00010000; check(32'd0,        "MUL: 0x10000*0x10000 (low=0)");

        // ==================================================================
        // MULH (control = 5'b01011) - upper 32 bits, signed*signed
        // ==================================================================
        $display("\n--- MULH (5'b01011) ---");
        control = 5'b01011;

        alu_a = 32'd6;        alu_b = 32'd7;        check(32'd0,        "MULH: 6*7 (high=0)");
        alu_a = 32'hFFFFFFFF; alu_b = 32'hFFFFFFFF; check(32'd0,        "MULH: (-1)*(-1) high=0");
        alu_a = 32'h80000000; alu_b = 32'd2;        check(32'hFFFFFFFF, "MULH: MIN_NEG*2 high");
        alu_a = 32'h7FFFFFFF; alu_b = 32'h7FFFFFFF; check(32'h3FFFFFFF, "MULH: MAX_POS*MAX_POS high");
        alu_a = 32'h80000000; alu_b = 32'h80000000; check(32'h40000000, "MULH: MIN_NEG*MIN_NEG high");
        alu_a = 32'd0;        alu_b = 32'hFFFFFFFF; check(32'd0,        "MULH: 0*(-1) high=0");
        alu_a = 32'hFFFFFFFF; alu_b = 32'h7FFFFFFF; check(32'hFFFFFFFF, "MULH: (-1)*MAX_POS high");
        alu_a = 32'h80000000; alu_b = 32'hFFFFFFFF; check(32'd0,        "MULH: MIN_NEG*(-1) high=0");

        // ==================================================================
        // MULHSU (control = 5'b01100) - upper 32 bits, signed*unsigned
        // ==================================================================
        $display("\n--- MULHSU (5'b01100) ---");
        control = 5'b01100;

        alu_a = 32'd6;        alu_b = 32'd7;        check(32'd0,        "MULHSU: 6*7 high=0");
        alu_a = 32'hFFFFFFFF; alu_b = 32'd1;        check(32'hFFFFFFFF, "MULHSU: (-1)*1 high=-1");
        alu_a = 32'hFFFFFFFF; alu_b = 32'hFFFFFFFF; check(32'hFFFFFFFF, "MULHSU: (-1)*0xFFFFFFFF high");
        alu_a = 32'd1;        alu_b = 32'hFFFFFFFF; check(32'd0,        "MULHSU: 1*0xFFFFFFFF high=0");
        alu_a = 32'h80000000; alu_b = 32'd2;        check(32'hFFFFFFFF, "MULHSU: MIN_NEG(s)*2(u) high");
        alu_a = 32'h80000000; alu_b = 32'hFFFFFFFF; check(32'h80000000, "MULHSU: MIN_NEG*0xFFFFFFFF hi");
        alu_a = 32'd0;        alu_b = 32'hFFFFFFFF; check(32'd0,        "MULHSU: 0*0xFFFFFFFF high=0");
        alu_a = 32'h7FFFFFFF; alu_b = 32'hFFFFFFFF; check(32'h7FFFFFFE, "MULHSU: MAX_POS*0xFFFFFFFF hi");

        // ==================================================================
        // MULHU (control = 5'b01101) - upper 32 bits, unsigned*unsigned
        // ==================================================================
        $display("\n--- MULHU (5'b01101) ---");
        control = 5'b01101;

        alu_a = 32'd6;        alu_b = 32'd7;        check(32'd0,        "MULHU: 6*7 high=0");
        alu_a = 32'hFFFFFFFF; alu_b = 32'hFFFFFFFF; check(32'hFFFFFFFE, "MULHU: MAX*MAX high");
        alu_a = 32'hFFFFFFFF; alu_b = 32'd1;        check(32'd0,        "MULHU: 0xFFFFFFFF*1 high=0");
        alu_a = 32'h80000000; alu_b = 32'd2;        check(32'd1,        "MULHU: 0x80000000*2 high=1");
        alu_a = 32'd0;        alu_b = 32'hFFFFFFFF; check(32'd0,        "MULHU: 0*MAX high=0");
        alu_a = 32'h80000000; alu_b = 32'h80000000; check(32'h40000000, "MULHU: 0x80000000^2 high");
        alu_a = 32'h00010000; alu_b = 32'h00010000; check(32'd1,        "MULHU: 0x10000*0x10000 high=1");

        // ==================================================================
        // DIV (control = 5'b01110) - signed division
        // ==================================================================
        $display("\n--- DIV (5'b01110) ---");
        control = 5'b01110;

        alu_a = 32'd20;       alu_b = 32'd4;        check(32'd5,        "DIV: 20/4");
        alu_a = 32'd7;        alu_b = 32'd2;        check(32'd3,        "DIV: 7/2 (truncate)");
        alu_a = 32'hFFFFFFFF; alu_b = 32'd1;        check(32'hFFFFFFFF, "DIV: -1/1 = -1");
        alu_a = 32'd10;       alu_b = 32'd0;        check(32'hFFFFFFFF, "DIV: div-by-zero -> 0xFFFFFFFF");
        alu_a = 32'h80000000; alu_b = 32'hFFFFFFFF; check(32'h80000000, "DIV: overflow MIN_NEG/-1");
        alu_a = 32'h80000000; alu_b = 32'd1;        check(32'h80000000, "DIV: MIN_NEG/1");
        alu_a = 32'd0;        alu_b = 32'd5;        check(32'd0,        "DIV: 0/5");
        alu_a = 32'hFFFFFFF6; alu_b = 32'd3;        // -10/3 = -3 (truncate toward zero)
                                                      check(32'hFFFFFFFD, "DIV: -10/3 = -3");
        alu_a = 32'd0;        alu_b = 32'd0;        check(32'hFFFFFFFF, "DIV: 0/0 -> 0xFFFFFFFF");
        alu_a = 32'hFFFFFFF6; alu_b = 32'hFFFFFFFD; // -10 / -3 = 3
                                                      check(32'd3,       "DIV: -10/-3 = 3");

        // ==================================================================
        // DIVU (control = 5'b01111) - unsigned division
        // ==================================================================
        $display("\n--- DIVU (5'b01111) ---");
        control = 5'b01111;

        alu_a = 32'd20;       alu_b = 32'd4;        check(32'd5,        "DIVU: 20/4");
        alu_a = 32'hFFFFFFFF; alu_b = 32'd2;        check(32'h7FFFFFFF, "DIVU: 0xFFFFFFFF/2");
        alu_a = 32'd10;       alu_b = 32'd0;        check(32'hFFFFFFFF, "DIVU: div-by-zero -> 0xFFFFFFFF");
        alu_a = 32'h80000000; alu_b = 32'd1;        check(32'h80000000, "DIVU: 0x80000000/1");
        alu_a = 32'd0;        alu_b = 32'd5;        check(32'd0,        "DIVU: 0/5");
        alu_a = 32'hFFFFFFFF; alu_b = 32'hFFFFFFFF; check(32'd1,        "DIVU: MAX/MAX=1");
        alu_a = 32'd1;        alu_b = 32'hFFFFFFFF; check(32'd0,        "DIVU: 1/MAX=0");
        alu_a = 32'd0;        alu_b = 32'd0;        check(32'hFFFFFFFF, "DIVU: 0/0 -> 0xFFFFFFFF");

        // ==================================================================
        // REM (control = 5'b10000) - signed remainder
        // ==================================================================
        $display("\n--- REM (5'b10000) ---");
        control = 5'b10000;

        alu_a = 32'd7;        alu_b = 32'd2;        check(32'd1,        "REM: 7%2=1");
        alu_a = 32'd20;       alu_b = 32'd4;        check(32'd0,        "REM: 20%4=0");
        alu_a = 32'd10;       alu_b = 32'd0;        check(32'd10,       "REM: div-by-zero -> dividend");
        alu_a = 32'h80000000; alu_b = 32'hFFFFFFFF; check(32'd0,        "REM: overflow MIN_NEG%-1=0");
        alu_a = 32'hFFFFFFF6; alu_b = 32'd3;        // -10 % 3 = -1
                                                      check(32'hFFFFFFFF, "REM: -10%3 = -1");
        alu_a = 32'd0;        alu_b = 32'd5;        check(32'd0,        "REM: 0%5=0");
        alu_a = 32'hFFFFFFF6; alu_b = 32'hFFFFFFFD; // -10 % -3 = -1
                                                      check(32'hFFFFFFFF, "REM: -10%-3 = -1");
        alu_a = 32'd0;        alu_b = 32'd0;        check(32'd0,        "REM: 0%0 -> dividend(0)");
        alu_a = 32'hDEADBEEF; alu_b = 32'd0;        check(32'hDEADBEEF, "REM: 0xDEADBEEF%0 -> dividend");

        // ==================================================================
        // REMU (control = 5'b10001) - unsigned remainder
        // ==================================================================
        $display("\n--- REMU (5'b10001) ---");
        control = 5'b10001;

        alu_a = 32'd7;        alu_b = 32'd2;        check(32'd1,        "REMU: 7%2=1");
        alu_a = 32'd20;       alu_b = 32'd4;        check(32'd0,        "REMU: 20%4=0");
        alu_a = 32'd10;       alu_b = 32'd0;        check(32'd10,       "REMU: div-by-zero -> dividend");
        alu_a = 32'hFFFFFFFF; alu_b = 32'd2;        check(32'd1,        "REMU: 0xFFFFFFFF%2=1");
        alu_a = 32'd0;        alu_b = 32'd5;        check(32'd0,        "REMU: 0%5=0");
        alu_a = 32'hFFFFFFFF; alu_b = 32'hFFFFFFFE; check(32'd1,        "REMU: MAX%(MAX-1)=1");
        alu_a = 32'd1;        alu_b = 32'hFFFFFFFF; check(32'd1,        "REMU: 1%MAX=1");
        alu_a = 32'd0;        alu_b = 32'd0;        check(32'd0,        "REMU: 0%0 -> dividend(0)");
        alu_a = 32'hCAFEBABE; alu_b = 32'd0;        check(32'hCAFEBABE, "REMU: 0xCAFEBABE%0 -> dividend");

        // ==================================================================
        // DSQ (control = 5'b10010) - (a-b)*(a-b), lower 32 bits
        // ==================================================================
        $display("\n--- DSQ (5'b10010) ---");
        control = 5'b10010;

        alu_a = 32'd10;       alu_b = 32'd7;        check(32'd9,        "DSQ: (10-7)^2=9");
        alu_a = 32'd7;        alu_b = 32'd10;       check(32'd9,        "DSQ: (7-10)^2=9 (neg diff)");
        alu_a = 32'd5;        alu_b = 32'd5;        check(32'd0,        "DSQ: (5-5)^2=0");
        alu_a = 32'd0;        alu_b = 32'd0;        check(32'd0,        "DSQ: (0-0)^2=0");
        alu_a = 32'd100;      alu_b = 32'd0;        check(32'd10000,    "DSQ: (100-0)^2=10000");
        alu_a = 32'd0;        alu_b = 32'd100;      check(32'd10000,    "DSQ: (0-100)^2=10000");
        alu_a = 32'd1;        alu_b = 32'd0;        check(32'd1,        "DSQ: (1-0)^2=1");
        // Large difference: a=0, b=0xFFFFFFFF -> diff=1, dsq=1
        alu_a = 32'd0;        alu_b = 32'hFFFFFFFF; check(32'd1,        "DSQ: (0-0xFFFFFFFF)^2=1 (wrap)");
        // a=0x80000000, b=0 -> diff=0x80000000, dsq=0x80000000*0x80000000 low32 = 0
        alu_a = 32'h80000000; alu_b = 32'd0;        check(32'd0,        "DSQ: (0x80000000-0)^2 low32=0");

        // ==================================================================
        // DEFAULT case - undefined control values
        // ==================================================================
        $display("\n--- DEFAULT (undefined control) ---");

        alu_a = 32'hDEADBEEF; alu_b = 32'h12345678;
        control = 5'b10011; check(32'd0, "DEFAULT: ctrl=10011 -> 0");
        control = 5'b11111; check(32'd0, "DEFAULT: ctrl=11111 -> 0");
        control = 5'b10100; check(32'd0, "DEFAULT: ctrl=10100 -> 0");

        // ==================================================================
        // Summary
        // ==================================================================
        $display("\n==============================================================");
        $display("  ALU Testbench - Summary");
        $display("==============================================================");
        $display("  Total Tests : %0d", pass_count + fail_count);
        $display("  PASSED      : %0d", pass_count);
        $display("  FAILED      : %0d", fail_count);
        $display("==============================================================");

        if (fail_count == 0)
            $display("  >>> ALL TESTS PASSED <<<");
        else
            $display("  >>> SOME TESTS FAILED <<<");

        $display("==============================================================\n");
        $finish;
    end

endmodule
