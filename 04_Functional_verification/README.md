# 🧪 04 Functional Verification

This directory contains the robust verification environment built to validate the **Hardware Root-of-Trust (RoT)** module before logic synthesis and tape-out.

## 🏗️ Verification Methodology
Verification is rigorously performed using the **Universal Verification Methodology (UVM)**. This ensures comprehensive testing through constrained-random stimulus generation, protocol checking, and coverage-driven verification (CDV) techniques.

## 🎯 Verification Goals
- **Cryptographic Accuracy:** Verify the SHA-256 hardware output against a golden software reference model.
- **Boot FSM Coverage:** Validate the Boot Controller FSM across all valid firmware, invalid firmware, and partial memory read scenarios.
- **Fail-Secure Validation:** Ensure the lockdown mechanism triggers immediately on a mismatch and cannot be bypassed via any input sequences.

## 📂 Environment Components
- **Testbench (`tb_top.sv`)**: Instantiates the Design Under Test (DUT) and the full UVM environment.
- **UVM Sequences**: Generates various firmware payloads (valid signatures, corrupted hashes, and out-of-bounds lengths).
- **UVM Scoreboard**: Automates output checking by comparing RTL hash digests and Boot Controller decisions against the ideal predictor.
- **Coverage Reports**: Detailed functional and code coverage reports to ensure 100% verification completeness.
