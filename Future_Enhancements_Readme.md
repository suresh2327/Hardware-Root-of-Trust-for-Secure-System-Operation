# Future Enhancements
The current RTL architecture includes preliminary interface hooks and modular infrastructure for future security enhancements.

The current Hardware Root-of-Trust (RoT) architecture is designed using a modular RTL structure, allowing future security extensions and architectural improvements. Several interface hooks and control signals have already been introduced in the current implementation to support future scalability.
## Implemented in RTL (Structural Hooks Present)

The following features have interface ports and stub logic wired into `rot_top`. They are not fully functional but provide the architectural foundation for future development.

### 1. Anti-Rollback Protection
**Status: Functional stub**

A version ratchet register (`fw_version_min`) is implemented in `rot_top`. After each successful authenticated boot, the minimum acceptable firmware version is updated if the incoming version is higher. A rollback is flagged if the incoming version is below the stored minimum.

**Ports exposed:**
- `fw_version_in [7:0]` — firmware version field from the firmware header
- `rollback_alert` — asserted if the incoming version is below the stored minimum


---

### 2. TEE Handoff Signal
**Status: Functional stub**

A registered output signal `tee_handoff` is driven high after a successful authenticated boot and de-asserted on hardware reset. This provides a single-cycle pulse that an external Trusted Execution Environment controller can use to begin its initialization sequence.

**Port exposed:**
- `tee_handoff` — registered pulse after trusted boot completes
---

### 3. OTA Firmware Authentication Interface
**Status: Combinational stub**

A top-level port for OTA update requests is present. The current grant logic is combinational: OTA is approved if the last boot passed authentication, no rollback is detected, and the system is not in lockdown.

**Ports exposed:**
- `ota_update_req` — input request to authenticate an OTA firmware image
- `ota_auth_grant` — output approval signal

---

### 4. Secure Debug Access Control
**Status: Functional**

A `debug_ctrl` module is instantiated and connected in `rot_top`. JTAG access is disabled during authentication failure or lockdown, and enabled only after a successful authentication.

**Ports exposed:**
- `jtag_disable` — asserted to disable JTAG access
- `debug_enable` — asserted only when `auth_pass` is high and `lockdown_active` is low

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
