`timescale 1ns / 1ps
`include "registerFile.v"

module registerFile_tb;

	reg clk;
	reg rst;
	reg regWrite;
	reg [4:0] readReg1;
	reg [4:0] readReg2;
	reg [4:0] writeReg;
	reg [15:0] writeData;
	wire [15:0] readData1;
	wire [15:0] readData2;

	integer errors;

	registerFile dut (
		.clk(clk),
		.rst(rst),
		.regWrite(regWrite),
		.readReg1(readReg1),
		.readReg2(readReg2),
		.writeReg(writeReg),
		.writeData(writeData),
		.readData1(readData1),
		.readData2(readData2)
	);

	initial begin
		clk = 1'b0;
		forever #5 clk = ~clk;
	end

	task check_read1;
		input [15:0] expected;
		begin
			#1;
			if (readData1 !== expected) begin
				errors = errors + 1;
				$display("FAIL t=%0t readData1=%h expected=%h", $time, readData1, expected);
			end else begin
				$display("PASS t=%0t readData1=%h", $time, readData1);
			end
		end
	endtask

	task check_read2;
		input [15:0] expected;
		begin
			#1;
			if (readData2 !== expected) begin
				errors = errors + 1;
				$display("FAIL t=%0t readData2=%h expected=%h", $time, readData2, expected);
			end else begin
				$display("PASS t=%0t readData2=%h", $time, readData2);
			end
		end
	endtask

	initial begin
		$dumpfile("registerFile_tb.vcd");
		$dumpvars(0, registerFile_tb);

		errors = 0;
		rst = 1'b1;
		regWrite = 1'b0;
		readReg1 = 5'd0;
		readReg2 = 5'd0;
		writeReg = 5'd0;
		writeData = 16'h0000;

		// Apply reset
		@(posedge clk);
		#1;

		// x0 must always be zero
		readReg1 = 5'd0;
		check_read1(16'h0000);

		// Release reset and write to x1
		rst = 1'b0;
		writeReg = 5'd1;
		writeData = 16'h1234;
		regWrite = 1'b1;
		@(posedge clk);
		regWrite = 1'b0;

		readReg1 = 5'd1;
		check_read1(16'h1234);

		// Write to x2 and read both x1 and x2
		writeReg = 5'd2;
		writeData = 16'hABCD;
		regWrite = 1'b1;
		@(posedge clk);
		regWrite = 1'b0;

		readReg1 = 5'd1;
		readReg2 = 5'd2;
		check_read1(16'h1234);
		check_read2(16'hABCD);

		// Attempt write to x0 should be ignored
		writeReg = 5'd0;
		writeData = 16'hFFFF;
		regWrite = 1'b1;
		@(posedge clk);
		regWrite = 1'b0;

		readReg1 = 5'd0;
		check_read1(16'h0000);

		// regWrite disabled should not modify destination register
		writeReg = 5'd3;
		writeData = 16'h5555;
		regWrite = 1'b0;
		@(posedge clk);

		readReg1 = 5'd3;
		check_read1(16'h0000);

		// Reset should clear all writable registers
		rst = 1'b1;
		@(posedge clk);
		rst = 1'b0;

		readReg1 = 5'd1;
		readReg2 = 5'd2;
		check_read1(16'h0000);
		check_read2(16'h0000);

		if (errors == 0)
			$display("\nALL REGISTER FILE TESTS PASSED\n");
		else
			$display("\nREGISTER FILE TESTS FAILED: %0d case(s)\n", errors);

		#10 $finish;
	end

endmodule

