# Logic Synthesis – Hardware Root-of-Trust (RoT)

## Overview

This directory contains the logic synthesis implementation of the Hardware Root-of-Trust (RoT) architecture using Cadence Genus synthesis environment.

The synthesizable SystemVerilog RTL design was converted into a gate-level hardware implementation optimized for timing, area, and power while preserving secure boot functionality and firmware authentication behavior.

The synthesis stage validates ASIC implementation feasibility before physical design and layout generation.

---

# Synthesis Objectives

- Convert RTL into gate-level hardware
- Perform timing-driven logic optimization
- Optimize area and power utilization
- Validate synthesizable hardware behavior
- Generate ASIC-ready netlist
- Prepare design for physical implementation flow

---

# Design Inputs

| Input | Description |
|---|---|
| RTL Design | SystemVerilog source modules |
| Constraints | Clock and timing specifications |
| Technology Library | Standard cell library |
| Synthesis Scripts | Cadence Genus TCL scripts |

---

# Synthesis Flow

```text
RTL Design
    ↓
Constraint Definition
    ↓
Logic Optimization
    ↓
Technology Mapping
    ↓
Gate-Level Netlist Generation
    ↓
Timing, Area & Power Analysis
```

---

# Tool Environment

| Category | Tool / Technology |
|---|---|
| HDL | SystemVerilog |
| Synthesis Tool | Cadence Genus 21.14 |
| Design Flow | RTL-to-Gate-Level |
| Technology Library | Standard Cell Library |

---

# Synthesis Results Summary

| Parameter | Result |
|---|---|
| Top Module | `rot_top` |
| Total Cell Count | 17,624 |
| Total Cell Area | 152,631.912 |
| SHA-256 Core Area | 117,728.225 |
| Timing Status | Setup Timing Met |
| Worst Positive Slack (WNS) | 6141 ps |
| Total Power | 1.92780e-02 W |
| Internal Power Contribution | 81.02% |
| Switching Power Contribution | 11.22% |
| Leakage Power Contribution | 7.76% |

---

# Area Analysis

The synthesis results confirmed successful hardware mapping of the complete Hardware Root-of-Trust architecture.

The final synthesized design achieved:
- Total cell count of **17,624**
- Total synthesized area of **152,631.912**

The SHA-256 authentication engine occupied the majority of the design area due to intensive cryptographic computation and sequential processing logic.

The area utilization demonstrates successful implementation of secure boot authentication logic suitable for ASIC realization.

---

# Timing Analysis

Static Timing Analysis (STA) confirmed successful setup timing closure after synthesis.

Key timing observations:
- Setup timing constraints were successfully met
- Worst Positive Slack (WNS): **6141 ps**
- No critical setup timing violations detected

The timing results validate reliable operation of the secure boot control logic and firmware authentication flow under defined clock constraints.

---

# Power Analysis

Power analysis was performed after synthesis to evaluate internal, switching, and leakage power contributions.

Observed power characteristics:
- Total Power: **1.92780e-02 W**
- Internal Power Dominates: **81.02%**
- Switching Power: **11.22%**
- Leakage Power: **7.76%**

The high internal power contribution is primarily associated with sequential operations and SHA-256 cryptographic processing activity.

---

# Generated Outputs

- Synthesized Gate-Level Netlist
- Timing Reports
- Area Reports
- Power Analysis Reports
- Constraint Reports
- Optimization Logs

---

# Key Design Considerations

- Timing-driven synthesis optimization
- Area-aware hardware mapping
- Power-aware implementation
- Secure boot logic preservation
- ASIC implementation readiness
- Modular hardware architecture

---

# Implementation Notes

- The design was synthesized using standard-cell based ASIC synthesis flow.
- Timing constraints were applied using Synopsys Design Constraints (SDC).
- The secure key storage is modeled using parameterized RTL-based reference storage for prototype implementation.
- The synthesized netlist was further used for physical design implementation in Cadence Innovus.

---

# Objective

To generate an optimized gate-level implementation of the Hardware Root-of-Trust architecture suitable for ASIC physical design and secure hardware realization.

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
