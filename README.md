```markdown
#Traffic Light FSM (SystemVerilog)

## Overview
A synchronous Moore-style finite state machine (FSM) for a two-direction
traffic light controller (North–South vs East–West).

The design uses a cycle-based timer to control green/yellow durations and a
`car_sensor` input to request a switch from NS to EW.

## Interface

### Inputs
- `clk`: system clock
- `rst_n`: active-low reset
- `car_sensor`: vehicle request on EW side

### Outputs
- NS lights: `ns_red`, `ns_yel`, `ns_grn`
- EW lights: `ew_red`, `ew_yel`, `ew_grn`

## Design Highlights
- Clear separation of:
  - combinational next-state logic (`always_comb`)
  - sequential state/timer registers (`always_ff`)
  - Moore output decode (`always_comb`)
- Deterministic reset behavior (starts at `NS_GREEN`)
- Safe output mapping (only one direction can be green/yellow at a time)

## Verification
Simulated in ModelSim using a directed testbench.  
Waveform evidence is stored in `docs/waveforms.png`.

## How to Run (ModelSim)

From the project directory:

```tcl
vlib work
vlog -sv rtl/traffic_fsm.sv tb/traffic_fsm_tb.sv
vsim work.traffic_fsm_tb
add wave *
run -all
