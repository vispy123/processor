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
    input [31:0] PC_in,
    input [31:0] PC_plus1_in,

    output [31:0] PC_out,
    output [31:0] PC_plus1_out,

    input clk,
    input en,
    input flush,
    input reset
    );

    reg [31:0] PC_reg;
    reg [31:0] PC_plus1_reg;

    always@(posedge clk)
        begin
            if (reset || flush)
                begin
                    PC_reg <= 32'b0;
                    PC_plus1_reg <= 32'b0;
                end
            else if (en)
                begin
                    PC_reg <= PC_in;
                    PC_plus1_reg <= PC_plus1_in;
                end
        end

    assign PC_out = PC_reg;
    assign PC_plus1_out = PC_plus1_reg;
    
endmodule