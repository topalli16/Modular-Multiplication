`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 02:35:26 PM
// Design Name: 
// Module Name: zt_Data_Path
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


module zt_Data_Path();
wire [7:0] C;
wire [2:0] Status_Signal;
wire [14:0] Control_Signal;
reg [7:0] A = 15, B = 25, N = 148;
reg clk = 0, rst = 0;
reg LoadA = 0, LoadN = 0, LoadCoun = 0, LoadB = 0, ShiftB = 0, LoadC = 0, ShiftC = 0, S_Coun = 0, S_Comp1 = 0, S_Comp2 = 0, S_AS1 = 0, S_C = 0, AS = 0;
reg [1:0] S_AS2 = 0;
assign Control_Signal = {LoadA, LoadN, LoadCoun, LoadB, ShiftB, LoadC, ShiftC, S_Coun, S_Comp1, S_Comp2, S_AS1, S_AS2, S_C, AS};
Data_Path D1(C, Status_Signal, A, B, Control_Signal, N, clk, rst);
always #100 clk = ~clk;
//initial 
//    begin
    // here I will configure the Control_Signal Bits
   
//    #50 LoadA = 1; LoadN = 1; LoadB = 1;
//    #60 LoadA = 0; LoadN = 0; LoadB = 0;
//    #10 A = 210; B = 15; N = 113;
//    #10 LoadA = 1; LoadN = 1; LoadB = 0;
//    #10 LoadA = 0; LoadN = 0; LoadB = 0;
//    end
//initial 
//    begin
    // here I will configure the Control_Signal Bits
//    #150 S_Coun = 0;
//        LoadCoun = 1; 
//    end
initial 
    begin
    // here I will configure the Control_Signal Bits
   
    #50 LoadA = 1; LoadN = 1; LoadB = 1;
    #60 LoadA = 0; LoadN = 0; LoadB = 0;
    #10 A = 210; B = 15; N = 113;
    #10 LoadA = 1; LoadN = 1; LoadB = 0;
    #10 LoadA = 0; LoadN = 0; LoadB = 0;
    end
initial 
    begin
    // here I will configure the Control_Signal Bits
    #150 S_Coun = 0; LoadCoun = 1;LoadC = 1;S_C = 1;AS = 0;S_AS1 = 1; S_AS2 = 2; 
    #160 LoadCoun = 0; LoadC = 0; S_C = 0; AS = 0; S_AS1 = 0; S_AS2 = 0; 
    end
//initial #510 S_Coun = 1;
//initial #510 S_Comp1 = 1;
//initial begin
//    #510 S_AS2 = 0;
//    #20  S_AS2 = 1;
//    #20  S_AS2 = 2;
//    #20  S_AS2 = 3; 
//end
//initial #510 AS = 1;
initial begin
    #510 {S_Comp1, S_Comp2} = 0;
    #20 {S_Comp1, S_Comp2} = 1;
    #20 {S_Comp1, S_Comp2} = 2;
    #20 {S_Comp1, S_Comp2} = 3;
end
endmodule
