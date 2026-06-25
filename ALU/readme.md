![Uploading image.png…]()

# 4-bit ALU (Verilog)

Professional, compact 4-bit Arithmetic Logic Unit (ALU) implemented in synthesizable Verilog with a testbench for functional verification.

## Overview

This project implements a parameterizable 4-bit ALU supporting common arithmetic and logic operations. It is intended as a learning resource and a small reusable hardware module for FPGA or ASIC projects.

## Features

- Supports 4-bit operands (A, B) and a set of operations (add, subtract, and, or, xor, not, pass-through).
- Single clock or combinational operation (depending on module implementation).
- Simple, readable Verilog suitable for synthesis and simulation.
- Includes a testbench (`4bit_alu_tb.v`) to exercise primary operations and edge cases.

## Repository Structure

- 4bit.v — ALU Verilog source
- 4bit_alu_tb.v — Testbench for simulation
- readme.md — This file

## Usage / Simulation

Recommended quick simulation using Icarus Verilog:

```bash
iverilog -o alu_tb 4bit.v 4bit_alu_tb.v
vvp alu_tb
```

For waveform inspection, generate a VCD in the testbench and open with GTKWave:

```bash
gtkwave dump.vcd
```

## Design Notes

- Width: 4 bits (can be generalized by modifying the parameter in `4bit.v`).
- Outputs include result bus and status flags (e.g., zero, carry, overflow) — see `4bit.v` for signal names and mapping.
- Testbench provides stimulus vectors and basic assertions to validate behavior across operations.

## Synthesis

The code is written with synthesis in mind. Keep tool-specific constraints and timing closure in mind when integrating into larger designs or FPGAs.

## Contributing

Contributions, improvements, or bug fixes are welcome. Please fork the repo and submit a pull request with a concise description of changes and test updates.

## License

Specify your preferred license here (e.g., MIT) or contact the author for licensing details.

## Author

Project maintained by the repository owner. For questions or feedback, open an issue in this repository.
