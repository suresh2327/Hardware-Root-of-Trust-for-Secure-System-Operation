# 📋 01 Specifications

This section defines the hardware specifications, security requirements, and expected behaviors established before the RTL design of the **Hardware Root-of-Trust (RoT)** module.

## 📖 System Description
The system functions as an immutable secure boot controller. Upon power-up, the system holds the main CPU in a reset state. It fetches firmware data and computes a SHA-256 hash using a dedicated cryptographic engine. The computed hash is compared against a trusted signature. If the match is successful, the CPU reset is lifted. If it fails, the system enters a secure lockdown state.

## ✅ Functional Requirements
- **Secure boot sequence enforcement**: Automated validation of execution code.
- **Firmware integrity checking**: Validating via SHA-256 hash blocks.
- **CPU reset management**: Strict control over the system CPU reset line based on authentication results.
- **Lockdown state**: Irreversible transition upon signature mismatch until hardware reboot.

## 🛡️ Security Constraints
- **Hardware Isolation:** Cryptographic operations are isolated from the main CPU to prevent software side-channel attacks.
- **Immutable BootROM:** The initial RoT sequence cannot be bypassed, tampered with, or modified by malicious software.
- **Tamper Response:** Unsuccessful authentications immediately lock the system, preventing brute-force attack attempts.
