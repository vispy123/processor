`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2026 01:51:09 PM
// Design Name: 
// Module Name: branch_taken
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

module branch_taken(
    input branch,
    input [2:0] branch_op,
    input wb_sel_pc_plus4,
    input [31:0] alu_a,
    input [31:0] alu_b,
    
    output reg branch_taken
);

    localparam branch_op_beq = 3'b000;
    localparam branch_op_bne = 3'b001;
    localparam branch_op_blt = 3'b100;
    localparam branch_op_bge = 3'b101;
    localparam branch_op_bltu = 3'b110;
    localparam branch_op_bgeu = 3'b111;

    always@*
        begin
            if (wb_sel_pc_plus4) branch_taken = 1'b1;
            else if (branch == 1'b1)
                begin
                    case (branch_op)
                        branch_op_beq: branch_taken = (alu_a == alu_b);
                        branch_op_bne: branch_taken = (alu_a != alu_b);
                        branch_op_blt: branch_taken = ($signed(alu_a) < $signed(alu_b));
                        branch_op_bge: branch_taken = ($signed(alu_a) >= $signed(alu_b));
                        branch_op_bltu: branch_taken = (alu_a < alu_b);
                        branch_op_bgeu: branch_taken = (alu_a >= alu_b);
                        default: branch_taken = 1'b0;
                    endcase
                end
            else branch_taken = 1'b0;
        end

endmodule