`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: MEM2_WB_buffer
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


module MEM2_WB_buffer(
    input [31:0] ALU_out_in,
    input [31:0] mem_data_in,
    input [4:0] rd_in,
    input [1:0] mem_to_reg_in,
    input reg_write_in,
    input [31:0] PC_plus1_in,
    output [31:0] ALU_out_out,
    output [31:0] mem_data_out,
    output [4:0] rd_out,
    output [1:0] mem_to_reg_out,
    output reg_write_out,
    output [31:0] PC_plus1_out,
    input clk,
    input clear
    );
endmodule
