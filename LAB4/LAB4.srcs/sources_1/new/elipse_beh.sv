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

parameter integer W = 12; //Width of the fixed-point (12:10) representation

input clock, reset, ce;
input [W-1:0] angle_in; //Angle in radians
output signed [W+2:0] X, Y;
output valid_out; //Valid data output flag
reg signed [W-1:0] sin_out, cos_out; 
parameter S1 = 4'h00, S2 = 4'h01;
reg [1:0] state;
reg signed [W+2:0] X_reg, Y_reg;

//Instantiation
cordic_pipe_rtl cordic ( clock, reset, ce, angle_in, sin_out, cos_out, valid_out ); 

reg [W+2:0] X_0, X_2, Y_0, Y_3;

initial
    begin
        X_reg <=0;
        Y_reg <=0;
        X_0 <= 0;
        X_2 <= 0;
        Y_0 <= 0;
        Y_3 <= 0;
        state <= S1;
    end

always @(clock)
    if(valid_out)
        begin
        case(state)
            S1: begin
                    X_0 <= sin_out;
                    Y_0 <= cos_out;
                    X_2 <= sin_out <<< 2;
                    Y_3 <= cos_out <<< 3;
                    state <= S2;
                end
            S2: begin
                    X_reg <= X_2 - X_0;
                    Y_reg <= Y_3 - Y_0;
                    state <= S1;
                end
        endcase;
        end
    else
        begin
            X_reg <= X_reg;
            Y_reg <= Y_reg;
        end


assign X = X_reg;
assign Y = Y_reg;

endmodule
