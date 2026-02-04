\# Design Explanation — Traffic Light FSM



\## 1. Architecture Summary

This module implements a two-direction traffic light controller using a

synchronous Moore FSM. It alternates traffic flow between North–South (NS)

and East–West (EW) directions. Outputs depend only on the current FSM state,

which improves predictability and simplifies verification.



\## 2. State Machine

The FSM uses four states:

\- `NS\_GREEN`

\- `NS\_YELLOW`

\- `EW\_GREEN`

\- `EW\_YELLOW`



States are defined using a SystemVerilog `enum`, improving readability and

reducing the risk of invalid encodings.



Two variables are used:

\- `state` (registered): current state

\- `next\_state` (combinational): next state decision



\## 3. Timing Mechanism (Cycle-Based Timer)

A 4-bit counter `timer` tracks the number of clock cycles spent in the current

state. The counter:

\- increments while staying in the same state

\- resets to 0 whenever a state transition occurs



This approach keeps state transition timing deterministic and easy to analyze.



\## 4. Transition Rules

\### `NS\_GREEN`

\- Minimum green duration is 10 cycles.

\- If `car\_sensor` is asserted and the timer reaches the threshold, the FSM moves

&nbsp; to `NS\_YELLOW`.

\- If `car\_sensor` is not asserted, NS can remain green beyond 10 cycles.



\### `NS\_YELLOW`

\- Fixed duration of 3 cycles, then transitions to `EW\_GREEN`.



\### `EW\_GREEN`

\- Fixed duration of 10 cycles, then transitions to `EW\_YELLOW`.



\### `EW\_YELLOW`

\- Fixed duration of 3 cycles, then transitions back to `NS\_GREEN`.



\## 5. Output Decode (Moore Outputs)

Outputs are derived only from `state`:

\- During `NS\_GREEN` / `NS\_YELLOW`, EW is red.

\- During `EW\_GREEN` / `EW\_YELLOW`, NS is red.



All outputs are assigned default 0 values before the case statement, preventing

latch inference and ensuring fully defined behavior.



\## 6. Reset Behavior

An active-low reset (`rst\_n`) initializes:

\- `state <= NS\_GREEN`

\- `timer <= 0`



This provides a safe default condition where NS traffic proceeds and EW is held

red after reset.



\## 7. What to Improve Next

Potential improvements aligned with ASIC/SoC design practices:

\- Parameterize timing constants (green/yellow durations).

\- Add SystemVerilog Assertions (SVA) to formally enforce safety properties.

\- Consider synchronous reset style depending on design guidelines.

\- Add pedestrian request inputs and additional safe states if needed.



