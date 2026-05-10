# RTL Design – Hardware Root-of-Trust (RoT)

## Overview
This directory contains the SystemVerilog RTL implementation of a prototype Hardware Root-of-Trust (RoT) architecture designed for secure boot and firmware authentication in embedded and SoC platforms. The design verifies firmware integrity before CPU execution, ensuring that only authenticated firmware is allowed to execute during system startup.

The implementation focuses on hardware-level secure boot control using SHA-256 based firmware authentication and trusted execution enforcement.

---

## RTL Modules

| Module | Description |
|---|---|
| `rot_top` | Top-level integration of all RoT modules |
| `boot_ctrl_fsm` | Controls secure boot sequencing and authentication flow |
| `auth_engine` | Performs firmware hash verification using SHA-256 |
| `secure_key_storage` | Parameterized secure reference hash storage model for authentication |
| `policy_engine` | Generates boot allow or deny decisions |
| `retry_counter` | Tracks failed authentication attempts |
| `lockdown_ctrl` | Activates secure lockdown after repeated failures |
| `cpu_reset_ctrl` | Controls CPU reset release after authentication |
| ` debug_ctrl `  | Disables JTAG/debug access during lockdown and untrusted boot |

---

## Functional Flow

```text
Power ON
   ↓
Boot Initialization
   ↓
Firmware Authentication
   ↓
Hash Verification
   ↓
PASS → CPU Enable
FAIL → Lockdown / Reset
```

---

## Design Highlights

- Hardware-Enforced Secure Boot
- SHA-256 Firmware Authentication
- CPU Reset-Based Execution Control
- Retry & Lockdown Protection
- Modular Synthesizable RTL Architecture
- ASIC-Oriented Hardware Design Flow

---

## Design Environment

| Category | Tool / Technology |
|---|---|
| HDL | SystemVerilog |
| Verification | SystemVerilog-based Functional Verification |
| Simulation | Cadence Xcelium |
| Synthesis | Cadence Genus |
| Physical Design | Cadence Innovus |

---

## Secure Key Storage Note

The current implementation models trusted hash storage using parameterized RTL-based secure storage for prototype verification purposes.

In practical silicon implementations, this storage would typically be implemented using:
- ROM
- eFuse
- OTP (One-Time Programmable) memory

to provide immutable hardware-level trust anchoring.

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

## Verification Coverage

The RTL implementation was functionally verified for:
- Authentication PASS scenario
- Authentication FAIL scenario
- Retry counter operation
- Lockdown activation
- CPU reset enforcement
- Secure boot state transitions

---

## Objective

To demonstrate a synthesizable hardware-based secure boot architecture capable of authenticating firmware before CPU execution and establishing a trusted startup mechanism for embedded systems and SoC platforms.

---
