`timescale 1ns / 1ps

module instructionMemory (
	input [15:0] address,
	input memRead,
	output reg [31:0] instruction
);

	reg [31:0] rom [0:255];
	integer i;

	initial begin
		for (i = 0; i < 256; i = i + 1)
			rom[i] = 32'h00000000;

		// Sample program (RV32I encodings)
		rom[0] = 32'h00500093; // addi x1, x0, 5
		rom[1] = 32'h00A00113; // addi x2, x0, 10
		rom[2] = 32'h002081B3; // add  x3, x1, x2
		rom[3] = 32'h00302023; // sw   x3, 0(x0)
		rom[4] = 32'h00002203; // lw   x4, 0(x0)
		rom[5] = 32'h00000013; // nop
	end

	always @(*) begin
		if (memRead)
			instruction = rom[address[7:0]];
		else
			instruction = 32'h00000000;
	end

endmodule

