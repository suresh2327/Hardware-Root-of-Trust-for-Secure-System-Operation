# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.14-s082_1 on Thu May 07 13:35:42 IST 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design rot_top

create_clock -name "clk" -period 10.0 -waveform {0.0 5.0} [get_ports clk]
set_clock_transition 0.1 [get_clocks clk]
set_load -pin_load 0.05 [get_ports cpu_reset_n]
set_load -pin_load 0.05 [get_ports boot_done]
set_load -pin_load 0.05 [get_ports boot_pass]
set_load -pin_load 0.05 [get_ports secure_mode]
set_false_path -from [get_ports rst_n]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports rst_n]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports boot_req]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[31]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[30]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[29]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[28]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[27]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[26]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[25]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[24]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[23]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[22]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[21]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[20]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[19]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[18]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[17]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[16]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[15]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[14]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[13]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[12]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[11]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[10]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[9]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[8]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[7]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[6]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[5]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[4]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[3]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[2]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_data[0]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports fw_valid]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports fw_last]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_strobe[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {fw_strobe[0]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports cpu_reset_n]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports boot_done]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports boot_pass]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports secure_mode]
set_max_fanout 8.000 [current_design]
set_max_transition 0.3 [current_design]
set_wire_load_mode "top"
set_clock_uncertainty -setup 0.2 [get_clocks clk]
set_clock_uncertainty -hold 0.2 [get_clocks clk]
## List of unsupported SDC commands ##
set_max_area 0
