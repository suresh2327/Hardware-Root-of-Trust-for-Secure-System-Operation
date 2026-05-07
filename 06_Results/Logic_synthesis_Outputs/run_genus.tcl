# Library
read_lib /home/install/FOUNDRY/digital/90nm/dig/lib/fast.lib

# RTL
read_hdl -sv design.sv
elaborate

# Constraints
read_sdc input.sdc

# Synthesis
syn_generic -effort high
syn_map	 -effort high
syn_opt  -effort high

# Outputs
write_hdl  > syn_netlist.v
write_sdc  > output.sdc

# Reports
report_area                > syn_area.repo
report_power               > syn_power.repo
report_timing              > syn_timing.repo
report_timing -unconstrained > syn_untiming.repo
report_gates               > syn_gates.repo
report_design              > syn_design.repo

#GUI SHOW
 gui_show

