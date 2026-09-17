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

    wire branch_taken_EX1;
    reg [31:0] branch_target_EX1;

    wire pc_en;
    assign pc_en = 1'b1;

    always@(posedge clk)
        begin
            if (reset) pc <= 32'b0;
            else if (pc_en) pc <= pc_next;
        end
    assign pc_next = branch_taken_EX1 ? branch_target_EX1 : pc_plus4_IF1;
    assign pc_IF1 = pc;
    assign pc_plus4_IF1 = pc + 4;


    //drive later
    wire IF1_IF2_en;
    wire IF2_ID_en;
    wire ID_EX1_en;
    wire EX1_EX2_en;
    wire EX2_MEM1_en;
    wire MEM1_MEM2_en;
    wire MEM2_WB_en;

    wire IF1_IF2_flush; //for branch
    wire IF2_ID_flush; //for branch
    wire ID_EX1_flush; //for branch
    wire EX1_EX2_flush; //hazard, drive later
    wire EX2_MEM1_flush; //hazard, drive later
    wire MEM1_MEM2_flush; //hazard, drive later
    wire MEM2_WB_flush; //hazard, drive later

    assign IF1_IF2_flush = branch_taken_EX1;
    assign IF2_ID_flush = branch_taken_EX1;
    assign ID_EX1_flush = branch_taken_EX1;


    //IF1_IF2_buffer

    wire [31:0] pc_IF2;
    wire [31:0] pc_plus4_IF2;

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

    wire we_instr;
    wire en_instr;
    wire [31:0] dout_instr;

    assign we_instr=1'b0;
    assign en_instr=1'b1;

    instr_mem u_instr_mem(
        .addr(pc_IF1[11:2]),
        .clk(clk),
        .we(we_instr),
        .en(en_instr),
        .din(32'b0),

        .dout(dout_instr)
    );


    //IF2_ID_buffer

    wire [31:0] instr_ID;
    wire [31:0] pc_ID;
    wire [31:0] pc_plus4_ID;

    IF2_ID_buffer u_IF2_ID_buffer(
        .instr_in(dout_instr),
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
    wire pc_sel_ID; 
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
    wire lui_check_ID;

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
        .imm(imm_ID),
        .lui_check(lui_check_ID)
    );


    //reg_file

    wire [31:0] rs1_data_ID;
    wire [31:0] rs2_data_ID;
    wire [4:0] rs1_ID;
    wire [4:0] rs2_ID;
    wire [4:0] rd_ID;

    wire reg_write_WB;
    wire [4:0] rd_WB;
    reg [31:0] write_data_WB;

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
    wire [4:0] rs1_intermediate_EX1;
    wire [4:0] rs2_EX1;
    wire [4:0] rd_EX1;
    wire [31:0] rs1_data_EX1;
    wire [31:0] rs2_data_EX1;
    wire alu_a_src_EX1;
    wire alu_b_src_EX1;
    wire [1:0] wb_sel_EX1;
    wire pc_sel_EX1; 
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
    wire lui_check_EX1;

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
        .lui_check_in(lui_check_ID),

        .rs1_out(rs1_intermediate_EX1),
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
        .lui_check_out(lui_check_EX1),

        .clk(clk),
        .en(ID_EX1_en),
        .flush(ID_EX1_flush),
        .reset(reset)
    );


    //branch_taken 

    branch_taken u_branch_taken(
        .branch(branch_EX1),
        .branch_op(branch_op_EX1),
        .wb_sel_pc_plus4(wb_sel_EX1[1]),
        .alu_a(rs1_data_EX1),
        .alu_b(rs2_data_EX1),
        
        .branch_taken(branch_taken_EX1)
    );

    wire [31:0] alu_a_intermediate_EX1;
    wire [31:0] alu_a_EX1;
    wire [31:0] alu_b_EX1;

    assign alu_a_intermediate_EX1 = (alu_a_src_EX1 == 1'b1)? pc_EX1 : rs1_data_EX1;
    assign alu_b_EX1 = (alu_b_src_EX1 == 1'b1)? imm_EX1 : rs2_data_EX1;
    assign alu_a_EX1 = (lui_check_EX1 == 1'b1)? 32'b0 : alu_a_intermediate_EX1;
    assign rs1_EX1 = (lui_check_EX1 == 1'b1)? 5'b0 : rs1_intermediate_EX1;

    //branch_target

    always @*
        begin
            if (branch_taken_EX1 == 1'b1) 
                begin
                    branch_target_EX1 = alu_a_EX1 + alu_b_EX1;
                    if (pc_sel_EX1 == 1'b1) branch_target_EX1[0] = 1'b0; 
                end
            else branch_target_EX1 = 32'b0;
        end


    //EX1_EX2_buffer

    wire [4:0] rs1_EX2;
    wire [4:0] rs2_EX2;
    wire [4:0] rd_EX2;
    wire [31:0] rs2_data_EX2; //for stores
    wire [31:0] alu_a_EX2;
    wire [31:0] alu_b_EX2;
    wire [1:0] wb_sel_EX2;
    wire reg_write_EX2; 
    wire mem_read_EX2;
    wire mem_write_EX2;
    wire [2:0] load_op_EX2;
    wire [1:0] store_op_EX2; 
    wire [4:0] alu_op_EX2; 
    wire fence_EX2;
    wire [1:0] sys_op_EX2;
    wire [31:0] pc_plus4_EX2;

    EX1_EX2_buffer u_EX1_EX2_buffer(
        .rs1_in(rs1_EX1),
        .rs2_in(rs2_EX1),
        .rd_in(rd_EX1),
        .rs2_data_in(rs2_data_EX1),
        .alu_a_in(alu_a_EX1),
        .alu_b_in(alu_b_EX1),
        .wb_sel_in(wb_sel_EX1),
        .reg_write_in(reg_write_EX1),
        .mem_read_in(mem_read_EX1),
        .mem_write_in(mem_write_EX1),
        .load_op_in(load_op_EX1),
        .store_op_in(store_op_EX1),
        .alu_op_in(alu_op_EX1),
        .fence_in(fence_EX1),
        .sys_op_in(sys_op_EX1),
        .pc_plus4_in(pc_plus4_EX1),

        .rs1_out(rs1_EX2),
        .rs2_out(rs2_EX2),
        .rd_out(rd_EX2),
        .rs2_data_out(rs2_data_EX2),
        .alu_a_out(alu_a_EX2),
        .alu_b_out(alu_b_EX2),
        .wb_sel_out(wb_sel_EX2),
        .reg_write_out(reg_write_EX2),
        .mem_read_out(mem_read_EX2),
        .mem_write_out(mem_write_EX2),
        .load_op_out(load_op_EX2),
        .store_op_out(store_op_EX2),
        .alu_op_out(alu_op_EX2),
        .fence_out(fence_EX2),
        .sys_op_out(sys_op_EX2),
        .pc_plus4_out(pc_plus4_EX2),

        .clk(clk),
        .en(EX1_EX2_en),
        .flush(EX1_EX2_flush),
        .reset(reset)
    );


    //alu

    wire [31:0] alu_out_EX2;

    alu u_alu(
        .alu_a(alu_a_EX2),
        .alu_b(alu_b_EX2),
        .control(alu_op_EX2),
        
        .alu_out(alu_out_EX2)
    );


    //EX2_MEM1_buffer

    wire [4:0] rd_MEM1;
    wire [31:0] rs2_data_MEM1;
    wire [31:0] alu_out_MEM1;
    wire [1:0] wb_sel_MEM1;
    wire reg_write_MEM1; 
    wire mem_read_MEM1;
    wire mem_write_MEM1;
    wire [2:0] load_op_MEM1;
    wire [1:0] store_op_MEM1; 
    wire fence_MEM1;
    wire [1:0] sys_op_MEM1;
    wire [31:0] pc_plus4_MEM1;

    EX2_MEM1_buffer u_EX2_MEM1_buffer(
        .rd_in(rd_EX2),
        .rs2_data_in(rs2_data_EX2),
        .alu_out_in(alu_out_EX2),
        .wb_sel_in(wb_sel_EX2),
        .reg_write_in(reg_write_EX2),
        .mem_read_in(mem_read_EX2),
        .mem_write_in(mem_write_EX2),
        .load_op_in(load_op_EX2),
        .store_op_in(store_op_EX2),
        .fence_in(fence_EX2),
        .sys_op_in(sys_op_EX2),
        .pc_plus4_in(pc_plus4_EX2),

        .rd_out(rd_MEM1),
        .rs2_data_out(rs2_data_MEM1),
        .alu_out_out(alu_out_MEM1),
        .wb_sel_out(wb_sel_MEM1),
        .reg_write_out(reg_write_MEM1),
        .mem_read_out(mem_read_MEM1),
        .mem_write_out(mem_write_MEM1),
        .load_op_out(load_op_MEM1),
        .store_op_out(store_op_MEM1),
        .fence_out(fence_MEM1),
        .sys_op_out(sys_op_MEM1),
        .pc_plus4_out(pc_plus4_MEM1),

        .clk(clk),
        .en(EX2_MEM1_en),
        .flush(EX2_MEM1_flush),
        .reset(reset)
    );


    //set en for stores

    wire [3:0] we_data;
    wire [31:0] din_data;

    store u_store(
        .mem_write(mem_write_MEM1),
        .store_op(store_op_MEM1),
        .offset(alu_out_MEM1[1:0]),
        .din(rs2_data_MEM1),

        .we(we_data),
        .din_out(din_data)
    );


    //data_mem

    wire [31:0] dout_data;
    wire en_data;
    assign en_data = (mem_read_MEM1==1'b1) | (mem_write_MEM1==1'b1);

    data_mem u_data_mem(
        .addr(alu_out_MEM1[11:2]),
        .clk(clk),
        .en(en_data),
        .we(we_data),
        .din(din_data),

        .dout(dout_data)
    );


    //MEM1_MEM2_buffer

    wire [4:0] rd_MEM2;
    wire [31:0] alu_out_MEM2;
    wire [1:0] wb_sel_MEM2;
    wire reg_write_MEM2; 
    wire mem_read_MEM2;
    wire [1:0] offset_MEM2;
    wire [2:0] load_op_MEM2; 
    wire fence_MEM2;
    wire [1:0] sys_op_MEM2;
    wire [31:0] pc_plus4_MEM2;

    MEM1_MEM2_buffer u_MEM1_MEM2_buffer(
        .rd_in(rd_MEM1),
        .alu_out_in(alu_out_MEM1),
        .wb_sel_in(wb_sel_MEM1),
        .reg_write_in(reg_write_MEM1),
        .mem_read_in(mem_read_MEM1),
        .offset_in(alu_out_MEM1[1:0]),
        .load_op_in(load_op_MEM1),
        .fence_in(fence_MEM1),
        .sys_op_in(sys_op_MEM1),
        .pc_plus4_in(pc_plus4_MEM1),

        .rd_out(rd_MEM2),
        .alu_out_out(alu_out_MEM2),
        .wb_sel_out(wb_sel_MEM2),
        .reg_write_out(reg_write_MEM2),
        .mem_read_out(mem_read_MEM2),
        .offset_out(offset_MEM2),
        .load_op_out(load_op_MEM2),
        .fence_out(fence_MEM2),
        .sys_op_out(sys_op_MEM2),
        .pc_plus4_out(pc_plus4_MEM2),

        .clk(clk),
        .en(MEM1_MEM2_en),
        .flush(MEM1_MEM2_flush),
        .reset(reset)
    );


    //load

    wire [31:0] data_MEM2;

    load u_load(
        .dout(dout_data),
        .mem_read(mem_read_MEM2),
        .load_op(load_op_MEM2),
        .offset(offset_MEM2),

        .data_out(data_MEM2)
    );


    //MEM2_WB_buffer

    wire [31:0] alu_out_WB;
    wire [1:0] wb_sel_WB; 
    wire fence_WB;
    wire [1:0] sys_op_WB;
    wire [31:0] pc_plus4_WB;
    wire [31:0] data_WB;

    MEM2_WB_buffer u_MEM2_WB_buffer(
        .rd_in(rd_MEM2),
        .alu_out_in(alu_out_MEM2),
        .wb_sel_in(wb_sel_MEM2),
        .reg_write_in(reg_write_MEM2),
        .fence_in(fence_MEM2),
        .sys_op_in(sys_op_MEM2),
        .pc_plus4_in(pc_plus4_MEM2),
        .data_in(data_MEM2),

        .rd_out(rd_WB),
        .alu_out_out(alu_out_WB),
        .wb_sel_out(wb_sel_WB),
        .reg_write_out(reg_write_WB),
        .fence_out(fence_WB),
        .sys_op_out(sys_op_WB),
        .pc_plus4_out(pc_plus4_WB),
        .data_out(data_WB),

        .clk(clk),
        .en(MEM2_WB_en),
        .flush(MEM2_WB_flush),
        .reset(reset)
    );


    //reg write mux

    localparam wb_sel_alu = 2'b00;
    localparam wb_sel_mem = 2'b01;
    localparam wb_sel_pc_plus4 = 2'b10;

    always@*
        begin
            case(wb_sel_WB)
                wb_sel_alu: write_data_WB = alu_out_WB;
                wb_sel_mem: write_data_WB = data_WB;
                wb_sel_pc_plus4: write_data_WB = pc_plus4_WB;
                default: write_data_WB = 32'b0;
            endcase
        end
    
endmodule