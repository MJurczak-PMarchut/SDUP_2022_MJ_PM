`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2022 10:18:40
// Design Name: 
// Module Name: cordic_elipse_TB
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


module cordic_elipse_TB;

reg clock, ce, reset, start; 
reg [11:0] angle_in; 
real angle;
wire signed [14:0] X, Y;
wire valid_out;
//For easy output value monitoring
real real_cos, real_sin;

//Instantiation
elipse_beh cordic ( clock, reset, ce, angle_in, X, Y, valid_out ); 

//Reset stimuli
initial
begin
 reset <= 1'b1;
 #10 reset <= 1'b0;
end 
//ce & clock generator stimuli
initial
begin
 ce <= 1'b1; 
 clock <= 1'b1;
end
always
 #5 clock <= ~clock;
//Signals stimuli
initial
 angle = 0.0;
always@(posedge clock)
begin
 if (angle < 3.14/2 ) angle = angle + 0.1; else angle = 0;
 angle_in <= angle * 1024; //Value in fixed-point (12:10) 
 //Convert and display results
 real_cos = Y;
 real_sin = X;
 real_cos = real_cos / 1024;
 real_sin = real_sin / 1024;
 $display("Real values: sin=%f, cos=%f", real_sin, real_cos);
end
endmodule
