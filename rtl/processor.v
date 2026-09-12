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


    //pc

    reg [31:0] pc;
    reg [31:0] pc_next;
    wire [31:0] pc_in;
    wire [31:0] pc_plus4_in;
    wire pc_en;

    assign pc_en = 1'b1;

    always@(posedge clk)
        begin
            if (reset) pc <= 32'b0;
            else pc <= pc_next;
        end
    always@*
        begin
            pc_next = pc;
            if (pc_en) pc_next = pc + 4;
        end
    assign pc_in = pc;
    assign pc_plus4_in = pc_in + 4;


    //IF1_IF2_buffer

    wire [31:0] pc_out_IF1;
    wire [31:0] pc_plus4_out_IF1;
    wire IF1_IF2_en;
    wire IF1_IF2_flush;

    IF1_IF2_buffer u_IF1_IF2_buffer(
        .pc_in(pc_in),
        .pc_plus4_in(pc_plus4_in),

        .pc_out(pc_out_IF1),
        .pc_plus4_out(pc_plus4_out_IF1),

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
        .addr(pc__IF1[9:0]),
        .clk(clk),
        .we(we),
        .en(en),
        .din(32'b0),

        .dout(dout)
    );


    //IF2_ID_buffer

    wire [31:0] instr_out_ID;
    wire [31:0] pc_out_ID;
    wire [31:0] pc_plus4_out_ID;
    wire IF2_ID_en;
    wire IF2_ID_flush;

    IF2_ID_buffer u_IF2_ID_buffer(
        .instr_in(dout),
        .pc_in(pc_out_IF1),
        .pc_plus4_in(pc_plus4_out_IF1),

        .instr_out(instr_out_ID),
        .pc_out(pc_out_ID),
        .pc_plus4_out(pc_plus4_out_ID),

        .clk(clk),
        .en(IF2_ID_en),
        .flush(IF2_ID_flush),
        .reset(reset)
    );


    //decoder

    wire alu_src_id_ID;
    wire [2:0] wb_sel_ID;
    wire [1:0] pc_sel_ID; 
    wire reg_write_ID; 
    wire mem_read_ID;
    wire mem_write_ID;
    wire branch_ID;
    wire [2:0] branch_op_ID; 
    wire [2:0] load_op_ID;
    wire [1:0] store_op_ID; 
    wire [4:0] alu_op_ID; 
    wire fence_ID;
    wire [1:0] sys_op_ID;

    decoder u_decoder(
        .instr(instr_out_ID)

        .alu_src(alu_src_ID),
        .wb_sel(wb_sel_ID),
        .pc_sel(pc_sel_ID),
        .reg_write(reg_write_ID),
        .mem_read(mem_read_ID),
        .mem_write(mem_write_ID),
        .branch(branch_ID),
        .branch_op(branch_op_ID),
        .load_op(load_op_ID),
        .store_op(store_op_ID),
        .alu_op(alu_op_ID),
        .fence(fence_ID),
        .sys_op(sys_op_ID)
    );


    //reg_file

    wire [31:0] rs1_out, rs2_out, wb_data;

    reg_file u_reg_file(
        .clk(clk),
        .reset(reset),

        .write_enable(reg_write_ID),
        .rd(instr_out_ID[11:7]),
        .write_data(wb_data),

        .rs1(instr_out_ID[19:15]),
        .rs2(instr_out_ID[24:20]),

        .read_data1(rs1_out),
        .read_data2(rs2_out)
    )




endmodule