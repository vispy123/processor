`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2026 11:49:54 PM
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
    input [4:0] rd_in,
    input [31:0] alu_out_in,
    input [1:0] wb_sel_in,
    input reg_write_in,
    input fence_in,
    input [1:0] sys_op_in,
    input [31:0] pc_plus4_in,
    input [31:0] data_in,

    output [4:0] rd_out,
    output [31:0] alu_out_out,
    output [1:0] wb_sel_out,
    output reg_write_out,
    output fence_out,
    output [1:0] sys_op_out,
    output [31:0] pc_plus4_out,
    output [31:0] data_out,

    input clk,
    input flush,
    input en,
    input reset
    );

    reg [4:0] rd_reg;
    reg [31:0] alu_out_reg;
    reg [1:0] wb_sel_reg;
    reg reg_write_reg;
    reg fence_reg;
    reg [1:0] sys_op_reg;
    reg [31:0] pc_plus4_reg; 
    reg [31:0] data_reg;

    always@(posedge clk)
        begin
            if (reset || flush)
                begin
                    rd_reg <= 5'b0;
                    alu_out_reg <= 32'b0;
                    wb_sel_reg <= 2'b0;
                    reg_write_reg <= 1'b0;
                    fence_reg <= 1'b0;
                    sys_op_reg <= 2'b0;
                    pc_plus4_reg <= 32'b0;
                    data_reg <= 32'b0;
                end
            else if (en)
                begin
                    rd_reg <= rd_in;
                    alu_out_reg <= alu_out_in;
                    wb_sel_reg <= wb_sel_in;
                    reg_write_reg <= reg_write_in;
                    fence_reg <= fence_in;
                    sys_op_reg <= sys_op_in;
                    pc_plus4_reg <= pc_plus4_in;
                    data_reg <= data_in;
                end
        end

    assign rd_out = rd_reg;
    assign alu_out_out = alu_out_reg;
    assign wb_sel_out = wb_sel_reg;
    assign reg_write_out = reg_write_reg;
    assign fence_out = fence_reg;
    assign sys_op_out = sys_op_reg;
    assign pc_plus4_out = pc_plus4_reg; 
    assign data_out = data_reg;
    
endmodule