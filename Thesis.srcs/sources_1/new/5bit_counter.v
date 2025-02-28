`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2025 07:42:50 PM
// Design Name: 
// Module Name: 5bit_counter
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



module five_bit_counter #(
    parameter N = 5  // Define parameter N, default to 4
)(
    input clk,
    input reset,
    input enable,
    input Load,
    output reg [N-1:0] count  // Output count
);

    // Internal signal to store the count value
    reg [N-1:0] pre_count;

    // Sequential logic for counting
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pre_count <= 0;  // Reset count to 0
        end
        else if (Load) begin
            pre_count <= 5'h0;  // Load Din into count
        end
        else if (enable) begin
            pre_count <= pre_count + 1;  // Increment count when enabled
        end
    end

    // Assign pre_count to output count
    always @(*) begin
        count = pre_count;
    end

endmodule
