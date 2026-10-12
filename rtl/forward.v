`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2026 01:39:50 AM
// Design Name: 
// Module Name: forward
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


module forward(
    input [4:0] rd_EX2,
    input [4:0] rd_MEM1,
    input [4:0] rd_MEM2,
    input [4:0] rd_WB,
    
    input [4:0] rs1_EX1,
    input [4:0] rs2_EX1,
    input [4:0] rs1_EX2,
    input [4:0] rs2_EX2,
    input [4:0] rs2_MEM1,

    input reg_write_EX2,
    input reg_write_MEM1,
    input reg_write_MEM2,
    input reg_write_WB,

    input [1:0] available_EX2,
    input [1:0] available_MEM1,
    input [1:0] available_MEM2,
    input [1:0] available_WB,

    output reg [2:0] forward_rs1_EX1,
    output reg [2:0] forward_rs2_EX1,
    output reg [2:0] forward_rs1_EX2,
    output reg [2:0] forward_rs2_EX2,
    output reg [2:0] forward_rs2_MEM1
);

    localparam no_forward=3'b000;
    localparam from_ex2=3'b001;
    localparam from_mem1=3'b010;
    localparam from_mem2=3'b011;
    localparam from_wb=3'b100;

    localparam available_in_EX2 = 2'b00;
    localparam available_in_MEM1 = 2'b01;
    localparam available_in_MEM2 = 2'b10;
    localparam available_in_WB = 2'b11;

    always@*
        begin

            if (available_EX2 <= available_in_EX2 && reg_write_EX2 && rd_EX2 != 5'b0 && rd_EX2 == rs1_EX1) forward_rs1_EX1 = from_ex2;
            else if (available_MEM1 <= available_in_MEM1 && reg_write_MEM1 && rd_MEM1 != 5'b0 && rd_MEM1 == rs1_EX1) forward_rs1_EX1 = from_mem1;
            else if (available_MEM2 <= available_in_MEM2 && reg_write_MEM2 && rd_MEM2 != 5'b0 && rd_MEM2 == rs1_EX1) forward_rs1_EX1 = from_mem2;
            else if (available_WB <= available_in_WB && reg_write_WB && rd_WB != 5'b0 && rd_WB == rs1_EX1) forward_rs1_EX1 = from_wb;
            else forward_rs1_EX1 = no_forward;

            if (available_MEM1 <= available_in_MEM1 && reg_write_MEM1 && rd_MEM1 != 5'b0 && rd_MEM1 == rs1_EX2) forward_rs1_EX2 = from_mem1;
            else if (available_MEM2 <= available_in_MEM2 && reg_write_MEM2 && rd_MEM2 != 5'b0 && rd_MEM2 == rs1_EX2) forward_rs1_EX2 = from_mem2;
            else if (available_WB <= available_in_WB && reg_write_WB && rd_WB != 5'b0 && rd_WB == rs1_EX2) forward_rs1_EX2 = from_wb;
            else forward_rs1_EX2 = no_forward;

            if (available_EX2 <= available_in_EX2 && reg_write_EX2 && rd_EX2 != 5'b0 && rd_EX2 == rs2_EX1) forward_rs2_EX1 = from_ex2;
            else if (available_MEM1 <= available_in_MEM1 && reg_write_MEM1 && rd_MEM1 != 5'b0 && rd_MEM1 == rs2_EX1) forward_rs2_EX1 = from_mem1;
            else if (available_MEM2 <= available_in_MEM2 && reg_write_MEM2 && rd_MEM2 != 5'b0 && rd_MEM2 == rs2_EX1) forward_rs2_EX1 = from_mem2;
            else if (available_WB <= available_in_WB && reg_write_WB && rd_WB != 5'b0 && rd_WB == rs2_EX1) forward_rs2_EX1 = from_wb;
            else forward_rs2_EX1 = no_forward;

            if (available_MEM1 <= available_in_MEM1 && reg_write_MEM1 && rd_MEM1 != 5'b0 && rd_MEM1 == rs2_EX2) forward_rs2_EX2 = from_mem1;
            else if (available_MEM2 <= available_in_MEM2 && reg_write_MEM2 && rd_MEM2 != 5'b0 && rd_MEM2 == rs2_EX2) forward_rs2_EX2 = from_mem2;
            else if (available_WB <= available_in_WB && reg_write_WB && rd_WB != 5'b0 && rd_WB == rs2_EX2) forward_rs2_EX2 = from_wb;
            else forward_rs2_EX2 = no_forward;

            if (available_MEM2 <= available_in_MEM2 && reg_write_MEM2 && rd_MEM2 != 5'b0 && rd_MEM2 == rs2_MEM1) forward_rs2_MEM1 = from_mem2;
            else if (available_WB <= available_in_WB && reg_write_WB && rd_WB != 5'b0 && rd_WB == rs2_MEM1) forward_rs2_MEM1 = from_wb;
            else forward_rs2_MEM1 = no_forward;

        end

endmodule