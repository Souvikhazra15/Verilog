`timescale 1ns / 1ps
`include "PC/programCounter.v"
`include "InstructionMemory/instructionMemory.v"
`include "ImmediateGenerator/immediateGenerator.v"
`include "RegisterFile/registerFile.v"
`include "alu/alu.v"
`include "DataMemory/dataMemory.v"

module processor (
	input clk,
	input rst,
	output [15:0] pc_debug,
	output [31:0] instruction_debug,
	output [15:0] alu_result_debug,
	output [15:0] mem_data_debug,
	output alu_carry_debug,
	output alu_overflow_debug
);

	// Program counter signals
	wire [15:0] pc_current;
	reg  [15:0] pc_next;
	reg         pc_load;
	reg         pc_inc;

	// Instruction and decode fields
	wire [31:0] instruction;
	wire [6:0] opcode;
	wire [2:0] funct3;
	wire [6:0] funct7;
	wire [4:0] rs1;
	wire [4:0] rs2;
	wire [4:0] rd;

	// Immediate path
	reg  [2:0]  imm_sel;
	wire [15:0] immediate;
	wire [15:0] branch_word_offset;

	// Register file path
	reg         reg_write;
	reg  [4:0]  rd_addr;
	reg  [15:0] reg_write_data;
	wire [15:0] reg_rs1_data;
	wire [15:0] reg_rs2_data;

	// ALU path
	reg  [3:0]  alu_control;
	reg  [15:0] alu_in_b;
	wire [15:0] alu_result;
	wire        alu_zero;
	wire        alu_carry;
	wire        alu_overflow;

	// Data memory path
	reg         mem_read;
	reg         mem_write;
	wire [15:0] mem_read_data;

	// Local constant
	wire [15:0] pc_plus_one;

	assign opcode = instruction[6:0];
	assign rd     = instruction[11:7];
	assign funct3 = instruction[14:12];
	assign rs1    = instruction[19:15];
	assign rs2    = instruction[24:20];
	assign funct7 = instruction[31:25];

	assign branch_word_offset = {immediate[15], immediate[15:1]};
	assign pc_plus_one        = pc_current + 16'h0001;

	// Program Counter
	programCounter pc_u (
		.clk(clk),
		.rst(rst),
		.load(pc_load),
		.inc(pc_inc),
		.pc_in(pc_next),
		.pc_out(pc_current)
	);

	// Instruction Memory (word-addressed)
	instructionMemory imem_u (
		.address(pc_current),
		.memRead(1'b1),
		.instruction(instruction)
	);

	// Immediate Generator
	immediateGenerator imm_u (
		.instruction(instruction),
		.immSel(imm_sel),
		.immediate(immediate)
	);

	// Register File
	registerFile rf_u (
		.clk(clk),
		.rst(rst),
		.regWrite(reg_write),
		.readReg1(rs1),
		.readReg2(rs2),
		.writeReg(rd_addr),
		.writeData(reg_write_data),
		.readData1(reg_rs1_data),
		.readData2(reg_rs2_data)
	);

	// ALU
	alu alu_u (
		.A(reg_rs1_data),
		.B(alu_in_b),
		.ALU_Control(alu_control),
		.Result(alu_result),
		.Zero(alu_zero),
		.Carry(alu_carry),
		.Overflow(alu_overflow)
	);

	// Data Memory
	dataMemory dmem_u (
		.clk(clk),
		.memRead(mem_read),
		.memWrite(mem_write),
		.address(alu_result),
		.writeData(reg_rs2_data),
		.readData(mem_read_data)
	);

	// Main control and datapath muxes
	always @(*) begin
		// Default control values
		imm_sel        = 3'b000;
		alu_control    = 4'b0000;
		alu_in_b       = reg_rs2_data;
		reg_write      = 1'b0;
		rd_addr        = rd;
		reg_write_data = alu_result;
		mem_read       = 1'b0;
		mem_write      = 1'b0;

		// PC defaults: sequential execution
		pc_inc         = 1'b1;
		pc_load        = 1'b0;
		pc_next        = 16'h0000;

		case (opcode)
			// R-type
			7'b0110011: begin
				reg_write = 1'b1;
				case ({funct7, funct3})
					{7'b0000000, 3'b000}: alu_control = 4'b0000; // ADD
					{7'b0100000, 3'b000}: alu_control = 4'b0001; // SUB
					{7'b0000000, 3'b111}: alu_control = 4'b0010; // AND
					{7'b0000000, 3'b110}: alu_control = 4'b0011; // OR
					{7'b0000000, 3'b100}: alu_control = 4'b0100; // XOR
					default: begin
						alu_control = 4'b0000;
						reg_write   = 1'b0;
					end
				endcase
			end

			// I-type arithmetic (addi/andi/ori/xori)
			7'b0010011: begin
				imm_sel   = 3'b000;
				alu_in_b  = immediate;
				reg_write = 1'b1;
				case (funct3)
					3'b000: alu_control = 4'b0000; // ADDI
					3'b111: alu_control = 4'b0010; // ANDI
					3'b110: alu_control = 4'b0011; // ORI
					3'b100: alu_control = 4'b0100; // XORI
					default: begin
						alu_control = 4'b0000;
						reg_write   = 1'b0;
					end
				endcase
			end

			// LOAD (LW)
			7'b0000011: begin
				imm_sel        = 3'b000;
				alu_in_b       = immediate;
				alu_control    = 4'b0000; // base + offset
				mem_read       = 1'b1;
				reg_write      = 1'b1;
				reg_write_data = mem_read_data;
			end

			// STORE (SW)
			7'b0100011: begin
				imm_sel     = 3'b001;
				alu_in_b    = immediate;
				alu_control = 4'b0000; // base + offset
				mem_write   = 1'b1;
			end

			// BRANCH (BEQ only)
			7'b1100011: begin
				imm_sel     = 3'b010;
				alu_control = 4'b0001; // compare rs1-rs2
				if (funct3 == 3'b000 && alu_zero) begin
					pc_inc  = 1'b0;
					pc_load = 1'b1;
					pc_next = pc_current + branch_word_offset;
				end
			end

			// JAL
			7'b1101111: begin
				imm_sel        = 3'b100;
				reg_write      = 1'b1;
				reg_write_data = pc_plus_one;
				pc_inc         = 1'b0;
				pc_load        = 1'b1;
				pc_next        = pc_current + branch_word_offset;
			end

			default: begin
				// Unsupported opcode behaves like NOP
			end
		endcase
	end

	assign pc_debug          = pc_current;
	assign instruction_debug = instruction;
	assign alu_result_debug  = alu_result;
	assign mem_data_debug    = mem_read_data;
	assign alu_carry_debug   = alu_carry;
	assign alu_overflow_debug = alu_overflow;

endmodule

