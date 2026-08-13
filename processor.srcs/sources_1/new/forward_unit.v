`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: forward_unit
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


module forward_unit(
    input EX_MEM1_reg_write,
    input [4:0] EX_MEM1_rd,
    input [4:0] ID_EX_rs1,
    input [4:0] ID_EX_rs2,
    input MEM2_WB_reg_write,
    input [4:0] MEM2_WB_rd,
    output [1:0] forward_A,
    output [1:0] forward_B
    );
endmodule
