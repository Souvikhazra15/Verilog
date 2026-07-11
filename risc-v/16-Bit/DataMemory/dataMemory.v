`timescale 1ns / 1ps

module dataMemory (
	input clk,
	input memRead,
	input memWrite,
	input [15:0] address,
	input [15:0] writeData,
	output reg [15:0] readData
);

	reg [15:0] mem [0:255];
	integer i;

	initial begin
		for (i = 0; i < 256; i = i + 1)
			mem[i] = 16'h0000;
	end

	// Write on rising clock edge when memWrite is enabled.
	always @(posedge clk) begin
		if (memWrite)
			mem[address[7:0]] <= writeData;
	end

	// Read path is combinational and gated by memRead.
	always @(*) begin
		if (memRead)
			readData = mem[address[7:0]];
		else
			readData = 16'h0000;
	end

endmodule

