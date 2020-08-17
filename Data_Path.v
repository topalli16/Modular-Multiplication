module Data_Path (C, Status_Signal, A, B, Control_Signal, N, clk, rst);
input [7:0] A, B, N;
input clk, rst;
input [14:0] Control_Signal;
output [7:0] C;
output reg [2:0] Status_Signal;
parameter k = 8; // using this parameter to decide the bit length of the numbers that the machine can handle
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Declarations
// internal register and wire declaration needed in the later sections
wire LoadA, LoadN, LoadCoun, LoadB, ShiftB, LoadC, ShiftC, S_Coun, S_Comp1, S_Comp2, S_AS1,  S_C, AS;
wire [1:0] S_AS2;
(* dont_touch="true" *) reg [k-1:0] REGA, REGN, Counter, REGB, REGC, ResultAS, C_Input, CounterInput, Operand1C, Operand2C, Operand1AS, Operand2AS;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Assigning the Control_Signal Comming from the Controller to the wires and registers declared in the section above
assign {LoadA, LoadN, LoadCoun, LoadB, ShiftB, LoadC, ShiftC, S_Coun, S_Comp1, S_Comp2, S_AS1, S_AS2, S_C, AS} = Control_Signal;
assign C = REGC;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Setting the LSB of the Status_Signal as the MSB of REGB
always @(REGB[k-1]) Status_Signal[0] = REGB[k-1];
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Configuring the registers --> at the posedge of the clk the reset or Load depending on their input signals
always @(posedge clk)
begin
    if(rst) REGA <= 0;
    else if(LoadA) REGA <= A;     
end

always @(posedge clk)
begin
    if(rst) REGN <= 0;
    else if(LoadN) REGN <= N; 
end

always @(posedge clk)
begin
    if(rst) Counter <= 0;
    else if(LoadCoun) Counter <= CounterInput;
end
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Configuring the register below --> at the posedge of the clk the reset, load or right shift depending on their input signals
always @(posedge clk)
begin
    if(rst) REGB <= 0;
    else if(LoadB) REGB <= B;
    if(ShiftB) REGB <= REGB << 1;
end

always @(posedge clk)
begin
    if(rst) REGC <= 0;
    else if(LoadC) REGC <= C_Input;
    if(ShiftC) REGC <= REGC << 1;
end
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Behavioral implementation of Multiplexers 2x1 and 4x1 
always @(ResultAS, S_Coun)
begin
    if(S_Coun) CounterInput = ResultAS;
    else if (!S_Coun) CounterInput = k;
end

always @(Counter, REGC, S_Comp1)
begin
    if(S_Comp1) Operand1C = REGC;
    else if(!S_Comp1) Operand1C = Counter;
end

always @(REGN, S_Comp2)
begin
    if(S_Comp2) Operand2C = REGN;
    else if(!S_Comp2) Operand2C = 0;    
end

always @(Counter, REGC, S_AS1)
begin
    if(S_AS1) Operand1AS = REGC;
    else if(!S_AS1) Operand1AS = Counter; 
end

always @(ResultAS, S_C)
begin
    if(S_C) C_Input = ResultAS;
    else if(!S_C) C_Input = 0;
end

always @(REGN, REGA, REGN, S_AS2)
begin
    if(S_AS2 == 0) Operand2AS = 1;
    else if(S_AS2 == 1) Operand2AS = REGN;
    else if(S_AS2 == 2) Operand2AS = REGA;
    else if(S_AS2 == 3) Operand2AS = REGN;
end
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Behavioral implementation of ADD_SUBB circuit, its functionality is derived from the truth table in homework file
always @(Operand1AS, Operand2AS, AS)
begin
   if(AS == 1)    ResultAS = Operand1AS - Operand2AS;
   else if(AS == 0) ResultAS = Operand1AS + Operand2AS;
end
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Behavioral implementation of Comparator circuit
always @(Operand1C, Operand2C, rst)
begin
   if (rst == 1) {Status_Signal[2], Status_Signal[1]} = 0;
   else if(Operand1C == Operand2C) {Status_Signal[2], Status_Signal[1]} = 2;
   else if(Operand1C > Operand2C)  {Status_Signal[2], Status_Signal[1]} = 1;
   else {Status_Signal[2], Status_Signal[1]} = 0;
end
endmodule