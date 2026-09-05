`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2026 12:26:17 AM
// Design Name: 
// Module Name: instr_mem
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


module instr_mem(
    input [9:0] addr, 
    input clk, en, we,
    input [31:0] din, 
    output [31:0] dout
    );
    
    blk_mem_gen_0 bram (
        .clka(clk),    // input wire clka
        .ena(en),      // input wire ena
        .wea(we),      // input wire [0 : 0] wea
        .addra(addr),  // input wire [9 : 0] addra
        .dina(din),    // input wire [31 : 0] dina
        .douta(dout)   // output wire [31 : 0] douta
    );

endmodule
