`timescale 1ns / 1ps
`include "processor.v"

module processor_tb;

	reg clk;
	reg rst;

	wire [15:0] pc_debug;
	wire [31:0] instruction_debug;
	wire [15:0] alu_result_debug;
	wire [15:0] mem_data_debug;
	wire alu_carry_debug;
	wire alu_overflow_debug;

	integer errors;
	integer cycle;

	processor dut (
		.clk(clk),
		.rst(rst),
		.pc_debug(pc_debug),
		.instruction_debug(instruction_debug),
		.alu_result_debug(alu_result_debug),
		.mem_data_debug(mem_data_debug),
		.alu_carry_debug(alu_carry_debug),
		.alu_overflow_debug(alu_overflow_debug)
	);

	initial begin
		clk = 1'b0;
		forever #5 clk = ~clk;
	end

	task check16;
		input [15:0] got;
		input [15:0] exp;
		input [255:0] label;
		begin
			if (got !== exp) begin
				errors = errors + 1;
				$display("FAIL t=%0t %0s got=%h exp=%h", $time, label, got, exp);
			end else begin
				$display("PASS t=%0t %0s val=%h", $time, label, got);
			end
		end
	endtask

	task step_cycle;
		begin
			@(posedge clk);
			#1;
			cycle = cycle + 1;
			$display("CYCLE=%0d PC=%h INSTR=%h ALU=%h MEM_RD=%h C=%b V=%b",
					 cycle, pc_debug, instruction_debug, alu_result_debug,
					 mem_data_debug, alu_carry_debug, alu_overflow_debug);
		end
	endtask

	initial begin
		$dumpfile("processor_tb.vcd");
		$dumpvars(0, processor_tb);

		errors = 0;
		cycle  = 0;
		rst    = 1'b1;

		// Keep reset asserted for two clock edges.
		repeat (2) @(posedge clk);
		#1;

		check16(pc_debug, 16'h0000, "pc_after_reset");
		check16(dut.rf_u.regs[1], 16'h0000, "x1_after_reset");
		check16(dut.rf_u.regs[2], 16'h0000, "x2_after_reset");
		check16(dut.rf_u.regs[3], 16'h0000, "x3_after_reset");
		check16(dut.rf_u.regs[4], 16'h0000, "x4_after_reset");

		rst = 1'b0;

		// Execute ROM program:
		// 0: addi x1, x0, 5
		// 1: addi x2, x0, 10
		// 2: add  x3, x1, x2
		// 3: sw   x3, 0(x0)
		// 4: lw   x4, 0(x0)
		// 5: nop

		step_cycle;
		check16(dut.rf_u.regs[1], 16'h0005, "x1_after_addi");
		check16(pc_debug, 16'h0001, "pc_after_instr0");

		step_cycle;
		check16(dut.rf_u.regs[2], 16'h000A, "x2_after_addi");
		check16(pc_debug, 16'h0002, "pc_after_instr1");

		step_cycle;
		check16(dut.rf_u.regs[3], 16'h000F, "x3_after_add");
		check16(pc_debug, 16'h0003, "pc_after_instr2");

		step_cycle;
		check16(dut.dmem_u.mem[8'h00], 16'h000F, "mem0_after_sw");
		check16(pc_debug, 16'h0004, "pc_after_instr3");

		step_cycle;
		check16(dut.rf_u.regs[4], 16'h000F, "x4_after_lw");
		check16(pc_debug, 16'h0005, "pc_after_instr4");

		step_cycle;
		check16(pc_debug, 16'h0006, "pc_after_nop");

		// x0 must always stay zero.
		check16(dut.rf_u.regs[0], 16'h0000, "x0_constant_zero");

		if (errors == 0)
			$display("\nALL PROCESSOR TESTS PASSED\n");
		else
			$display("\nPROCESSOR TESTS FAILED: %0d case(s)\n", errors);

		#10 $finish;
	end

endmodule

