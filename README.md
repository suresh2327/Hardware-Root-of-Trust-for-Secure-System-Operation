# 🛡️ Hardware Root-of-Trust (RoT) for Secure System Operation

## Overview

This repository presents the design and implementation of a Hardware Root-of-Trust (RoT) architecture developed for secure system boot and firmware authentication in embedded and SoC-based platforms.

The project demonstrates a hardware-controlled secure boot mechanism that verifies firmware integrity before CPU execution using SHA-256 cryptographic authentication. The implementation follows a complete RTL-to-GDSII ASIC design methodology using industry-standard Cadence tools.

The primary objective of the architecture is to establish a trusted hardware boundary during system startup and prevent unauthorized firmware execution during the boot phase.

---

# Project Objectives

- Implement a hardware-based secure boot architecture
- Authenticate firmware prior to CPU execution
- Prevent execution of modified or untrusted firmware
- Demonstrate retry and lockdown protection mechanisms
- Develop a synthesizable ASIC-oriented RTL design
- Perform complete RTL-to-GDSII implementation flow

---

# Problem Statement

Modern embedded systems and SoCs depend heavily on firmware during device initialization and startup. Since firmware is commonly stored in rewritable non-volatile memory such as Flash, it is vulnerable to tampering, unauthorized modification, and malicious firmware replacement attacks.

If compromised firmware executes during boot, attackers may gain privileged control of the system before software-level protections become active. Conventional software-based security mechanisms cannot fully protect the system during this early startup stage.

This project addresses the problem by implementing a Hardware Root-of-Trust architecture capable of verifying firmware authenticity before CPU execution begins.

---

# Proposed Solution

The proposed architecture establishes hardware-level trust during system startup through SHA-256 based firmware authentication.

During the boot process:

1. The CPU remains in reset state after power-on.
2. Firmware data is provided to the authentication engine.
3. A SHA-256 hash is generated for the incoming firmware.
4. The generated hash is compared with a trusted reference value stored in secure hardware storage.
5. If authentication succeeds, the CPU is released for normal execution.
6. If authentication fails repeatedly, the system enters a secure lockdown state.

This approach ensures that only authenticated firmware is permitted to execute during system startup.

---

# Architecture Overview

```text
Power ON
    ↓
Boot FSM Controller
    ↓
Firmware Authentication
    ↓
SHA-256 Verification
    ↓
Authentication PASS  → CPU Enable
Authentication FAIL  → Retry / Lockdown
```

---

# RTL Architecture Modules

| Module | Function |
|---|---|
| `rot_top` | Top-level integration of the complete RoT architecture |
| `boot_ctrl_fsm` | Controls secure boot sequence and authentication flow |
| `auth_engine` | Performs firmware authentication using SHA-256 |
| `secure_key_storage` | Stores trusted reference hash/key values |
| `policy_engine` | Generates authentication-based boot decisions |
| `retry_counter` | Tracks failed authentication attempts |
| `lockdown_ctrl` | Activates secure lockdown protection |
| `cpu_reset_ctrl` | Controls CPU reset and release operation |

---

# Key Features

- Hardware-Enforced Secure Boot
- SHA-256 Firmware Authentication
- CPU Reset-Based Execution Control
- Retry Protection Mechanism
- Secure Lockdown Control
- Modular Synthesizable RTL Design
- ASIC-Oriented Implementation Flow
- RTL-to-GDSII Design Methodology

---

# Technology Stack

| Category | Technology |
|---|---|
| Hardware Description Language | SystemVerilog |
| Cryptographic Algorithm | SHA-256 |
| Functional Verification | SystemVerilog Directed Testbench (5 test scenarios, Cadence Xcelium) |
| Simulation Tool | Cadence Xcelium |
| Logic Synthesis | Cadence Genus 21.14 |
| Physical Design | Cadence Innovus 21.15 |
| Final Implementation Output | GDSII |

---

# ASIC Design Flow

```text
System Specification
        ↓
RTL Design
        ↓
Functional Verification
        ↓
Logic Synthesis
        ↓
Floorplanning
        ↓
Placement
        ↓
Clock Tree Synthesis
        ↓
Routing
        ↓
Timing & Power Analysis
        ↓
GDSII Generation
```

---

# Repository Structure

| Directory | Description |
|---|---|
| `00_Documentation/` | Project reports, architecture explanation, implementation details, and supporting documentation |
| `01_Specifications/` | Functional specifications, architecture definitions, and security requirements |
| `02_RTL_Code/` | SystemVerilog RTL implementation of the RoT architecture |
| `03_Testbench/` | Verification environment, simulation testcases, and validation files |
| `04_Logic_synthesis/` | Cadence Genus synthesis scripts, reports, and gate-level outputs |
| `05_Physical_Design/` | Cadence Innovus implementation data, reports, and layout outputs |
| `06_Results/` | Simulation results, timing reports, power reports, area reports, and implementation screenshots |
| `07_Script_files/` | TCL automation scripts and implementation configuration files |

---

# Functional Verification

The architecture was verified using a five-scenario SystemVerilog directed testbench on Cadence Xcelium. All five test cases pass with zero errors.
- Test 0: Trusted firmware — SHA-256 match — boot_pass=1, cpu_reset_n=1 — PASS
- Test 1: HELLOWORLD — hash mismatch — boot_pass=0, cpu_reset_n=0, retry=1 — PASS
- Test 2: SECUREBOOT_HACKD — hash mismatch — boot_pass=0, cpu_reset_n=0, retry=2 — PASS
- Test 3: Three consecutive failures — lockdown_active=1, cpu_reset_n=0 — PASS
- Test 4: Trusted firmware after reset — boot_pass=1, cpu_reset_n=1 — PASS

---

# Logic Synthesis Results

| Parameter | Result |
|---|---|
| Total Cell Count | 17,624 |
| Total Synthesized Area | 152,631.912 µm² |
| Worst Positive Slack (WNS) | 6141 ps |
| Total Estimated Power | 1.92780e-02 W |

---

# Physical Design Results

| Parameter | Result |
|---|---|
| Total Instance Count | 17,643 |
| Total Physical Area | 165,148.011 µm² |
| Post-Route Timing Slack | 0.040 ns |
| Total Power | 15.3378 mW |

---

# Current Design Scope

The current implementation focuses on:
- Boot-time firmware authentication
- Hardware-controlled secure boot enforcement
- SHA-256 based integrity verification
- Retry and lockdown protection mechanisms
- ASIC implementation feasibility

---

# Future Enhancements

Potential future extensions include:

- ROM/eFuse/OTP-based secure key storage
- Secure firmware update authentication
- Rollback protection support
- Recovery boot mechanism
- Runtime firmware integrity monitoring
- Enhanced constrained-random verification
- Secure debug access control

---

# Applications

- Automotive Electronic Control Units (ECUs)
- IoT and Edge Devices
- Embedded Controllers
- Industrial Automation Systems
- Secure SoC Platforms
- Medical Embedded Devices

---

# Conclusion

This project demonstrates the implementation of a Hardware Root-of-Trust architecture capable of establishing trusted system startup through hardware-based firmware authentication.

The work successfully validates the feasibility of integrating secure boot enforcement, cryptographic authentication, retry protection, and lockdown control within a synthesizable ASIC-oriented design flow using industry-standard EDA tools.

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

# Acknowledgement

The team expresses sincere gratitude to the faculty mentors and institution for their guidance, technical support, and continuous encouragement throughout the development of this project.
