`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: hazard_unit
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


module hazard_unit(
    input EX_MEM1_mem_read,
    input [4:0] EX_MEM1_rd,
    input [4:0] ID_EX_rs1,
    input [4:0] ID_EX_rs2,
    input uses_rs1,
    input uses_rs2,
    input MEM1_MEM2_mem_read,
    input [4:0] MEM1_MEM2_rd,
    output stall
    );
endmodule
