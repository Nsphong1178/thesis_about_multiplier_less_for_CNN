`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2024 03:04:11 PM
// Design Name: 
// Module Name: memory
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


module memory(
    input clk,
    input reset,
    input we, 
    input re,
    input [3:0] address,      // 4-bit address to access 16 locations
    input [7:0] dataIn,       // 8-bit data input
    output reg [7:0] dataOut  // Declare dataOut as a reg
    );
    
    // Define memory array with 16 locations, each 8 bits wide
    reg [7:0] mem_arr [0:15];

    always @(posedge clk or negedge reset)
    begin 
        if(reset)
        begin
            dataOut <= 8'b0;  // Reset output to 0
        end
        else 
        begin
            if(we)
            begin
                mem_arr[address] <= dataIn;  // Write data to memory
            end
            if(re)
            begin
                dataOut <= mem_arr[address];  // Read data from memory
            end
        end
    end     
endmodule
