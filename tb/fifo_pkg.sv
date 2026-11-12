package fifo_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    parameter int FIFO_WIDTH = 8;
    parameter int FIFO_DEPTH = 8;

    `include "fifo_item.svh"
    typedef uvm_sequencer#(fifo_item) fifo_sequencer;

    `include "fifo_basic_seq.svh"
    `include "fifo_driver.svh"
    `include "fifo_monitor.svh"
    `include "fifo_agent_config.svh"
    `include "fifo_agent.svh"
    `include "fifo_coverage.svh"
    `include "fifo_scoreboard.svh"
    `include "fifo_env_config.svh"
    `include "fifo_env.svh"
    `include "fifo_base_test.svh"
    `include "fifo_basic_test.svh"

endpackage : fifo_pkg
