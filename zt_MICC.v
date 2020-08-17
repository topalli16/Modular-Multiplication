`timescale 1ns/1ps
module zt_MICC();
wire [7:0] C;
wire Done;
reg [7:0] A = 13, B = 13, N = 174; 
reg Start = 0, clk = 0, rst = 1;
MICC M1(C, Done, A, B, N, Start, clk, rst);
always #100 clk = !clk;

initial begin
 #50 Start = 0;
 #150 rst = 0;
 #400 Start = 1;
 #1000 Start = 0;
end
endmodule