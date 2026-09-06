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


module main_decoder(
    input [6:0] opcode,
    
    output ALU_src,
    output [1:0] mem_to_reg,
    output reg_write,
    output mem_read,
    output mem_write,
    output branch,
    output jump,
    output [1:0] ALU_op,
    output R,
    output L,
    output S,
    output B,
    output J
    );
    
    always@*
        begin
        end
            
    
endmodule
