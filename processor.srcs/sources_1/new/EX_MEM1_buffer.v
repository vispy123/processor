`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: EX_MEM1_buffer
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


module EX_MEM1_buffer(
    input PC_src_in,
    input [31:0] branch_target_in,
    input [31:0] ALU_out_in,
    input [31:0] read_data2_in,
    input [4:0] rd_in,
    input [1:0] mem_to_reg_in,
    input reg_write_in,
    input mem_read_in,
    input mem_write_in,
    input [31:0] PC_plus1_in,
    input clk,
    input en,
    input clear,
    output PC_src_out,
    output [31:0] branch_target_out,
    output [31:0] ALU_out_out,
    output [31:0] read_data2_out,
    output [4:0] rd_out,
    output [1:0] mem_to_reg_out,
    output reg_write_out,
    output mem_read_out,
    output mem_write_out,
    output [0:0] PC_plus1_out
    );
endmodule
