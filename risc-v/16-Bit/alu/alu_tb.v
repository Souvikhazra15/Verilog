`timescale 1ns / 1ps

module alu_tb;

    reg  [15:0] A;
    reg  [15:0] B;
    reg  [3:0]  ALU_Control;

    wire [15:0] Result;
    wire Zero;
    wire Carry;
    wire Overflow;

    integer errors;

    // Instantiate DUT
    alu dut (
        .A(A),
        .B(B),
        .ALU_Control(ALU_Control),
        .Result(Result),
        .Zero(Zero),
        .Carry(Carry),
        .Overflow(Overflow)
    );

    task run_case;
        input [15:0] a_i;
        input [15:0] b_i;
        input [3:0]  ctrl_i;
        input [15:0] exp_result;
        input        exp_zero;
        input        exp_carry;
        input        exp_overflow;
        begin
            A = a_i;
            B = b_i;
            ALU_Control = ctrl_i;
            #1;

            if ((Result !== exp_result) ||
                (Zero !== exp_zero) ||
                (Carry !== exp_carry) ||
                (Overflow !== exp_overflow)) begin
                errors = errors + 1;
                $display("FAIL t=%0t ctrl=%b A=%h B=%h -> R=%h Z=%b C=%b V=%b (exp R=%h Z=%b C=%b V=%b)",
                         $time, ALU_Control, A, B, Result, Zero, Carry, Overflow,
                         exp_result, exp_zero, exp_carry, exp_overflow);
            end else begin
                $display("PASS t=%0t ctrl=%b A=%h B=%h -> R=%h Z=%b C=%b V=%b",
                         $time, ALU_Control, A, B, Result, Zero, Carry, Overflow);
            end
        end
    endtask

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        errors = 0;

        // ADD: 1 + 1 = 2
        run_case(16'h0001, 16'h0001, 4'b0000, 16'h0002, 1'b0, 1'b0, 1'b0);

        // ADD with carry out
        run_case(16'hFFFF, 16'h0001, 4'b0000, 16'h0000, 1'b1, 1'b1, 1'b0);

        // ADD signed overflow: 32767 + 1 => -32768
        run_case(16'h7FFF, 16'h0001, 4'b0000, 16'h8000, 1'b0, 1'b0, 1'b1);

        // SUB: 7 - 3 = 4 (no borrow -> carry out asserted)
        run_case(16'h0007, 16'h0003, 4'b0001, 16'h0004, 1'b0, 1'b1, 1'b0);

        // SUB signed overflow: -32768 - 1 => 32767 (no borrow)
        run_case(16'h8000, 16'h0001, 4'b0001, 16'h7FFF, 1'b0, 1'b1, 1'b1);

        // SUB with borrow: 0 - 1 = FFFF
        run_case(16'h0000, 16'h0001, 4'b0001, 16'hFFFF, 1'b0, 1'b0, 1'b0);

        // AND
        run_case(16'hA55A, 16'h0FF0, 4'b0010, 16'h0550, 1'b0, 1'b0, 1'b0);

        // OR
        run_case(16'hA500, 16'h0FF0, 4'b0011, 16'hAFF0, 1'b0, 1'b0, 1'b0);

        // XOR
        run_case(16'hAAAA, 16'h0F0F, 4'b0100, 16'hA5A5, 1'b0, 1'b0, 1'b0);

        // SLL: 0x0001 << 4 = 0x0010
        run_case(16'h0001, 16'h0004, 4'b0101, 16'h0010, 1'b0, 1'b0, 1'b0);

        // SRL: 0x8000 >> 4 = 0x0800
        run_case(16'h8000, 16'h0004, 4'b0110, 16'h0800, 1'b0, 1'b0, 1'b0);

        // SLT signed: -1 < 1 => 1
        run_case(16'hFFFF, 16'h0001, 4'b0111, 16'h0001, 1'b0, 1'b0, 1'b0);

        // SLT signed: 2 < -1 => 0
        run_case(16'h0002, 16'hFFFF, 4'b0111, 16'h0000, 1'b1, 1'b0, 1'b0);

        // PASS A
        run_case(16'h1234, 16'hFFFF, 4'b1000, 16'h1234, 1'b0, 1'b0, 1'b0);

        // PASS B
        run_case(16'h1234, 16'hABCD, 4'b1001, 16'hABCD, 1'b0, 1'b0, 1'b0);

        // DEFAULT case
        run_case(16'h1111, 16'h2222, 4'b1111, 16'h0000, 1'b1, 1'b0, 1'b0);

        if (errors == 0)
            $display("\nALL TESTS PASSED\n");
        else
            $display("\nTESTS FAILED: %0d case(s)\n", errors);

        #5 $finish;
    end

endmodule
