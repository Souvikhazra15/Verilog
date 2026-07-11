`timescale 1ns / 1ps

module registerFile (
	input clk,
	input rst,
	input regWrite,
	input [4:0] readReg1,
	input [4:0] readReg2,
	input [4:0] writeReg,
	input [15:0] writeData,
	output [15:0] readData1,
	output [15:0] readData2
);

	reg [15:0] regs [0:31];
	integer i;

	always @(posedge clk) begin
		if (rst) begin
			for (i = 0; i < 32; i = i + 1)
				regs[i] <= 16'h0000;
		end else if (regWrite && (writeReg != 5'd0)) begin
			regs[writeReg] <= writeData;
		end

		regs[0] <= 16'h0000;
	end

	assign readData1 = (readReg1 == 5'd0) ? 16'h0000 : regs[readReg1];
	assign readData2 = (readReg2 == 5'd0) ? 16'h0000 : regs[readReg2];

endmodule

