# 🔐 Hardware Root-of-Trust (RoT) for Secure System Operation

## 📌 Overview
This project implements a synthesizable Hardware Root-of-Trust (RoT) architecture for secure boot and firmware authentication in modern embedded and SoC platforms. The design ensures that only authenticated and trusted firmware is executed before CPU startup, preventing unauthorized code execution and boot-level attacks.

The architecture uses SHA-256 cryptographic verification and hardware-enforced control logic to establish trust at the root level of the system.

---

# 📋 Specifications

| Parameter | Specification |
|---|---|
| Project Type | Hardware Root-of-Trust (RoT) |
| Security Function | Secure Boot & Firmware Authentication |
| Authentication Method | SHA-256 Cryptographic Verification |
| Design Language | SystemVerilog |
| Verification Methodology | UVM based SystemVerilog|
| Simulation Tool | Cadence Xcelium |
| Synthesis Tool | Cadence Genus |
| Physical Design Tool | Cadence Innovus |
| Output Format | GDSII |
| Target Platform | Embedded Systems & SoCs |
| Security Mechanism | Hardware-Enforced CPU Control |
| Key Storage | Immutable Secure Storage (ROM/OTP Model) |
| Boot Protection | Firmware Verification Before CPU Execution |
| Fail-Safe Mechanism | Retry Counter & Lockdown Control |

---

# 🚀 Key Features

- Hardware-Enforced Secure Boot
- SHA-256 Firmware Authentication
- Immutable Secure Key Storage
- Controlled CPU Execution
- Retry & Lockdown Protection
- Hardware-Level Trust Enforcement
- Synthesizable RTL Design
- RTL-to-GDSII ASIC Flow

---

# 🧠 Problem Statement

Modern embedded systems and SoC platforms store firmware in external flash memory, which is rewritable and physically accessible to an attacker. A supply-chain compromise, physical access attack, or software exploit can modify firmware stored in flash before the device powers on. At power-on the CPU has no mechanism to verify whether the firmware it is about to execute is the original authentic image or a tampered replacement. Software-level protections such as antivirus scanners, OS integrity checkers, and secure boot libraries are all ineffective at this stage because they execute after the firmware has already been loaded and the CPU has already started running. The attack completes before any software defence can activate. A hardware mechanism that cryptographically verifies firmware authenticity before releasing the CPU from reset is therefore required.

---

# 💡 Solution

 To address this issue, this project implements a Hardware Root-of-Trust architecture that authenticates firmware before CPU execution using SHA-256 cryptographic verification.
The Root-of-Trust establishes a trusted hardware security boundary by comparing the generated firmware hash against a securely stored trusted hash value. If the authentication succeeds, the CPU is released for normal execution. If authentication fails, the system blocks execution by maintaining the CPU in reset mode or entering a secure lockdown state.
This approach ensures that only trusted firmware is allowed to execute, thereby protecting the system from firmware-level attacks and unauthorized control.


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
Firmware Loaded from Memory
   ↓
SHA-256 Authentication
   ↓
Verification with Trusted Key
   ↓
PASS → CPU Execution Allowed
FAIL → Lockdown / Execution Blocked
```

---

# 🔐 Security Features

- Prevents unauthorized firmware execution
- Ensures trusted boot process
- Protects against firmware tampering
- Hardware-based non-bypassable security
- Secure storage of trusted keys
- Fail-safe lockdown mechanism

---

# 🌍 Applications

## 🚗 Automotive Systems
- ECU Security
- ADAS Systems
- OTA Firmware Updates

## 🌐 IoT Devices
- Smart Home Systems
- Industrial IoT
- Smart Security Devices

## 🏥 Medical Devices
- Patient Monitoring Systems
- Embedded Medical Controllers

---

# ⚙️ Technology Stack

| Category | Technology |
|---|---|
| HDL | SystemVerilog |
| Verification Methodology | UVM |
| Cryptographic Algorithm | SHA-256 |
| Simulation | Cadence Xcelium |
| Synthesis | Cadence Genus |
| Place & Route | Cadence Innovus |
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

# 🧪 Verification

The design is verified for:

- Authentication PASS scenario
- Authentication FAIL scenario
- Retry exhaustion
- Lockdown condition
- CPU reset enforcement

---

# 🎯 Project Objective

To design a secure, hardware-based trust mechanism that authenticates firmware before execution and establishes a trusted foundation for modern embedded systems.

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
We thank our faculty mentors and institution for supporting this project development.
