`timescale 1ns / 1ps
`include "dataMemory.v"

module dataMemory_tb;

	reg clk;
	reg memRead;
	reg memWrite;
	reg [15:0] address;
	reg [15:0] writeData;
	wire [15:0] readData;

	integer errors;

	dataMemory dut (
		.clk(clk),
		.memRead(memRead),
		.memWrite(memWrite),
		.address(address),
		.writeData(writeData),
		.readData(readData)
	);

	initial begin
		clk = 1'b0;
		forever #5 clk = ~clk;
	end

	task check_read;
		input [15:0] exp_read;
		begin
			#1;
			if (readData !== exp_read) begin
				errors = errors + 1;
				$display("FAIL t=%0t addr=%h readData=%h expected=%h", $time, address, readData, exp_read);
			end else begin
				$display("PASS t=%0t addr=%h readData=%h", $time, address, readData);
			end
		end
	endtask

	initial begin
		$dumpfile("dataMemory_tb.vcd");
		$dumpvars(0, dataMemory_tb);

		errors   = 0;
		memRead  = 1'b0;
		memWrite = 1'b0;
		address  = 16'h0000;
		writeData = 16'h0000;

		// Read disabled should drive zero.
		check_read(16'h0000);

		// Write 0x1234 to address 0x0002.
		address   = 16'h0002;
		writeData = 16'h1234;
		memWrite  = 1'b1;
		@(posedge clk);
		memWrite  = 1'b0;

		// Read back address 0x0002.
		memRead = 1'b1;
		check_read(16'h1234);

		// Write and read another location.
		memRead   = 1'b0;
		address   = 16'h000A;
		writeData = 16'hBEEF;
		memWrite  = 1'b1;
		@(posedge clk);
		memWrite  = 1'b0;

		memRead = 1'b1;
		check_read(16'hBEEF);

		// Check previous location remains unchanged.
		address = 16'h0002;
		check_read(16'h1234);

		// Address wraps to lower 8 bits.
		memRead   = 1'b0;
		address   = 16'h0102;
		writeData = 16'hCAFE;
		memWrite  = 1'b1;
		@(posedge clk);
		memWrite  = 1'b0;

		memRead = 1'b1;
		check_read(16'hCAFE);

		// Read disabled output check.
		memRead = 1'b0;
		check_read(16'h0000);

		if (errors == 0)
			$display("\nALL DATA MEMORY TESTS PASSED\n");
		else
			$display("\nDATA MEMORY TESTS FAILED: %0d case(s)\n", errors);

		#10 $finish;
	end

endmodule

