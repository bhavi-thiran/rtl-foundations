module traffic_fsm_tb;

  logic clk, rst_n, car_sensor;
  logic ns_red, ns_yel, ns_grn, ew_red, ew_yel, ew_grn;

  traffic_fsm dut (
    .clk, .rst_n, .car_sensor,
    .ns_red, .ns_yel, .ns_grn,
    .ew_red, .ew_yel, .ew_grn
  );

  // 100 MHz-ish clock (10ns period)
  initial clk = 0;
  always #5 clk = ~clk;

  // Simple assertions (Intel-style habit)
  // Never allow both greens at once
  always @(posedge clk) begin
    if (rst_n) begin
      assert (!(ns_grn && ew_grn)) else $fatal("Both directions green!");
      assert (!(ns_yel && ew_yel)) else $fatal("Both directions yellow!");
    end
  end

  initial begin
    // init
    rst_n = 0;
    car_sensor = 0;

    // reset
    repeat (3) @(posedge clk);
    rst_n = 1;

    // No car waiting: should stay NS green beyond 10 cycles
    repeat (15) @(posedge clk);

    // Car arrives: should switch after reaching 10 cycles then yellow->EW
    car_sensor = 1;
    repeat (20) @(posedge clk);

    // Car leaves: still completes cycle
    car_sensor = 0;
    repeat (30) @(posedge clk);

    $display("TB finished OK");
    $finish;
  end

endmodule
