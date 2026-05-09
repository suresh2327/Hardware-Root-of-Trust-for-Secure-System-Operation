# Results – Hardware Root-of-Trust (RoT)

## Overview

This directory contains the complete implementation outputs and validation results of the Hardware Root-of-Trust (RoT) architecture across simulation, logic synthesis, and physical design stages.

The results demonstrate successful secure boot verification, firmware authentication behavior, ASIC synthesis, timing closure, physical implementation, and RTL-to-GDSII realization of the proposed architecture.

---

# Results Directory Structure

```text
06_Results/
├── Simulation_outputs/
├── Logic_synthesis_Outputs/
└── Physical_Design_outputs/
```

---

# 1. Simulation Outputs

The simulation outputs validate the functional correctness of the Hardware Root-of-Trust architecture using Cadence Xcelium simulation environment.

## Verified Functional Scenarios

- Authentication PASS condition
- Authentication FAIL condition
- Retry counter operation
- Lockdown activation
- CPU reset enforcement
- Secure boot FSM transitions

## Simulation Validation

The timing waveforms and console outputs confirmed:
- Correct secure boot sequencing
- Proper SHA-256 authentication flow
- Successful firmware verification
- Lockdown behavior during invalid authentication
- Controlled CPU enable functionality

## Key Observation

The architecture successfully prevented unauthorized firmware execution by maintaining CPU reset control during authentication failure conditions.

---

# 2. Logic Synthesis Outputs

The synthesis outputs demonstrate successful gate-level implementation of the Hardware Root-of-Trust architecture using Cadence Genus synthesis environment.

## Synthesis Summary

| Parameter | Result |
|---|---|
| Top Module | `rot_top` |
| Total Cell Count | 17,624 |
| Total Cell Area | 152,631.912 |
| SHA-256 Core Area | 117,728.225 |
| Timing Status | Setup Timing Met |
| Worst Positive Slack (WNS) | 6141 ps |
| Total Power | 1.92780e-02 W |

---

## Area Analysis

The synthesized design successfully mapped all secure boot modules into standard-cell based hardware implementation.

The SHA-256 authentication engine occupied the majority of the synthesized area due to cryptographic computation complexity.

---

## Timing Analysis

Static Timing Analysis confirmed:
- Setup timing constraints successfully met
- Positive timing slack achieved
- No critical setup timing violations detected

This validates reliable operation of the authentication and secure boot logic under defined timing constraints.

---

## Power Analysis

Power analysis showed:
- Internal Power Dominates: 81.02%
- Switching Power: 11.22%
- Leakage Power: 7.76%

The observed power behavior is primarily associated with SHA-256 cryptographic operations and sequential logic activity.

---

# 3. Physical Design Outputs

The physical design outputs demonstrate successful ASIC implementation of the Hardware Root-of-Trust architecture using Cadence Innovus physical design environment.

---

## Physical Design Summary

| Parameter | Result |
|---|---|
| Physical Design Tool | Cadence Innovus 21.15 |
| Total Instance Count | 17,643 |
| Total Physical Area | 165,148.011 |
| SHA-256 Core Area | 128,856.170 |
| Setup Timing Status | MET |
| Post-Route Slack | 0.040 ns |
| Total Power | 15.3378 |

---

## Floorplanning & Placement

The floorplan was successfully generated with optimized standard-cell placement and routing resource allocation.

Placement optimization reduced congestion while maintaining timing closure and implementation feasibility.

---

## Clock Tree Synthesis (CTS)

Clock Tree Synthesis successfully distributed clock signals across the design while minimizing skew and balancing clock latency.

CTS optimization improved timing stability across sequential authentication logic.

---

## Routing Results

Global and detailed routing were completed successfully without major routing violations.

The routed layout established:
- Full signal connectivity
- Timing-aware routing
- DRC-aware implementation
- ASIC-ready physical realization

---

## Post-Layout Timing Analysis

Post-route Static Timing Analysis confirmed:
- Setup Timing MET
- Positive slack achieved
- Reliable post-layout operation

The timing results validate successful hardware implementation after routing optimization.

---

## Post-Layout Power Analysis

Post-layout power analysis demonstrated stable power behavior after physical implementation.

Power contribution breakdown:
- Internal Power: 75.6116%
- Switching Power: 18.6280%
- Leakage Power: 5.7604%

The results indicate successful physical implementation of the secure authentication hardware.

---

# Overall Implementation Outcome

The Hardware Root-of-Trust architecture was successfully implemented through:
- Functional RTL verification
- Gate-level synthesis
- Physical design implementation
- Timing closure validation
- ASIC layout generation

The final implementation demonstrates a complete prototype RTL-to-GDSII secure boot hardware design flow.

---

# Key Achievement

This project successfully demonstrates a synthesizable and physically implementable Hardware Root-of-Trust architecture capable of authenticating firmware before CPU execution and preventing unauthorized boot operation during system startup.

---
