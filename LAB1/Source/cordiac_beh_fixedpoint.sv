`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2022 09:08:31
// Design Name: 
// Module Name: cordiac_beh_fixedpoint
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


module cordiac_beh_fixedpoint(

    );
    /**
* Cordic algorithm
*/
parameter integer FXP_SCALE = 1024;
real a = 0.0;
real b = 0.0;
reg signed [11:0] t_angle = (3.1416/2) * FXP_SCALE; //Input angle
//Table of arctan (1/2^i)
// Note. Table initialization below is not correct for Verilog. Select System-Verilog mode
// in your simulator in the case of syntax errors
reg signed [11:0] atan[0:9] = {11'h324,
                                11'h1DA,
                                11'hFA,
                                11'h7F,
                                11'h3F,
                                11'h1F,
                                11'hF,
                                11'h7,
                                11'h3,
                                11'h1
                                };
//real Kn = 0.607253; //Cordic scaling factor for 10 iterations

//Variables
reg signed [11:0] cos = 1.0 * FXP_SCALE; //Initial condition
reg signed [11:0] sin = 0.0;
reg signed [11:0] angle = 0.0; //Running angle

integer i, d;
reg signed [23:0] tmp;

reg signed [11:0] Kn = 0.607253 * FXP_SCALE;

initial //Execute only once
begin
    for ( i = 0; i < 10; i = i + 1) //Ten algorithm iterations
    begin
        if( t_angle > angle )
        begin
            angle = angle + atan[i];
            tmp = cos - ( sin / 2**i );
            sin = ( cos / 2**i ) + sin;
            cos = tmp;
        end
        else
        begin
            angle = angle - atan[i];
            tmp = cos + ( sin / 2**i );
            sin = - ( cos / 2**i) + sin;
            cos = tmp;
        end //if
    end //for
 //Scale sin/cos values
    tmp = Kn * sin;
    a = $itor(tmp)/(FXP_SCALE**2);
    sin = tmp / FXP_SCALE;
    
    tmp = Kn * cos;
    b = $itor(tmp)/(FXP_SCALE**2);
    cos = tmp / FXP_SCALE;
    
    $display("sin=%f, cos=%f", a, b);
end
endmodule
