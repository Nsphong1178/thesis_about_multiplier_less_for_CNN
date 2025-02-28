module shift #(parameter MSB=16) (
    input [MSB-1:0] d,        // Dữ liệu đầu vào
    input clk,                // Xung nhịp
    input en,                 // Enable dịch bit
    input dir,                // Hướng dịch: 0 = trái, 1 = phải
    input rst,               // Reset (active high)
    input [3:0] shift_width,  // Số bit cần dịch (tối đa 15)
    output reg [MSB-1:0] out  // Thanh ghi đầu ra
);

    always @(posedge clk) begin
        if (rst) 
            out <= 0;  // Reset thanh ghi về 0
        else if (en) begin
            case (dir)
                0: out <= (d << shift_width);
                1: out <= (d >> shift_width);
            endcase
        end
    end
endmodule
