# Physical Design – Hardware Root-of-Trust (RoT)

## Overview
This stage focuses on the physical implementation of the Hardware Root-of-Trust (RoT) architecture using Cadence Innovus. The synthesized gate-level netlist is transformed into a manufacturable ASIC layout while meeting timing, power, and area constraints.

The physical design flow ensures that the secure hardware architecture is efficiently implemented for reliable silicon realization.

---

## Physical Design Objectives

- Implement optimized ASIC layout
- Achieve timing closure
- Minimize power consumption
- Optimize area utilization
- Ensure routing and signal integrity
- Prepare final layout for fabrication

---

## Physical Design Flow

```text
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
Physical Verification
    ↓
GDSII Generation
```

---

## Tool Environment

| Category | Tool |
|---|---|
| Physical Design Tool | Cadence Innovus |
| Input Netlist | Synthesized Gate-Level Netlist |
| Output Format | GDSII Layout |

---

## Physical Design Stages

| Stage | Description |
|---|---|
| Floorplanning | Defines chip area and macro placement |
| Power Planning | Creates stable power distribution network |
| Placement | Places standard cells in layout |
| CTS | Builds balanced clock distribution network |
| Routing | Connects all signal and clock paths |
| Physical Verification | Performs DRC and LVS checks |
| GDSII Generation | Produces final fabrication-ready layout |

---

## Generated Outputs

- Floorplan Layout  
- Routed Design Database  
- Timing Reports  
- Power Reports  
- DRC/LVS Reports  
- Final GDSII File  

---

## Key Considerations

- Timing closure optimization  
- Power integrity  
- Routing congestion management  
- Clock skew reduction  
- Physical rule compliance  
- ASIC fabrication readiness  

---

## Objective

To physically implement the Hardware Root-of-Trust architecture as a reliable and fabrication-ready ASIC layout while preserving secure hardware functionality.

---

## Team

**TeamRoT**

- 23A91A0417  
- 23A91A0429  
- 23A91A0426  
- 23A91A0461  
- 24A95A0406  
- 24A95A0415
