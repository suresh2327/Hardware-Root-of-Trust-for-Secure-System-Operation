# 🏛️ 02 Architecture

This directory details the architectural diagrams, block interactions, and Finite State Machines (FSM) driving the **Hardware Root-of-Trust**.

## 🏗️ System Architecture Overview
The architecture is divided into two primary hardware subsystems:
1. **Boot Controller FSM:** Orchestrates the boot process, data fetching, and decision logic.
2. **SHA-256 Cryptographic Engine:** Performs the data hashing mathematically and provides the resulting digest to the Boot Controller.

## 🔄 FSM Description
- **POWER_ON_RESET:** System initializes, and the CPU is strictly held in reset.
- **FETCH_FIRMWARE:** RoT module reads firmware blocks from internal/external memory.
- **HASH_COMPUTATION:** The SHA-256 engine processes the fetched firmware blocks in parallel.
- **AUTHENTICATION:** The computed hash is securely compared against the stored trusted signature.
- **BOOT_SUCCESS:** Signatures match; CPU reset is de-asserted, allowing normal OS boot.
- **LOCKDOWN:** Signatures mismatch; the system halts completely and refuses to boot.

## 📂 Available Documents
The following architectural documents represent the blueprint of the system:
- **FSM Documents:** Contains state transition graphs and signal-level explanations for the Boot Controller.
- **Architecture Diagrams:** High-level overview of the Data path and Control path of the RoT logic.
