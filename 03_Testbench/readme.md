# Testbench – Hardware Root-of-Trust (RoT)

## Overview

This directory contains the SystemVerilog-based functional verification environment used to validate the behavior of the Hardware Root-of-Trust (RoT) architecture.

The verification environment focuses on validating secure boot control, firmware authentication flow, retry handling, lockdown behavior, and CPU reset enforcement under different authentication scenarios.

The testbench is designed for functional verification of the RTL implementation using directed verification scenarios in Cadence Xcelium simulation environment.

---

## Verification Objectives

- Validate secure boot functionality
- Verify firmware authentication behavior
- Ensure controlled CPU execution
- Detect invalid firmware conditions
- Validate retry counter operation
- Verify lockdown activation
- Confirm reset and state transition behavior

---

## Verification Scenarios

| Test Case | Description |
|---|---|
| Authentication PASS | Valid firmware authentication flow |
| Authentication FAIL | Detection of modified firmware |
| Retry Validation | Multiple failed authentication attempts |
| Lockdown Verification | Secure lockdown activation after retry limit |
| CPU Reset Control | CPU release only after successful authentication |
| Reset Functionality | System reset and FSM recovery behavior |

---

## Verification Environment

| Category | Technology |
|---|---|
| Verification Language | SystemVerilog |
| Verification Style | Directed Functional Verification |
| Simulation Tool | Cadence Xcelium |

---

## Testbench Components

| Component | Function |
|---|---|
| Testbench Top | Integrates DUT and verification signals |
| Stimulus Generator | Applies firmware and control inputs |
| DUT Monitor | Observes DUT outputs and state transitions |
| Result Checker | Validates expected authentication behavior |
| Waveform Analysis | Verifies timing and signal activity |

---

## Functional Verification Flow

```text
Generate Test Stimulus
        ↓
Apply Firmware Data
        ↓
Execute Authentication Flow
        ↓
Monitor DUT Behavior
        ↓
Validate PASS / FAIL Results
```

---

## Testbench Structure

```text
tb/
├── testbench.sv
├── stimulus.sv
├── monitor.sv
├── checker.sv
├── testcases.sv
└── interface.sv
```



## Verification Coverage

The verification environment validates:
- Secure boot sequence
- SHA-256 authentication control flow
- PASS authentication condition
- FAIL authentication condition
- Retry exhaustion handling
- Lockdown activation
- CPU reset enforcement
- FSM state transitions

---

## Simulation Environment

Functional simulation was performed using Cadence Xcelium to verify RTL correctness and secure boot operation before synthesis and physical design implementation.

Simulation outputs include:
- Console verification logs
- Authentication PASS/FAIL waveforms
- FSM transition timing diagrams
- CPU reset and lockdown behavior

---

## Expected Outcome

The verification environment ensures that the Hardware Root-of-Trust architecture correctly authenticates firmware before CPU execution and prevents unauthorized boot operation during invalid authentication conditions.

---
