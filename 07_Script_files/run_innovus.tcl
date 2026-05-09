# ============================================================
# MMMC SETUP
# ============================================================
set_global _enable_mmmc_by_default_flow $CTE::mmmc_default
suppressMessage ENCEXT-2799
getVersion
win
save_global Default.globals


# ============================================================
# DESIGN INITIALIZATION
# ============================================================
set init_gnd_net vss
set init_pwr_net vdd

# FIX 1: only ONE LEF
set init_lef_file {../../../install/FOUNDRY_1/digital/90nm/dig/lef/gsclib090_translated.lef}

set init_verilog syn_netlist.v
set init_mmmc_file Default.view

init_design

getIoFlowFlag
setIoFlowFlag 0

# ============================================================
# FLOORPLAN
# ============================================================
floorPlan -site gsclib090site -r 0.746069556932 0.700016 10 10 10 10

# ============================================================
# POWER NET CONNECTION
# ============================================================
globalNetConnect vdd -type pgpin -pin VDD -all
globalNetConnect vss -type pgpin -pin VSS -all
applyGlobalNets

# ============================================================
# CORE RINGS
# ============================================================
setAddRingMode -ring_target default

addRing -nets {vdd vss} -type core_rings -follow core \
-layer {top Metal9 bottom Metal9 left Metal8 right Metal8} \
-width {top 1.8 bottom 1.8 left 1.8 right 1.8} \
-spacing {top 0.5 bottom 0.5 left 0.5 right 0.5} \
-offset {top 1.8 bottom 1.8 left 1.8 right 1.8}

# ============================================================
# STRIPES 
# ============================================================
addStripe -nets {vdd vss} -layer Metal9 -direction horizontal \
-width 1.8 -spacing 0.5 -number_of_sets 2

addStripe -nets {vdd vss} -layer Metal8 -direction vertical \
-width 1.8 -spacing 0.5 -number_of_sets 2

# ============================================================
# POWER ROUTING (CORE DESIGN ONLY)
# ============================================================
sroute -connect { corePin } -nets { vdd vss }

# ============================================================
# END CAPS + WELL TAPS
# ============================================================
addEndCap -preCap FILL2 -postCap FILL2 -prefix ENDCAP
addWellTap -cell FILL2 -cellInterval 40 -prefix WELLTAP

# ============================================================
# PLACEMENT SETTINGS
# ============================================================
setPlaceMode -congEffort auto \
             -timingDriven true \
             -clkGateAware true \
             -ignoreScan true \
             -placeIOPins true

# ============================================================
# RUN PLACEMENT
# ============================================================
place_design

# ============================================================
# PRE-CTS OPTIMIZATION SETTINGS
# ============================================================
setOptMode -fixCap true \
           -fixTran true \
           -fixFanoutLoad true

# ============================================================
# PRE-CTS OPT
# ============================================================
optDesign -preCTS -setup
timeDesign -preCTS -setup > timing_preCTS_setup.rpt

# CTS (CRITICAL)

getCTSMode -engine -quiet
create_ccopt_clock_tree_spec
ctd_win -side none -id ctd_window -unit_delay -include_reporting_only_skew_groups


#post cts optimization
optDesign -postCTS -setup -hold
timeDesign -postCTS -setup > timing_postCTS_setup.rpt
timeDesign -postCTS -hold  > timing_postCTS_hold.rpt


# nano route
setNanoRouteMode -quiet -routeWithTimingDriven 1
setNanoRouteMode -quiet -routeTopRoutingLayer 9
setNanoRouteMode -quiet -routeBottomRoutingLayer 1
setNanoRouteMode -quiet -drouteEndIteration 1
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven false
routeDesign -globalDetail
setAnalysisMode -cppr none -clockGatingCheck true -timeBorrowing true -useOutputPinCap true -sequentialConstProp false -timingSelfLoopsNoSkew false -enableMultipleDriveNet true -clkSrcPath true -warn true -usefulSkew true -analysisType onChipVariation -log true
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null

# POST-ROUTE
optDesign -postRoute -setup -hold
timeDesign -postRoute -setup > timing_postRoute_setup.rpt
timeDesign -postRoute -hold  > timing_postRoute_hold.rpt

timeDesign -postRoute -pathReports -drvReports -slackReports -numPaths 50 -prefix counter_postRoute -outDir timingReports
getFillerMode -quiet



#adding fillers

addFiller -cell FILL32 FILL4 FILL16 FILL8 FILL64 FILL2 FILL1 -prefix FILLER

#dowlanding pd_netlist

saveNetlist pd_netlist.v

#dowlanding gds

streamOut final_gds -libName DesignLib -units 2000 -mode ALL

#checking design

checkDesign -io -netlist -physicalLibrary -powerGround -tieHilo -timingLibrary -spef -floorplan -place -noHtml -outfile checkDesign.rpt

# GETTING GATE COUNT
reportGateCount -level 5 -limit 100 -outfile counter.gateCount

# DESIN BROWSER

loadWorkspace -name {Design Browser + Physical}

#REPORTS

report_area > pd_area.repo
report_power > pd_power.repo
report_design > pd_design.repo
report_timing > pd_timing.repo
report_timing -unconstrained > pd_untiming.repo
