# 🛡️ Hardware Root-of-Trust (HRoT) for Secure System Operation

A synthesizable Hardware Root-of-Trust (HRoT) architecture implemented in SystemVerilog RTL for secure boot and firmware authentication in embedded systems and SoC platforms.

This project demonstrates a complete RTL-to-GDSII ASIC implementation flow using Cadence EDA tools, including functional verification, logic synthesis, physical design, timing closure, power analysis, and GDSII layout generation.

---

# 📌 Project Overview

Modern embedded systems rely on firmware during system startup. Since firmware is generally stored in rewritable flash memory, it becomes vulnerable to tampering, malicious modification, and unauthorized replacement attacks.

This project implements a hardware-based secure boot mechanism that verifies firmware integrity before CPU execution begins. The architecture computes a SHA-256 hash of the incoming firmware image and compares it with a trusted reference hash stored in hardware.

- If authentication succeeds:
  - CPU reset is released
  - Secure boot is allowed

- If authentication fails:
  - CPU execution remains blocked
  - Retry logic is activated
  - Permanent lockdown is triggered after repeated failures

---

# 🎯 Problem Statement

At power-on, a processor may begin executing firmware without verifying whether the firmware image is authentic or modified. Software-level security mechanisms become ineffective during this early boot stage because they execute only after firmware execution has already started.

A hardware-enforced trusted boot mechanism is therefore required to:
- Verify firmware authenticity before CPU startup
- Prevent execution of tampered firmware
- Establish a secure chain of trust from the hardware level

---

# 💡 Proposed Solution

The Hardware Root-of-Trust architecture intercepts the boot sequence before CPU execution begins.

The design:
1. Receives firmware data through a streaming interface
2. Computes SHA-256 digest using dedicated hardware
3. Compares generated digest with trusted reference hash
4. Releases CPU reset only on successful authentication
5. Activates permanent lockdown after multiple failures

The architecture is fully synthesizable and implemented through a complete ASIC design flow.

---

# 🏗️ System Architecture

The design integrates the following RTL modules:

| Module | Function |
|---|---|
| `rot_top` | Top-level integration module |
| `boot_ctrl_fsm` | Secure boot sequencing FSM |
| `auth_engine` | Firmware authentication manager |
| `sha256_core` | SHA-256 cryptographic engine |
| `secure_key_storage` | Trusted hash storage |
| `policy_engine` | Security decision logic |
| `retry_counter` | Failed authentication tracking |
| `lockdown_ctrl` | Permanent lockdown controller |
| `cpu_reset_ctrl` | CPU reset release controller |

---

# 🔐 Key Features

- Hardware-Enforced Secure Boot
- SHA-256 Firmware Authentication
- CPU Reset Protection
- Trusted Hash Verification
- Retry and Lockdown Mechanism
- Multi-Block SHA-256 Processing
- Synthesizable SystemVerilog RTL
- ASIC RTL-to-GDSII Flow
- Timing, Area, and Power Analysis
- Cadence-Based Physical Design

---

# 🧪 Functional Verification

The project includes SystemVerilog-based functional verification covering:
- Valid firmware authentication
- Tampered firmware rejection
- Retry counter validation
- Lockdown verification
- CPU reset control behavior
- Multi-scenario authentication testing

### Verification Results
- Total Test Cases: 5
- Passed: 5
- Failed: 0

---

# ⚙️ EDA Tools and Technologies

| Category | Tool / Technology |
|---|---|
| HDL | SystemVerilog (IEEE 1800-2017) |
| Cryptography | SHA-256 (FIPS 180-4) |
| Simulation | Cadence Xcelium |
| Logic Synthesis | Cadence Genus 21.14 |
| Physical Design | Cadence Innovus 21.15 |
| Constraints | SDC |
| Technology Node | 90nm Standard Cell Library |
| Automation | TCL Scripting |

---

# 📊 Logic Synthesis Results

## Cadence Genus 21.14

### Area Report

| Parameter | Value |
|---|---|
| Total Cell Count | 17,624 |
| Total Area | 152,631.912 µm² |
| SHA-256 Core Area | 117,728.225 µm² |

### Timing Report

| Parameter | Value |
|---|---|
| Target Frequency | 100 MHz |
| Clock Period | 10 ns |
| Timing Slack | +6141 ps |
| Timing Status | MET |

### Power Report

| Parameter | Value |
|---|---|
| Internal Power | 11.597 mW |
| Switching Power | 2.857 mW |
| Leakage Power | 0.884 mW |
| Total Power | 15.338 mW |

---

# 🧱 Physical Design Results

## Cadence Innovus 21.15

The complete physical design flow was successfully implemented including:
- Floorplanning
- Power Planning
- Placement
- Clock Tree Synthesis (CTS)
- Routing
- GDSII Generation

### Post-Route Area

| Parameter | Value |
|---|---|
| Total Instance Count | 17,643 |
| Total Area | 165,148.011 µm² |

### Post-Route Timing

| Parameter | Value |
|---|---|
| Required Time | 9.663 ns |
| Arrival Time | 9.624 ns |
| Slack | +0.040 ns |
| Timing Closure | Achieved |

### Post-Route Power

| Parameter | Value |
|---|---|
| Internal Power | 15.6 mW |
| Switching Power | 2.16 mW |
| Leakage Power | 1.50 mW |
| Total Power | 19.28 mW |

---


# 📂 Repository Structure

```text
Hardware-Root-of-Trust-for-Secure-System-Operation/
│
├── 00_Documentation/
├── 01_Specifications/
├── 02_RTL_Code/
├── 03_Testbench/
├── 04_Logic_Synthesis/
├── 05_Physical_Design/
├── 06_Results/
├── 07_Script_files/
└── README.md
