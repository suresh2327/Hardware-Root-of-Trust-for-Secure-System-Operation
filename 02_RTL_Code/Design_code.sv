//  Hardware Root-of-Trust (RoT) - design.sv
//  SHA-256 firmware authentication engine
//  Supports arbitrary firmware length (multi 512-bit blocks)
//  sha256_core
//  Single-block SHA-256 compressor.
//  Supports multi-block chaining via reset_hash internal flag.
//    last_block=0 -> update H0..H7 state, assert done, stay ready
//    last_block=1 -> update H0..H7, output digest, reset for next msg
// ----------------------------------------------------------------
module sha256_core(
  input  wire         clk,
  input  wire         rst,
  input  wire         start,
  input  wire [511:0] block,
  input  wire         last_block,
  output reg  [255:0] digest,
  output reg          done,
  output wire         ready
);
  localparam IDLE=0, LOAD=1, EXPAND=2, ROUND=3, FINAL=4;
  reg [2:0] state;
  reg [31:0] W[0:63];

  function [31:0] get_k(input [5:0] idx);
    case(idx)
      0: get_k=32'h428a2f98; 1: get_k=32'h71374491; 2: get_k=32'hb5c0fbcf; 3: get_k=32'he9b5dba5;
      4: get_k=32'h3956c25b; 5: get_k=32'h59f111f1; 6: get_k=32'h923f82a4; 7: get_k=32'hab1c5ed5;
      8: get_k=32'hd807aa98; 9: get_k=32'h12835b01; 10: get_k=32'h243185be; 11: get_k=32'h550c7dc3;
      12: get_k=32'h72be5d74; 13: get_k=32'h80deb1fe; 14: get_k=32'h9bdc06a7; 15: get_k=32'hc19bf174;
      16: get_k=32'he49b69c1; 17: get_k=32'hefbe4786; 18: get_k=32'h0fc19dc6; 19: get_k=32'h240ca1cc;
      20: get_k=32'h2de92c6f; 21: get_k=32'h4a7484aa; 22: get_k=32'h5cb0a9dc; 23: get_k=32'h76f988da;
      24: get_k=32'h983e5152; 25: get_k=32'ha831c66d; 26: get_k=32'hb00327c8; 27: get_k=32'hbf597fc7;
      28: get_k=32'hc6e00bf3; 29: get_k=32'hd5a79147; 30: get_k=32'h06ca6351; 31: get_k=32'h14292967;
      32: get_k=32'h27b70a85; 33: get_k=32'h2e1b2138; 34: get_k=32'h4d2c6dfc; 35: get_k=32'h53380d13;
      36: get_k=32'h650a7354; 37: get_k=32'h766a0abb; 38: get_k=32'h81c2c92e; 39: get_k=32'h92722c85;
      40: get_k=32'ha2bfe8a1; 41: get_k=32'ha81a664b; 42: get_k=32'hc24b8b70; 43: get_k=32'hc76c51a3;
      44: get_k=32'hd192e819; 45: get_k=32'hd6990624; 46: get_k=32'hf40e3585; 47: get_k=32'h106aa070;
      48: get_k=32'h19a4c116; 49: get_k=32'h1e376c08; 50: get_k=32'h2748774c; 51: get_k=32'h34b0bcb5;
      52: get_k=32'h391c0cb3; 53: get_k=32'h4ed8aa4a; 54: get_k=32'h5b9cca4f; 55: get_k=32'h682e6ff3;
      56: get_k=32'h748f82ee; 57: get_k=32'h78a5636f; 58: get_k=32'h84c87814; 59: get_k=32'h8cc70208;
      60: get_k=32'h90befffa; 61: get_k=32'ha4506ceb; 62: get_k=32'hbef9a3f7; 63: get_k=32'hc67178f2;
      default: get_k=32'h0;
    endcase
  endfunction

  reg [31:0] a,b,c,d,e,f,g,h;
  reg [31:0] h0,h1,h2,h3,h4,h5,h6,h7;
  reg [6:0]  round, widx;
  reg        last_block_reg, reset_hash;

  assign ready = (state == IDLE);

  function [31:0] rotr(input [31:0] x, input [4:0] n);
    rotr = (x >> n) | (x << (32-n));
  endfunction
  function [31:0] ch(input [31:0] x, input [31:0] y, input [31:0] z);
    ch = (x & y) ^ (~x & z);
  endfunction
  function [31:0] maj(input [31:0] x, input [31:0] y, input [31:0] z);
    maj = (x & y) ^ (x & z) ^ (y & z);
  endfunction
  function [31:0] ep0(input [31:0] x); ep0 = rotr(x,2)^rotr(x,13)^rotr(x,22); endfunction
  function [31:0] ep1(input [31:0] x); ep1 = rotr(x,6)^rotr(x,11)^rotr(x,25); endfunction
  function [31:0] sig0(input [31:0] x); sig0 = rotr(x,7)^rotr(x,18)^(x>>3);   endfunction
  function [31:0] sig1(input [31:0] x); sig1 = rotr(x,17)^rotr(x,19)^(x>>10); endfunction

  wire [31:0] T1 = h + ep1(e) + ch(e,f,g) + get_k(round[5:0]) + W[round[5:0]];
  wire [31:0] T2 = ep0(a) + maj(a,b,c);

  always @(posedge clk) begin
    if (rst) begin
      state <= IDLE; done <= 0; round <= 0; reset_hash <= 1; digest <= 0;
      last_block_reg <= 0; widx <= 0;
      h0<=0; h1<=0; h2<=0; h3<=0; h4<=0; h5<=0; h6<=0; h7<=0;
      a<=0; b<=0; c<=0; d<=0; e<=0; f<=0; g<=0; h<=0;
    end else begin
      case (state)
        IDLE: begin
          done <= 0;
          if (start) begin
            last_block_reg <= last_block;
            if (reset_hash) begin
              h0 <= 32'h6a09e667; h1 <= 32'hbb67ae85;
              h2 <= 32'h3c6ef372; h3 <= 32'ha54ff53a;
              h4 <= 32'h510e527f; h5 <= 32'h9b05688c;
              h6 <= 32'h1f83d9ab; h7 <= 32'h5be0cd19;
              reset_hash <= 0;
            end
            state <= LOAD;
          end
        end

        LOAD: begin
          W[0] <=block[511:480]; W[1] <=block[479:448]; W[2] <=block[447:416]; W[3] <=block[415:384];
          W[4] <=block[383:352]; W[5] <=block[351:320]; W[6] <=block[319:288]; W[7] <=block[287:256];
          W[8] <=block[255:224]; W[9] <=block[223:192]; W[10]<=block[191:160]; W[11]<=block[159:128];
          W[12]<=block[127:96];  W[13]<=block[95:64];   W[14]<=block[63:32];   W[15]<=block[31:0];
          widx <= 16; state <= EXPAND;
        end

        EXPAND: begin
          W[widx[5:0]] <= sig1(W[(widx-2)&63]) + W[(widx-7)&63]
                        + sig0(W[(widx-15)&63]) + W[(widx-16)&63];
          if (widx == 63) begin
            a<=h0; b<=h1; c<=h2; d<=h3; e<=h4; f<=h5; g<=h6; h<=h7;
            round <= 0; state <= ROUND;
          end else widx <= widx + 1;
        end

        ROUND: begin
          h<=g; g<=f; f<=e; e<=d+T1; d<=c; c<=b; b<=a; a<=T1+T2;
          if (round == 63) state <= FINAL; else round <= round + 1;
        end

        FINAL: begin
          h0 <= h0+a; h1 <= h1+b; h2 <= h2+c; h3 <= h3+d;
          h4 <= h4+e; h5 <= h5+f; h6 <= h6+g; h7 <= h7+h;
          if (last_block_reg) begin
            digest    <= {h0+a,h1+b,h2+c,h3+d,h4+e,h5+f,h6+g,h7+h};
            reset_hash <= 1;
          end
          done  <= 1;
          state <= IDLE;
        end
      endcase
    end
  end
endmodule


//  auth_engine
//  Streams fw_data words into SHA-256 with correct PKCS padding.
//  State encoding (matches testbench monitor):
//    IDLE=0  COLLECT=1  PAD_WAIT=2  SEND_LENGTH_BLOCK=3
//    SHA_COMPUTE=4  DONE=5
// ----------------------------------------------------------------
module auth_engine (
  input  logic        clk,
  input  logic        rst_n,
  input  logic        start_auth,
  input  logic [31:0] fw_data,
  input  logic        fw_valid,
  input  logic        fw_last,
  input  logic [1:0]  fw_strobe,
  input  logic [255:0] trusted_key,
  output logic        auth_done,
  output logic        auth_pass
);
  logic sha_start, sha_last_block;
  logic [511:0] sha_block;
  logic [255:0] sha_digest;
  logic sha_done, sha_ready;

  sha256_core u_sha256 (
    .clk(clk), .rst(~rst_n),
    .start(sha_start), .block(sha_block), .last_block(sha_last_block),
    .digest(sha_digest), .done(sha_done), .ready(sha_ready)
  );

  // State encoding kept compatible with testbench monitor (state==4'd4 = SHA_COMPUTE)
  typedef enum logic [2:0] {
    IDLE             = 3'd0,
    COLLECT          = 3'd1,
    PAD_WAIT         = 3'd2,
    SEND_LENGTH_BLOCK= 3'd3,
    SHA_COMPUTE      = 3'd4,
    DONE             = 3'd5
  } state_t;
  state_t state;

  logic [511:0] buffer;
  logic [63:0]  total_bits;
  logic [4:0]   word_count;
  logic         last_seen;      // fw_last received
  logic         length_pending; // length did not fit in current block
  logic         pad_done;       // 0x80 already written into last data word

  // How many bits does the last word contribute?
  // strobe=0 means all 4 bytes valid (32 bits)
  function automatic [5:0] last_word_bits(input logic [1:0] s);
    case (s)
      2'b01: last_word_bits = 6'd8;
      2'b10: last_word_bits = 6'd16;
      2'b11: last_word_bits = 6'd24;
      default: last_word_bits = 6'd32;
    endcase
  endfunction

  // OR-mask to embed 0x80 immediately after the last valid byte
  function automatic [31:0] pad_byte_mask(input logic [1:0] s);
    case (s)
      2'b01: pad_byte_mask = 32'h00800000;
      2'b10: pad_byte_mask = 32'h00008000;
      2'b11: pad_byte_mask = 32'h00000080;
      default: pad_byte_mask = 32'h00000000;
    endcase
  endfunction

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state          <= IDLE;
      buffer         <= '0;
      total_bits     <= '0;
      word_count     <= '0;
      last_seen      <= 0;
      length_pending <= 0;
      pad_done       <= 0;
      auth_done      <= 0;
      auth_pass      <= 0;
      sha_start      <= 0;
      sha_block      <= '0;
      sha_last_block <= 0;
    end else begin
      sha_start <= 1'b0; // default: deassert every cycle

      case (state)

        // ---- IDLE -------------------------------------------------------
        // Wait for start_auth from boot_ctrl_fsm.
        // Reset all state so this engine is clean for every new boot attempt.
        // -----------------------------------------------------------------
        IDLE: begin
          auth_done      <= 0;
          auth_pass      <= 0;
          buffer         <= '0;
          total_bits     <= '0;
          word_count     <= '0;
          last_seen      <= 0;
          length_pending <= 0;
          pad_done       <= 0;
          if (start_auth) state <= COLLECT;
        end

        // ---- COLLECT ----------------------------------------------------
        // Receive one fw_data word per fw_valid cycle.
        //
        // Three paths:
        //  A) fw_last, partial word (strobe!=0):
        //       embed 0x80 in same word, set pad_done=1
        //  B) fw_last, full word (strobe==0):
        //       store word normally, pad_done stays 0 (0x80 written next cycle)
        //  C) word_count==15 (block full, not fw_last):
        //       flush block -> PAD_WAIT (sha_last_block=0) -> SHA_COMPUTE -> COLLECT
        //
        // After fw_last, two more cycles complete the padding:
        //  - If pad_done=0: write 0x80000000 word (or length if room)
        //  - Then write length at buffer[63:0] -> PAD_WAIT
        // -----------------------------------------------------------------
        COLLECT: begin
          if (fw_valid && !last_seen) begin

            if (fw_last && fw_strobe != 2'b00) begin
              // Path A: partial last word with embedded 0x80
              buffer[511 - word_count*32 -: 32] <= fw_data | pad_byte_mask(fw_strobe);
              total_bits <= total_bits + last_word_bits(fw_strobe);
              last_seen  <= 1'b1;
              pad_done   <= 1'b1;
              word_count <= word_count + 1'b1;

            end else begin
              // Path B or C: full word
              buffer[511 - word_count*32 -: 32] <= fw_data;
              total_bits <= total_bits + 64'd32;

              if (fw_last) begin
                // Path B: last full word - need 0x80 in a subsequent word
                last_seen  <= 1'b1;
                word_count <= word_count + 1'b1;
              end else if (word_count == 5'd15) begin
                // Path C: block boundary, not last - flush this block
                state      <= PAD_WAIT;
                word_count <= '0;
              end else begin
                word_count <= word_count + 1'b1;
              end
            end

          end else if (last_seen && !pad_done) begin
            // Write 0x80 word immediately after last data word
            buffer[511 - word_count*32 -: 32] <= 32'h8000_0000;
            if (word_count <= 5'd13) begin
              // Room for 0x80 AND length in this block
              buffer[63:0]   <= total_bits;
              length_pending <= 1'b0;
            end else begin
              // 0x80 at position 14 or 15 - no room for length
              length_pending <= 1'b1;
            end
            state <= PAD_WAIT;

          end else if (last_seen && pad_done) begin
            // 0x80 already embedded in last data word
            if (word_count <= 5'd14) begin
              // Room for length
              buffer[63:0]   <= total_bits;
              length_pending <= 1'b0;
            end else begin
              // word_count==15: no room for length (0x80 is at word 14)
              length_pending <= 1'b1;
            end
            state <= PAD_WAIT;
          end
        end

        // ---- PAD_WAIT ---------------------------------------------------
        // Wait for SHA core to be ready, then submit the current block.
        // If last_seen=0: this is a mid-stream data block (not last).
        // If last_seen=1: this is the padded block.
        // -----------------------------------------------------------------
        PAD_WAIT: begin
          if (sha_ready) begin
            sha_start <= 1'b1;
            sha_block <= buffer;
            if (last_seen) begin
              if (length_pending) begin
                sha_last_block <= 1'b0;
                state          <= SEND_LENGTH_BLOCK;
              end else begin
                sha_last_block <= 1'b1;
                state          <= SHA_COMPUTE;
              end
            end else begin
              sha_last_block <= 1'b0;
              state          <= SHA_COMPUTE;
            end
          end
        end

        // ---- SEND_LENGTH_BLOCK ------------------------------------------
        // Length did not fit in the padded block.
        // Send an extra block: {zeros[447:0], total_bits[63:0]}
        // -----------------------------------------------------------------
        SEND_LENGTH_BLOCK: begin
          if (sha_ready) begin
            sha_start      <= 1'b1;
            sha_block      <= '0;
            sha_block[63:0]<= total_bits;
            sha_last_block <= 1'b1;
            state          <= SHA_COMPUTE;
          end
        end

        // ---- SHA_COMPUTE ------------------------------------------------
        // Wait for SHA core done signal.
        //   sha_last_block=1 -> final digest ready -> go to DONE
        //   sha_last_block=0 -> mid-stream block done -> clear buffer, resume COLLECT
        // -----------------------------------------------------------------
        SHA_COMPUTE: begin
          if (sha_done) begin
            if (sha_last_block) begin
              auth_done <= 1'b1;
              auth_pass <= (sha_digest == trusted_key);
              state     <= DONE;
            end else begin
              buffer     <= '0;
              state      <= COLLECT;
            end
          end
        end

        // ---- DONE -------------------------------------------------------
        DONE: begin
          if (!start_auth) state <= IDLE;
        end

      endcase
    end
  end
endmodule


// ----------------------------------------------------------------
//  boot_ctrl_fsm
// ----------------------------------------------------------------
module boot_ctrl_fsm (
  input  logic clk, rst_n, boot_req, auth_done, auth_pass,
               retry_exceeded, lockdown_active,
  output logic start_auth, boot_done, boot_pass, auth_fail_pulse,
  output logic [2:0] current_state
);
  typedef enum logic [2:0] {
    RESET=0, IDLE=1, AUTH_START=2, AUTH_WAIT=3,
    CHECK_RESULT=4, BOOT_ALLOW=5, BOOT_DENY=6, LOCKDOWN=7
  } state_t;
  state_t state, next_state;
  assign current_state = state;

  always_ff @(posedge clk or negedge rst_n)
    if (!rst_n) state <= RESET; else state <= next_state;

  always_comb begin
    next_state = state; start_auth = 0; boot_done = 0;
    boot_pass  = 0;     auth_fail_pulse = 0;
    if (lockdown_active && state != LOCKDOWN) next_state = LOCKDOWN;
    else case (state)
      RESET:        next_state = IDLE;
      IDLE:         if (boot_req) next_state = AUTH_START;
      AUTH_START:   begin start_auth = 1; next_state = AUTH_WAIT; end
      AUTH_WAIT:    if (auth_done) next_state = CHECK_RESULT;
      CHECK_RESULT: begin
        if (retry_exceeded)   next_state = LOCKDOWN;
        else if (auth_pass)   next_state = BOOT_ALLOW;
        else begin auth_fail_pulse = 1; next_state = BOOT_DENY; end
      end
      BOOT_ALLOW: begin boot_done=1; boot_pass=1; if(!boot_req) next_state=IDLE; end
      BOOT_DENY:  begin boot_done=1; boot_pass=0; if(!boot_req) next_state=IDLE; end
      LOCKDOWN:   next_state = LOCKDOWN;
      default:    next_state = RESET;
    endcase
  end
endmodule


// ----------------------------------------------------------------
//  secure_key_storage
//  Change ONLY this parameter to update the trusted firmware hash.
//  Run: python3 -c "import hashlib; print(hashlib.sha256(b'YOUR_FW').hexdigest())"
// ----------------------------------------------------------------
module secure_key_storage (
    input  logic         clk,
    input  logic         rst_n,
  output logic [255:0] trusted_key
);

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        trusted_key <= 256'h0;
    else
        trusted_key <= 256'hcc369d06174db4fa54f4f20ae1523a10f8aa409a4b51193135fc798ce426e40e;
end

endmodule


// ----------------------------------------------------------------
//  policy_engine
// ----------------------------------------------------------------
module policy_engine (
  input  logic auth_pass, retry_exceeded,
  output logic policy_allow, policy_deny, policy_lockdown
);
  always_comb begin
    policy_allow = 0; policy_deny = 0; policy_lockdown = 0;
    if      (retry_exceeded) policy_lockdown = 1;
    else if (auth_pass)      policy_allow    = 1;
    else                     policy_deny     = 1;
  end
endmodule


// ----------------------------------------------------------------
//  lockdown_ctrl - sticky once set, only hardware reset clears it
// ----------------------------------------------------------------
module lockdown_ctrl (
  input  logic clk, rst_n, policy_lockdown,
  output logic lockdown_active
);
  always_ff @(posedge clk or negedge rst_n)
    if (!rst_n) lockdown_active <= 0;
    else if (policy_lockdown) lockdown_active <= 1;
endmodule


// ----------------------------------------------------------------
//  retry_counter
// ----------------------------------------------------------------
module retry_counter #(parameter int MAX_RETRY = 3)(
  input  logic clk, rst_n, auth_fail, lockdown_clear,
  output logic retry_exceeded
);
  logic [3:0] count;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin count <= '0; retry_exceeded <= 0; end
    else begin
      if (lockdown_clear) begin count <= '0; retry_exceeded <= 0; end
      else begin
        if (auth_fail && count < MAX_RETRY) count <= count + 1;
        if (count >= MAX_RETRY || (auth_fail && count == (MAX_RETRY-1)))
          retry_exceeded <= 1;
      end
    end
  end
endmodule


// ----------------------------------------------------------------
//  cpu_reset_ctrl
// ----------------------------------------------------------------
module cpu_reset_ctrl (
  input  logic clk, rst_n, lockdown_active, policy_allow,
  output logic cpu_reset_n
);
  always_ff @(posedge clk or negedge rst_n)
    if      (!rst_n)               cpu_reset_n <= 0;
    else if (lockdown_active)      cpu_reset_n <= 0;
    else if (policy_allow)         cpu_reset_n <= 1;
    else                           cpu_reset_n <= 0;
endmodule

module debug_ctrl (
    input  logic clk,
    input  logic rst_n,

    // Security status inputs
    input  logic auth_pass,
    input  logic auth_fail,
    input  logic lockdown_active,

    // Debug control outputs
    output logic jtag_disable,
    output logic debug_enable
);

always_comb begin

    // Default values
    jtag_disable = 1'b0;
    debug_enable = 1'b0;

    // Enable debug only after successful authentication
    if (auth_pass && !lockdown_active) begin
        debug_enable = 1'b1;
        jtag_disable = 1'b0;
    end

    // Disable debug access during authentication failure
    else if (auth_fail || lockdown_active) begin
        debug_enable = 1'b0;
        jtag_disable = 1'b1;
    end
end

endmodule

// ----------------------------------------------------------------
//  rot_top - top-level integration
// ----------------------------------------------------------------
module rot_top (
   input  logic        clk,
  input  logic        rst_n,
  input  logic        boot_req,
  input  logic [31:0] fw_data,
  input  logic        fw_valid,
  input  logic        fw_last,
  input  logic [1:0]  fw_strobe,

  // Core outputs
  output logic        cpu_reset_n,
  output logic        boot_done,
  output logic        boot_pass,
  output logic        secure_mode,

  // Future-scope: anti-rollback
  input  logic [7:0]  fw_version_in,      // version field from firmware header
  output logic        rollback_alert,      // high if version < stored minimum

  // Future-scope: OTA authentication
  input  logic        ota_update_req,      // request to authenticate OTA image
  output logic        ota_auth_grant,      // OTA authentication approved

  // Future-scope: TEE handoff
  output logic        tee_handoff,         // pulse after trusted boot completes

  // Future-scope: debug control (exposed for chip-level integration)
  output logic        jtag_disable,
  output logic        debug_enable
);

  // ---- Internal signals -----------------------------------------------
  logic auth_done, auth_pass, start_auth;
  logic retry_exceeded, policy_allow, policy_deny, policy_lockdown;
  logic lockdown_active, auth_fail_pulse;
  logic [255:0] trusted_key;

  // ---- Derived combinational ------------------------------------------
  assign secure_mode = !lockdown_active && boot_pass;

  // ---- Anti-rollback register -----------------------------------------
  // Stores the minimum acceptable firmware version seen after a good boot.
  // Future: compare against eFuse-burned minimum version.
  logic [7:0] fw_version_min;
  logic       rollback_detected;
  // Future-scope: AI-assisted policy engine
  input  logic        ai_policy_hint,
  output logic        ai_override_active,

  // Future-scope: hardware intrusion detection
  input  logic        tamper_detect_in,
  output logic        tamper_alert,

  // Future-scope: multi-core boot sequencing
  input  logic [3:0]  core_ready,
  output logic [3:0]  core_boot_grant

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      fw_version_min   <= 8'h00;
      rollback_detected <= 1'b0;
    end else if (boot_pass && auth_pass) begin
      // Ratchet: only update stored minimum if new version is higher
      if (fw_version_in > fw_version_min)
        fw_version_min <= fw_version_in;
      rollback_detected <= (fw_version_in < fw_version_min);
    end else begin
      rollback_detected <= 1'b0;
    end
  end

  assign rollback_alert = rollback_detected;

  // ---- OTA auth stub --------------------------------------------------
  // Future: route ota_update_req through a second auth_engine instance.
  // For now: OTA grant requires a successful boot AND no rollback.
  assign ota_auth_grant = boot_pass && !rollback_alert && !lockdown_active;

  // ---- TEE handoff register -------------------------------------------
  // Single-cycle pulse after trusted boot, cleared on next reset.
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      tee_handoff <= 1'b0;
    else
      tee_handoff <= boot_pass && !lockdown_active;
  end
// ---- AI policy stub -------------------------------------------------
  // Future: external AI engine sends policy_hint; override fires if hint
  // disagrees with local policy AND auth is valid.
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) ai_override_active <= 1'b0;
    else        ai_override_active <= ai_policy_hint && auth_pass 
                                      && !lockdown_active;
  end

  // ---- Hardware intrusion detection -----------------------------------
  // Future: connect to physical tamper mesh / voltage sensors.
  // Tamper event forces lockdown via policy_lockdown path.
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) tamper_alert <= 1'b0;
    else        tamper_alert <= tamper_detect_in;
  end

  // ---- Multi-core boot grant ------------------------------------------
  // Future: stagger core releases post-RoT authentication.
  // Core N boots only after RoT passes and core is ready.
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) core_boot_grant <= 4'b0000;
    else        core_boot_grant <= {4{boot_pass && !lockdown_active}} 
                                    & core_ready;
  end
  // ---- Submodule instantiations --------------------------------------
  boot_ctrl_fsm u_boot_ctrl_fsm (
    .clk(clk), .rst_n(rst_n), .boot_req(boot_req),
    .auth_done(auth_done), .auth_pass(auth_pass),
    .retry_exceeded(retry_exceeded), .lockdown_active(lockdown_active),
    .start_auth(start_auth), .boot_done(boot_done), .boot_pass(boot_pass),
    .auth_fail_pulse(auth_fail_pulse), .current_state()
  );


  auth_engine u_auth_engine (
    .clk(clk), .rst_n(rst_n), .start_auth(start_auth),
    .fw_data(fw_data), .fw_valid(fw_valid), .fw_last(fw_last),
    .fw_strobe(fw_strobe), .trusted_key(trusted_key),
    .auth_done(auth_done), .auth_pass(auth_pass)
  );

  secure_key_storage u_secure_key_storage (
    .clk(clk), .rst_n(rst_n), .trusted_key(trusted_key)
  );

  policy_engine u_policy_engine (
    .auth_pass(auth_pass), .retry_exceeded(retry_exceeded),
    .policy_allow(policy_allow), .policy_deny(policy_deny),
    .policy_lockdown(policy_lockdown)
  );

  retry_counter #(.MAX_RETRY(3)) u_retry_counter (
    .clk(clk), .rst_n(rst_n),
    .auth_fail(auth_fail_pulse), .lockdown_clear(1'b0),  // Intentional: only hw reset clears lockdown
    .retry_exceeded(retry_exceeded)
  );

  lockdown_ctrl u_lockdown_ctrl (
    .clk(clk), .rst_n(rst_n),
    .policy_lockdown(policy_lockdown), .lockdown_active(lockdown_active)
  );

  cpu_reset_ctrl u_cpu_reset_ctrl (
    .clk(clk), .rst_n(rst_n),
    .lockdown_active(lockdown_active), .policy_allow(policy_allow),
    .cpu_reset_n(cpu_reset_n)
  );

debug_ctrl u_debug_ctrl (
    .clk             (clk),
    .rst_n           (rst_n),
    .auth_pass       (auth_pass),
    .auth_fail       (auth_fail_pulse),
    .lockdown_active (lockdown_active),
    .jtag_disable    (jtag_disable),
    .debug_enable    (debug_enable)
);
endmodule
