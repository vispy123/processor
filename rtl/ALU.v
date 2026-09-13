`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 05:18:07 PM
// Design Name: 
// Module Name: alu
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


module alu(
    input [31:0] alu_a,
    input [31:0] alu_b,
    input [4:0] control,
    
    output reg [31:0] alu_out
    );

    reg [63:0] prod;
    
    always@*
        begin
            prod = 64'b0;
            case (control)
                5'b00000 : alu_out = alu_a + alu_b; //add
                5'b00001 : alu_out = alu_a - alu_b; //sub
                5'b00010 : alu_out = alu_a << alu_b[4:0]; //sll
                5'b00011 : alu_out = $signed(alu_a) < $signed(alu_b) ? 32'b1 : 32'b0; //slt
                5'b00100 : alu_out = alu_a < alu_b ? 32'b1 : 32'b0; //sltu
                5'b00101 : alu_out = alu_a ^ alu_b; //xor
                5'b00110 : alu_out = alu_a >> alu_b[4:0]; //srl
                5'b00111 : alu_out = $signed(alu_a) >>> alu_b[4:0]; //sra
                5'b01000 : alu_out = alu_a | alu_b; //or
                5'b01001 : alu_out = alu_a & alu_b; //and
                5'b01010 : alu_out = alu_a * alu_b; //mul
                5'b01011 : //mulh
                    begin
                        prod = $signed(alu_a) * $signed(alu_b);
                        alu_out = prod[63:32];
                    end
                5'b01100 : //mulhsu
                    begin
                        prod = $signed(alu_a) * $signed({1'b0, alu_b});
                        alu_out = prod[63:32];
                    end
                5'b01101 : //mulhu
                    begin
                        prod = alu_a * alu_b;
                        alu_out = prod[63:32];
                    end
                5'b01110 : //div
                    begin
                        if (alu_b == 32'b0) alu_out = 32'hFFFFFFFF;
                        else if (alu_a == 32'h80000000 && alu_b == 32'hFFFFFFFF) alu_out = 32'h80000000; //basically most neg int/-1 = most neg int
                        else alu_out = $signed(alu_a) / $signed(alu_b); 
                    end
                5'b01111 : //divu
                    begin
                        if (alu_b == 32'b0) alu_out = 32'hFFFFFFFF;
                        else alu_out = alu_a / alu_b; 
                    end
                5'b10000 : //rem
                    begin
                        if (alu_b == 32'b0) alu_out = alu_a;
                        else if (alu_a == 32'h80000000 && alu_b == 32'hFFFFFFFF) alu_out = 32'h0; //basically most neg int % -1 = 0
                        else alu_out = $signed(alu_a) % $signed(alu_b);
                    end
                5'b10001 : //remu
                    begin
                        if (alu_b == 32'b0) alu_out = alu_a;
                        else alu_out = alu_a % alu_b; 
                    end
                5'b10010 : alu_out = (alu_a - alu_b) * (alu_a - alu_b); //dsq
                default: 
                    begin
                        alu_out = 32'b0;
                        prod = 64'b0;
                    end
            endcase
        end
    
endmodule
