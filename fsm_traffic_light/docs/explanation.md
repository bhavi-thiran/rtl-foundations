# Design Explanation — Traffic Light FSM

## 1. Architecture Summary
This module implements a two-direction traffic light controller using a
synchronous Moore finite state machine (FSM). It alternates traffic flow
between North–South (NS) and East–West (EW) directions.

Outputs depend only on the current FSM state, which improves predictability
and simplifies verification.

## 2. State Machine
The FSM uses four states:
- `NS_GREEN`
- `NS_YELLOW`
- `EW_GREEN`
- `EW_YELLOW`

States are defined using a SystemVerilog `enum`, improving readability and
reducing the risk of invalid encodings.

Two variables are used:
- `state` (registered): current state
- `next_state` (combinational): next state decision

## 3. Timing Mechanism (Cycle-Based Timer)
A 4-bit counter `timer` tracks the number of clock cycles spent in the current
state.

The timer:
- increments when the FSM remains in the same state
- resets to zero when a state transition occurs

This approach ensures deterministic state durations and simplifies timing
analysis.

## 4. State Transitions

### NS_GREEN
- Minimum green duration of 10 cycles
- Transitions to `NS_YELLOW` only when `car_sensor` is asserted

### NS_YELLOW
- Fixed duration of 3 cycles
- Transitions to `EW_GREEN`

### EW_GREEN
- Fixed duration of 10 cycles
- Transitions to `EW_YELLOW`

### EW_YELLOW
- Fixed duration of 3 cycles
- Transitions back to `NS_GREEN`

## 5. Output Decode (Moore Outputs)
Outputs are derived only from the current FSM state:
- During NS states, EW lights remain red
- During EW states, NS lights remain red

All outputs are assigned default values before the state decode logic,
preventing latch inference.

## 6. Reset Behavior
An active-low reset (`rst_n`) initializes the FSM to:
- `NS_GREEN` state
- `timer = 0`

This guarantees a safe and deterministic startup condition.

## 7. Future Improvements
Possible enhancements aligned with ASIC/SoC design practices:
- Parameterize green/yellow timing values
- Add SystemVerilog Assertions (SVA) for safety checks
- Convert to synchronous reset if required by design guidelines
