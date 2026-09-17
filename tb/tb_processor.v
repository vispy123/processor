`timescale 1ns / 1ps

module tb_processor();

    reg clk;
    reg reset;

    processor dut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation: 100MHz (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    integer errors = 0;

    task check_reg(input [4:0] reg_idx, input [31:0] expected, input [127:0] name);
        begin
            if (dut.u_reg_file.rf[reg_idx] !== expected) begin
                $display("[FAIL] %0s (x%0d): expected 0x%08h, got 0x%08h", name, reg_idx, expected, dut.u_reg_file.rf[reg_idx]);
                errors = errors + 1;
            end else begin
                $display("[PASS] %0s (x%0d) == 0x%08h", name, reg_idx, expected);
            end
        end
    endtask

    initial begin
        // Initialize instruction memory
        dut.u_instr_mem.mem[0] = 32'h06400013; // 0x0000: x0 = 100 (should remain 0)
        dut.u_instr_mem.mem[1] = 32'h00000013; // 0x0004: nop
        dut.u_instr_mem.mem[2] = 32'h00000013; // 0x0008: nop
        dut.u_instr_mem.mem[3] = 32'h00000013; // 0x000c: nop
        dut.u_instr_mem.mem[4] = 32'h00000013; // 0x0010: nop
        dut.u_instr_mem.mem[5] = 32'h00000013; // 0x0014: nop
        dut.u_instr_mem.mem[6] = 32'h00000013; // 0x0018: nop
        dut.u_instr_mem.mem[7] = 32'h00f00093; // 0x001c: x1 = 15
        dut.u_instr_mem.mem[8] = 32'hffb00113; // 0x0020: x2 = -5 (0xFFFFFFFB)
        dut.u_instr_mem.mem[9] = 32'h00000013; // 0x0024: nop
        dut.u_instr_mem.mem[10] = 32'h00000013; // 0x0028: nop
        dut.u_instr_mem.mem[11] = 32'h00000013; // 0x002c: nop
        dut.u_instr_mem.mem[12] = 32'h00000013; // 0x0030: nop
        dut.u_instr_mem.mem[13] = 32'h00000013; // 0x0034: nop
        dut.u_instr_mem.mem[14] = 32'h00000013; // 0x0038: nop
        dut.u_instr_mem.mem[15] = 32'h00012193; // 0x003c: x3 = (x2 < 0) = 1 (signed)
        dut.u_instr_mem.mem[16] = 32'h00a0a213; // 0x0040: x4 = (x1 < 10) = 0
        dut.u_instr_mem.mem[17] = 32'h00a13293; // 0x0044: x5 = (unsigned(-5) < 10) = 0
        dut.u_instr_mem.mem[18] = 32'h0140b313; // 0x0048: x6 = (15 < 20) = 1
        dut.u_instr_mem.mem[19] = 32'h05a0c393; // 0x004c: x7 = 15 ^ 0x5A = 0x55
        dut.u_instr_mem.mem[20] = 32'h0f00e413; // 0x0050: x8 = 15 | 0xF0 = 0xFF
        dut.u_instr_mem.mem[21] = 32'h00a0f493; // 0x0054: x9 = 15 & 0x0A = 10
        dut.u_instr_mem.mem[22] = 32'h00209513; // 0x0058: x10 = 15 << 2 = 60
        dut.u_instr_mem.mem[23] = 32'h00255593; // 0x005c: x11 = 60 >> 2 = 15
        dut.u_instr_mem.mem[24] = 32'h40115613; // 0x0060: x12 = -5 >>> 1 = -3 (0xFFFFFFFD)
        dut.u_instr_mem.mem[25] = 32'h00000013; // 0x0064: nop
        dut.u_instr_mem.mem[26] = 32'h00000013; // 0x0068: nop
        dut.u_instr_mem.mem[27] = 32'h00000013; // 0x006c: nop
        dut.u_instr_mem.mem[28] = 32'h00000013; // 0x0070: nop
        dut.u_instr_mem.mem[29] = 32'h00000013; // 0x0074: nop
        dut.u_instr_mem.mem[30] = 32'h00000013; // 0x0078: nop
        dut.u_instr_mem.mem[31] = 32'h123456b7; // 0x007c: x13 = 0x12345000
        dut.u_instr_mem.mem[32] = 32'h00001717; // 0x0080: x14 = auipc (addr + 0x1000)
        dut.u_instr_mem.mem[33] = 32'h00000013; // 0x0084: nop
        dut.u_instr_mem.mem[34] = 32'h00000013; // 0x0088: nop
        dut.u_instr_mem.mem[35] = 32'h00000013; // 0x008c: nop
        dut.u_instr_mem.mem[36] = 32'h00000013; // 0x0090: nop
        dut.u_instr_mem.mem[37] = 32'h00000013; // 0x0094: nop
        dut.u_instr_mem.mem[38] = 32'h00000013; // 0x0098: nop
        dut.u_instr_mem.mem[39] = 32'h002087b3; // 0x009c: x15 = 15 + (-5) = 10
        dut.u_instr_mem.mem[40] = 32'h40208833; // 0x00a0: x16 = 15 - (-5) = 20
        dut.u_instr_mem.mem[41] = 32'h00f098b3; // 0x00a4: x17 = 15 << (10 & 0x1F) = 15 << 10 = 15360
        dut.u_instr_mem.mem[42] = 32'h00112933; // 0x00a8: x18 = -5 < 15 = 1
        dut.u_instr_mem.mem[43] = 32'h001139b3; // 0x00ac: x19 = (unsigned -5) < 15 = 0
        dut.u_instr_mem.mem[44] = 32'h00f0ca33; // 0x00b0: x20 = 15 ^ 10 = 5
        dut.u_instr_mem.mem[45] = 32'h00f8dab3; // 0x00b4: x21 = 15360 >> 10 = 15
        dut.u_instr_mem.mem[46] = 32'h40f15b33; // 0x00b8: x22 = -5 >>> (10 & 0x1F) = -1
        dut.u_instr_mem.mem[47] = 32'h00f0ebb3; // 0x00bc: x23 = 15 | 10 = 15
        dut.u_instr_mem.mem[48] = 32'h00f0fc33; // 0x00c0: x24 = 15 & 10 = 10
        dut.u_instr_mem.mem[49] = 32'h00000013; // 0x00c4: nop
        dut.u_instr_mem.mem[50] = 32'h00000013; // 0x00c8: nop
        dut.u_instr_mem.mem[51] = 32'h00000013; // 0x00cc: nop
        dut.u_instr_mem.mem[52] = 32'h00000013; // 0x00d0: nop
        dut.u_instr_mem.mem[53] = 32'h00000013; // 0x00d4: nop
        dut.u_instr_mem.mem[54] = 32'h00000013; // 0x00d8: nop
        dut.u_instr_mem.mem[55] = 32'h02f08cb3; // 0x00dc: x25 = 15 * 10 = 150
        dut.u_instr_mem.mem[56] = 32'h0217cd33; // 0x00e0: x26 = 10 / 15 = 0
        dut.u_instr_mem.mem[57] = 32'h02f0cdb3; // 0x00e4: x27 = 15 / 10 = 1
        dut.u_instr_mem.mem[58] = 32'h02f0ee33; // 0x00e8: x28 = 15 % 10 = 5
        dut.u_instr_mem.mem[59] = 32'h40f09eb3; // 0x00ec: x29 = (15 - 10)^2 = 25
        dut.u_instr_mem.mem[60] = 32'h0200cf33; // 0x00f0: x30 = 15 / 0 = -1 (0xFFFFFFFF)
        dut.u_instr_mem.mem[61] = 32'h0200dfb3; // 0x00f4: x31 = 15 / 0 = -1 (0xFFFFFFFF)
        dut.u_instr_mem.mem[62] = 32'h00000013; // 0x00f8: nop
        dut.u_instr_mem.mem[63] = 32'h00000013; // 0x00fc: nop
        dut.u_instr_mem.mem[64] = 32'h00000013; // 0x0100: nop
        dut.u_instr_mem.mem[65] = 32'h00000013; // 0x0104: nop
        dut.u_instr_mem.mem[66] = 32'h00000013; // 0x0108: nop
        dut.u_instr_mem.mem[67] = 32'h00000013; // 0x010c: nop
        dut.u_instr_mem.mem[68] = 32'h0200e1b3; // 0x0110: x3 = 15 % 0 = 15
        dut.u_instr_mem.mem[69] = 32'h0200f233; // 0x0114: x4 = 15 % 0 = 15
        dut.u_instr_mem.mem[70] = 32'hffe00293; // 0x0118: x5 = -2
        dut.u_instr_mem.mem[71] = 32'h00300313; // 0x011c: x6 = 3
        dut.u_instr_mem.mem[72] = 32'h00000013; // 0x0120: nop
        dut.u_instr_mem.mem[73] = 32'h00000013; // 0x0124: nop
        dut.u_instr_mem.mem[74] = 32'h00000013; // 0x0128: nop
        dut.u_instr_mem.mem[75] = 32'h00000013; // 0x012c: nop
        dut.u_instr_mem.mem[76] = 32'h00000013; // 0x0130: nop
        dut.u_instr_mem.mem[77] = 32'h00000013; // 0x0134: nop
        dut.u_instr_mem.mem[78] = 32'h026293b3; // 0x0138: x7 = mulh(-2, 3) = -1 (0xFFFFFFFF)
        dut.u_instr_mem.mem[79] = 32'h0262b433; // 0x013c: x8 = mulhu(-2, 3) = 2
        dut.u_instr_mem.mem[80] = 32'h0262a4b3; // 0x0140: x9 = mulhsu(-2, 3) = -1 (0xFFFFFFFF)
        dut.u_instr_mem.mem[81] = 32'h00000013; // 0x0144: nop
        dut.u_instr_mem.mem[82] = 32'h00000013; // 0x0148: nop
        dut.u_instr_mem.mem[83] = 32'h00000013; // 0x014c: nop
        dut.u_instr_mem.mem[84] = 32'h00000013; // 0x0150: nop
        dut.u_instr_mem.mem[85] = 32'h00000013; // 0x0154: nop
        dut.u_instr_mem.mem[86] = 32'h00000013; // 0x0158: nop
        dut.u_instr_mem.mem[87] = 32'h00000513; // 0x015c: x10 = 0 (base address)
        dut.u_instr_mem.mem[88] = 32'hdeadb5b7; // 0x0160: x11 upper = 0xDEADB000
        dut.u_instr_mem.mem[89] = 32'h00000013; // 0x0164: nop
        dut.u_instr_mem.mem[90] = 32'h00000013; // 0x0168: nop
        dut.u_instr_mem.mem[91] = 32'h00000013; // 0x016c: nop
        dut.u_instr_mem.mem[92] = 32'h00000013; // 0x0170: nop
        dut.u_instr_mem.mem[93] = 32'h00000013; // 0x0174: nop
        dut.u_instr_mem.mem[94] = 32'h00000013; // 0x0178: nop
        dut.u_instr_mem.mem[95] = 32'heef5e593; // 0x017c: x11 = 0xDEADBEEF
        dut.u_instr_mem.mem[96] = 32'h00000013; // 0x0180: nop
        dut.u_instr_mem.mem[97] = 32'h00000013; // 0x0184: nop
        dut.u_instr_mem.mem[98] = 32'h00000013; // 0x0188: nop
        dut.u_instr_mem.mem[99] = 32'h00000013; // 0x018c: nop
        dut.u_instr_mem.mem[100] = 32'h00000013; // 0x0190: nop
        dut.u_instr_mem.mem[101] = 32'h00000013; // 0x0194: nop
        dut.u_instr_mem.mem[102] = 32'h00b52023; // 0x0198: SW: mem[0] <= 0xDEADBEEF
        dut.u_instr_mem.mem[103] = 32'h00000013; // 0x019c: nop
        dut.u_instr_mem.mem[104] = 32'h00000013; // 0x01a0: nop
        dut.u_instr_mem.mem[105] = 32'h00000013; // 0x01a4: nop
        dut.u_instr_mem.mem[106] = 32'h00000013; // 0x01a8: nop
        dut.u_instr_mem.mem[107] = 32'h00000013; // 0x01ac: nop
        dut.u_instr_mem.mem[108] = 32'h00000013; // 0x01b0: nop
        dut.u_instr_mem.mem[109] = 32'h00052603; // 0x01b4: LW: x12 <= mem[0] (should be 0xDEADBEEF)
        dut.u_instr_mem.mem[110] = 32'h00000013; // 0x01b8: nop
        dut.u_instr_mem.mem[111] = 32'h00000013; // 0x01bc: nop
        dut.u_instr_mem.mem[112] = 32'h00000013; // 0x01c0: nop
        dut.u_instr_mem.mem[113] = 32'h00000013; // 0x01c4: nop
        dut.u_instr_mem.mem[114] = 32'h00000013; // 0x01c8: nop
        dut.u_instr_mem.mem[115] = 32'h00000013; // 0x01cc: nop
        dut.u_instr_mem.mem[116] = 32'h23400793; // 0x01d0: x15 = 0x1234
        dut.u_instr_mem.mem[117] = 32'hfff00813; // 0x01d4: x16 = 0xFFFFFFFF
        dut.u_instr_mem.mem[118] = 32'h00000013; // 0x01d8: nop
        dut.u_instr_mem.mem[119] = 32'h00000013; // 0x01dc: nop
        dut.u_instr_mem.mem[120] = 32'h00000013; // 0x01e0: nop
        dut.u_instr_mem.mem[121] = 32'h00000013; // 0x01e4: nop
        dut.u_instr_mem.mem[122] = 32'h00000013; // 0x01e8: nop
        dut.u_instr_mem.mem[123] = 32'h00000013; // 0x01ec: nop
        dut.u_instr_mem.mem[124] = 32'h00f51223; // 0x01f0: SH: mem[1][15:0] <= 0x1234
        dut.u_instr_mem.mem[125] = 32'h01051323; // 0x01f4: SH: mem[1][31:16] <= 0xFFFF
        dut.u_instr_mem.mem[126] = 32'h00000013; // 0x01f8: nop
        dut.u_instr_mem.mem[127] = 32'h00000013; // 0x01fc: nop
        dut.u_instr_mem.mem[128] = 32'h00000013; // 0x0200: nop
        dut.u_instr_mem.mem[129] = 32'h00000013; // 0x0204: nop
        dut.u_instr_mem.mem[130] = 32'h00000013; // 0x0208: nop
        dut.u_instr_mem.mem[131] = 32'h00000013; // 0x020c: nop
        dut.u_instr_mem.mem[132] = 32'h00451883; // 0x0210: LH: x17 <= 0x1234 (sign extended)
        dut.u_instr_mem.mem[133] = 32'h00651903; // 0x0214: LH: x18 <= 0xFFFFFFFF (sign extended -1)
        dut.u_instr_mem.mem[134] = 32'h00655983; // 0x0218: LHU: x19 <= 0x0000FFFF (zero extended)
        dut.u_instr_mem.mem[135] = 32'h00000013; // 0x021c: nop
        dut.u_instr_mem.mem[136] = 32'h00000013; // 0x0220: nop
        dut.u_instr_mem.mem[137] = 32'h00000013; // 0x0224: nop
        dut.u_instr_mem.mem[138] = 32'h00000013; // 0x0228: nop
        dut.u_instr_mem.mem[139] = 32'h00000013; // 0x022c: nop
        dut.u_instr_mem.mem[140] = 32'h00000013; // 0x0230: nop
        dut.u_instr_mem.mem[141] = 32'h07f00a13; // 0x0234: x20 = 0x7F (pos byte)
        dut.u_instr_mem.mem[142] = 32'h08500a93; // 0x0238: x21 = 0x85 (-123 signed byte)
        dut.u_instr_mem.mem[143] = 32'h00000013; // 0x023c: nop
        dut.u_instr_mem.mem[144] = 32'h00000013; // 0x0240: nop
        dut.u_instr_mem.mem[145] = 32'h00000013; // 0x0244: nop
        dut.u_instr_mem.mem[146] = 32'h00000013; // 0x0248: nop
        dut.u_instr_mem.mem[147] = 32'h00000013; // 0x024c: nop
        dut.u_instr_mem.mem[148] = 32'h00000013; // 0x0250: nop
        dut.u_instr_mem.mem[149] = 32'h01450423; // 0x0254: SB: mem[2][7:0] <= 0x7F
        dut.u_instr_mem.mem[150] = 32'h015504a3; // 0x0258: SB: mem[2][15:8] <= 0x85
        dut.u_instr_mem.mem[151] = 32'h00000013; // 0x025c: nop
        dut.u_instr_mem.mem[152] = 32'h00000013; // 0x0260: nop
        dut.u_instr_mem.mem[153] = 32'h00000013; // 0x0264: nop
        dut.u_instr_mem.mem[154] = 32'h00000013; // 0x0268: nop
        dut.u_instr_mem.mem[155] = 32'h00000013; // 0x026c: nop
        dut.u_instr_mem.mem[156] = 32'h00000013; // 0x0270: nop
        dut.u_instr_mem.mem[157] = 32'h00850b03; // 0x0274: LB: x22 <= 0x0000007F
        dut.u_instr_mem.mem[158] = 32'h00950b83; // 0x0278: LB: x23 <= 0xFFFFFF85 (sign extended)
        dut.u_instr_mem.mem[159] = 32'h00954c03; // 0x027c: LBU: x24 <= 0x00000085 (zero extended)
        dut.u_instr_mem.mem[160] = 32'h00000013; // 0x0280: nop
        dut.u_instr_mem.mem[161] = 32'h00000013; // 0x0284: nop
        dut.u_instr_mem.mem[162] = 32'h00000013; // 0x0288: nop
        dut.u_instr_mem.mem[163] = 32'h00000013; // 0x028c: nop
        dut.u_instr_mem.mem[164] = 32'h00000013; // 0x0290: nop
        dut.u_instr_mem.mem[165] = 32'h00000013; // 0x0294: nop
        dut.u_instr_mem.mem[166] = 32'h008000ef; // 0x0298: JAL x1, +8
        dut.u_instr_mem.mem[167] = 32'hbad00113; // 0x029c: SKIPPED INSTRUCTION! If executed, x2 = 0xBAD
        dut.u_instr_mem.mem[168] = 32'h00d00113; // 0x02a0: JAL TARGET: x2 = 0x600D
        dut.u_instr_mem.mem[169] = 32'h00000013; // 0x02a4: nop
        dut.u_instr_mem.mem[170] = 32'h00000013; // 0x02a8: nop
        dut.u_instr_mem.mem[171] = 32'h00000013; // 0x02ac: nop
        dut.u_instr_mem.mem[172] = 32'h00000013; // 0x02b0: nop
        dut.u_instr_mem.mem[173] = 32'h00000013; // 0x02b4: nop
        dut.u_instr_mem.mem[174] = 32'h00000013; // 0x02b8: nop
        dut.u_instr_mem.mem[175] = 32'h2d000193; // 0x02bc: x3 = target_jalr_pc (720)
        dut.u_instr_mem.mem[176] = 32'h00000013; // 0x02c0: nop
        dut.u_instr_mem.mem[177] = 32'h00000013; // 0x02c4: nop
        dut.u_instr_mem.mem[178] = 32'h00000013; // 0x02c8: nop
        dut.u_instr_mem.mem[179] = 32'h00000013; // 0x02cc: nop
        dut.u_instr_mem.mem[180] = 32'h00000013; // 0x02d0: nop
        dut.u_instr_mem.mem[181] = 32'h00000013; // 0x02d4: nop
        dut.u_instr_mem.mem[182] = 32'h00018267; // 0x02d8: JALR x4, 0(x3)
        dut.u_instr_mem.mem[183] = 32'hbad00293; // 0x02dc: SKIPPED INSTRUCTION! If executed, x5 = 0xBAD
        dut.u_instr_mem.mem[184] = 32'h00d00293; // 0x02e0: JALR TARGET: x5 = 0x600D
        dut.u_instr_mem.mem[185] = 32'h00000013; // 0x02e4: nop
        dut.u_instr_mem.mem[186] = 32'h00000013; // 0x02e8: nop
        dut.u_instr_mem.mem[187] = 32'h00000013; // 0x02ec: nop
        dut.u_instr_mem.mem[188] = 32'h00000013; // 0x02f0: nop
        dut.u_instr_mem.mem[189] = 32'h00000013; // 0x02f4: nop
        dut.u_instr_mem.mem[190] = 32'h00000013; // 0x02f8: nop
        dut.u_instr_mem.mem[191] = 32'h02a00313; // 0x02fc: x6 = 42
        dut.u_instr_mem.mem[192] = 32'h02a00393; // 0x0300: x7 = 42
        dut.u_instr_mem.mem[193] = 32'h00000013; // 0x0304: nop
        dut.u_instr_mem.mem[194] = 32'h00000013; // 0x0308: nop
        dut.u_instr_mem.mem[195] = 32'h00000013; // 0x030c: nop
        dut.u_instr_mem.mem[196] = 32'h00000013; // 0x0310: nop
        dut.u_instr_mem.mem[197] = 32'h00000013; // 0x0314: nop
        dut.u_instr_mem.mem[198] = 32'h00000013; // 0x0318: nop
        dut.u_instr_mem.mem[199] = 32'h00730463; // 0x031c: BEQ x6, x7, +8 (taken)
        dut.u_instr_mem.mem[200] = 32'hbad00413; // 0x0320: SKIPPED: x8 = 0xBAD
        dut.u_instr_mem.mem[201] = 32'h00d00413; // 0x0324: TARGET: x8 = 0x600D
        dut.u_instr_mem.mem[202] = 32'h00000013; // 0x0328: nop
        dut.u_instr_mem.mem[203] = 32'h00000013; // 0x032c: nop
        dut.u_instr_mem.mem[204] = 32'h00000013; // 0x0330: nop
        dut.u_instr_mem.mem[205] = 32'h00000013; // 0x0334: nop
        dut.u_instr_mem.mem[206] = 32'h00000013; // 0x0338: nop
        dut.u_instr_mem.mem[207] = 32'h00000013; // 0x033c: nop
        dut.u_instr_mem.mem[208] = 32'h02b00393; // 0x0340: x7 = 43
        dut.u_instr_mem.mem[209] = 32'h00000013; // 0x0344: nop
        dut.u_instr_mem.mem[210] = 32'h00000013; // 0x0348: nop
        dut.u_instr_mem.mem[211] = 32'h00000013; // 0x034c: nop
        dut.u_instr_mem.mem[212] = 32'h00000013; // 0x0350: nop
        dut.u_instr_mem.mem[213] = 32'h00000013; // 0x0354: nop
        dut.u_instr_mem.mem[214] = 32'h00000013; // 0x0358: nop
        dut.u_instr_mem.mem[215] = 32'h00730463; // 0x035c: BEQ x6, x7, +8 (NOT taken)
        dut.u_instr_mem.mem[216] = 32'h00d00493; // 0x0360: FALLTHROUGH: x9 = 0x600D
        dut.u_instr_mem.mem[217] = 32'h00000013; // 0x0364: nop
        dut.u_instr_mem.mem[218] = 32'h00000013; // 0x0368: nop
        dut.u_instr_mem.mem[219] = 32'h00000013; // 0x036c: nop
        dut.u_instr_mem.mem[220] = 32'h00000013; // 0x0370: nop
        dut.u_instr_mem.mem[221] = 32'h00000013; // 0x0374: nop
        dut.u_instr_mem.mem[222] = 32'h00000013; // 0x0378: nop
        dut.u_instr_mem.mem[223] = 32'h00000013; // 0x037c: nop
        dut.u_instr_mem.mem[224] = 32'h00731463; // 0x0380: BNE x6, x7, +8 (taken)
        dut.u_instr_mem.mem[225] = 32'hbad00513; // 0x0384: SKIPPED: x10 = 0xBAD
        dut.u_instr_mem.mem[226] = 32'h00d00513; // 0x0388: TARGET: x10 = 0x600D
        dut.u_instr_mem.mem[227] = 32'h00000013; // 0x038c: nop
        dut.u_instr_mem.mem[228] = 32'h00000013; // 0x0390: nop
        dut.u_instr_mem.mem[229] = 32'h00000013; // 0x0394: nop
        dut.u_instr_mem.mem[230] = 32'h00000013; // 0x0398: nop
        dut.u_instr_mem.mem[231] = 32'h00000013; // 0x039c: nop
        dut.u_instr_mem.mem[232] = 32'h00000013; // 0x03a0: nop
        dut.u_instr_mem.mem[233] = 32'h00614463; // 0x03a4: BLT -5 < 42, +8 (taken)
        dut.u_instr_mem.mem[234] = 32'hbad00593; // 0x03a8: SKIPPED: x11 = 0xBAD
        dut.u_instr_mem.mem[235] = 32'h00d00593; // 0x03ac: TARGET: x11 = 0x600D
        dut.u_instr_mem.mem[236] = 32'h00000013; // 0x03b0: nop
        dut.u_instr_mem.mem[237] = 32'h00000013; // 0x03b4: nop
        dut.u_instr_mem.mem[238] = 32'h00000013; // 0x03b8: nop
        dut.u_instr_mem.mem[239] = 32'h00000013; // 0x03bc: nop
        dut.u_instr_mem.mem[240] = 32'h00000013; // 0x03c0: nop
        dut.u_instr_mem.mem[241] = 32'h00000013; // 0x03c4: nop
        dut.u_instr_mem.mem[242] = 32'h00235463; // 0x03c8: BGE 42 >= -5, +8 (taken)
        dut.u_instr_mem.mem[243] = 32'hbad00613; // 0x03cc: SKIPPED: x12 = 0xBAD
        dut.u_instr_mem.mem[244] = 32'h00d00613; // 0x03d0: TARGET: x12 = 0x600D
        dut.u_instr_mem.mem[245] = 32'h00000013; // 0x03d4: nop
        dut.u_instr_mem.mem[246] = 32'h00000013; // 0x03d8: nop
        dut.u_instr_mem.mem[247] = 32'h00000013; // 0x03dc: nop
        dut.u_instr_mem.mem[248] = 32'h00000013; // 0x03e0: nop
        dut.u_instr_mem.mem[249] = 32'h00000013; // 0x03e4: nop
        dut.u_instr_mem.mem[250] = 32'h00000013; // 0x03e8: nop
        dut.u_instr_mem.mem[251] = 32'h00236463; // 0x03ec: BLTU 42 < unsigned(-5), +8 (taken)
        dut.u_instr_mem.mem[252] = 32'hbad00693; // 0x03f0: SKIPPED: x13 = 0xBAD
        dut.u_instr_mem.mem[253] = 32'h00d00693; // 0x03f4: TARGET: x13 = 0x600D
        dut.u_instr_mem.mem[254] = 32'h00000013; // 0x03f8: nop
        dut.u_instr_mem.mem[255] = 32'h00000013; // 0x03fc: nop
        dut.u_instr_mem.mem[256] = 32'h00000013; // 0x0400: nop
        dut.u_instr_mem.mem[257] = 32'h00000013; // 0x0404: nop
        dut.u_instr_mem.mem[258] = 32'h00000013; // 0x0408: nop
        dut.u_instr_mem.mem[259] = 32'h00000013; // 0x040c: nop
        dut.u_instr_mem.mem[260] = 32'h00000013; // 0x0410: nop
        dut.u_instr_mem.mem[261] = 32'h00000013; // 0x0414: nop
        dut.u_instr_mem.mem[262] = 32'h00000013; // 0x0418: nop
        dut.u_instr_mem.mem[263] = 32'h00000013; // 0x041c: nop
        dut.u_instr_mem.mem[264] = 32'h00000013; // 0x0420: nop
        dut.u_instr_mem.mem[265] = 32'h00000013; // 0x0424: nop
        dut.u_instr_mem.mem[266] = 32'h00000013; // 0x0428: nop
        dut.u_instr_mem.mem[267] = 32'h00000013; // 0x042c: nop
        dut.u_instr_mem.mem[268] = 32'h00000013; // 0x0430: nop
        dut.u_instr_mem.mem[269] = 32'h00000013; // 0x0434: nop

        for (int i = 270; i < 1024; i = i + 1) begin
            dut.u_instr_mem.mem[i] = 32'h00000013; // NOP
        end

        // Drive enables to 1 and hazard flushes to 0 (per assumption: ignore hazard unit for now)
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

        // Reset pulse
        reset = 1;
        #20;
        @(posedge clk);
        #1;
        reset = 0;
        $display("Processor reset released. Executing test suite...");

        // Wait for program to execute
        #3000;

        $display("========================================");
        $display("          PROCESSOR AUDIT TESTS         ");
        $display("========================================");

        // Check x0 is 0
        check_reg(0, 32'h00000000, "x0 hardwired 0");

        // ALU Imm
        check_reg(1, 32'd15, "ADDI x1");
        check_reg(2, 32'hFFFFFFFB, "ADDI x2 (-5)");
        check_reg(3, 32'd1, "SLTI x3 (-5 < 0)");
        check_reg(4, 32'd0, "SLTI x4 (15 < 10)");
        check_reg(5, 32'd0, "SLTIU x5 (unsigned -5 < 10)");
        check_reg(6, 32'd1, "SLTIU x6 (15 < 20)");
        check_reg(7, 32'h00000055, "XORI x7 (15 ^ 0x5A)");
        check_reg(8, 32'h000000FF, "ORI x8 (15 | 0xF0)");
        check_reg(9, 32'd10, "ANDI x9 (15 & 0x0A)");
        check_reg(10, 32'd60, "SLLI x10 (15 << 2)");
        check_reg(11, 32'd15, "SRLI x11 (60 >> 2)");
        check_reg(12, 32'hFFFFFFFD, "SRAI x12 (-5 >>> 1)");

        // Upper Imm
        check_reg(13, 32'h12345000, "LUI x13");
        check_reg(14, 32'h00001080, "AUIPC x14");

        // R-type ALU
        check_reg(15, 32'd10, "ADD x15 (15 + -5)");
        check_reg(16, 32'd20, "SUB x16 (15 - -5)");
        check_reg(17, 32'd15360, "SLL x17 (15 << 10)");
        check_reg(18, 32'd1, "SLT x18 (-5 < 15)");
        check_reg(19, 32'd0, "SLTU x19 (unsigned -5 < 15)");
        check_reg(20, 32'd5, "XOR x20 (15 ^ 10)");
        check_reg(21, 32'd15, "SRL x21 (15360 >> 10)");
        check_reg(22, 32'hFFFFFFFF, "SRA x22 (-5 >>> 10)");
        check_reg(23, 32'd15, "OR x23 (15 | 10)");
        check_reg(24, 32'd10, "AND x24 (15 & 10)");

        // M-extension & DSQ
        check_reg(25, 32'd150, "MUL x25 (15 * 10)");
        check_reg(26, 32'd0, "DIV x26 (10 / 15)");
        check_reg(27, 32'd1, "DIV x27 (15 / 10)");
        check_reg(28, 32'd5, "REM x28 (15 % 10)");
        check_reg(29, 32'd25, "DSQ x29 (15 - 10)^2");
        check_reg(30, 32'hFFFFFFFF, "DIV by 0");
        check_reg(31, 32'hFFFFFFFF, "DIVU by 0");

        check_reg(7, 32'hFFFFFFFF, "MULH (-2 * 3)");
        check_reg(8, 32'd2, "MULHU (-2 * 3)");
        check_reg(9, 32'hFFFFFFFF, "MULHSU (-2 * 3)");

        // Load / Store
        check_reg(12, 32'hDEADBEEF, "LW word");
        check_reg(17, 32'h00001234, "LH halfword");
        check_reg(18, 32'hFFFFFFFF, "LH signed -1");
        check_reg(19, 32'h0000FFFF, "LHU unsigned");
        check_reg(22, 32'h0000007F, "LB byte pos");
        check_reg(23, 32'hFFFFFF85, "LB byte neg sign-extended");
        check_reg(24, 32'h00000085, "LBU byte unsigned zero-extended");

        // JAL & JALR
        check_reg(1, 32'h0000029c, "JAL return address in x1");
        check_reg(2, 32'h0000600D, "JAL target executed (x2)");
        check_reg(4, 32'h000002cc, "JALR return address in x4");
        check_reg(5, 32'h0000600D, "JALR target executed (x5)");

        // Branches
        check_reg(8, 32'h0000600D, "BEQ taken (x8)");
        check_reg(9, 32'h0000600D, "BEQ not taken (x9)");
        check_reg(10, 32'h0000600D, "BNE taken (x10)");
        check_reg(11, 32'h0000600D, "BLT taken (x11)");
        check_reg(12, 32'h0000600D, "BGE taken (x12)");
        check_reg(13, 32'h0000600D, "BLTU taken (x13)");

        $display("========================================");
        if (errors == 0) begin
            $display("ALL TESTS PASSED SUCCESSFULLY! (0 errors)");
        end else begin
            $display("TEST SUITE FAILED with %0d errors!", errors);
        end
        $display("========================================");

        $finish;
    end

endmodule
