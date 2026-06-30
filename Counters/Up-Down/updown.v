module up_down_counter (
    clk, rst, din, load, up_down, count
);

input [3:0] din;
input clk, rst, load, up_down;
output reg [3:0] count;

always @(posedge clk) begin
    if(rst)
     count <= 0;
    else if (load)
     count <= din;
    else if (up_down)
     count <= count + 4'd1;
    else 
     count <= count + 4'd1;
end
    
endmodule