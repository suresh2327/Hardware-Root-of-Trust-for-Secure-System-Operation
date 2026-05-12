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
-Performs SHA-256 based firmware authentication
- CPU Reset-Based Execution Control
- Retry & Lockdown Protection
- Modular Synthesizable RTL Architecture
- ASIC-Oriented Hardware Design Flow

---

## Design Environment

| Category | Tool / Technology |
|---|---|
| HDL | SystemVerilog |
| Verification | SystemVerilog-based Directed Functional Verification |
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

## Verification Coverage

The RTL implementation was functionally verified for:
- Authentication PASS scenario
- Authentication FAIL scenario
- Retry counter operation
- Lockdown activation
- CPU reset enforcement
- Secure boot state transitions

---
## Future Enhancements
The current RTL architecture includes preliminary interface hooks and modular infrastructure for future security enhancements.
- Runtime firmware integrity monitoring support  
- Secure OTA firmware update authentication support  
- Anti-rollback firmware protection using firmware version tracking  
- Enhanced secure key storage using ROM/eFuse/OTP implementation  
- Trusted Execution Environment (TEE) handoff support  
- Extended secure debug control and protected debug access  
- Migration toward complete UVM-based constrained-random verification  
- Formal verification and assertion-based security validation   
- Low-power optimization for security-oriented hardware blocks  
- FPGA-based prototype implementation for hardware validation  
- Modular policy engine extension for advanced security control  
# Future Enhancements

This section documents the future-scope provisions currently present in the RTL (`02_RTL_Code/Design_code.sv`), along with planned enhancements that require additional implementation work.

---

## Implemented in RTL (Structural Hooks Present)

The following features have interface ports and stub logic wired into `rot_top`. They are not fully functional but provide the architectural foundation for future development.

### 1. Anti-Rollback Protection
**Status: Functional stub**

A version ratchet register (`fw_version_min`) is implemented in `rot_top`. After each successful authenticated boot, the minimum acceptable firmware version is updated if the incoming version is higher. A rollback is flagged if the incoming version is below the stored minimum.

**Ports exposed:**
- `fw_version_in [7:0]` — firmware version field from the firmware header
- `rollback_alert` — asserted if the incoming version is below the stored minimum

**Limitation:** The minimum version register is volatile (RAM-based). A production implementation would store this value in eFuse or OTP to prevent reset-based rollback attacks.

---

### 2. TEE Handoff Signal
**Status: Functional stub**

A registered output signal `tee_handoff` is driven high after a successful authenticated boot and de-asserted on hardware reset. This provides a single-cycle pulse that an external Trusted Execution Environment controller can use to begin its initialization sequence.

**Port exposed:**
- `tee_handoff` — registered pulse after trusted boot completes

**Limitation:** No TEE controller is instantiated. The signal is a handoff trigger only; the receiving TEE logic is out of scope for the current design.

---

### 3. OTA Firmware Authentication Interface
**Status: Combinational stub**

A top-level port for OTA update requests is present. The current grant logic is combinational: OTA is approved if the last boot passed authentication, no rollback is detected, and the system is not in lockdown.

**Ports exposed:**
- `ota_update_req` — input request to authenticate an OTA firmware image
- `ota_auth_grant` — output approval signal

**Limitation:** No second `auth_engine` instance is present for independent OTA image authentication. The current logic reuses the boot authentication result as a proxy. A full implementation requires a dedicated authentication path.

---

### 4. Secure Debug Access Control
**Status: Functional**

A `debug_ctrl` module is instantiated and connected in `rot_top`. JTAG access is disabled during authentication failure or lockdown, and enabled only after a successful authentication.

**Ports exposed:**
- `jtag_disable` — asserted to disable JTAG access
- `debug_enable` — asserted only when `auth_pass` is high and `lockdown_active` is low

**Limitation:** The module uses combinational logic only. A registered implementation with glitch filtering would be preferred for production security.

---

## Planned Enhancements (Not Yet in RTL)

The following items are documented in the specification but have no current RTL implementation. They represent the next development phase.

### 5. ROM/eFuse/OTP-Based Secure Key Storage
The `secure_key_storage` module currently holds the trusted hash in a register initialized from a `localparam`. This value is synthesized away to a constant by the synthesis tool. A production implementation must store the key in eFuse or OTP memory that is physically immutable after programming.

### 6. Runtime Firmware Integrity Monitoring
No runtime monitoring hooks exist in the current RTL. Future work would add a continuous hash-checking engine that periodically re-authenticates firmware in memory during normal system operation, not just at boot time.

### 7. Enhanced Verification Environment
The current testbench uses directed SystemVerilog test scenarios. A constrained-random UVM environment with a scoreboard, coverage groups, and assertion-based checking is planned for future verification completeness.

### 8. Recovery Boot Mechanism
No fallback or recovery boot path is implemented. A future enhancement would support a secondary trusted firmware image that the boot FSM can fall back to after repeated authentication failures, rather than entering hard lockdown.

---

## Summary Table

| Feature | RTL Status | Ports Present | Fully Functional |
|---|---|---|---|
| Anti-rollback protection | Stub | `fw_version_in`, `rollback_alert` | Volatile only (no eFuse) |
| TEE handoff signal | Stub | `tee_handoff` | Signal only, no TEE logic |
| OTA authentication interface | Stub |  `ota_update_req`, `ota_auth_grant` | No dedicated auth path |
| Secure debug / JTAG control | Functional |  `jtag_disable`, `debug_enable` | Combinational only |

## Objective

To demonstrate a synthesizable hardware-based secure boot architecture capable of authenticating firmware before CPU execution and establishing a trusted startup mechanism for embedded systems and SoC platforms.

---
