`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: ID_EX_buffer
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


module ID_EX_buffer(
    input [4:0] rs1_in,
    input [4:0] rs2_in,
    input [31:0] imm_in,
    input [31:0] PC_in,
    input [31:0] read_data1_in,
    input [31:0] read_data2_in,
    input [4:0] rd_in,
    input [6:0] funct7_in,
    input [2:0] funct3_in,
    input ALU_src_in,
    input [1:0] mem_to_reg_in, 
    input reg_write_in, 
    input mem_read_in,
    input mem_write_in, 
    input branch_in, 
    input jump_in, 
    input [1:0] ALU_op_in,
    input [31:0] PC_plus1_in,
    input uses_rs1_in,
    input uses_rs2_in,

    output [4:0] rs1_out,
    output [4:0] rs2_out,
    output [31:0] imm_out,
    output [31:0] PC_out,
    output [31:0] read_data1_out,
    output [31:0] read_data2_out,
    output [4:0] rd_out,
    output [6:0] funct7_out,
    output [2:0] funct3_out,
    output ALU_src_out,
    output [1:0] mem_to_reg_out,
    output reg_write_out,
    output mem_read_out,
    output mem_write_out,
    output branch_out,
    output jump_out,
    output [1:0] ALU_op_out,
    output [31:0] PC_plus1_out,
    output uses_rs1_out,
    output uses_rs2_out,

    input clk,
    input en,
    input flush,
    input reset
    );

    reg [4:0] rs1_reg;
    reg [4:0] rs2_reg;
    reg [31:0] imm_reg;
    reg [31:0] PC_reg;
    reg [31:0] read_data1_reg;
    reg [31:0] read_data2_reg;
    reg [4:0] rd_reg;
    reg [6:0] funct7_reg;
    reg [2:0] funct3_reg;
    reg ALU_src_reg;
    reg [1:0] mem_to_reg_reg;
    reg reg_write_reg;
    reg mem_read_reg;
    reg mem_write_reg;
    reg branch_reg;
    reg jump_reg;
    reg [1:0] ALU_op_reg;
    reg [31:0] PC_plus1_reg;
    reg uses_rs1_reg;
    reg uses_rs2_reg;

    always@(posedge clk)
        begin
            if (reset || flush)
                begin
                    rs1_reg <= 5'b0;
                    rs2_reg <= 5'b0;
                    imm_reg <= 32'b0;
                    PC_reg <= 32'b0;
                    read_data1_reg <= 32'b0;
                    read_data2_reg <= 32'b0;
                    rd_reg <= 5'b0;
                    funct7_reg <= 7'b0;
                    funct3_reg <= 3'b0;
                    ALU_src_reg <= 1'b0;
                    mem_to_reg_reg <= 2'b0;
                    reg_write_reg <= 1'b0;
                    mem_read_reg <= 1'b0;
                    mem_write_reg <= 1'b0;
                    branch_reg <= 1'b0;
                    jump_reg <= 1'b0;
                    ALU_op_reg <= 2'b0;
                    PC_plus1_reg <= 32'b0;
                    uses_rs1_reg <= 1'b0;
                    uses_rs2_reg <= 1'b0;
                end
            else if (en)
                begin
                    rs1_reg <= rs1_in;
                    rs2_reg <= rs2_in;
                    imm_reg <= imm_in;
                    PC_reg <= PC_in;
                    read_data1_reg <= read_data1_in;
                    read_data2_reg <= read_data2_in;
                    rd_reg <= rd_in;
                    funct7_reg <= funct7_in;
                    funct3_reg <= funct3_in;
                    ALU_src_reg <= ALU_src_in;
                    mem_to_reg_reg <= mem_to_reg_in;
                    reg_write_reg <= reg_write_in;
                    mem_read_reg <= mem_read_in;
                    mem_write_reg <= mem_write_in;
                    branch_reg <= branch_in;
                    jump_reg <= jump_in;
                    ALU_op_reg <= ALU_op_in;
                    PC_plus1_reg <= PC_plus1_in;
                    uses_rs1_reg <= uses_rs1_in;
                    uses_rs2_reg <= uses_rs2_in;
                end
        end

    assign rs1_out = rs1_reg;
    assign rs2_out = rs2_reg;
    assign imm_out = imm_reg;
    assign PC_out = PC_reg;
    assign read_data1_out = read_data1_reg;
    assign read_data2_out = read_data2_reg;
    assign rd_out = rd_reg;
    assign funct7_out = funct7_reg;
    assign funct3_out = funct3_reg;
    assign ALU_src_out = ALU_src_reg;
    assign mem_to_reg_out = mem_to_reg_reg;
    assign reg_write_out = reg_write_reg;
    assign mem_read_out = mem_read_reg;
    assign mem_write_out = mem_write_reg;
    assign branch_out = branch_reg;
    assign jump_out = jump_reg;
    assign ALU_op_out = ALU_op_reg;
    assign PC_plus1_out = PC_plus1_reg;
    assign uses_rs1_out = uses_rs1_reg;
    assign uses_rs2_out = uses_rs2_reg;

endmodule
