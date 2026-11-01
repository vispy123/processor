`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Testbench: tb_hazard
// Tests the hazard detection and forwarding unit for a 7-stage RISC-V pipeline
// Pipeline: IF1 → IF2 → ID → EX1 → EX2 → MEM1 → MEM2 → WB
//////////////////////////////////////////////////////////////////////////////

module tb_hazard;

    // -----------------------------------------------------------------------
    // Forward-source encoding
    // -----------------------------------------------------------------------
    localparam [2:0] NO_FWD   = 3'b000;
    localparam [2:0] FROM_EX2 = 3'b001;
    localparam [2:0] FROM_MEM1= 3'b010;
    localparam [2:0] FROM_MEM2= 3'b011;
    localparam [2:0] FROM_WB  = 3'b100;

    // Available-stage encoding
    localparam [1:0] AVAIL_EX2  = 2'b00;
    localparam [1:0] AVAIL_MEM1 = 2'b01;
    localparam [1:0] AVAIL_MEM2 = 2'b10;
    localparam [1:0] AVAIL_WB   = 2'b11;

    // -----------------------------------------------------------------------
    // DUT signals
    // -----------------------------------------------------------------------
    reg  [4:0] rd_EX2, rd_MEM1, rd_MEM2, rd_WB;
    reg  [4:0] rs1_EX1, rs2_EX1, rs1_EX2, rs2_EX2, rs2_MEM1;
    reg        reg_write_EX2, reg_write_MEM1, reg_write_MEM2, reg_write_WB;
    reg  [1:0] available_EX2, available_MEM1, available_MEM2, available_WB;
    reg        uses_rs1_EX1, uses_rs1_EX2, uses_rs1_MEM1;
    reg        uses_rs2_EX1, uses_rs2_EX2, uses_rs2_MEM1;

    wire [2:0] forward_rs1_EX1, forward_rs2_EX1;
    wire [2:0] forward_rs1_EX2, forward_rs2_EX2;
    wire [2:0] forward_rs2_MEM1;
    wire       stall_EX1, stall_EX2, stall_MEM1;

    // -----------------------------------------------------------------------
    // DUT instantiation
    // -----------------------------------------------------------------------
    hazard uut (
        .rd_EX2(rd_EX2), .rd_MEM1(rd_MEM1), .rd_MEM2(rd_MEM2), .rd_WB(rd_WB),
        .rs1_EX1(rs1_EX1), .rs2_EX1(rs2_EX1),
        .rs1_EX2(rs1_EX2), .rs2_EX2(rs2_EX2), .rs2_MEM1(rs2_MEM1),
        .reg_write_EX2(reg_write_EX2), .reg_write_MEM1(reg_write_MEM1),
        .reg_write_MEM2(reg_write_MEM2), .reg_write_WB(reg_write_WB),
        .available_EX2(available_EX2), .available_MEM1(available_MEM1),
        .available_MEM2(available_MEM2), .available_WB(available_WB),
        .uses_rs1_EX1(uses_rs1_EX1), .uses_rs1_EX2(uses_rs1_EX2),
        .uses_rs1_MEM1(uses_rs1_MEM1),
        .uses_rs2_EX1(uses_rs2_EX1), .uses_rs2_EX2(uses_rs2_EX2),
        .uses_rs2_MEM1(uses_rs2_MEM1),
        .forward_rs1_EX1(forward_rs1_EX1), .forward_rs2_EX1(forward_rs2_EX1),
        .forward_rs1_EX2(forward_rs1_EX2), .forward_rs2_EX2(forward_rs2_EX2),
        .forward_rs2_MEM1(forward_rs2_MEM1),
        .stall_EX1(stall_EX1), .stall_EX2(stall_EX2), .stall_MEM1(stall_MEM1)
    );

    // -----------------------------------------------------------------------
    // Score tracking
    // -----------------------------------------------------------------------
    integer pass_count, fail_count, test_num;

    // -----------------------------------------------------------------------
    // Helper task: reset all inputs to benign values (no hazards)
    // -----------------------------------------------------------------------
    task reset_inputs;
    begin
        rd_EX2   = 5'd0;  rd_MEM1  = 5'd0;  rd_MEM2  = 5'd0;  rd_WB    = 5'd0;
        rs1_EX1  = 5'd0;  rs2_EX1  = 5'd0;
        rs1_EX2  = 5'd0;  rs2_EX2  = 5'd0;
        rs2_MEM1 = 5'd0;
        reg_write_EX2 = 0; reg_write_MEM1 = 0;
        reg_write_MEM2= 0; reg_write_WB   = 0;
        available_EX2 = AVAIL_EX2; available_MEM1 = AVAIL_MEM1;
        available_MEM2= AVAIL_MEM2; available_WB   = AVAIL_WB;
        uses_rs1_EX1 = 0; uses_rs1_EX2 = 0; uses_rs1_MEM1 = 0;
        uses_rs2_EX1 = 0; uses_rs2_EX2 = 0; uses_rs2_MEM1 = 0;
    end
    endtask

    // -----------------------------------------------------------------------
    // Helper task: check a single signal and report PASS/FAIL
    // -----------------------------------------------------------------------
    task check;
        input [63:0] actual;
        input [63:0] expected;
        input [255:0] sig_name;  // signal name (padded string)
    begin
        if (actual === expected) begin
            pass_count = pass_count + 1;
        end else begin
            $display("  FAIL  %0s : got %0b, expected %0b", sig_name, actual, expected);
            fail_count = fail_count + 1;
        end
    end
    endtask

    // -----------------------------------------------------------------------
    // Main test sequence
    // -----------------------------------------------------------------------
    initial begin
        pass_count = 0;
        fail_count = 0;
        test_num   = 0;

        // ==================================================================
        // TEST 1: No hazard — all clean
        // ==================================================================
        test_num = 1;
        $display("TEST %0d: No hazard (no dependencies)", test_num);
        reset_inputs;
        // EX1 uses rs1=x1, rs2=x2 but nobody writes to them
        rs1_EX1 = 5'd1; rs2_EX1 = 5'd2;
        uses_rs1_EX1 = 1; uses_rs2_EX1 = 1;
        #10;
        check({61'b0, forward_rs1_EX1}, {61'b0, NO_FWD},  "fwd_rs1_EX1");
        check({61'b0, forward_rs2_EX1}, {61'b0, NO_FWD},  "fwd_rs2_EX1");
        check({61'b0, forward_rs1_EX2}, {61'b0, NO_FWD},  "fwd_rs1_EX2");
        check({61'b0, forward_rs2_EX2}, {61'b0, NO_FWD},  "fwd_rs2_EX2");
        check({61'b0, forward_rs2_MEM1},{61'b0, NO_FWD},  "fwd_rs2_MEM1");
        check({63'b0, stall_EX1},  64'd0, "stall_EX1");
        check({63'b0, stall_EX2},  64'd0, "stall_EX2");
        check({63'b0, stall_MEM1}, 64'd0, "stall_MEM1");

        // ==================================================================
        // TEST 2: RAW forwarding EX2 → EX1 (ALU, available_EX2=00)
        //   add x3,x4,x5 in EX2; add x6,x3,x7 in EX1
        // ==================================================================
        test_num = 2;
        $display("TEST %0d: RAW forward EX2->EX1 rs1 (ALU available in EX2)", test_num);
        reset_inputs;
        rd_EX2 = 5'd3;   reg_write_EX2 = 1; available_EX2 = AVAIL_EX2;
        rs1_EX1 = 5'd3;  uses_rs1_EX1 = 1;
        rs2_EX1 = 5'd7;  uses_rs2_EX1 = 1;
        #10;
        check({61'b0, forward_rs1_EX1}, {61'b0, FROM_EX2}, "fwd_rs1_EX1");
        check({61'b0, forward_rs2_EX1}, {61'b0, NO_FWD},   "fwd_rs2_EX1");
        check({63'b0, stall_EX1}, 64'd0, "stall_EX1");

        // ==================================================================
        // TEST 3: RAW forwarding MEM1 → EX1 (available_MEM1=01, ready)
        //   Instruction in MEM1 writes x5; EX1 reads rs1=x5
        // ==================================================================
        test_num = 3;
        $display("TEST %0d: RAW forward MEM1->EX1 rs1", test_num);
        reset_inputs;
        rd_MEM1 = 5'd5; reg_write_MEM1 = 1; available_MEM1 = AVAIL_MEM1;
        rs1_EX1 = 5'd5; uses_rs1_EX1 = 1;
        #10;
        check({61'b0, forward_rs1_EX1}, {61'b0, FROM_MEM1}, "fwd_rs1_EX1");
        check({63'b0, stall_EX1}, 64'd0, "stall_EX1");

        // ==================================================================
        // TEST 4: RAW forwarding MEM2 → EX1 (available_MEM2=10, ready)
        // ==================================================================
        test_num = 4;
        $display("TEST %0d: RAW forward MEM2->EX1 rs1", test_num);
        reset_inputs;
        rd_MEM2 = 5'd8; reg_write_MEM2 = 1; available_MEM2 = AVAIL_MEM2;
        rs1_EX1 = 5'd8; uses_rs1_EX1 = 1;
        #10;
        check({61'b0, forward_rs1_EX1}, {61'b0, FROM_MEM2}, "fwd_rs1_EX1");
        check({63'b0, stall_EX1}, 64'd0, "stall_EX1");

        // ==================================================================
        // TEST 5: RAW forwarding WB → EX1 (available_WB=11, ready)
        // ==================================================================
        test_num = 5;
        $display("TEST %0d: RAW forward WB->EX1 rs1", test_num);
        reset_inputs;
        rd_WB = 5'd10; reg_write_WB = 1; available_WB = AVAIL_WB;
        rs1_EX1 = 5'd10; uses_rs1_EX1 = 1;
        #10;
        check({61'b0, forward_rs1_EX1}, {61'b0, FROM_WB}, "fwd_rs1_EX1");
        check({63'b0, stall_EX1}, 64'd0, "stall_EX1");

        // ==================================================================
        // TEST 6: ALU stall EX1↔EX2 — available_EX2 = MEM1 (01)
        //   Data produced by EX2 available in MEM1 (not yet in EX2)
        //   Must stall EX1
        // ==================================================================
        test_num = 6;
        $display("TEST %0d: ALU stall EX1<->EX2 (available_EX2=MEM1)", test_num);
        reset_inputs;
        rd_EX2 = 5'd4; reg_write_EX2 = 1; available_EX2 = AVAIL_MEM1; // available in MEM1
        rs1_EX1 = 5'd4; uses_rs1_EX1 = 1;
        #10;
        check({63'b0, stall_EX1}, 64'd1, "stall_EX1");
        // No forward from EX2 since data not ready (available_EX2=01 > available_in_EX2=00)
        check({61'b0, forward_rs1_EX1}, {61'b0, NO_FWD}, "fwd_rs1_EX1");

        // ==================================================================
        // TEST 7: Load-use stall EX1↔EX2 — available_EX2 = WB (11)
        //   Load in EX2, data available only at WB
        // ==================================================================
        test_num = 7;
        $display("TEST %0d: Load-use stall EX1<->EX2 (available_EX2=WB)", test_num);
        reset_inputs;
        rd_EX2 = 5'd6; reg_write_EX2 = 1; available_EX2 = AVAIL_WB;
        rs2_EX1 = 5'd6; uses_rs2_EX1 = 1;
        #10;
        check({63'b0, stall_EX1}, 64'd1, "stall_EX1");
        check({61'b0, forward_rs2_EX1}, {61'b0, NO_FWD}, "fwd_rs2_EX1");

        // ==================================================================
        // TEST 8: Load-use stall EX1↔MEM1 — available_MEM1 = WB (11)
        //   Load in MEM1, data available only at WB; EX1 depends on it
        // ==================================================================
        test_num = 8;
        $display("TEST %0d: Load-use stall EX1<->MEM1 (available_MEM1=WB)", test_num);
        reset_inputs;
        rd_MEM1 = 5'd7; reg_write_MEM1 = 1; available_MEM1 = AVAIL_WB;
        rs1_EX1 = 5'd7; uses_rs1_EX1 = 1;
        #10;
        check({63'b0, stall_EX1}, 64'd1, "stall_EX1");
        // Data not ready at MEM1 (available=WB > MEM1), so no forward
        check({61'b0, forward_rs1_EX1}, {61'b0, NO_FWD}, "fwd_rs1_EX1");

        // ==================================================================
        // TEST 9: Load-use stall EX1↔MEM2 — available_MEM2 = WB (11)
        // ==================================================================
        test_num = 9;
        $display("TEST %0d: Load-use stall EX1<->MEM2 (available_MEM2=WB)", test_num);
        reset_inputs;
        rd_MEM2 = 5'd9; reg_write_MEM2 = 1; available_MEM2 = AVAIL_WB;
        rs1_EX1 = 5'd9; uses_rs1_EX1 = 1;
        #10;
        check({63'b0, stall_EX1}, 64'd1, "stall_EX1");
        check({61'b0, forward_rs1_EX1}, {61'b0, NO_FWD}, "fwd_rs1_EX1");

        // ==================================================================
        // TEST 10: Load-use stall EX2↔MEM1 — available_MEM1 = WB
        //   EX2 depends on load result from MEM1
        // ==================================================================
        test_num = 10;
        $display("TEST %0d: Load-use stall EX2<->MEM1 (available_MEM1=WB)", test_num);
        reset_inputs;
        rd_MEM1 = 5'd11; reg_write_MEM1 = 1; available_MEM1 = AVAIL_WB;
        rs1_EX2 = 5'd11; uses_rs1_EX2 = 1;
        #10;
        check({63'b0, stall_EX2}, 64'd1, "stall_EX2");
        check({63'b0, stall_EX1}, 64'd0, "stall_EX1");
        // No forward from MEM1 since data not ready
        check({61'b0, forward_rs1_EX2}, {61'b0, NO_FWD}, "fwd_rs1_EX2");

        // ==================================================================
        // TEST 11: Load-use stall EX2↔MEM2 — available_MEM2 = WB
        // ==================================================================
        test_num = 11;
        $display("TEST %0d: Load-use stall EX2<->MEM2 (available_MEM2=WB)", test_num);
        reset_inputs;
        rd_MEM2 = 5'd12; reg_write_MEM2 = 1; available_MEM2 = AVAIL_WB;
        rs2_EX2 = 5'd12; uses_rs2_EX2 = 1;
        #10;
        check({63'b0, stall_EX2}, 64'd1, "stall_EX2");
        check({61'b0, forward_rs2_EX2}, {61'b0, NO_FWD}, "fwd_rs2_EX2");

        // ==================================================================
        // TEST 12: Store forwarding MEM1↔MEM2
        //   Store in MEM1 needs rs2 data; load in MEM2 provides it
        // ==================================================================
        test_num = 12;
        $display("TEST %0d: Store forwarding MEM1<->MEM2 (rs2_MEM1 from MEM2)", test_num);
        reset_inputs;
        rd_MEM2 = 5'd13; reg_write_MEM2 = 1; available_MEM2 = AVAIL_MEM2;
        rs2_MEM1 = 5'd13; uses_rs2_MEM1 = 1;
        #10;
        check({61'b0, forward_rs2_MEM1}, {61'b0, FROM_MEM2}, "fwd_rs2_MEM1");
        check({63'b0, stall_MEM1}, 64'd0, "stall_MEM1");

        // ==================================================================
        // TEST 12b: Store forwarding MEM1↔WB
        // ==================================================================
        test_num = 12;
        $display("TEST %0d-b: Store forwarding MEM1 from WB", test_num);
        reset_inputs;
        rd_WB = 5'd14; reg_write_WB = 1; available_WB = AVAIL_WB;
        rs2_MEM1 = 5'd14; uses_rs2_MEM1 = 1;
        #10;
        check({61'b0, forward_rs2_MEM1}, {61'b0, FROM_WB}, "fwd_rs2_MEM1");
        check({63'b0, stall_MEM1}, 64'd0, "stall_MEM1");

        // ==================================================================
        // TEST 12c: Store stall MEM1↔MEM2 (load not ready)
        // ==================================================================
        $display("TEST %0d-c: Store stall MEM1<->MEM2 (load data in WB)", test_num);
        reset_inputs;
        rd_MEM2 = 5'd15; reg_write_MEM2 = 1; available_MEM2 = AVAIL_WB;
        rs2_MEM1 = 5'd15; uses_rs2_MEM1 = 1;
        #10;
        check({63'b0, stall_MEM1}, 64'd1, "stall_MEM1");

        // ==================================================================
        // TEST 13: rd = x0 should NOT forward
        //   EX2 writes x0, EX1 reads rs1=x0 → no forward
        // ==================================================================
        test_num = 13;
        $display("TEST %0d: rd=x0 no forward", test_num);
        reset_inputs;
        rd_EX2 = 5'd0; reg_write_EX2 = 1; available_EX2 = AVAIL_EX2;
        rs1_EX1 = 5'd0; uses_rs1_EX1 = 1;
        #10;
        check({61'b0, forward_rs1_EX1}, {61'b0, NO_FWD}, "fwd_rs1_EX1");
        check({63'b0, stall_EX1}, 64'd0, "stall_EX1");

        // Also verify across all stages
        reset_inputs;
        rd_MEM1 = 5'd0; reg_write_MEM1 = 1; available_MEM1 = AVAIL_MEM1;
        rd_MEM2 = 5'd0; reg_write_MEM2 = 1; available_MEM2 = AVAIL_MEM2;
        rd_WB   = 5'd0; reg_write_WB   = 1; available_WB   = AVAIL_WB;
        rs1_EX1 = 5'd0; uses_rs1_EX1 = 1;
        rs2_EX1 = 5'd0; uses_rs2_EX1 = 1;
        rs1_EX2 = 5'd0; uses_rs1_EX2 = 1;
        rs2_EX2 = 5'd0; uses_rs2_EX2 = 1;
        rs2_MEM1= 5'd0; uses_rs2_MEM1= 1;
        #10;
        check({61'b0, forward_rs1_EX1}, {61'b0, NO_FWD}, "fwd_rs1_EX1 (all x0)");
        check({61'b0, forward_rs2_EX1}, {61'b0, NO_FWD}, "fwd_rs2_EX1 (all x0)");
        check({61'b0, forward_rs1_EX2}, {61'b0, NO_FWD}, "fwd_rs1_EX2 (all x0)");
        check({61'b0, forward_rs2_EX2}, {61'b0, NO_FWD}, "fwd_rs2_EX2 (all x0)");
        check({61'b0, forward_rs2_MEM1},{61'b0, NO_FWD}, "fwd_rs2_MEM1 (all x0)");

        // ==================================================================
        // TEST 14: uses_rs1 = 0 → no forward even if rd matches
        // ==================================================================
        test_num = 14;
        $display("TEST %0d: uses_rs1=0 suppresses forwarding", test_num);
        reset_inputs;
        rd_EX2 = 5'd3; reg_write_EX2 = 1; available_EX2 = AVAIL_EX2;
        rs1_EX1 = 5'd3; uses_rs1_EX1 = 0;  // ← not using rs1
        rs2_EX1 = 5'd3; uses_rs2_EX1 = 0;  // ← not using rs2 either
        #10;
        check({61'b0, forward_rs1_EX1}, {61'b0, NO_FWD}, "fwd_rs1_EX1");
        check({61'b0, forward_rs2_EX1}, {61'b0, NO_FWD}, "fwd_rs2_EX1");
        check({63'b0, stall_EX1}, 64'd0, "stall_EX1");

        // Also test uses_rs2_EX2=0
        reset_inputs;
        rd_MEM1 = 5'd5; reg_write_MEM1 = 1; available_MEM1 = AVAIL_MEM1;
        rs1_EX2 = 5'd5; uses_rs1_EX2 = 0;
        rs2_EX2 = 5'd5; uses_rs2_EX2 = 0;
        #10;
        check({61'b0, forward_rs1_EX2}, {61'b0, NO_FWD}, "fwd_rs1_EX2 (uses=0)");
        check({61'b0, forward_rs2_EX2}, {61'b0, NO_FWD}, "fwd_rs2_EX2 (uses=0)");

        // uses_rs2_MEM1 = 0
        reset_inputs;
        rd_MEM2 = 5'd6; reg_write_MEM2 = 1; available_MEM2 = AVAIL_MEM2;
        rs2_MEM1 = 5'd6; uses_rs2_MEM1 = 0;
        #10;
        check({61'b0, forward_rs2_MEM1}, {61'b0, NO_FWD}, "fwd_rs2_MEM1 (uses=0)");

        // ==================================================================
        // TEST 15: Forwarding priority — closest stage wins
        //   EX2, MEM1, MEM2, WB all write to x5; EX1 reads rs1=x5
        //   EX2 has highest priority for EX1
        // ==================================================================
        test_num = 15;
        $display("TEST %0d: Forwarding priority — closest wins (EX2 > MEM1 > MEM2 > WB)", test_num);
        reset_inputs;
        // All stages write x5 and data is available at their stage
        rd_EX2  = 5'd5; reg_write_EX2  = 1; available_EX2  = AVAIL_EX2;
        rd_MEM1 = 5'd5; reg_write_MEM1 = 1; available_MEM1 = AVAIL_MEM1;
        rd_MEM2 = 5'd5; reg_write_MEM2 = 1; available_MEM2 = AVAIL_MEM2;
        rd_WB   = 5'd5; reg_write_WB   = 1; available_WB   = AVAIL_WB;
        rs1_EX1 = 5'd5; uses_rs1_EX1 = 1;
        rs2_EX1 = 5'd5; uses_rs2_EX1 = 1;
        #10;
        check({61'b0, forward_rs1_EX1}, {61'b0, FROM_EX2}, "fwd_rs1_EX1 (EX2 wins)");
        check({61'b0, forward_rs2_EX1}, {61'b0, FROM_EX2}, "fwd_rs2_EX1 (EX2 wins)");

        // For EX2: MEM1 should win over MEM2/WB
        rs1_EX2 = 5'd5; uses_rs1_EX2 = 1;
        rs2_EX2 = 5'd5; uses_rs2_EX2 = 1;
        #10;
        check({61'b0, forward_rs1_EX2}, {61'b0, FROM_MEM1}, "fwd_rs1_EX2 (MEM1 wins)");
        check({61'b0, forward_rs2_EX2}, {61'b0, FROM_MEM1}, "fwd_rs2_EX2 (MEM1 wins)");

        // For MEM1 rs2: MEM2 should win over WB
        rs2_MEM1 = 5'd5; uses_rs2_MEM1 = 1;
        #10;
        check({61'b0, forward_rs2_MEM1}, {61'b0, FROM_MEM2}, "fwd_rs2_MEM1 (MEM2 wins)");

        // ==================================================================
        // TEST 15b: Remove EX2 from the race, MEM1 should win for EX1
        // ==================================================================
        $display("TEST %0d-b: Priority with EX2 removed (MEM1 wins for EX1)", test_num);
        reset_inputs;
        rd_MEM1 = 5'd5; reg_write_MEM1 = 1; available_MEM1 = AVAIL_MEM1;
        rd_MEM2 = 5'd5; reg_write_MEM2 = 1; available_MEM2 = AVAIL_MEM2;
        rd_WB   = 5'd5; reg_write_WB   = 1; available_WB   = AVAIL_WB;
        rs1_EX1 = 5'd5; uses_rs1_EX1 = 1;
        #10;
        check({61'b0, forward_rs1_EX1}, {61'b0, FROM_MEM1}, "fwd_rs1_EX1 (MEM1 wins)");

        // ==================================================================
        // TEST 15c: Remove MEM1 too, MEM2 should win for EX1
        // ==================================================================
        $display("TEST %0d-c: Priority with EX2,MEM1 removed (MEM2 wins for EX1)", test_num);
        reset_inputs;
        rd_MEM2 = 5'd5; reg_write_MEM2 = 1; available_MEM2 = AVAIL_MEM2;
        rd_WB   = 5'd5; reg_write_WB   = 1; available_WB   = AVAIL_WB;
        rs1_EX1 = 5'd5; uses_rs1_EX1 = 1;
        #10;
        check({61'b0, forward_rs1_EX1}, {61'b0, FROM_MEM2}, "fwd_rs1_EX1 (MEM2 wins)");

        // ==================================================================
        // TEST 16: Multiple simultaneous hazards (rs1 from one, rs2 from another)
        //   EX2 writes x3 → forward to EX1 rs1=x3
        //   MEM1 writes x4 → forward to EX1 rs2=x4
        // ==================================================================
        test_num = 16;
        $display("TEST %0d: Multiple simultaneous hazards (rs1≠rs2, different sources)", test_num);
        reset_inputs;
        rd_EX2  = 5'd3; reg_write_EX2  = 1; available_EX2  = AVAIL_EX2;
        rd_MEM1 = 5'd4; reg_write_MEM1 = 1; available_MEM1 = AVAIL_MEM1;
        rs1_EX1 = 5'd3; uses_rs1_EX1 = 1;
        rs2_EX1 = 5'd4; uses_rs2_EX1 = 1;
        #10;
        check({61'b0, forward_rs1_EX1}, {61'b0, FROM_EX2},  "fwd_rs1_EX1 (from EX2)");
        check({61'b0, forward_rs2_EX1}, {61'b0, FROM_MEM1}, "fwd_rs2_EX1 (from MEM1)");
        check({63'b0, stall_EX1}, 64'd0, "stall_EX1");

        // ==================================================================
        // TEST 16b: rs1 from MEM2, rs2 from WB
        // ==================================================================
        $display("TEST %0d-b: rs1 from MEM2, rs2 from WB", test_num);
        reset_inputs;
        rd_MEM2 = 5'd8;  reg_write_MEM2 = 1; available_MEM2 = AVAIL_MEM2;
        rd_WB   = 5'd9;  reg_write_WB   = 1; available_WB   = AVAIL_WB;
        rs1_EX1 = 5'd8;  uses_rs1_EX1 = 1;
        rs2_EX1 = 5'd9;  uses_rs2_EX1 = 1;
        #10;
        check({61'b0, forward_rs1_EX1}, {61'b0, FROM_MEM2}, "fwd_rs1_EX1 (from MEM2)");
        check({61'b0, forward_rs2_EX1}, {61'b0, FROM_WB},   "fwd_rs2_EX1 (from WB)");

        // ==================================================================
        // TEST 17: EX2 forward for rs2_EX1 (not just rs1)
        // ==================================================================
        test_num = 17;
        $display("TEST %0d: EX2->EX1 forward on rs2", test_num);
        reset_inputs;
        rd_EX2 = 5'd20; reg_write_EX2 = 1; available_EX2 = AVAIL_EX2;
        rs2_EX1 = 5'd20; uses_rs2_EX1 = 1;
        #10;
        check({61'b0, forward_rs2_EX1}, {61'b0, FROM_EX2}, "fwd_rs2_EX1");
        check({63'b0, stall_EX1}, 64'd0, "stall_EX1");

        // ==================================================================
        // TEST 18: EX2 forwarding for rs1_EX2 and rs2_EX2
        //   MEM1 → EX2 forward
        // ==================================================================
        test_num = 18;
        $display("TEST %0d: MEM1->EX2 forward rs1 and rs2", test_num);
        reset_inputs;
        rd_MEM1 = 5'd16; reg_write_MEM1 = 1; available_MEM1 = AVAIL_MEM1;
        rs1_EX2 = 5'd16; uses_rs1_EX2 = 1;
        rs2_EX2 = 5'd16; uses_rs2_EX2 = 1;
        #10;
        check({61'b0, forward_rs1_EX2}, {61'b0, FROM_MEM1}, "fwd_rs1_EX2");
        check({61'b0, forward_rs2_EX2}, {61'b0, FROM_MEM1}, "fwd_rs2_EX2");
        check({63'b0, stall_EX2}, 64'd0, "stall_EX2");

        // ==================================================================
        // TEST 19: MEM2 → EX2 forward
        // ==================================================================
        test_num = 19;
        $display("TEST %0d: MEM2->EX2 forward rs1", test_num);
        reset_inputs;
        rd_MEM2 = 5'd17; reg_write_MEM2 = 1; available_MEM2 = AVAIL_MEM2;
        rs1_EX2 = 5'd17; uses_rs1_EX2 = 1;
        #10;
        check({61'b0, forward_rs1_EX2}, {61'b0, FROM_MEM2}, "fwd_rs1_EX2");

        // ==================================================================
        // TEST 20: WB → EX2 forward
        // ==================================================================
        test_num = 20;
        $display("TEST %0d: WB->EX2 forward rs2", test_num);
        reset_inputs;
        rd_WB = 5'd18; reg_write_WB = 1; available_WB = AVAIL_WB;
        rs2_EX2 = 5'd18; uses_rs2_EX2 = 1;
        #10;
        check({61'b0, forward_rs2_EX2}, {61'b0, FROM_WB}, "fwd_rs2_EX2");

        // ==================================================================
        // TEST 21: reg_write=0 means no forwarding even with matching rd
        // ==================================================================
        test_num = 21;
        $display("TEST %0d: reg_write=0 suppresses forwarding", test_num);
        reset_inputs;
        rd_EX2 = 5'd3; reg_write_EX2 = 0; available_EX2 = AVAIL_EX2;
        rs1_EX1 = 5'd3; uses_rs1_EX1 = 1;
        #10;
        check({61'b0, forward_rs1_EX1}, {61'b0, NO_FWD}, "fwd_rs1_EX1 (rw=0)");
        check({63'b0, stall_EX1}, 64'd0, "stall_EX1");

        // ==================================================================
        // TEST 22: ALU stall via rs2 match (not just rs1)
        // ==================================================================
        test_num = 22;
        $display("TEST %0d: ALU stall EX1<->EX2 via rs2 match", test_num);
        reset_inputs;
        rd_EX2 = 5'd4; reg_write_EX2 = 1; available_EX2 = AVAIL_MEM1;
        rs2_EX1 = 5'd4; uses_rs2_EX1 = 1;
        #10;
        check({63'b0, stall_EX1}, 64'd1, "stall_EX1");

        // ==================================================================
        // TEST 23: Stall should NOT fire if rd=x0 (even with available mismatch)
        // ==================================================================
        test_num = 23;
        $display("TEST %0d: No stall for rd=x0", test_num);
        reset_inputs;
        rd_EX2 = 5'd0; reg_write_EX2 = 1; available_EX2 = AVAIL_WB;
        rs1_EX1 = 5'd0; uses_rs1_EX1 = 1;
        #10;
        check({63'b0, stall_EX1}, 64'd0, "stall_EX1 (rd=x0)");

        // ==================================================================
        // TEST 24: Stall should NOT fire if uses_rsX = 0
        // ==================================================================
        test_num = 24;
        $display("TEST %0d: No stall when uses_rsX=0", test_num);
        reset_inputs;
        rd_EX2 = 5'd4; reg_write_EX2 = 1; available_EX2 = AVAIL_WB;
        rs1_EX1 = 5'd4; uses_rs1_EX1 = 0;
        rs2_EX1 = 5'd4; uses_rs2_EX1 = 0;
        #10;
        check({63'b0, stall_EX1}, 64'd0, "stall_EX1 (uses=0)");

        // ==================================================================
        // TEST 25: EX2 has available_MEM2 (data ready at MEM2)
        //   EX1 depends: should NOT stall (data will be available via MEM2 fwd)
        //   ... but we need to verify: stall only checks available_in_MEM1 and WB
        //   available_EX2=10 (MEM2): not == MEM1(01), not == WB(11) → no stall
        // ==================================================================
        test_num = 25;
        $display("TEST %0d: No stall for EX2 available_MEM2 (data ready at MEM2 fwd path)", test_num);
        reset_inputs;
        rd_EX2 = 5'd5; reg_write_EX2 = 1; available_EX2 = AVAIL_MEM2;
        rs1_EX1 = 5'd5; uses_rs1_EX1 = 1;
        #10;
        check({63'b0, stall_EX1}, 64'd0, "stall_EX1");
        // No forward from EX2 since available_EX2=MEM2(10) > EX2(00)
        check({61'b0, forward_rs1_EX1}, {61'b0, NO_FWD}, "fwd_rs1_EX1");

        // ==================================================================
        // TEST 26: EX2 priority with simultaneous stall condition
        //   EX2 writes x5 available_MEM1 → stall
        //   MEM1 writes x5 available_MEM1 → would forward, but stall dominates
        // ==================================================================
        test_num = 26;
        $display("TEST %0d: Stall with concurrent forward from later stage", test_num);
        reset_inputs;
        rd_EX2  = 5'd5; reg_write_EX2  = 1; available_EX2  = AVAIL_MEM1;
        rd_MEM1 = 5'd5; reg_write_MEM1 = 1; available_MEM1 = AVAIL_MEM1;
        rs1_EX1 = 5'd5; uses_rs1_EX1 = 1;
        #10;
        check({63'b0, stall_EX1}, 64'd1, "stall_EX1");
        // forward_rs1_EX1: EX2 data not ready, MEM1 matches → from_mem1
        check({61'b0, forward_rs1_EX1}, {61'b0, FROM_MEM1}, "fwd_rs1_EX1");

        // ==================================================================
        // TEST 27: Multiple stall sources simultaneously
        //   stall_EX1 from EX2 (load) AND stall_EX2 from MEM1 (load)
        // ==================================================================
        test_num = 27;
        $display("TEST %0d: Multiple simultaneous stalls (EX1 and EX2)", test_num);
        reset_inputs;
        // EX1 stalls due to EX2 load
        rd_EX2 = 5'd3; reg_write_EX2 = 1; available_EX2 = AVAIL_WB;
        rs1_EX1 = 5'd3; uses_rs1_EX1 = 1;
        // EX2 stalls due to MEM1 load
        rd_MEM1 = 5'd4; reg_write_MEM1 = 1; available_MEM1 = AVAIL_WB;
        rs1_EX2 = 5'd4; uses_rs1_EX2 = 1;
        #10;
        check({63'b0, stall_EX1}, 64'd1, "stall_EX1");
        check({63'b0, stall_EX2}, 64'd1, "stall_EX2");

        // ==================================================================
        // TEST 28: All three stalls simultaneously
        // ==================================================================
        test_num = 28;
        $display("TEST %0d: All three stalls simultaneously", test_num);
        reset_inputs;
        rd_EX2  = 5'd3; reg_write_EX2  = 1; available_EX2  = AVAIL_WB;
        rd_MEM1 = 5'd4; reg_write_MEM1 = 1; available_MEM1 = AVAIL_WB;
        rd_MEM2 = 5'd5; reg_write_MEM2 = 1; available_MEM2 = AVAIL_WB;
        rs1_EX1 = 5'd3; uses_rs1_EX1 = 1;
        rs1_EX2 = 5'd4; uses_rs1_EX2 = 1;
        rs2_MEM1= 5'd5; uses_rs2_MEM1= 1;
        #10;
        check({63'b0, stall_EX1}, 64'd1, "stall_EX1");
        check({63'b0, stall_EX2}, 64'd1, "stall_EX2");
        check({63'b0, stall_MEM1},64'd1, "stall_MEM1");

        // ==================================================================
        // TEST 29: Forward rs2 EX1 from each stage individually
        // ==================================================================
        test_num = 29;
        $display("TEST %0d: Forward rs2 EX1 from MEM1", test_num);
        reset_inputs;
        rd_MEM1 = 5'd21; reg_write_MEM1 = 1; available_MEM1 = AVAIL_MEM1;
        rs2_EX1 = 5'd21; uses_rs2_EX1 = 1;
        #10;
        check({61'b0, forward_rs2_EX1}, {61'b0, FROM_MEM1}, "fwd_rs2_EX1");

        $display("TEST %0d: Forward rs2 EX1 from MEM2", test_num);
        reset_inputs;
        rd_MEM2 = 5'd22; reg_write_MEM2 = 1; available_MEM2 = AVAIL_MEM2;
        rs2_EX1 = 5'd22; uses_rs2_EX1 = 1;
        #10;
        check({61'b0, forward_rs2_EX1}, {61'b0, FROM_MEM2}, "fwd_rs2_EX1");

        $display("TEST %0d: Forward rs2 EX1 from WB", test_num);
        reset_inputs;
        rd_WB = 5'd23; reg_write_WB = 1; available_WB = AVAIL_WB;
        rs2_EX1 = 5'd23; uses_rs2_EX1 = 1;
        #10;
        check({61'b0, forward_rs2_EX1}, {61'b0, FROM_WB}, "fwd_rs2_EX1");

        // ==================================================================
        // TEST 30: EX2 priority for rs2 — MEM2 wins when EX2 removed
        // ==================================================================
        test_num = 30;
        $display("TEST %0d: EX2 priority for rs2_EX2 (MEM2 wins over WB)", test_num);
        reset_inputs;
        rd_MEM2 = 5'd24; reg_write_MEM2 = 1; available_MEM2 = AVAIL_MEM2;
        rd_WB   = 5'd24; reg_write_WB   = 1; available_WB   = AVAIL_WB;
        rs2_EX2 = 5'd24; uses_rs2_EX2 = 1;
        #10;
        check({61'b0, forward_rs2_EX2}, {61'b0, FROM_MEM2}, "fwd_rs2_EX2 (MEM2 wins)");

        // ==================================================================
        // SUMMARY
        // ==================================================================
        $display("");
        $display("==========================================================");
        $display("  HAZARD UNIT TESTBENCH SUMMARY");
        $display("==========================================================");
        $display("  PASSED: %0d", pass_count);
        $display("  FAILED: %0d", fail_count);
        $display("  TOTAL : %0d", pass_count + fail_count);
        $display("==========================================================");
        if (fail_count == 0)
            $display("  *** ALL TESTS PASSED ***");
        else
            $display("  *** SOME TESTS FAILED ***");
        $display("==========================================================");
        $finish;
    end

endmodule
