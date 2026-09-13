`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module decoder(
    input [31:0] instr,
    
    output reg alu_a_src, //rs1 or pc(auipc)
    output reg alu_b_src, //rs2 or imm
    output reg [1:0] wb_sel,
    output reg [1:0] pc_sel, 
    output reg reg_write, 
    output reg mem_read,
    output reg mem_write,
    output reg branch,
    output reg [2:0] branch_op, 
    output reg [2:0] load_op, 
    output reg [1:0] store_op, 
    output reg [4:0] alu_op, 
    output reg fence,
    output reg [1:0] sys_op, //ecall, ebreak
    output reg [31:0] imm,
    output reg lui_check
    );
    
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];

    localparam wb_sel_alu = 2'b00;
    localparam wb_sel_mem = 2'b01;
    localparam wb_sel_pc_plus4 = 2'b10;
    localparam wb_sel_imm = 2'b11;

    localparam pc_sel_pc_plus4 = 2'b00;
    localparam pc_sel_imm = 2'b01;
    localparam pc_sel_reg = 2'b10;

    localparam branch_op_beq = 3'b000;
    localparam branch_op_bne = 3'b001;
    localparam branch_op_blt = 3'b100;
    localparam branch_op_bge = 3'b101;
    localparam branch_op_bltu = 3'b110;
    localparam branch_op_bgeu = 3'b111;

    localparam load_op_lb = 3'b000;
    localparam load_op_lh = 3'b001;
    localparam load_op_lw = 3'b010;
    localparam load_op_lbu = 3'b011;
    localparam load_op_lhu = 3'b100;

    localparam store_op_sb = 2'b00;
    localparam store_op_sh = 2'b01;
    localparam store_op_sw = 2'b10;

    localparam alu_op_add = 5'b00000;
    localparam alu_op_sub = 5'b00001;
    localparam alu_op_sll = 5'b00010;
    localparam alu_op_slt = 5'b00011;
    localparam alu_op_sltu = 5'b00100;
    localparam alu_op_xor = 5'b00101;
    localparam alu_op_srl = 5'b00110;
    localparam alu_op_sra = 5'b00111;
    localparam alu_op_or = 5'b01000;
    localparam alu_op_and = 5'b01001;
    localparam alu_op_mul = 5'b01010;
    localparam alu_op_mulh = 5'b01011;
    localparam alu_op_mulhsu = 5'b01100;
    localparam alu_op_mulhu = 5'b01101;
    localparam alu_op_div = 5'b01110;
    localparam alu_op_divu = 5'b01111;
    localparam alu_op_rem = 5'b10000;
    localparam alu_op_remu = 5'b10001;
    localparam alu_op_dsq = 5'b10010;

    localparam sys_op_ecall = 2'b01;
    localparam sys_op_ebreak = 2'b10;

    always@*
        begin
            alu_a_src = 1'b0;
            alu_b_src = 1'b0;
            wb_sel = 2'b00;
            pc_sel = 2'b00;
            reg_write = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            branch = 1'b0;
            branch_op = 3'b000;
            load_op = 3'b000;
            store_op = 2'b00;
            alu_op = 5'b00000;
            fence = 1'b0;
            sys_op = 2'b00;
            imm = 32'b0;
            lui_check = 1'b0;
            case(opcode)
                7'b0110111: //lui
                    begin
                        alu_b_src = 1'b1;
                        reg_write = 1'b1;
                        wb_sel = wb_sel_alu;
                        imm = {instr[31:12], 12'b0};
                        lui_check = 1'b1;
                    end
                7'b0010111: //auipc
                    begin
                        alu_a_src = 1'b1;
                        alu_b_src = 1'b1;
                        reg_write= 1'b1;
                        wb_sel = wb_sel_alu;
                        alu_op = alu_op_add;
                        imm = {instr[31:12], 12'b0};
                    end
                7'b1101111: //jal
                    begin
                        pc_sel = pc_sel_imm;
                        reg_write = 1'b1;
                        wb_sel = wb_sel_pc_plus4;
                        imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
                    end
                7'b1100111: //jalr
                    begin
                        alu_b_src = 1'b1;
                        wb_sel = wb_sel_pc_plus4;
                        pc_sel = pc_sel_reg;
                        reg_write = 1'b1;
                        alu_op = alu_op_add;
                        imm = {{20{instr[31]}}, instr[31:20]};
                    end
                7'b1100011: //branch
                    begin
                        case (funct3)
                            3'b000: //beq
                                begin
                                    branch_op = branch_op_beq;  
                                    alu_op = alu_op_sub;
                                end
                            3'b001: //bne
                                begin
                                    branch_op = branch_op_bne;  
                                    alu_op = alu_op_sub;
                                end
                            3'b100: //blt
                                begin
                                    branch_op = branch_op_blt;  
                                    alu_op = alu_op_slt;
                                end
                            3'b101: //bge
                                begin
                                    branch_op = branch_op_bge; 
                                    alu_op = alu_op_slt;
                                end
                            3'b110: //bltu
                                begin
                                    branch_op = branch_op_bltu; 
                                    alu_op = alu_op_sltu;
                                end
                            3'b111: //bgeu
                                begin
                                    branch_op = branch_op_bgeu; 
                                    alu_op = alu_op_sltu;
                                end
                            default: 
                                begin
                                    branch_op = 3'b000;
                                    alu_op = 5'b00000;
                                end
                        endcase
                        alu_b_src = 1'b0;
                        branch = 1'b1;
                        imm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
                    end
                7'b0000011: //load
                    begin
                        case (funct3)
                            3'b000: load_op = load_op_lb;
                            3'b001: load_op = load_op_lh;
                            3'b010: load_op = load_op_lw;
                            3'b100: load_op = load_op_lbu;
                            3'b101: load_op = load_op_lhu;
                            default: load_op = 3'b000; 
                        endcase
                        alu_b_src = 1'b1;
                        mem_read = 1'b1;
                        reg_write = 1'b1;
                        alu_op = alu_op_add;
                        wb_sel = wb_sel_mem;
                        imm = {{20{instr[31]}}, instr[31:20]};
                    end
                7'b0100011: //store
                    begin
                        case (funct3)
                            3'b000: store_op = store_op_sb;
                            3'b001: store_op = store_op_sh;
                            3'b010: store_op = store_op_sw;
                            default: store_op = 2'b00;
                        endcase
                        alu_b_src = 1'b1;
                        mem_write = 1'b1;
                        alu_op = alu_op_add;
                        imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
                    end
                7'b0010011: //alu imm
                    begin
                        case (funct3)
                            3'b000: alu_op = alu_op_add;  //addi
                            3'b010: alu_op = alu_op_slt;  //slti
                            3'b011: alu_op = alu_op_sltu; //sltiu
                            3'b100: alu_op = alu_op_xor;  //xori
                            3'b110: alu_op = alu_op_or;   //ori
                            3'b111: alu_op = alu_op_and;  //andi
                            3'b001: alu_op = alu_op_sll;  //slli
                            3'b101:
                                begin
                                    case (funct7)
                                        7'b0000000: alu_op = alu_op_srl; //srli
                                        7'b0100000: alu_op = alu_op_sra; //srai
                                        default: alu_op = 5'b00000;
                                    endcase
                                end
                            default: alu_op = 5'b00000;
                        endcase
                        alu_b_src = 1'b1;
                        reg_write = 1'b1;
                        wb_sel = wb_sel_alu;
                        if (funct3 == 3'b001 || funct3 == 3'b101)
                            imm = {{27{1'b0}}, instr[24:20]};
                        else
                            imm = {{20{instr[31]}}, instr[31:20]};
                    end
                7'b0110011: //alu
                    begin
                        case (funct3)
                            3'b000:
                                begin
                                    case (funct7)
                                        7'b0000000: alu_op = alu_op_add; 
                                        7'b0100000: alu_op = alu_op_sub; 
                                        7'b0000001: alu_op = alu_op_mul; 
                                        default: alu_op = 5'b00000;
                                    endcase
                                end
                            3'b001: 
                                begin
                                    case (funct7)
                                        7'b0000000: alu_op = alu_op_sll; 
                                        7'b0000001: alu_op = alu_op_mulh;
                                        7'b0100000: alu_op = alu_op_dsq;
                                        default: alu_op = 5'b00000;
                                    endcase
                                end
                            3'b010: 
                                begin
                                    case (funct7)
                                        7'b0000000: alu_op = alu_op_slt;
                                        7'b0000001: alu_op = alu_op_mulhsu;
                                        default: alu_op = 5'b00000;
                                    endcase
                                end
                            3'b011: 
                                begin
                                    case (funct7)
                                        7'b0000000: alu_op = alu_op_sltu;
                                        7'b0000001: alu_op = alu_op_mulhu;
                                        default: alu_op = 5'b00000;
                                    endcase
                                end
                            3'b100: 
                                begin
                                    case(funct7)
                                        7'b0000000: alu_op = alu_op_xor;
                                        7'b0000001: alu_op = alu_op_div;
                                        default: alu_op = 5'b00000;
                                    endcase
                                end
                            3'b101:
                                begin
                                    case (funct7)
                                        7'b0000000: alu_op = alu_op_srl;
                                        7'b0100000: alu_op = alu_op_sra; 
                                        7'b0000001: alu_op = alu_op_divu;
                                        default: alu_op = 5'b00000;
                                    endcase
                                end
                            3'b110: 
                                begin
                                    case (funct7)
                                        7'b0000000: alu_op = alu_op_or; 
                                        7'b0000001: alu_op = alu_op_rem;
                                        default: alu_op = 5'b00000;
                                    endcase
                                end
                            3'b111: 
                                begin
                                    case (funct7)
                                        7'b0000000: alu_op = alu_op_and;
                                        7'b0000001: alu_op = alu_op_remu;
                                        default: alu_op = 5'b00000;
                                    endcase
                                end
                            default: alu_op = 5'b00000;
                        endcase
                        alu_b_src = 1'b0;
                        reg_write = 1'b1;
                        wb_sel = wb_sel_alu;
                    end
                7'b0001111: //fence
                    begin
                        if (funct3 == 3'b000) fence = 1'b1; 
                        else fence = 1'b0;
                    end
                7'b1110011: //sys
                    begin
                        if (instr[31:20] == 12'b000000000000 && instr[19:7] == 0 && funct3 == 3'b000) sys_op = sys_op_ecall;
                        else if (instr[31:20] == 12'b000000000001 && instr[19:7] == 0 && funct3 == 3'b000) sys_op = sys_op_ebreak;
                        else sys_op = 2'b00;
                    end
                default:
                    begin
                        alu_a_src = 1'b0;
                        alu_b_src = 1'b0;
                        wb_sel = 2'b00;
                        pc_sel = 2'b00;
                        reg_write = 1'b0;
                        mem_read = 1'b0;
                        mem_write = 1'b0;
                        branch = 1'b0;
                        branch_op = 3'b000;
                        load_op = 3'b000;
                        store_op = 2'b00;
                        alu_op = 5'b00000;
                        fence = 1'b0;
                        sys_op = 2'b00;
                        imm = 32'b0;
                        lui_check = 1'b0;
                    end
            endcase
        end
            
endmodule