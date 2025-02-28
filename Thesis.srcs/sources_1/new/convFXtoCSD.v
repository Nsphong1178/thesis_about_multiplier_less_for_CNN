`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2025 05:54:58 PM
// Design Name: 
// Module Name: convFXtoCSD
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


module convFXtoCSD(
    input clk, reset, start,
    input [15:0] dataIn,
    input [7:0] address,
    output reg [31:0] dataOut,
    output reg done
    );

    
    wire [4:0] i;
    reg enable_i, load;
    wire [1:0] bit, carry_out, csd_out;
    reg enable_carry, enable_csd;
    reg [1:0] carry_in, csd_in;

    five_bit_counter cnt_i(
        .clk(clk),  
        .reset(reset),
        .enable(enable_i),
        .Load(load),
        .count(i)
    );

    register carry(
        .clk(clk),
        .reset(reset),
        .data(carry_in),
        .enReg(enable_carry),
        .q(carry_out)
    );

    register csd(
        .clk(clk),
        .reset(reset),
        .data(csd_in),
        .enReg(enable_csd),
        .q(csd_out)
    );

    wire Z_i;
    reg enable_i_inverted;

    assign Z_i = (i < 5'h17) ? 1'b1 : 1'b0; // enable counter i


    assign bit = dataIn[i] + carry_out;

//    assign dataOut[(i * 2) + 1 -: 2] = csd_out;

    reg [4:0] state;
    
     always @(posedge enable_i) begin
         if (reset)
             dataOut <= 32'b0;
         dataOut[(i-1) * 2 +: 2] <= csd_out;
     end

    // State Machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 5'd0;
        end else begin
            case (state)
                5'd0: state <= 5'd1; 
                5'd1: begin
                    if (start)
                        state <= 5'd2;
                    else 
                        state <= 5'd0;
                end
                5'd2: state <= 5'd3; 
                5'd3: begin
                    if (Z_i)
                        state <= 5'd4;
                    else 
                        state <= 5'd11  ; //done
                end

                5'd4: begin
                    if (bit == 2'b10)
                        state <= 5'd5;
                    else 
                        state <= 5'd6;
                end
                5'd5: state <= 5'd3; 
                5'd6: begin 
                    if (bit == 2'b01)
                        state <= 5'd7;
                    else 
                        state <= 5'd10;
                end
                5'd7: begin 
                    if (i < 5'h15 && dataIn[i+5'h1] == 1'b1)
                        state <= 5'd8;
                    else 
                        state <= 5'd9;
                end
                5'd8: state <= 5'd3; 
                5'd9: state <= 5'd3; 
                5'd10: state <= 5'd3;  
            default: state <= 5'd0;
            endcase
        end
    end

         // Control Outputs
   always @(*) begin
        load = (state == 5'd2) ? 1'b1 : 1'b0;
        csd_in = (state == 5'd5 || state == 5'd10) ? 2'b00 : 
              (state == 5'd8) ? 2'b10 : 2'b01;
        enable_csd = (state == 5'd5 || state == 5'd8 || state == 5'd9 || state == 5'd10) ? 1'b1 : 1'b0;
        enable_carry = (state == 5'd5 || state == 5'd8 || state == 5'd9 || state == 5'd10) ? 1'b1 : 1'b0;
        carry_in = (state == 5'd5 || state == 5'd8) ? 2'b01 : 2'b00;
        done = (state == 5'd11) ? 1'b1 : 1'b0;
        enable_i = (state == 5'd5 || state == 5'd8 || state == 5'd9 || state == 5'd10) ? 1'b1 : 1'b0;
    
	end

endmodule
