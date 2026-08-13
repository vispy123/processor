`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] ALU1_in,
    input [31:0] ALU2_in,
    input [1:0] control,
    output reg [31:0] ALU_out,
    output zero
    );
    
    always@*
        begin
            case (control)
                2'b00 : ALU_out = ALU1_in + ALU2_in;
                2'b01 : ALU_out = ALU1_in - ALU2_in;
                2'b10 : ALU_out = ALU1_in | ALU2_in;
                2'b11 : ALU_out = ALU1_in & ALU2_in;
                default: ALU_out = 32'b0;
            endcase
        end
    assign zero = (ALU_out == 32'b0 ? 1'b1 : 1'b0);
    
endmodule
