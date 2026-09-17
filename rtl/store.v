`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2026 09:36:17 PM
// Design Name: 
// Module Name: store
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

module store(
    input mem_write,
    input [1:0] store_op,
    input [1:0] offset,
    input [31:0] din,

    output reg [3:0] we,
    output reg [31:0] din_out
);

    localparam store_op_sb = 2'b00;
    localparam store_op_sh = 2'b01;
    localparam store_op_sw = 2'b10;

    always@*
        begin
            if (mem_write)
                case(store_op)
                    store_op_sb: 
                        begin
                            din_out = {4{din[7:0]}};
                            case(offset)
                                2'b00: we = 4'b0001;
                                2'b01: we = 4'b0010;
                                2'b10: we = 4'b0100;
                                2'b11: we = 4'b1000;
                                default: we = 4'b0000;
                            endcase
                        end
                    store_op_sh: 
                        begin
                            din_out = {2{din[15:0]}};
                            case(offset)
                                2'b00: we = 4'b0011;
                                2'b10: we = 4'b1100;
                                default: we = 4'b0000;
                            endcase
                        end
                    store_op_sw: 
                        begin
                            din_out = din;
                            we = 4'b1111;
                        end
                    default: 
                        begin
                            din_out = 32'b0;
                            we = 4'b0000;
                        end
                endcase
            else 
                begin
                    din_out = 32'b0;
                    we = 4'b0000;
                end
        end

endmodule