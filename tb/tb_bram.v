`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2026 12:50:54 AM
// Design Name: 
// Module Name: tb_bram
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


module tb_bram();

    reg clk, en, we;
    reg [9:0] addr;
    reg [31:0] din;
    wire [31:0] dout;
    
    instr_mem dut (
        .clk(clk),   
        .en(en),      
        .we(we),     
        .addr(addr), 
        .din(din),   
        .dout(dout)   
    );
    
    initial
        begin
            clk=0;
            forever #5 clk=~clk;
        end
        
    initial 
        begin
            en=1;
            we=0;
            addr=0;
            din=0;
            
            @(posedge clk);
            addr=0;
            din=32'hCECECECE;
            we=1;
            
            @(posedge clk);
            addr=1;
            din=32'hBFBFBFBF;
            
            @(posedge clk);
            we=0;
            addr=0;
            @(posedge clk);
            addr=1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            
            $finish;
            
        end

endmodule
