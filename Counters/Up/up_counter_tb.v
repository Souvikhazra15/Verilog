module up_counter_tb (
    clk, rst, din, load, count
);

reg [3:0] din;
reg clk, rst, load;
wire [3:0] count;

up_counter DUT( clk, rst, din, load, count);

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    {rst, load} = 0;
    din = 4'do;
    #10 ;
end

initial begin
    {rst, load} = 2'b10 ; din = 4'd3 ; #10;
    {rst, load} = 2'b01 ; din = 4'd4 ; #10;
    {rst, load} = 2'010 ; din = 4'd4 ; #10;
    {rst, load} = 2'b00 ; din = 4'd4 ; #10;
    {rst, load} = 2'b00 ; din = 4'd4 ; #10;
    {rst, load} = 2'b11 ; din = 4'd4 ; #10;
    {rst, load} = 2'b00 ; din = 4'd9 ; #10;
    {rst, load} = 2'b10 ; din = 4'd2 ; #10;
end

initial begin
    $monitor($time, "input din=%b output count=%b" , din, count);
    #120 $finish
end
    
endmodule