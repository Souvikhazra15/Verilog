module updown_counter_tb (
    clk, rst, up_down, din, load, count
);

reg [3:0] din;
reg clk, rst, load, up_down;
wire [3:0] count;

up_down_counter DUT(clk, rst, up_down, din, load, count);

initial begin
    clk = 1'b0;
    #5 forever clk = ~clk;
end

initial begin
    {rst, load, up_down} = 3'b0;
    din = 4'd0;
    #10;
    
    // Reset
    {rst, load, up_down} = 3'b100; din = 4'd3; #10;
    
    // Load value 3 and start counting up
    {rst, load, up_down} = 3'b110; din = 4'd3; #10;
    {rst, load, up_down} = 3'b010; din = 4'd3; #10;
    {rst, load, up_down} = 3'b010; din = 4'd3; #10;
    {rst, load, up_down} = 3'b010; din = 4'd3; #10;
    
    // Load value 0 and start counting down
    {rst, load, up_down} = 3'b101; din = 4'd0; #10;
    {rst, load, up_down} = 3'b001; din = 4'd0; #10;
    {rst, load, up_down} = 3'b001; din = 4'd0; #10;
    {rst, load, up_down} = 3'b001; din = 4'd0; #10;
    
    // Load value 13 and count up
    {rst, load, up_down} = 3'b110; din = 4'd13; #10;
    {rst, load, up_down} = 3'b010; din = 4'd13; #10;
    {rst, load, up_down} = 3'b010; din = 4'd13; #10;
    {rst, load, up_down} = 3'b010; din = 4'd13; #10;
    {rst, load, up_down} = 3'b010; din = 4'd13; #10;
    
    #150 $finish;
end
endmodule