module traffic_fsm (
  input  logic clk,
  input  logic rst_n,
  input  logic car_sensor,   // car waiting on EW side
  output logic ns_red, ns_yel, ns_grn,
  output logic ew_red, ew_yel, ew_grn
);

  typedef enum logic [1:0] {
    NS_GREEN  = 2'd0,
    NS_YELLOW = 2'd1,
    EW_GREEN  = 2'd2,
    EW_YELLOW = 2'd3
  } state_t;

  state_t state, next_state;

  logic [3:0] timer;   // enough for counts up to 10

  // Next-state logic
  always_comb begin
    next_state = state;

    unique case (state)
      NS_GREEN: begin
        // Stay green 10 cycles, but if no car waiting, you may extend
        if (timer >= 4'd10 && car_sensor) next_state = NS_YELLOW;
      end

      NS_YELLOW: begin
        if (timer >= 4'd3) next_state = EW_GREEN;
      end

      EW_GREEN: begin
        // Switch back after 10 cycles (always)
        if (timer >= 4'd10) next_state = EW_YELLOW;
      end

      EW_YELLOW: begin
        if (timer >= 4'd3) next_state = NS_GREEN;
      end

      default: next_state = NS_GREEN;
    endcase
  end

  // State + timer registers
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= NS_GREEN;
      timer <= 4'd0;
    end else begin
      if (next_state != state) begin
        state <= next_state;
        timer <= 4'd0;
      end else begin
        timer <= timer + 4'd1;
      end
    end
  end

  // Output decode
  always_comb begin
    // default all off
    ns_red = 0; ns_yel = 0; ns_grn = 0;
    ew_red = 0; ew_yel = 0; ew_grn = 0;

    unique case (state)
      NS_GREEN:  begin ns_grn = 1; ew_red = 1; end
      NS_YELLOW: begin ns_yel = 1; ew_red = 1; end
      EW_GREEN:  begin ew_grn = 1; ns_red = 1; end
      EW_YELLOW: begin ew_yel = 1; ns_red = 1; end
      default:   begin ns_grn = 1; ew_red = 1; end
    endcase
  end

endmodule
