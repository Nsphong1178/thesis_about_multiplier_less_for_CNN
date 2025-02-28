`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2025 06:57:17 PM
// Design Name: 
// Module Name: convFXtoCSD_tb
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
module convFXtoCSD_tb;

    reg clk, reset, start;
    reg [15:0] dataIn;
    reg [7:0] address;
    wire [31:0] dataOut;
    wire done;

    // Instantiate the module
    convFXtoCSD uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .dataIn(dataIn),
        .address(address),
        .dataOut(dataOut),
        .done(done)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period (100MHz)

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        start = 0;
        dataIn = 16'b0110001100101100; // Example input
        address = 8'h0;

        // Reset sequence
        #10 reset = 0;
        
        // Start the process
        #10 start = 1;
        #10 start = 0;

        // Wait for done signal
        wait(done);

        // Display results
        $display("Test Completed. DataOut = %h", dataOut);

        // Finish simulation
        #50;
        $finish;
    end

endmodule

