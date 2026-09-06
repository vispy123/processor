`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: MEM2_WB_buffer
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


module MEM2_WB_buffer(
    input [31:0] ALU_out_in,
    input [31:0] mem_data_in,
    input [4:0] rd_in,
    input [1:0] mem_to_reg_in,
    input reg_write_in,
    input [31:0] PC_plus1_in,
    
    output [31:0] ALU_out_out,
    output [31:0] mem_data_out,
    output [4:0] rd_out,
    output [1:0] mem_to_reg_out,
    output reg_write_out,
    output [31:0] PC_plus1_out,

    input clk,
    input en,
    input reset
    );

    reg [31:0] ALU_out_reg;
    reg [31:0] mem_data_reg;
    reg [4:0] rd_reg;
    reg [1:0] mem_to_reg_reg;
    reg reg_write_reg;
    reg [31:0] PC_plus1_reg;

    always@(posedge clk)
        begin
            if (reset)
                begin
                    ALU_out_reg <= 32'b0;
                    mem_data_reg <= 32'b0;
                    rd_reg <= 5'b0;
                    mem_to_reg_reg <= 2'b0;
                    reg_write_reg <= 1'b0;
                    PC_plus1_reg <= 32'b0;
                end
            else if (en)
                begin
                    ALU_out_reg <= ALU_out_in;
                    mem_data_reg <= mem_data_in;
                    rd_reg <= rd_in;
                    mem_to_reg_reg <= mem_to_reg_in;
                    reg_write_reg <= reg_write_in;
                    PC_plus1_reg <= PC_plus1_in;
                end
        end
    
    assign ALU_out_out = ALU_out_reg;
    assign mem_data_out = mem_data_reg;
    assign rd_out = rd_reg;
    assign mem_to_reg_out = mem_to_reg_reg;
    assign reg_write_out = reg_write_reg;
    assign PC_plus1_out = PC_plus1_reg;

endmodule
