`timescale 1ns/ 1ps
module zt_Controller();
wire [14:0] Control_Signal;
wire Done;
reg Start = 0;
reg [2:0] Status_Signal = 3'b011;
reg clk = 0;
reg rst = 1;
Controller uut(Control_Signal, Done, Start, Status_Signal, clk, rst);

always #20 clk = !clk;
initial #26 Start = 1;
initial #10 rst = 1;
initial    #25 rst = 0;
initial    #230 Status_Signal = 3'b001;
initial    #315 Status_Signal = 3'b110;
endmodule