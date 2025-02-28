`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2024 07:15:12 PM
// Design Name: 
// Module Name: down_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 4-bit Down Counter
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module down_counter #(
    parameter N = 4  // Define parameter N, default to 16
)(
    input clk,
    input reset,
    input enable,
    input Load,
   
    output reg [N-1:0] count  // Output count
);

    // Sequential logic for counting
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;  // Reset count to 0
        end
        else if (Load) begin
            count <= 4'hE;  // Load Din into count
        end
        else if (enable) begin
            count <= count - 1;  // Decrement count when enabled
        end
    end

endmodule
