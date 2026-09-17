`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2026 09:36:17 PM
// Design Name: 
// Module Name: data_mem
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

//`define FPGA

module data_mem(
    input [9:0] addr, 
    input clk, 
    input en, 
    input [3:0] we,
    input [31:0] din, 
    
    output reg [31:0] dout
    );
    
    `ifdef FPGA

    blk_mem_gen_1 bram (
        .clka(clk),    // input wire clka
        .ena(en),      // input wire ena
        .wea(we),      // input wire [3 : 0] wea
        .addra(addr),  // input wire [9 : 0] addra
        .dina(din),    // input wire [31 : 0] dina
        .douta(dout)   // output wire [31 : 0] douta
    );

    `else

    reg [31:0] mem [0:1023];

    always @(posedge clk)
        begin
            if (en) 
                begin
                    if (we == 4'b0000) dout <= mem[addr];
                    else
                        begin
                            if (we[0]) mem[addr][7:0]   <= din[7:0];
                            if (we[1]) mem[addr][15:8]  <= din[15:8];
                            if (we[2]) mem[addr][23:16] <= din[23:16];
                            if (we[3]) mem[addr][31:24] <= din[31:24];
                        end
                end
        end
    
    `endif

endmodule