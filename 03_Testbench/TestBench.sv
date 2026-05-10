`timescale 1ns/1ps
// ================================================================
//  testbench.sv  -  Hardware Root-of-Trust Testbench
// ----------------------------------------------------------------
//  firmware_ascii_loader
//  Converts a string to 32-bit word stream with correct padding.
//  Throttles to only send when auth_engine is in COLLECT state.
// ----------------------------------------------------------------
module firmware_ascii_loader (
    input  logic        clk,
    output logic [31:0] fw_data,
    output logic        fw_valid,
    output logic        fw_last,
    output logic [1:0]  fw_strobe
);
    initial begin
        fw_data=0; fw_valid=0; fw_last=0; fw_strobe=0;
    end

    task send_firmware(input string fw_string);
        int len, words;
        logic [31:0] word_data;
        int wait_cnt;
        len   = fw_string.len();
        words = (len + 3) / 4;

        for (int i = 0; i < words; i++) begin
            // Pack up to 4 ASCII bytes, big-endian, zero-pad if partial
            word_data = 32'h0;
            for (int j = 0; j < 4; j++) begin
                if ((i*4+j) < len)
                    word_data[(3-j)*8 +: 8] = fw_string[i*4+j];
                else
                    word_data[(3-j)*8 +: 8] = 8'h00;
            end

            // Wait for auth_engine to be in COLLECT (state==1)
            // Timeout after 2000 cycles to avoid infinite hang
            wait_cnt = 0;
            @(posedge clk);
            while (tb_sv.dut.u_auth_engine.state !== 3'd1) begin
                @(posedge clk);
                wait_cnt = wait_cnt + 1;
                if (wait_cnt > 2000) begin
                    $display("  ERROR: loader timed out waiting for COLLECT state");
                    disable send_firmware;
                end
            end

            fw_valid  <= 1'b1;
            fw_data   <= word_data;
            fw_last   <= (i == words-1);
            fw_strobe <= (i == words-1) ? (len % 4) : 2'b00;
        end
        @(posedge clk);
        fw_valid<=0; fw_last<=0; fw_data<=0; fw_strobe<=0;
    endtask
endmodule


// ----------------------------------------------------------------
//  tb_sv - top-level testbench
// ----------------------------------------------------------------
module tb_sv;

    logic        clk, rst_n, boot_req;
    logic [31:0] fw_data;
    logic        fw_valid, fw_last;
    logic [1:0]  fw_strobe;
    logic        cpu_reset_n, boot_done, boot_pass, secure_mode;

    // Latched result - captured before boot_req drops
    logic        result_pass;
    logic        result_cpu;

    rot_top dut (
        .clk(clk), .rst_n(rst_n), .boot_req(boot_req),
        .fw_data(fw_data), .fw_valid(fw_valid),
        .fw_last(fw_last), .fw_strobe(fw_strobe),
        .cpu_reset_n(cpu_reset_n), .boot_done(boot_done),
        .boot_pass(boot_pass), .secure_mode(secure_mode)
    );

    firmware_ascii_loader loader (
        .clk(clk), .fw_data(fw_data), .fw_valid(fw_valid),
        .fw_last(fw_last), .fw_strobe(fw_strobe)
    );

    initial clk=0;
    always #5 clk=~clk;

    // ---- digest monitor: prints once when final SHA block completes ----
    always @(posedge clk) begin
        if (dut.u_auth_engine.state == 3'd4 &&   // SHA_COMPUTE
            dut.u_auth_engine.sha_done          &&
            dut.u_auth_engine.sha_last_block) begin
            $display("  SHA-256 computed : %h", dut.u_auth_engine.sha_digest);
            $display("  Golden hash      : %h", dut.u_auth_engine.trusted_key);
            if (dut.u_auth_engine.sha_digest == dut.u_auth_engine.trusted_key)
                $display("  Digest match     : YES");
            else
                $display("  Digest match     : NO");
        end
    end

    // ----------------------------------------------------------------
    //  do_boot task
    //  1. Hard-resets the DUT (clears lockdown, retry counter, all state)
    //  2. Asserts boot_req, waits 2 cycles, sends firmware
    //  3. Waits for boot_done, LATCHES result while FSM still in BOOT_ALLOW/DENY
    //  4. Drops boot_req, waits for system to return to idle
    // ----------------------------------------------------------------
    task do_boot(input string fw_str, input string label);
        // -- Hard reset: clears lockdown, retry counter, everything --
        boot_req = 0;
        rst_n    = 0;
        #20;
        rst_n    = 1;
        repeat(4) @(posedge clk);

        $display("\n--- %s ---", label);

        @(posedge clk);
        boot_req = 1;
        repeat(2) @(posedge clk);

        loader.send_firmware(fw_str);

        // Wait for boot decision
        wait(boot_done);
        @(posedge clk);

        // Latch result NOW while FSM is still asserting boot_pass/boot_done
        result_pass = boot_pass;
        result_cpu  = cpu_reset_n;

        $display("  boot_pass=%0b  cpu_reset_n=%0b  secure_mode=%0b",
                 boot_pass, cpu_reset_n, secure_mode);
        if (boot_pass)
            $display("  Result: TRUSTED - device ON");
        else
            $display("  Result: REJECTED - device OFF");

        // Deassert boot_req, let FSM return to IDLE
        boot_req = 0;
        wait(!boot_done);
        #50;
    endtask

    // ================================================================
    //  MAIN TEST SEQUENCE
    //  Tests can be in any order - each do_boot resets the DUT first.
    //
    //  GOLDEN FIRMWARE: change EXPECTED_HASH in secure_key_storage
    //  to match SHA-256 of whichever string you put in TEST 0 below.
    //
    //  Current golden:
    //    SHA-256("Modern electronic systems require...") =
    //    dd7ff9198386cfde00f9d96aa877e6ba4d48b863788cfb39b0249ee7fd372ed1
    // ================================================================
    initial begin
        $dumpfile("rot_sim.vcd");
        $dumpvars(0, tb_sv);

        rst_n=0; boot_req=0;
        #20 rst_n=1;
        repeat(4) @(posedge clk);

        $display("\n========================================");
        $display("  Hardware Root-of-Trust Testbench");
        $display("  Golden = SHA-256(large firmware string)");
        $display("========================================");

        // ---- TEST 0: Trusted firmware (multi-block, expect PASS) -------
        do_boot(
            "Modern electronic systems require a secure mechanism to ensure that only authentic and unmodified firmware is executed during device startup. However, firmware stored in memory can be vulnerable to tampering, unauthorized modification, or malicious code insertion. Therefore, a reliable method is needed to verify the integrity and authenticity of firmware before the device begins execution. This project addresses the problem by implementing a hardware-based verification mechanism that validates firmware using cryptographic algorithms, ensuring that only trusted firmware is allowed to run and preventing potential security breaches during the boot process. Modern electronic systems require a secure mechanism to ensure that only authentic and unmodified firmware is executed during device startup. However, firmware stored in memory can be vulnerable to tampering, unauthorized modification, or malicious code insertion. Therefore, a reliable method is needed to verify the integrity and authenticity of firmware before the device begins execution. This project addresses the problem by implementing a hardware-based verification mechanism that validates firmware using cryptographic algorithms, ensuring that only trusted firmware is allowed to run and preventing potential security breaches during the boot process. Modern electronic systems require a secure mechanism to ensure that only authentic and unmodified firmware is executed during device startup. However, firmware stored in memory can be vulnerable to tampering, unauthorized modification, or malicious code insertion. Therefore, a reliable method is needed to verify the integrity and authenticity of firmware before the device begins execution. This project addresses the problem by implementing a hardware-based verification mechanism that validates firmware using cryptographic algorithms, ensuring that only trusted firmware is allowed to run and preventing potential security breaches during the boot process. Modern electronic systems require a secure mechanism to ensure that only authentic and unmodified firmware is executed during device startup. However, firmware stored in memory can be vulnerable to tampering, unauthorized modification, or malicious code insertion. Therefore, a reliable method is needed to verify the integrity and authenticity of firmware before the device begins execution. This project addresses the problem by implementing a hardware-based verification mechanism that validates firmware using cryptographic algorithms, ensuring that only trusted firmware is allowed to run and preventing potential security breaches during the boot process.",
            "TEST 0: large trusted firmware (expect TRUSTED)"
        );
        if (result_pass && result_cpu)
            $display("  TEST 0 PASS");
        else
            $display("  TEST 0 FAIL (result_pass=%0b result_cpu=%0b)", result_pass, result_cpu);

        // ---- TEST 1: Wrong firmware (expect REJECTED) ------------------
        do_boot("HELLOWORLD", "TEST 1: HELLOWORLD (expect REJECTED)");
        if (!result_pass && !result_cpu)
            $display("  TEST 1 PASS");
        else
            $display("  TEST 1 FAIL");

        // ---- TEST 2: Wrong firmware (expect REJECTED) ------------------
        do_boot("SECUREBOOT_HACKD", "TEST 2: SECUREBOOT_HACKD (expect REJECTED)");
        if (!result_pass && !result_cpu)
            $display("  TEST 2 PASS");
        else
            $display("  TEST 2 FAIL");

        // ---- TEST 3: Wrong firmware -> lockdown (expect LOCKDOWN) ------
        // Note: lockdown needs 3 consecutive fails WITHOUT a reset between them.
        // do_boot resets each time, so we use a special inline sequence here.
        $display("\n--- TEST 3: 3x wrong firmware -> LOCKDOWN ---");
        // Reset once to start clean
        rst_n=0; #20; rst_n=1; repeat(4) @(posedge clk);
        // Attempt 1
        @(posedge clk); boot_req=1; repeat(2) @(posedge clk);
        loader.send_firmware("BAD_FIRMWARE_001");
        wait(boot_done); @(posedge clk); boot_req=0;
        wait(!boot_done); #50;
        $display("  Attempt 1 done - retry count rising");
        // Attempt 2
        @(posedge clk); boot_req=1; repeat(2) @(posedge clk);
        loader.send_firmware("BAD_FIRMWARE_002");
        wait(boot_done); @(posedge clk); boot_req=0;
        wait(!boot_done); #50;
        $display("  Attempt 2 done - retry count rising");
        // Attempt 3 -> lockdown
        @(posedge clk); boot_req=1; repeat(2) @(posedge clk);
        loader.send_firmware("BAD_FIRMWARE_003");
        wait(dut.lockdown_active);
        #100;
        if (dut.lockdown_active && !cpu_reset_n)
            $display("  TEST 3 PASS - lockdown_active=1  cpu_reset_n=0");
        else
            $display("  TEST 3 FAIL");
        boot_req=0; #50;

        // ---- TEST 4: Trusted firmware AFTER lockdown (with reset) ------
        // do_boot resets the DUT, so lockdown is cleared -> should PASS
        do_boot(
            "Modern electronic systems require a secure mechanism to ensure that only authentic and unmodified firmware is executed during device startup. However, firmware stored in memory can be vulnerable to tampering, unauthorized modification, or malicious code insertion. Therefore, a reliable method is needed to verify the integrity and authenticity of firmware before the device begins execution. This project addresses the problem by implementing a hardware-based verification mechanism that validates firmware using cryptographic algorithms, ensuring that only trusted firmware is allowed to run and preventing potential security breaches during the boot process. Modern electronic systems require a secure mechanism to ensure that only authentic and unmodified firmware is executed during device startup. However, firmware stored in memory can be vulnerable to tampering, unauthorized modification, or malicious code insertion. Therefore, a reliable method is needed to verify the integrity and authenticity of firmware before the device begins execution. This project addresses the problem by implementing a hardware-based verification mechanism that validates firmware using cryptographic algorithms, ensuring that only trusted firmware is allowed to run and preventing potential security breaches during the boot process. Modern electronic systems require a secure mechanism to ensure that only authentic and unmodified firmware is executed during device startup. However, firmware stored in memory can be vulnerable to tampering, unauthorized modification, or malicious code insertion. Therefore, a reliable method is needed to verify the integrity and authenticity of firmware before the device begins execution. This project addresses the problem by implementing a hardware-based verification mechanism that validates firmware using cryptographic algorithms, ensuring that only trusted firmware is allowed to run and preventing potential security breaches during the boot process. Modern electronic systems require a secure mechanism to ensure that only authentic and unmodified firmware is executed during device startup. However, firmware stored in memory can be vulnerable to tampering, unauthorized modification, or malicious code insertion. Therefore, a reliable method is needed to verify the integrity and authenticity of firmware before the device begins execution. This project addresses the problem by implementing a hardware-based verification mechanism that validates firmware using cryptographic algorithms, ensuring that only trusted firmware is allowed to run and preventing potential security breaches during the boot process.",
            "TEST 4: trusted firmware after lockdown reset (expect TRUSTED)"
        );
        if (result_pass && result_cpu)
            $display("  TEST 4 PASS");
        else
            $display("  TEST 4 FAIL");

        $display("\n========================================");
        $display("  ALL ROT TESTS COMPLETE");
        $display("========================================\n");
            // ── Functional Coverage ──────────────────────────────────────────
covergroup rot_coverage @(posedge clk);

  cp_boot_pass: coverpoint boot_pass {
    bins trusted  = {1};
    bins rejected = {0};
  }

  cp_lockdown: coverpoint dut.lockdown_active {
    bins no_lockdown = {0};
    bins lockdown    = {1};
  }

  cp_cpu_reset: coverpoint cpu_reset_n {
    bins cpu_running = {1};
    bins cpu_blocked = {0};
  }

  cp_secure_mode: coverpoint secure_mode {
    bins secure     = {1};
    bins not_secure = {0};
  }

  // Cross coverage: boot_pass must only be 1 when cpu_reset_n is 1
  cx_pass_cpu: cross cp_boot_pass, cp_cpu_reset;

  // Cross coverage: lockdown must always block CPU
  cx_lock_cpu: cross cp_lockdown, cp_cpu_reset;

endgroup

rot_coverage cov_inst = new();
        $display("Functional Coverage: %.1f%%", cov_inst.get_coverage());
        $finish;
    end



endmodule
