# Synthesis – Hardware Root-of-Trust (RoT)

## Overview
This stage focuses on the logic synthesis of the Hardware Root-of-Trust (RoT) architecture using Cadence Genus. The synthesizable SystemVerilog RTL is converted into a gate-level netlist optimized for timing, area, and power requirements.

The synthesis process ensures that the secure boot architecture and authentication logic are correctly mapped into hardware for ASIC implementation.

---

## Synthesis Objectives

- Convert RTL into gate-level hardware
- Optimize timing, area, and power
- Validate synthesizable design functionality
- Prepare design for physical implementation
- Maintain secure hardware behavior

---

## Design Inputs

| Input | Description |
|---|---|
| RTL Design | SystemVerilog source modules |
| Constraints | Clock and timing specifications |
| Technology Library | Standard cell library |
| Synthesis Scripts | Cadence Genus TCL scripts |

---

## Synthesis Flow

```text
RTL Design
    ↓
Constraint Application
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

## Tool Environment

| Category | Tool |
|---|---|
| HDL | SystemVerilog |
| Synthesis Tool | Cadence Genus |
| Design Flow | RTL-to-Gate-Level |

---

## Generated Outputs

- Gate-Level Netlist  
- Timing Reports  
- Area Utilization Reports  
- Power Analysis Reports  
- Constraint Reports  

---

## Key Considerations

- Timing-driven optimization  
- Area and power efficiency  
- Clock constraint handling  
- Secure logic preservation  
- ASIC implementation readiness  

---

## Objective

To generate an optimized gate-level implementation of the Hardware Root-of-Trust architecture suitable for physical design and ASIC fabrication flow.

---

## Team

**TeamRoT**

- 23A91A0417  
- 23A91A0429  
- 23A91A0426  
- 23A91A0461  
- 24A95A0406  
- 24A95A0415
