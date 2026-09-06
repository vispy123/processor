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
    output [31:0] PC_plus1_out,

    input clk,
    input en,
    input flush,
    input reset
    );

    reg [31:0] instr_reg;
    reg [31:0] PC_reg;
    reg [31:0] PC_plus1_reg;

    always@(posedge clk)
        begin
            if (reset || flush)
                begin
                    instr_reg <= 32'b0;
                    PC_reg <= 32'b0;
                    PC_plus1_reg <= 32'b0;
                end
            else if (en)
                begin
                    instr_reg <= instr_in;
                    PC_reg <= PC_in;
                    PC_plus1_reg <= PC_plus1_in;
                end
        end

    assign instr_out = instr_reg;
    assign PC_out = PC_reg;
    assign PC_plus1_out = PC_plus1_reg;
    
endmodule
