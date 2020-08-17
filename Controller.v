`timescale 1ns/1ps

module Controller (Control_Signal, Done, Start, Status_Signal, clk, rst);
output [14:0] Control_Signal;
output reg Done;
input Start, clk, rst;
input [2:0] Status_Signal;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// State Parameters
// Here I have declareted the states as parameters. The states that _d extension are the decision states required for the 
// implementation of the conditional statements of the ASM chart shown in the odev3 file.
parameter S0 = 4'b0000, S1 = 4'b0001, S2 = 4'b0010, S2_d = 4'b1000,                                                                
          S3 = 4'b0011, S3_d = 4'b1001, S4 = 4'b0100, S5 = 4'b0101, 
          S5_d = 4'b1010, S6 = 4'b0110, S6_d = 4'b1011, S7 = 4'b0111; 
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// State Registers
// Here I have created some registers for controling the state flow
// I made them 4-bit wide because that is the amount of space needed to store the State_parameters
// Please see that the parameters at row 12,13 and 14 are 4-bit wide.
// The present_state register keeps the state we are currently in and the next_state register
// keeps the predicted next_state in the case structure that starts in line 50
(* dont_touch="true" *) reg [3:0] present_state, next_state; 

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Control_Signal Registers
// Here I have created the Control_Signal Register
reg LoadA, LoadN, LoadCoun, LoadB, ShiftB, LoadC, ShiftC, S_Coun, S_Comp1, S_Comp2, S_AS1, S_C, AS;
reg [1:0] S_AS2;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Control_Signal Output
// Here I assigned to Control_Signal all the registers that I createrd in the Control_Signal register section (section above)
assign Control_Signal = {LoadA, LoadN, LoadCoun, LoadB, ShiftB, LoadC, ShiftC, S_Coun, S_Comp1, S_Comp2, S_AS1, S_AS2, S_C, AS};
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
always @(posedge clk)// Here I created a always block to make the circuit work any time the clock is in posedge
begin
present_state = next_state;
if(rst == 1) 
    begin
    // It was not specified in the homework but I created a synchronous reset device
    // If the reset signal is high, the circuit will go to state S1 and will make the output Done low
    next_state = S1;
    end
    
if(rst == 0) begin
// if reset signal is low, the circuit should continue to work
case(present_state) // depending on the preset_state value, one of the set of instructions below will be executed
    S0:
    begin
     next_state = S1;
    end
    S1: // If present_state equals S1, the circuit should check the Start_Signal and make
    begin   // decisions depending on its value.
    if(Start) begin
        Done = 0;
        S_Coun = 0; 
        S_Comp1 = 0; 
        S_Comp2 = 0; 
        S_C = 0; 
        AS = 0; 
        LoadA = 1; 
        LoadN = 1; 
        LoadCoun = 1; 
        LoadB = 1; 
        ShiftB = 0; 
        LoadC = 1; 
        ShiftC = 0;
        S_AS1 = 0;
        S_AS2 = 0;
        next_state = S2;
    end
    else begin
        LoadA = 0; 
        LoadN = 0; 
        LoadCoun = 0; 
        LoadB = 0; 
        ShiftB = 0; 
        LoadC = 1; 
        ShiftC = 0;
        S_AS1 = 0;
        S_AS2 = 0;
        next_state = S1;
    end
    end
    S2: //Please note that S_Coun, S_Comp1, S_Comp2, S_C and AS should happen before decision state happens
        // because these particular signals are neccesary to direct the flow of data in the Data_Path
        //which will be very important for the Decesion states because they  control the Status_Signal value
        // which is very important in the decision states
        //The above coments will be valid for each of the cases in the lines below
    begin 
        LoadA = 0; 
        LoadN = 0; 
        LoadCoun = 0; 
        LoadB = 0; 
        ShiftB = 0; 
        LoadC = 0; 
        ShiftC = 0;
        S_AS1 = 0;
        S_AS2 = 0;
       
        S_Coun = 1; 
        S_Comp1 = 0; 
        S_Comp2 = 0;
        S_C = 0; 
        AS = 1;  
        next_state = S2_d;
    end
    
    S2_d: // decision state dependent on the S_Coun, S_Comp1, S_Comp2, S_C and AS values given in the state before
          // because they control the Status_Signal registers. Status_Signal Registers are important for decision making 
          // states because their value will control the state flow.
          // valid for each decision state case shown in the rest of the code
    if(Status_Signal[2] == 0)begin
        LoadA = 0; 
        LoadN = 0; 
        LoadCoun = 1; 
        LoadB = 0; 
        ShiftB = 0; 
        LoadC = 0; 
        ShiftC = 1;
        S_AS1 = 0;
        S_AS2 = 0;
        next_state = S3;
    end
    else if(Status_Signal[2] == 1) begin
        Done = 1;
        LoadA = 0; 
        LoadN = 0; 
        LoadCoun = 1; 
        LoadB = 0; 
        ShiftB = 0; 
        LoadC = 0; 
        ShiftC = 0;
        S_AS1 = 0;
        S_AS2 = 0;
        next_state = S1;
    end
    S3: 
    begin 
        LoadA = 0; 
        LoadN = 0; 
        LoadCoun = 0; 
        LoadB = 0; 
        ShiftB = 0; 
        LoadC = 0; 
        ShiftC = 0;
        S_AS1 = 0;
        S_AS2 = 0;
        
        S_Coun = 0; 
        S_Comp1 = 1; 
        S_Comp2 = 1; 
        S_C = 1; 
        AS = 1;  
        next_state = S3_d;
        end
    S3_d: 
    if(Status_Signal[2:1] == 0)begin
        LoadA = 0; 
        LoadN = 0; 
        LoadCoun = 0; 
        LoadB = 0; 
        ShiftB = 0; 
        LoadC = 0; 
        ShiftC = 0;
        S_AS1 = 0;
        S_AS2 = 0;
        next_state = S5;
    end
    else if(Status_Signal[2:1] == 1 || Status_Signal[2:1] == 2) begin
        LoadA = 0; 
        LoadN = 0; 
        LoadCoun = 0; 
        LoadB = 0; 
        ShiftB = 0; 
        LoadC = 1; 
        ShiftC = 0;
        S_AS1 = 1;
        S_AS2 = 1;
        next_state = S4;
    end
    
    S4: begin 
        LoadA = 0; 
        LoadN = 0; 
        LoadCoun = 0; 
        LoadB = 0; 
        ShiftB = 0; 
        LoadC = 0; 
        ShiftC = 0;
        S_AS1 = 0;
        S_AS2 = 0;        
        S_Coun = 0; 
        S_Comp1 = 0; 
        S_Comp2 = 0;
        S_C = 1; 
        AS = 0;
        next_state = S5;
        end
    S5: 
    begin 
        LoadA = 0; 
        LoadN = 0; 
        LoadCoun = 0; 
        LoadB = 0; 
        ShiftB = 0; 
        LoadC = 0; 
        ShiftC = 0;
        S_AS1 = 0;
        S_AS2 = 0;
        
        S_Coun = 0; 
        S_Comp1 = 1; 
        S_Comp2 = 1;
        S_C = 1; 
        AS = 0; 
        next_state = S5_d;
    end    
    S5_d: 
    if(Status_Signal[0] == 0)begin
        LoadA = 0; 
        LoadN = 0; 
        LoadCoun = 0; 
        LoadB = 0; 
        ShiftB = 1; 
        LoadC = 0; 
        ShiftC = 0;
        S_AS1 = 0;
        S_AS2 = 0;
        next_state = S2;
    end
    else if(Status_Signal[0] == 1) begin
        LoadA = 0; 
        LoadN = 0; 
        LoadCoun = 0; 
        LoadB = 0; 
        ShiftB = 1; 
        LoadC = 1; 
        ShiftC = 0;
        S_AS1 = 1;
        S_AS2 = 2;
        next_state = S6;
    end
    S6: 
    begin 
        LoadA = 0; 
        LoadN = 0; 
        LoadCoun = 0; 
        LoadB = 0; 
        ShiftB = 0; 
        LoadC = 0; 
        ShiftC = 0;
        S_AS1 = 0;
        S_AS2 = 0;
        
        S_Coun = 0; 
        S_Comp1 = 1; 
        S_Comp2 = 1;
        S_C = 1; 
        AS = 1;   
        next_state = S6_d;
    end
             
    S6_d: 
    if(Status_Signal[2:1] == 0)begin
        LoadA = 0; 
        LoadN = 0; 
        LoadCoun = 0; 
        LoadB = 0; 
        ShiftB = 0; 
        LoadC = 0; 
        ShiftC = 0;
        S_AS1 = 0;
        S_AS2 = 0;
        next_state = S2;
    end
    
    else if(Status_Signal[2:1] == 1 || Status_Signal[2:1] == 2) begin
        LoadA = 0; 
        LoadN = 0; 
        LoadCoun = 0; 
        LoadB = 0; 
        ShiftB = 0; 
        LoadC = 1; 
        ShiftC = 0;
        S_AS1 = 1;
        S_AS2 = 3;
        next_state = S7;
    end
      
    S7: begin 
        LoadA = 0; 
        LoadN = 0; 
        LoadCoun = 0; 
        LoadB = 0; 
        ShiftB = 0; 
        LoadC = 0; 
        ShiftC = 0;
        S_AS1 = 0;
        S_AS2 = 0;
        
        S_Coun = 0; 
        S_Comp1 = 0; 
        S_Comp2 = 0;
        S_C = 0; 
        AS = 0; 
        next_state = S2;
        end
        
    default: begin //If the circuit reaches an error state, the circuit will go back at S1 and 
                   // And it will start working when Start == 1
        Done = 0;
        S_Coun = 0; 
        S_Comp1 = 0; 
        S_Comp2 = 0; 
        S_C = 0; 
        AS = 0; 
        LoadA = 0; 
        LoadN = 0; 
        LoadCoun = 0; 
        LoadB = 0; 
        ShiftB = 0; 
        LoadC = 0; 
        ShiftC = 0;
        S_AS1 = 0;
        S_AS2 = 0;
        next_state = S1; 
    end      
    endcase
end
end
endmodule
