# Testbench – Hardware Root-of-Trust (RoT)

## Overview
This directory contains the verification environment and testbench implementation for validating the functionality of the Hardware Root-of-Trust (RoT) architecture. The verification environment is developed using SystemVerilog and UVM methodology to ensure correct secure boot operation and firmware authentication behavior.

---

## Verification Objectives

- Validate secure boot functionality
- Verify firmware authentication flow
- Ensure controlled CPU execution
- Detect invalid firmware conditions
- Validate retry and lockdown mechanisms
- Verify reset and control behavior

---

## Test Scenarios

| Test Case | Description |
|---|---|
| Authentication PASS | Valid firmware authentication |
| Authentication FAIL | Detection of modified firmware |
| Retry Validation | Multiple failed authentication attempts |
| Lockdown Verification | Secure lockdown activation |
| CPU Reset Control | CPU release only after verification |
| Reset Functionality | System behavior during reset |

---

## Verification Environment

| Category | Technology |
|---|---|
| Verification Language | SystemVerilog |
| Methodology | UVM |
| Simulation Tool | Cadence Xcelium |

---

## Testbench Components

| Component | Function |
|---|---|
| Driver | Drives firmware and control signals |
| Monitor | Observes DUT behavior |
| Scoreboard | Validates expected functionality |
| Sequence | Generates verification scenarios |
| Agent | Controls verification components |
| Environment | Integrates complete testbench |

---

## Functional Flow

```text
Generate Test Stimulus
        ↓
Drive Firmware Data
        ↓
Monitor DUT Response
        ↓
Compare Expected Results
        ↓
PASS / FAIL Verification
```

---

## Directory Structure

```text
tb/
├── testbench.sv
├── interface.sv
├── driver.sv
├── monitor.sv
├── scoreboard.sv
├── sequence.sv
├── agent.sv
├── env.sv
└── test.sv
```

---

## Expected Outcome
The verification environment ensures that the RoT design correctly authenticates firmware, prevents unauthorized execution, and maintains secure system behavior under all test conditions.

---

