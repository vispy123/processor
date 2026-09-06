`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: IF2_ID_buffer
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


module IF2_ID_buffer(
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
