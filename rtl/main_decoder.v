`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: main_decoder
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


module main_decoder(
    input [6:0] opcode,
    
    output reg ALU_src, //imm or reg
    output reg [1:0] mem_to_reg,
    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg [3:0] ALU_op,
    );
    
    always@*
        begin
            case(opcode)
                7'h0D: //lui
                7'h05: //auipc
                7'h1b: //jal
                7'h19: //jalr
                7'h18: //branch
                7'h00: //load
                7'h08: //store
                7'h04: //alu imm
                    begin
                        ALU_src = 1'b1;
                    end
                7'h0c: //alu
                    begin
                        ALU_src = 1'b0;
                    end
                7'h1c: //sys
            endcase
        end
            
endmodule
