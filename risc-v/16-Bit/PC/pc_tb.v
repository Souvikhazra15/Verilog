`timescale 1ns / 1ps
`include "programCounter.v"

module pc_tb;

	reg clk;
	reg rst;
	reg load;
	reg inc;
	reg [15:0] pc_in;
	wire [15:0] pc_out;

	integer errors;

	programCounter dut (
		.clk(clk),
		.rst(rst),
		.load(load),
		.inc(inc),
		.pc_in(pc_in),
		.pc_out(pc_out)
	);

	initial begin
		clk = 1'b0;
		forever #5 clk = ~clk;
	end

	task check_pc;
		input [15:0] exp_pc;
		begin
			if (pc_out !== exp_pc) begin
				errors = errors + 1;
				$display("FAIL t=%0t pc_out=%h expected=%h", $time, pc_out, exp_pc);
			end else begin
				$display("PASS t=%0t pc_out=%h", $time, pc_out);
			end
		end
	endtask

	initial begin
		$dumpfile("pc_tb.vcd");
		$dumpvars(0, pc_tb);

		errors = 0;
		rst    = 1'b1;
		load   = 1'b0;
		inc    = 1'b0;
		pc_in  = 16'h0000;

		// Apply reset
		@(posedge clk);
		#1 check_pc(16'h0000);

		// Release reset and increment
		rst = 1'b0;
		inc = 1'b1;
		@(posedge clk);
		#1 check_pc(16'h0001);

		@(posedge clk);
		#1 check_pc(16'h0002);

		// Hold value when inc=0 and load=0
		inc = 1'b0;
		@(posedge clk);
		#1 check_pc(16'h0002);

		// Load explicit value
		load  = 1'b1;
		pc_in = 16'h00A5;
		@(posedge clk);
		#1 check_pc(16'h00A5);

		// Priority check: load should win over inc
		inc   = 1'b1;
		load  = 1'b1;
		pc_in = 16'h0F0F;
		@(posedge clk);
		#1 check_pc(16'h0F0F);

		// Increment after load
		load = 1'b0;
		inc  = 1'b1;
		@(posedge clk);
		#1 check_pc(16'h0F10);

		// Reset priority check
		rst  = 1'b1;
		load = 1'b1;
		inc  = 1'b1;
		pc_in = 16'hFFFF;
		@(posedge clk);
		#1 check_pc(16'h0000);

		if (errors == 0)
			$display("\nALL PC TESTS PASSED\n");
		else
			$display("\nPC TESTS FAILED: %0d case(s)\n", errors);

		#10 $finish;
	end

endmodule

