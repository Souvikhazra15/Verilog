// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module traffic_light_fsm_tb;

    reg clk;
    wire [2:0] light;
  
    traffic_light_fsm dut(
        .clk(clk),
        .light(light)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        $display("Time\tClock\tLight");
        $monitor("%0t\t%b\t%b", $time, clk, light);

        #50;
        $finish;

    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, traffic_light_fsm_tb);
    end

endmodule