`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2022 10:13:32
// Design Name: 
// Module Name: elipse_beh
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


module elipse_beh( clock, reset, ce, angle_in, X, Y, valid_out );
parameter A = 3;
parameter B = 7;
parameter integer W = 12; //Width of the fixed-point (12:10) representation
parameter FXP_MUL = 1024; //Scaling factor for fixed-point (12:10) representation
parameter PIPE_LATENCY = 15; // Input->output delay in clock cycles

input clock, reset, ce;
input [W-1:0] angle_in; //Angle in radians
output signed [W+2:0] X, Y;
output valid_out; //Valid data output flag
reg signed [W-1:0] sin_out, cos_out; 
parameter S1 = 4'h00, S2 = 4'h01, S3 = 4'h02, S4 = 4'h03;
reg [1:0] state;
reg signed [W+2:0] X_reg, Y_reg;
//Instantiation
cordic_pipe_rtl cordic ( clock, reset, ce, angle_in, sin_out, cos_out, valid_out ); 

reg [W+2:0] X_1, X_2, X_12,Y_1, Y_2, Y_12, Y_3, Y_123;

initial
    begin
        X_reg <=0;
        Y_reg <=0;
        X_12 <= 0;
        Y_12 <= 0;
        Y_3 <= 0;
        Y_123 <= 0;
        state <= S1;
    end

always @(clock)
    if(valid_out)
        begin
            X_1 <= X <<< 1;
            X_2 <= X <<< 2;
            Y_1 <= Y <<< 1;
            Y_2 <= Y <<< 2;
            Y_3 <= Y <<< 3;
            state <= S2;
        end
    else
        begin
            X_reg <= X_reg;
            Y_reg <= Y_reg;
        end


assign X = X_reg;
assign Y = Y_reg;

endmodule
