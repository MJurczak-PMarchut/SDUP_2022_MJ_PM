`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2022 19:05:12
// Design Name: 
// Module Name: cordic_rtl_TB
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


module cordic_rtl_TB(

    );
reg clock, reset, start;
reg [11:0] angle_in;
wire ready_out;
wire signed [11:0] sin_out, cos_out;
real real_cos, real_sin;
cordic_rtl cordic( clock, reset, start, angle_in, ready_out, sin_out, cos_out);
//Clock generator
initial
    clock <= 1'b1;
always
    #5 clock <= ~clock;
 
//Reset signal
initial
    begin
        reset <= 1'b1;
        #10 reset <= 1'b0;
    end 
//Stimuli signals
initial
    begin
        angle_in <= 0 * 1024; //Modify value in fixed-point [2:10] 
        start <= 1'b0;
        #20 start <= 1'b1;
        #30 start <= 1'b0;
    end
//Catch output
always @ (posedge ready_out)
    begin
        #10;
        real_cos = $itor(cos_out);
        real_sin = $itor(sin_out);
        real_cos = real_cos / 1024;
        real_sin = real_sin / 1024;
        $display("Real values: sin=%f, cos=%f", real_sin, real_cos);
    end
endmodule
