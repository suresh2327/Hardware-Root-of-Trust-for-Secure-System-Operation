# 🔐 Hardware Root-of-Trust (RoT) – Specifications

## 📌 Overview

This specification document defines the architecture, functionality, and implementation scope of a prototype Hardware Root-of-Trust (RoT) designed for secure boot and firmware authentication in embedded systems and SoC platforms.

The architecture establishes hardware-level trust by verifying firmware integrity before CPU execution using SHA-256 cryptographic authentication. The design focuses on secure boot control, trusted execution enforcement, retry protection, and secure lockdown behavior during authentication failure conditions.

---

# 📋 System Specifications

| Parameter | Specification |
|---|---|
| Project Type | Prototype Hardware Root-of-Trust (RoT) |
| Security Function | Secure Boot & Firmware Authentication |
| Authentication Method | SHA-256 Cryptographic Verification |
| Design Language | SystemVerilog |
| Verification Approach | SystemVerilog-based Functional Verification |
| Simulation Tool | Cadence Xcelium |
| Synthesis Tool | Cadence Genus |
| Physical Design Tool | Cadence Innovus |
| Output Format | GDSII |
| Target Platform | Embedded Systems & SoCs |
| Security Mechanism | Hardware-Controlled CPU Execution |
| Key Storage Model | Parameterized Secure Reference Storage |
| Boot Protection | Firmware Verification Before CPU Execution |
| Fail-Safe Mechanism | Retry Counter & Lockdown Control |

---

# 🚀 Key Features

- Hardware-Enforced Secure Boot
- SHA-256 Firmware Authentication
- CPU Reset-Based Execution Control
- Retry & Lockdown Protection
- Modular RTL Architecture
- Synthesizable ASIC-Oriented Design
- RTL-to-GDSII Design Flow

---

# 🧠 Problem Statement

Modern embedded systems and SoC platforms rely heavily on firmware during system startup and hardware initialization. Since firmware is commonly stored in rewritable flash memory, it becomes vulnerable to tampering, unauthorized modification, and malicious firmware replacement attacks.

At power-on, the CPU may begin executing firmware without verifying whether the loaded image is authentic or modified. Software-level protection mechanisms become ineffective during this early boot stage because they execute only after firmware execution begins.

A hardware-based secure boot mechanism is therefore required to verify firmware integrity before CPU startup and establish trusted system execution from the root level of the hardware.

---

# 💡 Proposed Solution

This project implements a prototype Hardware Root-of-Trust architecture that authenticates firmware before CPU execution using SHA-256 cryptographic verification.

The architecture compares the generated firmware hash with a trusted reference hash stored within the secure storage model. If authentication succeeds, the CPU is released for normal execution. If authentication fails, the system blocks execution by maintaining CPU reset control or entering secure lockdown mode after repeated failures.

This approach establishes a hardware-controlled trusted boot mechanism capable of preventing unauthorized firmware execution during system startup.

---

# 🏗️ Architecture Overview

```text
rot_top
 ├── boot_ctrl_fsm
 ├── auth_engine
 ├── secure_key_storage
 ├── policy_engine
 ├── retry_counter
 ├── lockdown_ctrl
 ├── cpu_reset_ctrl
```

---

# 🔄 Working Flow

```text
Power ON
   ↓
CPU Held in Reset
   ↓
Firmware Stream Provided
   ↓
SHA-256 Authentication
   ↓
Hash Verification
   ↓
PASS → CPU Enable
FAIL → Retry / Lockdown
```

---

# 🔐 Security Features

- Firmware integrity verification before execution
- Hardware-controlled boot authorization
- CPU reset enforcement during authentication
- Retry limitation against repeated failures
- Secure lockdown protection mechanism
- Hardware-level trusted boot operation

---

# 🌍 Applications

## 🚗 Automotive Systems
- ECU Security
- ADAS Controllers
- Secure Firmware Updates

## 🌐 IoT Devices
- Smart Home Devices
- Industrial IoT Platforms
- Secure Embedded Controllers

## 🏥 Medical Electronics
- Embedded Medical Devices
- Patient Monitoring Systems

## 🏭 Industrial Systems
- Industrial Automation Controllers
- Secure Embedded Monitoring Units

---

# ⚙️ Technology Stack

| Category | Technology |
|---|---|
| HDL | SystemVerilog |
| Verification | Functional SystemVerilog Verification |
| Cryptographic Algorithm | SHA-256 |
| Simulation | Cadence Xcelium |
| Synthesis | Cadence Genus |
| Physical Design | Cadence Innovus |
| Final Output | GDSII |

---

# 🏭 ASIC Design Flow

```text
Specification
    ↓
Architecture Design
    ↓
RTL Implementation
    ↓
Functional Verification
    ↓
Logic Synthesis
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
Physical Verification
    ↓
GDSII Generation
```

---

# 🧪 Verification Scope

The RTL implementation was verified for:
- Authentication PASS condition
- Authentication FAIL condition
- Retry counter operation
- Lockdown activation
- CPU reset control
- Secure boot state transitions

---

# ⚠️ Current Implementation Notes

- The current implementation models secure key storage using parameterized RTL-based storage for prototype validation.
- External flash/DDR controller functionality is abstracted in the current architecture.
- Runtime firmware monitoring is outside the current implementation scope.
- The project focuses primarily on boot-time firmware authentication.


# Future Enhancements

## 1. ROM/eFuse-Based Secure Key Storage
The current implementation models trusted hash storage using parameterized RTL-based storage. Future versions can integrate ROM, eFuse, or OTP memory to provide stronger immutable hardware-level trust anchoring.


## 2. Firmware Rollback Protection
Version-checking mechanisms can be added to prevent execution of outdated or vulnerable firmware images during the secure boot process.

## 3. Secure OTA Firmware Update Verification
Future implementations can support secure Over-The-Air (OTA) firmware update authentication using cryptographic verification before firmware installation and execution.


## 4. Enhanced Verification Environment
The current functional verification flow can be extended with complete UVM-based constrained-random verification, assertions, and functional coverage analysis.

## 5. Recovery Mode Implementation
A dedicated secure recovery mechanism can be integrated to restore valid firmware after authentication failure or lockdown conditions.


## 6. Runtime Firmware Integrity Monitoring
The architecture can be extended to periodically monitor firmware integrity during runtime in addition to boot-time authentication.


## 7. Hardened Debug Access Control
Future versions can integrate authenticated debug access protection for interfaces such as JTAG to prevent unauthorized hardware debugging.


# 🎯 Project Objective

To demonstrate a synthesizable hardware-based secure boot architecture capable of authenticating firmware before CPU execution and establishing trusted startup operation for embedded systems and SoC platforms.

---

# 👥 Team Information

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

# 🙏 Acknowledgement

We thank our faculty mentors and institution for providing guidance and support throughout the development of this project.

---
