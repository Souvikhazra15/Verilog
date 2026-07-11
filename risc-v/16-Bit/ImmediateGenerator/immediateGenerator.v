`timescale 1ns / 1ps

module immediateGenerator (
	input  [31:0] instruction,
	input  [2:0]  immSel,
	output reg [15:0] immediate
);

	reg [31:0] imm32;

	always @(*) begin
		case (immSel)
			// I-type immediate: instr[31:20]
			3'b000: imm32 = {{20{instruction[31]}}, instruction[31:20]};

			// S-type immediate: instr[31:25] | instr[11:7]
			3'b001: imm32 = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

			// B-type immediate (branch), LSB is always 0
			3'b010: imm32 = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

			// U-type immediate: upper immediate value
			3'b011: imm32 = {instruction[31:12], 12'b0};

			// J-type immediate (jump), LSB is always 0
			3'b100: imm32 = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};

			default: imm32 = 32'h00000000;
		endcase

		immediate = imm32[15:0];
	end

endmodule

