`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: main_decoder
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
    
    output reg ALU_src, //imm or reg
    output reg [2:0] wb_sel, //0alu, 1load, 2pc_plus1(jal/jalr), 3lui, 4auipc
    output reg [1:0] pc_sel, //0pc_plus1, 1imm(jal/branch), 2reg(jalr)
    output reg reg_write, 
    output reg mem_read,
    output reg mem_write,
    output reg branch,
    output reg [2:0] branch_op, //0beq, 1bne, 2blt, 3bge, 4bltu, 5bgeu
    output reg [2:0] load_op, //0lb, 1lh, 2lw, 3lbu, 4lhu
    output reg [1:0] store_op, //0sb, 1sh, 2sw
    output reg [3:0] ALU_op, //0add, 1sub, 2sll, 3slt, 4sltu, 5xor, 6srl, 7sra, 8or, 9and
    output reg fence,
    output reg [1:0] sys_op //ecall, ebreak
    );
    
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];

    always@*
        begin
            ALU_src = 1'b0;
            wb_sel = 3'b000;
            pc_sel = 2'b00;
            reg_write = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            branch = 1'b0;
            branch_op = 3'b000;
            load_op = 3'b000;
            store_op = 2'b00;
            ALU_op = 4'b0000;
            fence = 1'b0;
            sys_op = 2'b00;
            case(opcode)
                7'b0110111: //lui
                    begin
                        reg_write = 1'b1;
                        wb_sel = 3'b011; //lui
                    end
                7'b0010111: //auipc
                    begin
                        reg_write= 1'b1;
                        wb_sel = 3'b100; //auipc
                        ALU_op = 4'b0000; //add
                    end
                7'b1101111: //jal
                    begin
                        pc_sel = 2'b01;
                        reg_write = 1'b1;
                        wb_sel = 3'b010; //pc_plus1
                    end
                7'b1100111: //jalr
                    begin
                        ALU_src = 1'b1;
                        wb_sel = 3'b010; //pc_plus1
                        pc_sel = 2'b10;
                        reg_write = 1'b1;
                        ALU_op = 4'b0000; //add
                    end
                7'b1100011: //branch
                    begin
                        ALU_src = 1'b0;
                        branch = 1'b1;
                        case (funct3)
                            3'b000: branch_op = 3'b000; //beq
                            3'b001: branch_op = 3'b001; //bne
                            3'b100: branch_op = 3'b010; //blt
                            3'b101: branch_op = 3'b011; //bge
                            3'b110: branch_op = 3'b100; //bltu
                            3'b111: branch_op = 3'b101; //bgeu
                            default: branch_op = 3'b000;
                        endcase
                    end
                7'b0000011: //load
                    begin
                        ALU_src = 1'b1;
                        mem_read = 1'b1;
                        reg_write = 1'b1;
                        ALU_op = 4'b0000; //add
                        wb_sel = 3'b001; //load
                        case (funct3)
                            3'b000: load_op = 3'b000; //lb
                            3'b001: load_op = 3'b001; //lh
                            3'b010: load_op = 3'b010; //lw
                            3'b100: load_op = 3'b011; //lbu
                            3'b101: load_op = 3'b100; //lhu
                            default: load_op = 3'b000; 
                        endcase
                    end
                7'b0100011: //store
                    begin
                        ALU_src = 1'b1;
                        mem_write = 1'b1;
                        ALU_op = 4'b0000; //add
                        case (funct3)
                            3'b000: store_op = 2'b00; //sb
                            3'b001: store_op = 2'b01; //sh
                            3'b010: store_op = 2'b10; //sw
                            default: store_op = 2'b00;
                        endcase
                    end
                7'b0010011: //alu imm
                    begin
                        ALU_src = 1'b1;
                        reg_write = 1'b1;
                        wb_sel = 3'b000; //alu
                        case (funct3)
                            3'b000: ALU_op = 4'b0000; //addi
                            3'b010: ALU_op = 4'b0011; //slti
                            3'b011: ALU_op = 4'b0100; //sltiu
                            3'b100: ALU_op = 4'b0101; //xori
                            3'b110: ALU_op = 4'b1000; //ori
                            3'b111: ALU_op = 4'b1001; //andi
                            3'b001: ALU_op = 4'b0010; //slli
                            3'b101:
                                begin
                                    case (instr[31:26])
                                        6'b000000: ALU_op = 4'b0110; //srli
                                        6'b010000: ALU_op = 4'b0111; //srai
                                        default: ALU_op = 4'b0000;
                                    endcase
                                end
                            default: ALU_op = 4'b0000;
                        endcase
                    end
                7'b0110011: //alu
                    begin
                        ALU_src = 1'b0;
                        reg_write = 1'b1;
                        wb_sel = 3'b000; //alu
                        case (funct3)
                            3'b000:
                                begin
                                    case (funct7)
                                        7'b0000000: ALU_op = 4'b0000; //add
                                        7'b0100000: ALU_op = 4'b0001; //sub
                                        default: ALU_op = 4'b0000;
                                    endcase
                                end
                            3'b001: ALU_op = 4'b0010; //sll
                            3'b010: ALU_op = 4'b0011; //slt
                            3'b011: ALU_op = 4'b0100; //sltu
                            3'b100: ALU_op = 4'b0101; //xor
                            3'b101:
                                begin
                                    case (funct7)
                                        7'b0000000: ALU_op = 4'b0110; //srl
                                        7'b0100000: ALU_op = 4'b0111; //sra
                                        default: ALU_op = 4'b0000;
                                    endcase
                                end
                            3'b110: ALU_op = 4'b1000; //or
                            3'b111: ALU_op = 4'b1001; //and
                            default: ALU_op = 4'b0000;
                        endcase
                    end
                7'b0001111: //fence
                    begin
                        if (funct3 == 3'b000) fence = 1'b1; 
                        else fence = 1'b0;
                    end
                7'b1110011: //sys
                    begin
                        if (instr[31:20] == 12'b000000000000 && instr[19:7] == 0 && funct3 == 3'b00) //ecall
                            sys_op = 2'b01;
                        else if (instr[31:20] == 12'b000000000001 && instr[19:7] == 0 && funct3 == 3'b00) //ebreak
                            sys_op = 2'b10;
                        else sys_op = 2'b00;
                    end
                default:
                    begin
                        ALU_src = 1'b0;
                        wb_sel = 3'b000;
                        pc_sel = 2'b00;
                        reg_write = 1'b0;
                        mem_read = 1'b0;
                        mem_write = 1'b0;
                        branch = 1'b0;
                        branch_op = 3'b000;
                        load_op = 3'b000;
                        store_op = 2'b00;
                        ALU_op = 4'b0000;
                        fence = 1'b0;
                        sys_op = 2'b00;
                    end
            endcase
        end
            
endmodule