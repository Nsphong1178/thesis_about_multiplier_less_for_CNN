    `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2025 05:56:00 PM
// Design Name: 
// Module Name: convolution
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

module convCSDtoASD(
    input clk, reset, start,
    input [31:0] dataIn,
    input [7:0] address,
    // input Load, enable,
    output [8:0] dataOut
);
    reg load, enable_i, enable_k, enable_reg_k1, enable_reg_ck1;
    wire [1:0] data;
    wire Z_i, Z_comp, Z_cnt_K, Z_ck, Z_last;
    wire [3:0] i, k;
    wire [3:0] outRegK0, outRegK1, outRegK2, outRegK3;
    wire enRegK0, enRegK1, enRegK2, enRegK3;
    wire enRegck0, enRegck1, enRegck2, enRegck3;
    wire [1:0] ck0, ck1, ck2, ck3;
    wire [1:0] ck2_invert;
    wire [3:0] k_to_reg_1;
    wire [1:0] ck_to_reg_ck1;   
    wire Z_k1_k2;

    down_counter cnt_i(
        .clk(clk),
        .reset(reset),
        .enable(enable_i),
        .Load(load),
        .count(i)
    );
    
    assign Z_i = (i > 4'h0) ? 1'b1 : 1'b0; // enable counter i
    assign data = dataIn[(i * 2) + 1 -: 2];
    assign Z_comp = (data == 2'b00) ? 1'b0 : 1'b1;

    counter cnt_k(
        .clk(clk),
        .reset(reset),
        .enable(enable_k),
        .Load(load),
        .count(k)
    );
    
    assign Z_cnt_K = (k > 4) ? 1'b1 : 1'b0;
    assign enRegK0 = (k == 4'h0) ? 1'b1 : 1'b0;
    assign enRegK1 = (k == 4'h1) ? 1'b1 : 1'b0;
    assign enRegK1_final = (enable_reg_k1 == 1'b0) ? enRegK1 && enable_k : enable_reg_k1;
    assign enRegK2 = (k == 4'h2) ? 1'b1 : 1'b0;
    assign enRegK3 = (k == 4'h3) ? 1'b1 : 1'b0;
    assign k_to_reg_1 = (enable_reg_k1 == 1'b0) ? i+4'h1 : outRegK1-4'h1;
    

    register regK0(
    .clk(clk), 
    .reset(reset), 
    .data(i+4'h1), 
    .enReg(enRegK0 && enable_k), 
    .q(outRegK0));
    
    register regK1(
    .clk(clk), 
    .reset(reset), 
    .data(k_to_reg_1), 
    .enReg(enRegK1_final), 
    .q(outRegK1));
    
    register regK2(
    .clk(clk), 
    .reset(reset), 
    .data(i+4'h1), 
    .enReg(enRegK2 && enable_k), 
    .q(outRegK2));
    
    register regK3(
    .clk(clk), 
    .reset(reset), 
    .data(i+4'h1), 
    .enReg(enRegK3 && enable_k), 
    .q(outRegK3));
    
    assign Z_k1_k2 = (outRegK1 == outRegK2 + 4'd2) ? 1'b1 : 1'b0;
    assign enRegck0 = (k == 4'h0) ? 1'b1 : 1'b0;
    assign enRegck1 = (k == 4'h1) ? 1'b1 : 1'b0;
    assign enRegck2 = (k == 4'h2) ? 1'b1 : 1'b0;
    assign enRegck3 = (k == 4'h3) ? 1'b1 : 1'b0;

    assign ck2_invert = {ck2[0], ck2[1]};

    register reg_ck0(
    .clk(clk), 
    .reset(reset), .data(data), 
    .enReg(enRegck0 && Z_comp), 
    .q(ck0));
    
    assign ck_to_reg_ck1 = (enable_reg_ck1 == 1'b0) ? data : ck2_invert;
    
    register reg_ck1(
    .clk(clk), 
    .reset(reset), 
    .data(ck_to_reg_ck1), 
    .enReg(enRegck1 && Z_comp), 
    .q(ck1));
    
    register reg_ck2(
    .clk(clk), 
    .reset(reset), .data(data), 
    .enReg(enRegck2 && Z_comp), 
    .q(ck2));
    
    register reg_ck3(
    .clk(clk), 
    .reset(reset), 
    .data(data), 
    .enReg(enRegck3 && Z_comp), 
    .q(ck3));

    
    assign Z_ck = ((ck1 == 2'b01 && ck2 == 2'b10 && ck3 == 2'b10) || 
                   (ck1 == 2'b10 && ck2 == 2'b01 && ck3 == 2'b01)) ? 1'b1 : 1'b0;
    
    assign Z_last = (Z_ck && Z_cnt_K && Z_k1_k2) ? 1'b1 : 1'b0;
    
    assign dataOut[8:5] = outRegK0;
    assign dataOut[4:3] = (outRegK0 - outRegK1 == 4'h5) ? 2'b11 :
                          (outRegK0 - outRegK1 == 4'h4) ? 2'b10 :
                          (outRegK0 - outRegK1 == 4'h3) ? 2'b01 : 2'b00;
    assign dataOut[2:0] = 
			  (ck1 == 2'b01 && ck2 == 2'b00) ? 3'b100 :
              (ck1 == 2'b01 && ck2 == 2'b01) ? 3'b010 :
              (ck1 == 2'b01 && ck2 == 2'b10) ? 3'b110 : 
              (ck1 == 2'b10 && ck2 == 2'b00) ? 3'b101 :
              (ck1 == 2'b10 && ck2 == 2'b01) ? 3'b011 : 
			  (ck1 == 2'b10 && ck2 == 2'b10) ? 3'b111 : 3'b000;

    reg [4:0] state;

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
                        state <= 5'd6; //done
                end
                5'd4: begin
                    if (Z_comp)
                        state <= 5'd5;
                    else 
                        state <= 5'd3; //done
                end
                5'd5: state <= 5'd3; 
                5'd6: begin 
                    if (Z_last)
                        state <= 5'd7;
                    else 
                        state <= 5'd8;
                end
                5'd7: state <= 5'd8;
            default: state <= 5'd0;
            endcase
        end
    end

         // Control Outputs
   always @(*) begin
        load = (state == 5'd2) ? 1'b1 : 1'b0;
        enable_i = (state == 5'd4) ? 1'b1 : 1'b0;
        enable_k = (state == 5'd5) ? 1'b1 : 1'b0;
        enable_reg_k1 = (state == 5'd7) ? 1'b1 : 1'b0;
        enable_reg_ck1 = (state == 5'd7) ? 1'b1 : 1'b0;
	end

    
endmodule
