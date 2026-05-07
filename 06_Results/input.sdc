# 1. Define Operating Environment
set_units -capacitance fF -time ns -resistance kOhm

# 2. Create Clock (Targeting 100MHz - 200MHz for power/area efficiency)
# A 5ns period is a good starting point for a balanced VLSI design.
create_clock -name clk -period 5.0 [get_ports clk]
set_clock_uncertainty 0.15 [get_clocks clk]

# 3. Input Delays (Assume 20% of clock period)
set_input_delay -clock clk 1.0 [remove_from_collection [all_inputs] clk]

# 4. Output Delays (Assume 20% of clock period)
set_output_delay -clock clk 1.0 [all_outputs]

# 5. Load and Transition (To prevent unrealistic drive strengths)
set_load 10 [all_outputs]
set_input_transition 0.1 [all_inputs]

# 6. Optimization Directives for Area/Power
# This tells the tool to prioritize area over timing if possible
set_max_area 0
