`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2025 03:18:57 PM
// Design Name: 
// Module Name: carry_save_adder
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


module carry_save_adder_signed (
    input  wire signed [15:0] A,   // Số thứ nhất (16-bit, có dấu)
    input  wire signed [15:0] B,   // Số thứ hai (16-bit, có dấu)
    input  wire signed [15:0] C,   // Số thứ ba (16-bit, có dấu)
    output wire signed [15:0] Sum, // Tổng cuối cùng (16-bit, có dấu)
    output wire Carry_Out          // Carry cuối cùng
);
    wire signed [15:0] sum_t;      // Tổng tạm thời
    wire signed [15:0] carry_t;    // Carry tạm thời

    // Bước 1: Cộng 3 số dùng Carry Save Adder (CSA)
    assign sum_t   = A ^ B ^ C;      // Sum tạm thời (A XOR B XOR C)
    assign carry_t = (A & B) | (B & C) | (C & A); // Carry tạm thời

    // Bước 2: Cộng sum_t và carry_t bằng một bộ cộng (Ripple Carry Adder)
    assign {Carry_Out, Sum} = sum_t + (carry_t <<< 1);  // <<< là dịch trái giữ bit dấu

endmodule


