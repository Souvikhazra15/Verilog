
# Rock-Paper-Scissors (Verilog)

Professional, compact Rock–Paper–Scissors (RPS) game implemented in synthesizable Verilog with a testbench for functional verification.

## Overview

This repository contains a simple hardware implementation of the classic Rock–Paper–Scissors game intended for learning, simulation, and small FPGA experiments. The design exercises combinational logic, simple state handling, and testbench-driven verification.

## Features

- Implements RPS decision logic for two players (A and B).
- Clean, synthesizable Verilog suitable for simulation and basic synthesis.
- Testbench (`rps_tb.v`) included to validate all outcome cases (win/lose/tie).

## Repository Structure

- rps.v — RPS Verilog module
- rps_tb.v — Testbench for simulation
- readme.md — This file

## Usage / Simulation

Quick simulation using Icarus Verilog:

```bash
iverilog -o rps_tb rps.v rps_tb.v
vvp rps_tb
```

If the testbench generates a VCD waveform file (e.g., `dump.vcd`), view it with GTKWave:

```bash
gtkwave dump.vcd
```

## Design Notes

- Inputs: two player choice buses (e.g., 2-bit encoding: 00=rock, 01=paper, 10=scissors) — check `rps.v` for exact pin names and encoding.
- Output: result signals indicating win/lose/tie (per-player or encoded result bus).
- The module is designed to be deterministic and combinational; if you need handshaking or a clocked interface, wrap the combinational core inside a registered wrapper.

## Testing

- The included `rps_tb.v` enumerates all choice combinations to verify correctness and exercise edge cases.
- Add assertions or $display checks in the testbench for automated pass/fail reporting.

## Synthesis

The RPS core is written to be synthesizable. When targeting an FPGA, add appropriate I/O constraints and timing directives for the target device.

## Contributing

Improvements and bug fixes are welcome. Please open an issue or submit a pull request with a description of the change and updated tests.

## License

Choose and add a license (for example, MIT) or contact the repository owner for licensing details.

## Author

Maintained by the repository owner. For questions or feedback, open an issue in this repository.
