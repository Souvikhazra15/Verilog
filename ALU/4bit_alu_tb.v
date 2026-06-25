// Code your testbench here
// or browse Examples
module alu_4bit_tb;
    reg [3:0] a, b;
    reg [3:0] opcode;
    reg enable;

    wire [3:0] ALU_out;
    wire zero, negative, carry, overflow;

    // Instantiate DUT
    alu_4bit dut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .enable(enable),
        .ALU_out(ALU_out),
        .zero(zero),
        .negative(negative),
        .carry(carry),
        .overflow(overflow)
    );

    initial begin

        $display("Time\ta\tb\topcode\tALU_out\tZ\tN\tC\tV");
      
        enable = 1;

        a = 4'd5; b = 4'd3; opcode = 4'b0000;
        #10;
        $display("%0t\t%d\t%d\tADD\t%b\t%b\t%b\t%b\t%b",
                 $time,a,b,ALU_out,zero,negative,carry,overflow);

        a = 4'd7; b = 4'd2; opcode = 4'b0001;
        #10;
        $display("%0t\t%d\t%d\tSUB\t%b\t%b\t%b\t%b\t%b",
                 $time,a,b,ALU_out,zero,negative,carry,overflow);

        a = 4'd8; b = 0; opcode = 4'b0010;
        #10;
        $display("%0t\t%d\t-\tINC\t%b\t%b\t%b\t%b\t%b",
                 $time,a,ALU_out,zero,negative,carry,overflow);

        a = 4'd8; b = 0; opcode = 4'b0011;
        #10;
        $display("%0t\t%d\t-\tDEC\t%b\t%b\t%b\t%b\t%b",
                 $time,a,ALU_out,zero,negative,carry,overflow);

        a = 4'b1100;
        b = 4'b1010;
        opcode = 4'b0100;
        #10;
        $display("%0t\t%b\t%b\tAND\t%b\t%b\t%b\t%b\t%b",
                 $time,a,b,ALU_out,zero,negative,carry,overflow);

        opcode = 4'b0101;
        #10;
        $display("%0t\t%b\t%b\tOR\t%b\t%b\t%b\t%b\t%b",
                 $time,a,b,ALU_out,zero,negative,carry,overflow);

        opcode = 4'b0110;
        #10;
        $display("%0t\t%b\t%b\tXOR\t%b\t%b\t%b\t%b\t%b",
                 $time,a,b,ALU_out,zero,negative,carry,overflow);

        opcode = 4'b0111;
        #10;
        $display("%0t\t%b\t-\tNOT\t%b\t%b\t%b\t%b\t%b",
                 $time,a,ALU_out,zero,negative,carry,overflow);

        a = 4'b1011;
        opcode = 4'b1000;
        #10;
        $display("%0t\t%b\t-\tSLL\t%b\t%b\t%b\t%b\t%b",
                 $time,a,ALU_out,zero,negative,carry,overflow);

        opcode = 4'b1001;
        #10;
        $display("%0t\t%b\t-\tSRL\t%b\t%b\t%b\t%b\t%b",
                 $time,a,ALU_out,zero,negative,carry,overflow);

        opcode = 4'b1010;
        #10;
        $display("%0t\t%b\t-\tSRA\t%b\t%b\t%b\t%b\t%b",
                 $time,a,ALU_out,zero,negative,carry,overflow);

        enable = 0;
        opcode = 4'b0000;
        a = 4'd9;
        b = 4'd2;
        #10;
        $display("%0t\tDisabled\tOutput=%b", $time, ALU_out);

        $finish;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, alu_4bit_tb);
    end

endmodule