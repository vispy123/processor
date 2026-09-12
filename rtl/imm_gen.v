`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: imm_gen
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


module imm_gen(
    input [31:0] instr,

    output reg[31:0] imm
    );

    wire [6:0] opcode;
    assign opcode = instr[6:0];

    always@*
        begin
            case(opcode)
                7'b0110111: imm = {instr[31:12], 12'b0}; //lui
                7'b0010111: imm = {instr[31:12], 12'b0}; //auipc
                7'b1101111: imm = {instr[31], instr[20], instr[30:25], instr[24:21], 1'b0}; //jal
                7'b1100111: imm = {instr[31:20], 12'b0}; //jalr
                7'b1100011: imm = {instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; //branch
                7'b0000011: imm = {instr[31:20], instr[11:7]}; //load
                7'b0010011: imm = {instr[31:20], instr[7]}; //alu imm
                default: imm = 32'b0;
            endcase
        end

    
endmodule
