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
    input [6:0] funct7,
    input [4:0] rs1,
    input [4:0] rs2,
    input [2:0] funct3,
    input [4:0] rd,
    input L,
    input S,
    input B,
    input J,

    output [31:0] imm
    );
    
endmodule
