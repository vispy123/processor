`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: EX2_MEM1_buffer
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


module EX2_MEM1_buffer(
    input [4:0] rd_in,
    input [31:0] rs2_data_in,
    input [31:0] alu_out_in,
    input [1:0] wb_sel_in,
    input [1:0] pc_sel_in,
    input reg_write_in,
    input mem_read_in,
    input mem_write_in,
    input branch_in,
    input [2:0] branch_op_in,
    input [2:0] load_op_in,
    input [1:0] store_op_in,
    input fence_in,
    input [1:0] sys_op_in,
    input [31:0] pc_in,
    input [31:0] pc_plus4_in,

    output [4:0] rd_out,
    output [31:0] rs2_data_out,
    output [31:0] alu_out_out,
    output [1:0] wb_sel_out,
    output [1:0] pc_sel_out,
    output reg_write_out,
    output mem_read_out,
    output mem_write_out,
    output branch_out,
    output [2:0] branch_op_out,
    output [2:0] load_op_out,
    output [1:0] store_op_out,
    output fence_out,
    output [1:0] sys_op_out,
    output [31:0] pc_out,
    output [31:0] pc_plus4_out,

    input clk,
    input flush,
    input en,
    input reset
    );

    reg [4:0] rd_reg;
    reg [31:0] rs2_data_reg;
    reg [31:0] alu_out_reg;
    reg [1:0] wb_sel_reg;
    reg [1:0] pc_sel_reg;
    reg reg_write_reg;
    reg mem_read_reg;
    reg mem_write_reg;
    reg branch_reg;
    reg [2:0] branch_op_reg;
    reg [2:0] load_op_reg;
    reg [1:0] store_op_reg;
    reg fence_reg;
    reg [1:0] sys_op_reg;
    reg [31:0] pc_reg;
    reg [31:0] pc_plus4_reg; 

    always@(posedge clk)
        begin
            if (reset || flush)
                begin
                    rd_reg <= 5'b0;
                    rs2_data_reg <= 32'b0;
                    alu_out_reg <= 32'b0;
                    wb_sel_reg <= 2'b0;
                    pc_sel_reg <= 2'b0;
                    reg_write_reg <= 1'b0;
                    mem_read_reg <= 1'b0;
                    mem_write_reg <= 1'b0;
                    branch_reg <= 1'b0;
                    branch_op_reg <= 3'b0;
                    load_op_reg <= 3'b0;
                    store_op_reg <= 2'b0;
                    fence_reg <= 1'b0;
                    sys_op_reg <= 2'b0;
                    pc_reg <= 32'b0;
                    pc_plus4_reg <= 32'b0;
                end
            else if (en)
                begin
                    rd_reg <= rd_in;
                    rs2_data_reg <= rs2_data_in;
                    alu_out_reg <= alu_out_in;
                    wb_sel_reg <= wb_sel_in;
                    pc_sel_reg <= pc_sel_in;
                    reg_write_reg <= reg_write_in;
                    mem_read_reg <= mem_read_in;
                    mem_write_reg <= mem_write_in;
                    branch_reg <= branch_in;
                    branch_op_reg <= branch_op_in;
                    load_op_reg <= load_op_in;
                    store_op_reg <= store_op_in;
                    fence_reg <= fence_in;
                    sys_op_reg <= sys_op_in;
                    pc_reg <= pc_in;
                    pc_plus4_reg <= pc_plus4_in;
                end
        end

    assign rd_out = rd_reg;
    assign rs2_data_out = rs2_data_reg;
    assign alu_out_out = alu_out_reg;
    assign wb_sel_out = wb_sel_reg;
    assign pc_sel_out = pc_sel_reg;
    assign reg_write_out = reg_write_reg;
    assign mem_read_out = mem_read_reg;
    assign mem_write_out = mem_write_reg;
    assign branch_out = branch_reg;
    assign branch_op_out = branch_op_reg;
    assign load_op_out = load_op_reg;
    assign store_op_out = store_op_reg;
    assign fence_out = fence_reg;
    assign sys_op_out = sys_op_reg;
    assign pc_out = pc_reg;
    assign pc_plus4_out = pc_plus4_reg; 
    
endmodule
