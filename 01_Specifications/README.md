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
| Verification Methodology | UVM |
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

Firmware stored in rewritable memory is vulnerable to tampering and unauthorized modification. In the absence of hardware-level verification, compromised firmware can execute during system startup, leading to critical system-level security risks.

---

# 💡 Solution

This project implements a Hardware Root-of-Trust that authenticates firmware using SHA-256 cryptographic verification before CPU execution. The system allows execution only for trusted firmware and blocks unauthorized or modified firmware.

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
 └── debug_ctrl
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

# 📂 Repository Structure

```text
Hardware-RoT/
│
├── rtl/
├── tb/
├── synthesis/
├── pnr/
├── docs/
├── scripts/
└── README.md
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

# 📌 Future Scope

- Runtime Security Monitoring
- AI-Assisted Policy Engine
- Secure OTA Authentication
- Advanced Threat Detection
- Formal Verification

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

# 📜 License
This project is intended for academic and research purposes.

---

# 🙏 Acknowledgement
We thank our faculty mentors and institution for supporting this project development.
