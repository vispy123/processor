`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: reg_file
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


module reg_file(
    input write_enable,
    input [4:0] rd,
    input [0:0] write_data,
    input [4:0] rs1,
    input [4:0] rs2,

    output [31:0] read_data1,
    output [31:0] read_data2,

    input clk,
    input reset
    );
    
endmodule
