# Script Files – Hardware Root-of-Trust (RoT)

## Overview

This directory contains the automation scripts and configuration files used throughout the ASIC implementation flow of the Hardware Root-of-Trust (RoT) architecture.

The provided TCL scripts automate synthesis and physical design execution using Cadence Genus and Cadence Innovus environments. These scripts ensure reproducible design flow execution, constraint application, report generation, and implementation consistency.

---

# Directory Structure

```text
07_Script_files/
├── Default.globals
├── Default.view
├── run_genus.tcl
├── run_innovus.tcl
└── temp/
```

---

# Script Description

| File | Description |
|---|---|
| `run_genus.tcl` | TCL automation script for logic synthesis using Cadence Genus |
| `run_innovus.tcl` | TCL automation script for physical design flow using Cadence Innovus |
| `Default.globals` | Global configuration settings for implementation environment |
| `Default.view` | Tool environment and design view configuration |
| `temp/` | Temporary execution and intermediate tool-generated files |

---

# Cadence Genus Synthesis Script

## `run_genus.tcl`

This script automates the complete RTL synthesis flow including:
- RTL file loading
- Library setup
- Constraint application
- Logic synthesis
- Timing optimization
- Area optimization
- Power analysis
- Netlist generation
- Report generation

### Generated Outputs

- Synthesized gate-level netlist
- Timing reports
- Area reports
- Power reports
- Constraint validation reports

---

# Cadence Innovus Physical Design Script

## `run_innovus.tcl`

This script automates the ASIC physical implementation flow including:
- Netlist import
- Floorplanning
- Power planning
- Placement
- Clock Tree Synthesis (CTS)
- Routing
- Timing optimization
- Physical verification
- GDSII generation

### Generated Outputs

- Routed netlist
- Placement reports
- CTS reports
- Timing reports
- Power reports
- Area reports
- Final GDSII layout

---

# Design Automation Flow

```text
RTL Design
    ↓
run_genus.tcl
    ↓
Gate-Level Netlist
    ↓
run_innovus.tcl
    ↓
Physical Layout & GDSII
```

---

# Tool Environment

| Category | Tool |
|---|---|
| Synthesis Tool | Cadence Genus 21.14 |
| Physical Design Tool | Cadence Innovus 21.15 |
| Scripting Language | TCL |
| Constraint Format | SDC |

---

# Key Features

- Automated RTL-to-GDSII flow
- Timing-driven optimization
- Area and power-aware implementation
- ASIC implementation support
- Reproducible design execution
- Automated report generation

---

# Implementation Notes

- The scripts are designed for Cadence ASIC implementation flow.
- Timing constraints are applied using SDC-based configuration.
- Generated reports support timing, area, power, and placement analysis.
- The scripts automate major synthesis and physical design stages to reduce manual implementation effort.

---

# Objective

To provide reusable and automated ASIC implementation scripts for synthesis and physical design execution of the Hardware Root-of-Trust architecture.

---

