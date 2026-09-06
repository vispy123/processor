`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2026 12:12:27 PM
// Design Name: 
// Module Name: IF1_IF2_buffer
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


module IF1_IF2_buffer(
    input [31:0] instr_in,
    input [31:0] PC_in,
    input [31:0] PC_plus1_in,

    output [31:0] instr_out,
    output [31:0] PC_out,
    output [31:0] PC_plus1_out

    input clk,
    input en,
    input clear,
    );
    
endmodule