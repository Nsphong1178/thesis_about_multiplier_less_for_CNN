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


module convolution(
    input [3:0] M, N, n,
    input clk, reset, start,
    input re_kernel, re_matrix, we_kernel, we_matrix, re_out, we_out,
    input [15:0] data_in_matrix

    );
    counter cnt_i(
        .clk(clk),
        .reset(reset),
        .enable(enable_i),
        .Load(load),
        .count(i)
    );

    counter cnt_j(
        .clk(clk),
        .reset(reset),
        .enable(enable_j),
        .Load(load),
        .count(j)
    );

    counter cnt_k(
        .clk(clk),
        .reset(reset),
        .enable(enable_k),
        .Load(load),
        .count(k)
    );



    assign Z_i < (M-n) ? 1'b1 : 1'b0;
    assign Z_j < (N-n) ? 1'b1 : 1'b0;
    assign Z_k < (k < 3'h8) ? 1'b1 : 1'b0;

    memory matrix(
        .clk(clk),
        .reset(reset),
        .re(re_matrix),
        .we(we_matrix),
        .address(address_matrix),
        .dataIn(data_in_matrix),
        .dataOut(data_out_matrix)
    );

    memory kernel(
        .clk(clk),
        .reset(reset),
        .re(re_kernel),
        .we(we_kernel),
        .address(address_kernel),
        .dataIn(data_in_kernel),
        .dataOut(data_out_kernel)
    );

    wire [15:0] f0, f1, f2, f3, f4, f5, f6, f7, f8;
    wire [8:0] k0, k1, k2, k3, k4, k5, k6, k7, k8;

    assign address_matrix = (k == 0) ? j*M + i + 1: 
                          (k == 1) ? j*M + i + 2:
                          (k == 2) ? j*M + i + 3: 
                          (k == 3) ? (j + 1)*M + i + 1:
                          (k == 4) ? (j + 1)*M + i + 2:
                          (k == 5) ? (j + 1)*M + i + 3:
                          (k == 6) ? (j + 2)*M + i + 1:
                          (k == 7) ? (j + 2)*M + i + 2:
                          (k == 8) ? (j + 2)*M + i + 3: 0;
    
    assign en_bit0 = (k == 0) ? 1'b1 : 1'b0;
    assign en_bit1 = (k == 1) ? 1'b1 : 1'b0;
    assign en_bit2 = (k == 2) ? 1'b1 : 1'b0;
    assign en_bit3 = (k == 3) ? 1'b1 : 1'b0;
    assign en_bit4 = (k == 4) ? 1'b1 : 1'b0;
    assign en_bit5 = (k == 5) ? 1'b1 : 1'b0;
    assign en_bit6 = (k == 6) ? 1'b1 : 1'b0;
    assign en_bit7 = (k == 7) ? 1'b1 : 1'b0;
    assign en_bit8 = (k == 8) ? 1'b1 : 1'b0;

    register reg_f0(.clk(clk), .reset(reset), .data(data_out_matrix), .enReg(en_bit0), .q(f0));
    register reg_f1(.clk(clk), .reset(reset), .data(data_out_matrix), .enReg(en_bit1), .q(f1));
    register reg_f2(.clk(clk), .reset(reset), .data(data_out_matrix), .enReg(en_bit2), .q(f2));
    register reg_f3(.clk(clk), .reset(reset), .data(data_out_matrix), .enReg(en_bit3), .q(f3));
    register reg_f4(.clk(clk), .reset(reset), .data(data_out_matrix), .enReg(en_bit4), .q(f4));
    register reg_f5(.clk(clk), .reset(reset), .data(data_out_matrix), .enReg(en_bit5), .q(f5));
    register reg_f6(.clk(clk), .reset(reset), .data(data_out_matrix), .enReg(en_bit6), .q(f6));
    register reg_f7(.clk(clk), .reset(reset), .data(data_out_matrix), .enReg(en_bit7), .q(f7));
    register reg_f8(.clk(clk), .reset(reset), .data(data_out_matrix), .enReg(en_bit8), .q(f8));

    register reg_f0(.clk(clk), .reset(reset), .data(data_out_kernel), .enReg(en_bit0), .q(k0));
    register reg_f1(.clk(clk), .reset(reset), .data(data_out_kernel), .enReg(en_bit1), .q(k1));
    register reg_f2(.clk(clk), .reset(reset), .data(data_out_kernel), .enReg(en_bit2), .q(k2));
    register reg_f3(.clk(clk), .reset(reset), .data(data_out_kernel), .enReg(en_bit3), .q(k3));
    register reg_f4(.clk(clk), .reset(reset), .data(data_out_kernel), .enReg(en_bit4), .q(k4));
    register reg_f5(.clk(clk), .reset(reset), .data(data_out_kernel), .enReg(en_bit5), .q(k5));
    register reg_f6(.clk(clk), .reset(reset), .data(data_out_kernel), .enReg(en_bit6), .q(k6));
    register reg_f7(.clk(clk), .reset(reset), .data(data_out_kernel), .enReg(en_bit7), .q(k7));
    register reg_f8(.clk(clk), .reset(reset), .data(data_out_kernel), .enReg(en_bit8), .q(k8));

    wire[3:0] s00, s01, s10, s11, s20, s21, s30, s31, s40, s41, s50, s51, s60, s61, s70, s71, s80, s81;
    wire[1:0] v00, v01, v10, v11, v20, v21, v30, v31, v40, v41, v50, v51, v60, v61, v70, v71, v80, v81;
    wire [3:0] dif0, dif1, dif2, dif3, dif4, dif5, dif6, dif7, dif8;
    assign dif0 = (k0[4:3] == 2'b00) ? 4'h2: (k0[4:3] == 2'b01) ? 4'h3:  (k0[4:3] == 2'b10) ? 4'h4: (k0[4:3] == 2'b11) ? 4'h5: 4'h0;
    assign dif1 = (k1[4:3] == 2'b00) ? 4'h2: (k1[4:3] == 2'b01) ? 4'h3:  (k1[4:3] == 2'b10) ? 4'h4: (k1[4:3] == 2'b11) ? 4'h5: 4'h0;
    assign dif2 = (k2[4:3] == 2'b00) ? 4'h2: (k2[4:3] == 2'b01) ? 4'h3:  (k2[4:3] == 2'b10) ? 4'h4: (k2[4:3] == 2'b11) ? 4'h5: 4'h0;
    assign dif3 = (k3[4:3] == 2'b00) ? 4'h2: (k3[4:3] == 2'b01) ? 4'h3:  (k3[4:3] == 2'b10) ? 4'h4: (k3[4:3] == 2'b11) ? 4'h5: 4'h0;
    assign dif4 = (k4[4:3] == 2'b00) ? 4'h2: (k4[4:3] == 2'b01) ? 4'h3:  (k4[4:3] == 2'b10) ? 4'h4: (k4[4:3] == 2'b11) ? 4'h5: 4'h0;
    assign dif5 = (k5[4:3] == 2'b00) ? 4'h2: (k5[4:3] == 2'b01) ? 4'h3:  (k5[4:3] == 2'b10) ? 4'h4: (k5[4:3] == 2'b11) ? 4'h5: 4'h0;
    assign dif6 = (k6[4:3] == 2'b00) ? 4'h2: (k6[4:3] == 2'b01) ? 4'h3:  (k6[4:3] == 2'b10) ? 4'h4: (k6[4:3] == 2'b11) ? 4'h5: 4'h0;
    assign dif7 = (k7[4:3] == 2'b00) ? 4'h2: (k7[4:3] == 2'b01) ? 4'h3:  (k7[4:3] == 2'b10) ? 4'h4: (k7[4:3] == 2'b11) ? 4'h5: 4'h0;
    assign dif8 = (k7[4:3] == 2'b00) ? 4'h2: (k8[4:3] == 2'b01) ? 4'h3:  (k8[4:3] == 2'b10) ? 4'h4: (k8[4:3] == 2'b11) ? 4'h5: 4'h0;
    
    assign s00 = k0[8:5];
    assign s01 = k0[8:5] - dif0;
    assign s10 = k1[8:5];
    assign s11 = k1[8:5] - dif1;
    assign s20 = k2[8:5];
    assign s21 = k2[8:5] - dif2;
    assign s30 = k3[8:5];
    assign s31 = k3[8:5] - dif3;
    assign s40 = k4[8:5];
    assign s41 = k4[8:5] - dif4;
    assign s50 = k5[8:5];
    assign s51 = k5[8:5] - dif5;
    assign s60 = k6[8:5];
    assign s61 = k6[8:5] - dif6;
    assign s70 = k7[8:5];
    assign s71 = k7[8:5] - dif7;
    assign s80 = k8[8:5];
    assign s81 = k8[8:5] - dif8;

    assign v00 = (k0[2:0] === 3'b101 || k0[2:0] == 3'b110 || k0[2:0] == 3'b111 ) ? 2'b10 : 
                 (k0[2:0] === 3'b001 || k0[2:0] == 3'b010 || k0[2:0] == 3'b011) ? 2'b01 : 2'b00;
    assign v01 = (k0[2:0] === 3'b011 || k0[2:0] == 3'b111) ? 2'b10 : 
                 (k0[2:0] === 3'b010 || k0[2:0] == 3'b110) ? 2'b01 : 2'b00;

    assign v10 = (k1[2:0] == 3'b101 || k1[2:0] == 3'b110 || k1[2:0] == 3'b111 ) ? 2'b10 : 
                 (k1[2:0] == 3'b001 || k1[2:0] == 3'b010 || k1[2:0] == 3'b011) ? 2'b01 : 2'b00;
    assign v11 = (k1[2:0] == 3'b011 || k1[2:0] == 3'b111) ? 2'b10 : 
                 (k1[2:0] == 3'b010 || k1[2:0] == 3'b110) ? 2'b01 : 2'b00;

    assign v20 = (k2[2:0] == 3'b101 || k2[2:0] == 3'b110 || k2[2:0] == 3'b111 ) ? 2'b10 : 
                 (k2[2:0] == 3'b001 || k2[2:0] == 3'b010 || k2[2:0] == 3'b011) ? 2'b01 : 2'b00;
    assign v21 = (k2[2:0] == 3'b011 || k2[2:0] == 3'b111) ? 2'b10 : 
                 (k2[2:0] == 3'b010 || k2[2:0] == 3'b110) ? 2'b01 : 2'b00;

    assign v30 = (k3[2:0] == 3'b101 || k3[2:0] == 3'b110 || k3[2:0] == 3'b111 ) ? 2'b10 : 
                 (k3[2:0] == 3'b001 || k3[2:0] == 3'b010 || k3[2:0] == 3'b011) ? 2'b01 : 2'b00;
    assign v31 = (k3[2:0] == 3'b011 || k3[2:0] == 3'b111) ? 2'b10 : 
                 (k3[2:0] == 3'b010 || k3[2:0] == 3'b110) ? 2'b01 : 2'b00;

    assign v40 = (k4[2:0] == 3'b101 || k4[2:0] == 3'b110 || k4[2:0] == 3'b111 ) ? 2'b10 : 
                 (k4[2:0] == 3'b001 || k4[2:0] == 3'b010 || k4[2:0] == 3'b011) ? 2'b01 : 2'b00;
    assign v41 = (k4[2:0] == 3'b011 || k4[2:0] == 3'b111) ? 2'b10 : 
                 (k4[2:0] == 3'b010 || k4[2:0] == 3'b110) ? 2'b01 : 2'b00;

    assign v50 = (k5[2:0] == 3'b101 || k5[2:0] == 3'b110 || k5[2:0] == 3'b111 ) ? 2'b10 : 
                 (k5[2:0] == 3'b001 || k5[2:0] == 3'b010 || k5[2:0] == 3'b011) ? 2'b01 : 2'b00;
    assign v51 = (k5[2:0] == 3'b011 || k5[2:0] == 3'b111) ? 2'b10 : 
                 (k5[2:0] == 3'b010 || k5[2:0] == 3'b110) ? 2'b01 : 2'b00;

    assign v60 = (k6[2:0] == 3'b101 || k6[2:0] == 3'b110 || k6[2:0] == 3'b111 ) ? 2'b10 : 
                 (k6[2:0] == 3'b001 || k6[2:0] == 3'b010 || k6[2:0] == 3'b011) ? 2'b01 : 2'b00;
    assign v61 = (k6[2:0] == 3'b011 || k6[2:0] == 3'b111) ? 2'b10 : 
                 (k6[2:0] == 3'b010 || k6[2:0] == 3'b110) ? 2'b01 : 2'b00;

    assign v70 = (k7[2:0] == 3'b101 || k7[2:0] == 3'b110 || k7[2:0] == 3'b111 ) ? 2'b10 : 
                 (k7[2:0] == 3'b001 || k7[2:0] == 3'b010 || k7[2:0] == 3'b011) ? 2'b01 : 2'b00;
    assign v71 = (k7[2:0] == 3'b011 || k7[2:0] == 3'b111) ? 2'b10 : 
                 (k7[2:0] == 3'b010 || k7[2:0] == 3'b110) ? 2'b01 : 2'b00;

    assign v80 = (k8[2:0] == 3'b101 || k8[2:0] == 3'b110 || k8[2:0] == 3'b111 ) ? 2'b10 : 
                 (k8[2:0] == 3'b001 || k8[2:0] == 3'b010 || k8[2:0] == 3'b011) ? 2'b01 : 2'b00;
    assign v81 = (k8[2:0] == 3'b011 || k8[2:0] == 3'b111) ? 2'b10 : 
                 (k8[2:0] == 3'b010 || k8[2:0] == 3'b110) ? 2'b01 : 2'b00;

    carry_save_adder_signed csa_10(.A(b00), .B(b01), .C(0), .Sum(sum_10), .Carry_Out(carry_10));
    carry_save_adder_signed csa_11(.A(b10), .B(b11), .C(0), .Sum(sum_11), .Carry_Out(carry_11));
    carry_save_adder_signed csa_12(.A(b20), .B(b21), .C(0), .Sum(sum_12), .Carry_Out(carry_12));
    carry_save_adder_signed csa_13(.A(b30), .B(b31), .C(0), .Sum(sum_13), .Carry_Out(carry_13));
    carry_save_adder_signed csa_14(.A(b40), .B(b41), .C(0), .Sum(sum_14), .Carry_Out(carry_14));
    carry_save_adder_signed csa_14(.A(b50), .B(b51), .C(0), .Sum(sum_15), .Carry_Out(carry_15));

    carry_save_adder_signed csa_20(.A(sum_10), .B(carry_10), .C(sum_11), .Sum(sum_20), .Carry_Out(carry_20));
    carry_save_adder_signed csa_21(.A(carry_11), .B(sum_12), .C(carry_20), .Sum(sum_21), .Carry_Out(carry_21));
    carry_save_adder_signed csa_22(.A(sum_13), .B(carry_13), .C(sum_14), .Sum(sum_22), .Carry_Out(carry_22));
    carry_save_adder_signed csa_23(.A(carry_14), .B(sum_15), .C(carry_15), .Sum(sum_23), .Carry_Out(carry_23));
   
    carry_save_adder_signed csa_31(.A(sum_20), .B(carry_20), .C(0), .Sum(sum_30), .Carry_Out(carry_30));
    carry_save_adder_signed csa_32(.A(sum_21), .B(carry_21), .C(sum_22), .Sum(sum_31), .Carry_Out(carry_31));
    carry_save_adder_signed csa_33(.A(carry_22), .B(sum_23), .C(carry_23), .Sum(sum_32), .Carry_Out(carry_32));
    
    carry_save_adder_signed csa_41(.A(sum_30), .B(carry_30), .C(sum_31), .Sum(sum_40), .Carry_Out(carry_40));
    carry_save_adder_signed csa_42(.A(carry_31), .B(sum_32), .C(carry_32), .Sum(sum_41), .Carry_Out(carry_41));
  
    carry_save_adder_signed csa_51(.A(carry_40), .B(sum_41), .C(carry_41), .Sum(sum_50), .Carry_Out(carry_50));

    carry_save_adder_signed csa_61(.A(carry_50), .B(sum_50), .C(sum_40), .Sum(sum_60), .Carry_Out(carry_60));
  
    assign final_sum = sum_60 + carry_60;

    memory matrix_output(
        .clk(clk),
        .reset(reset),
        .re(re_out),
        .we(we_out),
        .address(j * (M - n + 1) + i),
        .dataIn(final_sum),
        .dataOut(data_out)
    );

endmodule
