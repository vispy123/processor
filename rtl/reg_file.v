`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: reg_file
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


module reg_file(
    input write_enable,
    input [4:0] rd,
    input [31:0] write_data,
    input [4:0] rs1,
    input [4:0] rs2,

    output [31:0] read_data1,
    output [31:0] read_data2,

    input clk,
    input reset
    );

    reg [31:0]rf[31:0];
    integer i;

    always@(posedge clk) 
        if (reset)
            for (i = 0; i < 32; i = i + 1)
                rf[i] <= 32'b0;
        else if (write_enable && rd != 0)
            rf[rd] <= write_data;

    assign read_data1 = (rs1 == 0) ? 32'b0 : (write_enable && (rd == rs1)) ? write_data : rf[rs1];
    assign read_data2 = (rs2 == 0) ? 32'b0 : (write_enable && (rd == rs2)) ? write_data : rf[rs2];


endmodule
