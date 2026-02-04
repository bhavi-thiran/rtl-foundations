# \# Traffic Light FSM (SystemVerilog)

# 

# \## Overview

# A synchronous Moore-style finite state machine (FSM) for a two-direction traffic

# light controller (North–South vs East–West). The design uses a cycle-based timer

# to control green/yellow durations and a `car\_sensor` input to request a switch

# from NS to EW.

# 

# \## Interface

# \*\*Inputs\*\*

# \- `clk`: system clock

# \- `rst\_n`: active-low reset

# \- `car\_sensor`: vehicle request on EW side

# 

# \*\*Outputs\*\*

# \- NS lights: `ns\_red`, `ns\_yel`, `ns\_grn`

# \- EW lights: `ew\_red`, `ew\_yel`, `ew\_grn`

# 

# \## Design Highlights

# \- Clear separation of:

# &nbsp; - combinational next-state logic (`always\_comb`)

# &nbsp; - sequential state/timer registers (`always\_ff`)

# &nbsp; - Moore output decode (`always\_comb`)

# \- Deterministic reset behavior (starts at `NS\_GREEN`)

# \- Safe output mapping (only one direction can be green/yellow at a time)

# 

# \## Verification

# Simulated in ModelSim using a directed testbench.

# Waveform evidence is stored in `docs/waveforms.png`.

# 

# \## How to Run (ModelSim)

# From the project directory:

# 

# ```tcl

# vlib work

# vlog -sv rtl/traffic\_fsm.sv tb/traffic\_fsm\_tb.sv

# vsim work.traffic\_fsm\_tb

# add wave \*

# run -all



