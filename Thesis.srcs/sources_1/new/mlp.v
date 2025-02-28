`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2025 07:56:06 PM
// Design Name: 
// Module Name: multiplier_less
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


module mlp(
    input clk, reset, start, ena,
    input [15:0] f,
    input [1:0] v0, v1,
    input [3:0] s0, s1,
    output signed [15:0] b0, b1
    );
    
    wire signed [15:0] out_shift_0, out_shift_1;
    shift shift_reg_1(
        .d(f),
        .clk(clk),
        .en(ena),
        .dif(0),
        .rst(reset),
        .shift_width(s0),
        .out(out_shift_0)
    );

    shift shift_reg_2(
        .d(f),
        .clk(clk),
        .en(ena),
        .dif(0),
        .rst(reset),
        .shift_width(s1),
        .out(out_shift_1)
    );

    assign b0 = (v0 == 2'b01) ? out_shift_0 : (v0 == 2'b10) ? (~ out_shift_0) + 1: 16'h0;
    assign b1 = (v1 == 2'b01) ? out_shift_1 : (v1 == 2'b10) ? (~ out_shift_1) + 1: 16'h0;

endmodule
