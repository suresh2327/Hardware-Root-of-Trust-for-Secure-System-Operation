# 💻 03 RTL Design

This directory contains the Register Transfer Level (RTL) implementation of the **Hardware Root-of-Trust (RoT)**.

## 🛠️ Implementation Details
The hardware components are entirely written in **SystemVerilog**, focusing on synthesizability, timing constraints, and performance within an ASIC standard cell flow.

### 🧩 Key Hardware Modules
- **`secure_boot_controller.sv`**: Implements the Boot FSM and strict CPU reset logic.
- **`sha256_engine.sv`**: A hardware-accelerated SHA-256 hash generator optimized for minimal clock cycles per block.
- **`rot_top.sv`**: The top-level wrapper module securely wiring the Boot Controller and the Cryptographic Engine.

## ⚙️ Design Goals
- **Low Latency:** Optimized SHA-256 rounds to minimize boot delay without compromising security.
- **High Security:** No hidden debugging states, JTAG backdoors, or scan-chain vulnerabilities in the critical authentication logic.
- **Scalability:** The top-level interface is standard, making it easily integratable into larger System-on-Chip (SoC) designs.
