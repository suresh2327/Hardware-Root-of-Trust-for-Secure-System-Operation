# Physical Design – Hardware Root-of-Trust (RoT)

## Overview

This directory contains the complete ASIC physical design implementation of the Hardware Root-of-Trust (RoT) architecture using Cadence Innovus physical design environment.

The synthesized gate-level netlist generated from Cadence Genus was implemented through floorplanning, power planning, placement, clock tree synthesis (CTS), routing, timing optimization, and GDSII generation.

The physical design flow validates the ASIC implementation feasibility of the secure boot architecture and firmware authentication hardware.

---

# Physical Design Objectives

- Implement synthesized RTL at physical layout level
- Achieve timing closure after placement and routing
- Optimize area utilization and routing congestion
- Generate ASIC-ready routed layout
- Validate post-layout timing and power behavior
- Produce final GDSII output for fabrication flow

---

# Physical Design Flow

```text
Synthesized Netlist
        ↓
Floorplanning
        ↓
Power Planning
        ↓
Placement
        ↓
Clock Tree Synthesis (CTS)
        ↓
Routing
        ↓
Timing Optimization
        ↓
Physical Verification
        ↓
GDSII Generation
```

---

# Tool Environment

| Category | Tool / Technology |
|---|---|
| Physical Design Tool | Cadence Innovus 21.15 |
| Input Netlist | Gate-Level Netlist |
| Constraint Format | SDC |
| Target Flow | ASIC Physical Implementation |
| Output Format | GDSII |

---

# Physical Design Stages

## Floorplanning

The floorplan was generated successfully by defining core utilization, routing resources, placement regions, and IO boundaries.

The floorplanning stage ensured:
- Proper module distribution
- Efficient routing resource allocation
- Balanced core utilization
- Reduced congestion probability

---

## Power Planning

Power and ground networks were created across the complete design to ensure reliable voltage delivery and stable operation during secure boot authentication.

The power planning stage focused on:
- Stable VDD/VSS distribution
- Reduced IR-drop impact
- Reliable sequential logic operation
- Routing compatibility with standard cells

---

## Placement

Standard cell placement was completed successfully with optimized cell distribution and congestion-aware implementation.

Placement optimization helped:
- Improve routing quality
- Reduce wirelength
- Support timing closure
- Maintain ASIC implementation feasibility

---

## Clock Tree Synthesis (CTS)

Clock Tree Synthesis was performed successfully to distribute clock signals across the design while minimizing skew and balancing clock latency.

CTS optimization ensured:
- Stable clock propagation
- Reduced clock skew
- Reliable sequential synchronization
- Improved timing stability

---

## Routing

Global and detailed routing were completed successfully without major routing violations.

The routed layout established:
- Full signal connectivity
- Timing-aware routing optimization
- DRC-aware interconnect generation
- ASIC-ready routed implementation

---

# Physical Design Results Summary

| Parameter | Result |
|---|---|
| Top Module | `rot_top` |
| Physical Design Tool | Cadence Innovus 21.15 |
| Total Instance Count | 17,643 |
| Total Physical Area | 165,148.011 |
| SHA-256 Core Area | 128,856.170 |
| Setup Timing Status | MET |
| Post-Route Slack | 0.040 ns |
| Total Power | 15.3378 |
| Internal Power Contribution | 75.6116% |
| Switching Power Contribution | 18.6280% |
| Leakage Power Contribution | 5.7604% |

---

# Area Analysis

Post-layout area analysis confirmed successful implementation of the Hardware Root-of-Trust architecture within the defined placement region.

The SHA-256 authentication engine occupied the majority of the physical area due to cryptographic processing complexity and sequential logic requirements.

The final implemented design achieved:
- Total Instance Count: **17,643**
- Total Physical Area: **165,148.011**

The area utilization demonstrates successful ASIC realization of the secure boot architecture.

---

# Timing Analysis

Post-route Static Timing Analysis (STA) confirmed successful timing closure after physical implementation.

Timing observations:
- Setup Timing Status: **MET**
- Post-route Slack: **0.040 ns**
- No critical setup timing violations detected

The timing closure validates reliable operation of the secure boot controller, authentication engine, and firmware verification logic after routing implementation.

---

# Power Analysis

Post-layout power analysis was performed to evaluate internal, switching, and leakage power behavior of the complete design.

Observed power characteristics:
- Total Power: **15.3378**
- Internal Power: **75.6116%**
- Switching Power: **18.6280%**
- Leakage Power: **5.7604%**

The higher internal power contribution is primarily associated with SHA-256 cryptographic processing and sequential switching activity.

---

# Generated Outputs

- Routed Gate-Level Netlist
- Timing Reports
- Area Reports
- Power Reports
- Placement Reports
- CTS Reports
- Routing Reports
- Constraint Files
- Final GDSII Layout

---

# Available Reports

| Report/File | Description |
|---|---|
| `checkDesign.rpt` | Physical design rule checks |
| `checkPlacement.rpt` | Placement validation report |
| `counter.gateCount` | Gate count summary |
| `output.sdc` | Timing constraints |
| `pd_area.repo` | Physical area analysis |
| `pd_design.repo` | Design implementation report |
| `pd_netlist.v` | Post-layout netlist |
| `pd_power.repo` | Post-layout power analysis |
| `pd_timing.repo` | Timing analysis report |
| `pd_untiming.repo` | Untimed path analysis |
| `timing_preCTS_setup.rpt` | Pre-CTS timing report |
| `timing_postCTS_setup.rpt` | Post-CTS setup timing |
| `timing_postCTS_hold.rpt` | Post-CTS hold timing |
| `timing_postRoute_setup.rpt` | Post-route setup timing |
| `timing_postRoute_hold.rpt` | Post-route hold timing |
| `final_gds` | Final GDSII layout output |

---

# Implementation Notes

- Physical implementation was completed using standard ASIC design methodology.
- Timing optimization was performed throughout placement and routing stages.
- The routed layout successfully achieved setup timing closure.
- Final GDSII generation confirms successful RTL-to-GDSII implementation flow.

---

# Objective

To implement the Hardware Root-of-Trust architecture as a physically realizable ASIC layout while maintaining secure boot functionality, timing closure, and hardware implementation integrity.

---

# Team Information

## Team Name
**TeamRoT**

## Team Members
- 23A91A0417
- 23A91A0429
- 23A91A0426
- 23A91A0461
- 24A95A0406
- 24A95A0415

---
