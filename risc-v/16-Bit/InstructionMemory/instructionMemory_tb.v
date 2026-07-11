`timescale 1ns / 1ps
`include "instructionMemory.v"

module instructionMemory_tb;

	reg [15:0] address;
	reg memRead;
	wire [31:0] instruction;

	integer errors;

	instructionMemory dut (
		.address(address),
		.memRead(memRead),
		.instruction(instruction)
	);

	task check_instruction;
		input [31:0] exp_instruction;
		begin
			#1;
			if (instruction !== exp_instruction) begin
				errors = errors + 1;
				$display("FAIL t=%0t addr=%h instruction=%h expected=%h", $time, address, instruction, exp_instruction);
			end else begin
				$display("PASS t=%0t addr=%h instruction=%h", $time, address, instruction);
			end
		end
	endtask

	initial begin
		$dumpfile("instructionMemory_tb.vcd");
		$dumpvars(0, instructionMemory_tb);

		errors = 0;
		address = 16'h0000;
		memRead = 1'b0;

		// Read disabled should output zero.
		check_instruction(32'h00000000);

		memRead = 1'b1;

		address = 16'h0000;
		check_instruction(32'h00500093);

		address = 16'h0001;
		check_instruction(32'h00A00113);

		address = 16'h0002;
		check_instruction(32'h002081B3);

		address = 16'h0003;
		check_instruction(32'h00302023);

		address = 16'h0004;
		check_instruction(32'h00002203);

		address = 16'h0005;
		check_instruction(32'h00000013);

		// Uninitialized location should be zero.
		address = 16'h0010;
		check_instruction(32'h00000000);

		// Address wraps to lower 8 bits.
		address = 16'h0101;
		check_instruction(32'h00A00113);

		memRead = 1'b0;
		check_instruction(32'h00000000);

		if (errors == 0)
			$display("\nALL INSTRUCTION MEMORY TESTS PASSED\n");
		else
			$display("\nINSTRUCTION MEMORY TESTS FAILED: %0d case(s)\n", errors);

		#10 $finish;
	end

endmodule

