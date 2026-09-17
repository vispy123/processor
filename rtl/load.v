`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2026 11:31:00 AM
// Design Name: 
// Module Name: load
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

module load(
    input [31:0] dout,
    input mem_read,
    input [2:0] load_op,
    input [1:0] offset,

    output reg [31:0] data_out
);

    localparam load_op_lb = 3'b000;
    localparam load_op_lh = 3'b001;
    localparam load_op_lw = 3'b010;
    localparam load_op_lbu = 3'b011;
    localparam load_op_lhu = 3'b100;

    always@*
        begin
            if (mem_read)
                case(load_op)
                    load_op_lb: 
                        begin
                            case(offset)
                                2'b00: data_out = {{24{dout[7]}}, dout[7:0]};
                                2'b01: data_out = {{24{dout[15]}}, dout[15:8]};
                                2'b10: data_out = {{24{dout[23]}}, dout[23:16]};
                                2'b11: data_out = {{24{dout[31]}}, dout[31:24]};
                                default: data_out = 32'b0;
                            endcase
                        end
                    load_op_lh: 
                        begin
                            case(offset)
                                2'b00: data_out = {{16{dout[15]}}, dout[15:0]};
                                2'b10: data_out = {{16{dout[31]}}, dout[31:16]};
                                default: data_out = 32'b0;
                            endcase
                        end
                    load_op_lw: data_out = dout;
                    load_op_lbu: 
                        begin
                            case(offset)
                                2'b00: data_out = {{24{1'b0}}, dout[7:0]};
                                2'b01: data_out = {{24{1'b0}}, dout[15:8]};
                                2'b10: data_out = {{24{1'b0}}, dout[23:16]};
                                2'b11: data_out = {{24{1'b0}}, dout[31:24]};
                                default: data_out = 32'b0;
                            endcase
                        end
                    load_op_lhu: 
                        begin
                            case(offset)
                                2'b00: data_out = {{16{1'b0}}, dout[15:0]};
                                2'b10: data_out = {{16{1'b0}}, dout[31:16]};
                                default: data_out = 32'b0;
                            endcase
                        end
                    default: data_out = 32'b0;
                endcase
            else data_out = 32'b0;
        end

endmodule