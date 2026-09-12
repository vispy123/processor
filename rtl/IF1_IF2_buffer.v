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
    input [31:0] pc_in,
    input [31:0] pc_plus4_in,

    output [31:0] pc_out,
    output [31:0] pc_plus4_out,

    input clk,
    input en,
    input flush,
    input reset
    );

    reg [31:0] pc_reg;
    reg [31:0] pc_plus4_reg;

    always@(posedge clk)
        begin
            if (reset || flush)
                begin
                    pc_reg <= 32'b0;
                    pc_plus4_reg <= 32'b0;
                end
            else if (en)
                begin
                    pc_reg <= pc_in;
                    pc_plus4_reg <= pc_plus4_in;
                end
        end

    assign pc_out = pc_reg;
    assign pc_plus4_out = pc_plus4_reg;
    
endmodule