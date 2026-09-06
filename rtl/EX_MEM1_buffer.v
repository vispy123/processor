`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: EX_MEM1_buffer
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


module EX_MEM1_buffer(
    input PC_src_in,
    input [31:0] branch_target_in,
    input [31:0] ALU_out_in,
    input [31:0] read_data2_in,
    input [4:0] rd_in,
    input [1:0] mem_to_reg_in,
    input reg_write_in,
    input mem_read_in,
    input mem_write_in,
    input [31:0] PC_plus1_in,

    output PC_src_out,
    output [31:0] branch_target_out,
    output [31:0] ALU_out_out,
    output [31:0] read_data2_out,
    output [4:0] rd_out,
    output [1:0] mem_to_reg_out,
    output reg_write_out,
    output mem_read_out,
    output mem_write_out,
    output [31:0] PC_plus1_out,

    input clk,
    input en,
    input reset
    );

    reg PC_src_reg;
    reg [31:0] branch_target_reg;
    reg [31:0] ALU_out_reg;
    reg [31:0] read_data2_reg;
    reg [4:0] rd_reg;
    reg [1:0] mem_to_reg_reg;
    reg reg_write_reg;
    reg mem_read_reg;
    reg mem_write_reg;
    reg [31:0] PC_plus1_reg;

    always@(posedge clk)
        begin
            if (reset)
                begin
                    PC_src_reg <= 1'b0;
                    branch_target_reg <= 32'b0;
                    ALU_out_reg <= 32'b0;
                    read_data2_reg <= 32'b0;
                    rd_reg <= 5'b0;
                    mem_to_reg_reg <= 2'b0;
                    reg_write_reg <= 1'b0;
                    mem_read_reg <= 1'b0;
                    mem_write_reg <= 1'b0;
                    PC_plus1_reg <= 32'b0;
                end
            else if (en)
                begin
                    PC_src_reg <= PC_src_in;
                    branch_target_reg <= branch_target_in;
                    ALU_out_reg <= ALU_out_in;
                    read_data2_reg <= read_data2_in;
                    rd_reg <= rd_in;
                    mem_to_reg_reg <= mem_to_reg_in;
                    reg_write_reg <= reg_write_in;
                    mem_read_reg <= mem_read_in;
                    mem_write_reg <= mem_write_in;
                    PC_plus1_reg <= PC_plus1_in;
                end
        end

    assign PC_src_out = PC_src_reg;
    assign branch_target_out = branch_target_reg;
    assign ALU_out_out = ALU_out_reg;
    assign read_data2_out = read_data2_reg;
    assign rd_out = rd_reg;
    assign mem_to_reg_out = mem_to_reg_reg;
    assign reg_write_out = reg_write_reg;
    assign mem_read_out = mem_read_reg;
    assign mem_write_out = mem_write_reg;
    assign PC_plus1_out = PC_plus1_reg;
    
endmodule
