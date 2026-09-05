`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: ALU_decoder
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


module ALU_decoder(
    input [6:0] funct7,
    input [2:0] funct3,
    input [1:0] ALU_op,
    output [1:0] control
    );
    
    always@*
        begin
            //if (funct7[4] == 0 && {funct3[1], funct3[0]} == 3'b0 && (ALU_op == 2'b00 || ALU_op == 2'b10))
        end 
    
endmodule
