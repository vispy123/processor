`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: processor
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


module processor(
    input clk,
    input reset
    );


    //PC

    reg [31:0] PC, PC_next;
    wire PC_en;
    wire [31:0] PC_in, PC_plus1_in;

    assign PC_en=1'b1;

    always@(posedge clk)
        begin
            if (reset) PC <= 32'b0;
            else PC <= PC_next;
        end
    always@*
        begin
            PC_next = PC;
            if (PC_en) PC_next = PC + 1;
        end
    assign PC_in = PC;
    assign PC_plus1_in = PC_in + 1;


    //IF_ID_buffer

    wire [31:0] PC_out_IF1;
    wire [31:0] PC_plus1_out_IF1;
    wire IF1_IF2_en;
    wire IF1_IF2_flush;

    IF1_IF2_buffer u_IF1_IF2_buffer(
        .PC_in(PC_in),
        .PC_plus1_in(PC_plus1_in),

        .PC_out(PC_out_IF1),
        .PC_plus1_out(PC_plus1_out_IF1),

        .clk(clk),
        .en(IF1_IF2_en),
        .flush(IF1_IF2_flush),
        .reset(reset)
    );


    //instr_mem

    wire we;
    wire en;
    wire [31:0] dout;

    assign we=1'b0;
    assign en=1'b1;

    instr_mem u_instr_mem(
        .addr(PC_out_IF1[9:0]),
        .clk(clk),
        .we(we),
        .en(en),
        .din(32'b0),

        .dout(dout)
    );


    //IF2_ID_buffer

    wire [31:0] instr_out_ID;
    wire [31:0] PC_out_ID;
    wire [31:0] PC_plus1_out_ID;
    wire IF2_ID_en;
    wire IF2_ID_flush;

    IF2_ID_buffer u_IF2_ID_buffer(
        .instr_in(dout),
        .PC_in(PC_out_IF1),
        .PC_plus1_in(PC_plus1_out_IF1),

        .instr_out(instr_out_ID),
        .PC_out(PC_out_ID),
        .PC_plus1_out(PC_plus1_out_ID),

        .clk(clk),
        .en(IF2_ID_en),
        .flush(IF2_ID_flush),
        .reset(reset)
    );


    //decoder


    //reg_file


endmodule
