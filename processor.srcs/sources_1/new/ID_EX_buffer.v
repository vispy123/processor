`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: ID_EX_buffer
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


module ID_EX_buffer(
    input [4:0] rs1_in,
    input [4:0] rs2_in,
    input [31:0] imm_in,
    input [31:0] PC_in,
    input [31:0] read_data1_in,
    input [31:0] read_data2_in,
    input [4:0] rd_in,
    input [6:0] funct7_in,
    input [2:0] funct3_in,
    input ALU_src_in,
    input [1:0] mem_to_reg_in,
    input reg_write_in,
    input mem_read_in,
    input mem_write_in,
    input branch_in,
    input jump_in,
    input [1:0] ALU_op_in,
    input [31:0] PC_plus1_in,
    input uses_rs1_in,
    input uses_rs2_in,

    output [4:0] rs1_out,
    output [4:0] rs2_out,
    output [31:0] imm_out,
    output [31:0] PC_out,
    output [31:0] read_data1_out,
    output [31:0] read_data2_out,
    output [4:0] rd_out,
    output [6:0] funct7_out,
    output [2:0] funct3_out,
    output ALU_src_out,
    output [1:0] mem_to_reg_out,
    output reg_write_out,
    output mem_read_out,
    output mem_write_out,
    output branch_out,
    output jump_out,
    output [1:0] ALU_op_out,
    output [31:0] PC_plus1_out,
    output uses_rs1_out,
    output uses_rs2_out

    input clk,
    input en,
    input clear,
    );
    
endmodule
