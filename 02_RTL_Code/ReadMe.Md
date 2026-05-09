# RTL Design – Hardware Root-of-Trust (RoT)

## Overview
This directory contains the SystemVerilog RTL implementation of a Hardware Root-of-Trust (RoT) designed for secure boot and firmware authentication in embedded and SoC platforms. The architecture verifies firmware integrity before CPU execution, ensuring that only trusted firmware is allowed to run.

---

## RTL Modules

| Module | Description |
|---|---|
| `rot_top` | Top-level integration of all RoT modules |
| `boot_ctrl_fsm` | Controls secure boot sequence and state transitions |
| `auth_engine` | Performs firmware authentication using SHA-256 |
| `secure_key_storage` | Provides immutable trusted key/hash storage |
| `policy_engine` | Generates boot allow/deny decisions |
| `retry_counter` | Tracks failed authentication attempts |
| `lockdown_ctrl` | Activates secure lockdown on critical failure |
| `cpu_reset_ctrl` | Controls CPU release after authentication |


---

## Functional Flow

```text
Power ON
   ↓
Boot Initialization
   ↓
Firmware Authentication
   ↓
Trusted Verification
   ↓
CPU Enable / Secure Lockdown
```

---

## Design Highlights

- Hardware-Enforced Secure Boot
- SHA-256 Firmware Authentication
- Secure CPU Execution Control
- Immutable Trust Anchor
- Retry & Lockdown Protection
- Modular Synthesizable RTL Architecture

---

## Design Environment

| Category | Tool / Technology |
|---|---|
| HDL | SystemVerilog |
| Verification Methodology | UVM-inspired SystemVerilog verification |
| Simulation | Cadence Xcelium |
| Synthesis | Cadence Genus |
| Physical Design | Cadence Innovus |

---

## Directory Structure

```text
rtl/
├── rot_top.sv
├── boot_ctrl_fsm.sv
├── auth_engine.sv
├── secure_key_storage.sv
├── policy_engine.sv
├── retry_counter.sv
├── lockdown_ctrl.sv
├── cpu_reset_ctrl.sv

```

---

## Objective
To establish a hardware-based trusted boot mechanism capable of preventing unauthorized firmware execution and protecting the system during startup.

---

