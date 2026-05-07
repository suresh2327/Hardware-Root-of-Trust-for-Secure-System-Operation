# 🛡️ Hardware Root-of-Trust (RoT) for Secure System Operation

Welcome to the **Hardware Root-of-Trust (RoT)** repository! This project showcases a robust hardware-enforced security module designed for secure boot and firmware authentication using SHA-256 cryptographic verification.

## 📖 Project Overview
The Hardware Root-of-Trust (RoT) module ensures that only trusted, cryptographically verified firmware is allowed to execute before the main CPU startup sequence begins. It acts as the immutable foundational security layer in the system, implemented completely in hardware to resist software-based attacks. 

## 🎯 Motivation
With the rise of hardware security threats and unauthorized firmware modifications, establishing a secure state before software execution is critical. This project demonstrates a hardware-first approach to security by offloading SHA-256 hashing and authentication directly to an ASIC-compatible RTL design.

## ✨ Key Features
- **Secure Boot Controller:** Manages the system startup state machine, enforcing firmware verification.
- **SHA-256 Cryptographic Engine:** Performs fast, hardware-accelerated hashing of the firmware image.
- **Hardware-Enforced Security:** CPU remains in reset until firmware authenticity is mathematically proven.
- **ASIC Design Ready:** Implemented with standard RTL-to-GDSII flows in mind.
- **UVM Verification:** Rigorously tested using the Universal Verification Methodology (UVM).



## 🛠️ VLSI Design Flow
1. **Specifications & Architecture:** Defining the RoT protocols, FSM states, and threat models.
2. **RTL Design:** Writing SystemVerilog for the SHA-256 engine and Boot Controller.
3. **Functional Verification:** Utilizing UVM to create a constrained-random test environment.
4. **Synthesis & Physical Design:** Prepared for integration using standard Cadence tools.

## 📂 Folder Structure Explanation
| Folder | Description |
|--------|-------------|
| **`01_Specifications/`** | Contains specifications, security requirements, and feature definitions. |
| **`02_RTL_Code/`** | Contains the SystemVerilog RTL code for the secure boot controller and SHA-256 engine. |
| **`03_TestBench/`** | Contains UVM testbenches, verification plans, and test scripts. |
| **`04_Logic_synthesis/`** | Contains UVM testbenches, verification plans, and test scripts. |
| **`05_Physical_Design/`** | Contains UVM testbenches, verification plans, and test scripts. |
| **`06_Outputs/`** | Contains UVM testbenches, verification plans, and test scripts. |


## 🧰 Tools Used
- **Hardware Language:** SystemVerilog
- **Simulation & Verification:** Cadence Xcelium,Genus,innovus / UVM Integration

*Designed and Compiled to showcase advanced hardware security and VLSI verification methodologies.*
