# src

> Folder containing the source code (RTL/HDL, testbenches, simulation scripts...) of the project.

## File list

| File | Description | Note |
|---|---|---|
| pe_mac.v | Single Processing Element (MAC unit) |  |
| systolic_array.v | N x N Systolic Array top module |  |
| tb_systolic_array.v | Simulation testbench |  |

## Tools used
- Icarus Verilog (simulation)
- Intel Quartus Prime (synthesis, target: DE10 board)

## Build / simulation instructions
```bash
iverilog -g2012 -o sim.out pe_mac.v systolic_array.v tb_systolic_array.v
vvp sim.out
```
