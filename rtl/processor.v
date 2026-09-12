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
    wire [31:0] pc_IF1;
    wire [31:0] pc_plus4_IF1;
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
    assign pc_IF1 = pc;
    assign pc_plus4_IF1 = pc + 4;


    //IF1_IF2_buffer

    wire [31:0] pc_IF2;
    wire [31:0] pc_plus4_IF2;
    wire IF1_IF2_en;
    wire IF1_IF2_flush;

    IF1_IF2_buffer u_IF1_IF2_buffer(
        .pc_in(pc_IF1),
        .pc_plus4_in(pc_plus4_IF1),

        .pc_out(pc_IF2),
        .pc_plus4_out(pc_plus4_IF2),

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
        .addr(pc_IF1[9:0]),
        .clk(clk),
        .we(we),
        .en(en),
        .din(32'b0),

        .dout(dout)
    );


    //IF2_ID_buffer

    wire [31:0] instr_ID;
    wire [31:0] pc_ID;
    wire [31:0] pc_plus4_ID;
    wire IF2_ID_en;
    wire IF2_ID_flush;

    IF2_ID_buffer u_IF2_ID_buffer(
        .instr_in(dout),
        .pc_in(pc_IF2),
        .pc_plus4_in(pc_plus4_IF2),

        .instr_out(instr_ID),
        .pc_out(pc_ID),
        .pc_plus4_out(pc_plus4_ID),

        .clk(clk),
        .en(IF2_ID_en),
        .flush(IF2_ID_flush),
        .reset(reset)
    );


    //decoder

    wire alu_a_src_ID;
    wire alu_b_src_ID;
    wire [1:0] wb_sel_ID;
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
    wire [31:0] imm_ID;

    decoder u_decoder(
        .instr(instr_ID),

        .alu_a_src(alu_a_src_ID),
        .alu_b_src(alu_b_src_ID),
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
        .sys_op(sys_op_ID),
        .imm(imm_ID)
    );


    //reg_file

    wire [31:0] rs1_data_ID;
    wire [31:0] rs2_data_ID;
    wire [4:0] rs1_ID;
    wire [4:0] rs2_ID;
    wire [4:0] rd_ID;

    wire reg_write_WB;
    wire [4:0] rd_WB;
    wire [31:0] write_data_WB;

    assign rs1_ID = instr_ID[19:15];
    assign rs2_ID = instr_ID[24:20];
    assign rd_ID = instr_ID[11:7];

    reg_file u_reg_file(
        .write_enable(reg_write_WB), 
        .rd(rd_WB), 
        .write_data(write_data_WB), 
        .rs1(rs1_ID),
        .rs2(rs2_ID),

        .read_data1(rs1_data_ID),
        .read_data2(rs2_data_ID),

        .clk(clk),
        .reset(reset)
    );


    //ID_EX1_buffer
    wire [4:0] rs1_EX1;
    wire [4:0] rs2_EX1;
    wire [4:0] rd_EX1;
    wire [31:0] rs1_data_EX1;
    wire [31:0] rs2_data_EX1;
    wire alu_a_src_EX1;
    wire alu_b_src_EX1;
    wire [1:0] wb_sel_EX1;
    wire [1:0] pc_sel_EX1; 
    wire reg_write_EX1; 
    wire mem_read_EX1;
    wire mem_write_EX1;
    wire branch_EX1;
    wire [2:0] branch_op_EX1; 
    wire [2:0] load_op_EX1;
    wire [1:0] store_op_EX1; 
    wire [4:0] alu_op_EX1; 
    wire fence_EX1;
    wire [1:0] sys_op_EX1;
    wire [31:0] imm_EX1;
    wire [31:0] pc_EX1;
    wire [31:0] pc_plus4_EX1;
    wire ID_EX1_en;
    wire ID_EX1_flush;

    ID_EX1_buffer u_ID_EX1_buffer(
        .rs1_in(rs1_ID),
        .rs2_in(rs2_ID),
        .rd_in(rd_ID),
        .rs1_data_in(rs1_data_ID),
        .rs2_data_in(rs2_data_ID),
        .alu_a_src_in(alu_a_src_ID),
        .alu_b_src_in(alu_b_src_ID),
        .wb_sel_in(wb_sel_ID),
        .pc_sel_in(pc_sel_ID),
        .reg_write_in(reg_write_ID),
        .mem_read_in(mem_read_ID),
        .mem_write_in(mem_write_ID),
        .branch_in(branch_ID),
        .branch_op_in(branch_op_ID),
        .load_op_in(load_op_ID),
        .store_op_in(store_op_ID),
        .alu_op_in(alu_op_ID),
        .fence_in(fence_ID),
        .sys_op_in(sys_op_ID),
        .imm_in(imm_ID),
        .pc_in(pc_ID),
        .pc_plus4_in(pc_plus4_ID),

        .rs1_out(rs1_EX1),
        .rs2_out(rs2_EX1),
        .rd_out(rd_EX1),
        .rs1_data_out(rs1_data_EX1),
        .rs2_data_out(rs2_data_EX1),
        .alu_a_src_out(alu_a_src_EX1),
        .alu_b_src_out(alu_b_src_EX1),
        .wb_sel_out(wb_sel_EX1),
        .pc_sel_out(pc_sel_EX1),
        .reg_write_out(reg_write_EX1),
        .mem_read_out(mem_read_EX1),
        .mem_write_out(mem_write_EX1),
        .branch_out(branch_EX1),
        .branch_op_out(branch_op_EX1),
        .load_op_out(load_op_EX1),
        .store_op_out(store_op_EX1),
        .alu_op_out(alu_op_EX1),
        .fence_out(fence_EX1),
        .sys_op_out(sys_op_EX1),
        .imm_out(imm_EX1),
        .pc_out(pc_EX1),
        .pc_plus4_out(pc_plus4_EX1),

        .clk(clk),
        .en(ID_EX1_en),
        .flush(ID_EX1_flush),
        .reset(reset)
    );

endmodule