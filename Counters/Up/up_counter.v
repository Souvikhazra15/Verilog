module upCounter (
    clk, rst, din, load, count
);

input [3:0] din;
input clk, rst, load;
output reg [3:0] count;

always @(posedge clk) begin
    
    if(rst)
      count<=0;
    else if(load) 
     count <= din;
    else count <= count+din;
    
end
    
endmodule