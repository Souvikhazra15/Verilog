`timescale 1ns / 1ps

module programCounter (
    input clk,
    input rst,
    input load,
    input inc,
    input [15:0] pc_in,
    output reg [15:0] pc_out
);

always @(posedge clk) begin
    if (rst)
        pc_out <= 16'h0000;
    else if (load)
        pc_out <= pc_in;
    else if (inc)
        pc_out <= pc_out + 16'h0001;
end

endmodule
