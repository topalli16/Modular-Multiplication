`timescale 1ns/1ps
module MICC(C, Done, A, B, N, Start, clk, rst);
parameter k = 8;
output [k-1:0] C;
output Done; 
input [k-1:0] A, B, N; 
input Start, clk, rst;
wire [14:0] Control_Signal;
wire [2:0] Status_Signal;
Controller C1(Control_Signal, Done, Start, Status_Signal, clk, rst);
Data_Path D1(C, Status_Signal, A, B, Control_Signal, N, clk, rst);
endmodule