`timescale 1ns/1ps

module digital_clock_tb;

    reg clk;
    reg rst;
    wire [5:0] secs;
    wire [5:0] mins;
    wire [4:0] hrs;

    digital_clock uut (
        .clk(clk),
        .rst(rst),
        .secs(secs),
        .mins(mins),
        .hrs(hrs)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #20;
        rst = 0;
        #500000;
        $finish;
    end

    initial begin
        $monitor("Time=%0t | %02d:%02d:%02d",
                  $time, hrs, mins, secs);
    end

endmodule