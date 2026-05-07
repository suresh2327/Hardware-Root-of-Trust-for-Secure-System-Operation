#========================================================
# SDC File - Hardware Root-of-Trust (RoT)
# Optimized for Cadence Genus Synthesis
#========================================================

#-------------------------------
# Clock Definition
#-------------------------------
create_clock -name clk -period 10 [get_ports clk]

# Clock Uncertainty
set_clock_uncertainty 0.2 [get_clocks clk]

# Clock Transition
set_clock_transition 0.1 [get_clocks clk]

#-------------------------------
# Input Delays
#-------------------------------
set_input_delay 1.0 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]

#-------------------------------
# Output Delays
#-------------------------------
set_output_delay 1.0 -clock clk [all_outputs]

#-------------------------------
# Driving Cell Assumptions
#-------------------------------
set_driving_cell -lib_cell BUF_X4 [all_inputs]

#-------------------------------
# Output Load Assumptions
#-------------------------------
set_load 0.05 [all_outputs]

#-------------------------------
# Fanout Optimization
#-------------------------------
set_max_fanout 8 [current_design]

#-------------------------------
# Transition Constraints
#-------------------------------
set_max_transition 0.3 [current_design]

#-------------------------------
# Area Optimization
#-------------------------------
set_max_area 0

#-------------------------------
# False Paths
# Reset Path Excluded
#-------------------------------
set_false_path -from [get_ports rst_n]

#-------------------------------
# Multicycle Paths
# SHA-256 iterative rounds
# Helps timing optimization
#-------------------------------
set_multicycle_path 2 -setup \
-from [get_registers *round*] \
-to [get_registers *round*]

set_multicycle_path 1 -hold \
-from [get_registers *round*] \
-to [get_registers *round*]

#-------------------------------
# Power Optimization Hint
#-------------------------------
set_dynamic_optimization true

#-------------------------------
# Wire Load Model
#-------------------------------
set_wire_load_mode top

#-------------------------------
# Operating Conditions
#-------------------------------
set_operating_conditions -max_library typical -max typical

#========================================================
# End of SDC
#========================================================
