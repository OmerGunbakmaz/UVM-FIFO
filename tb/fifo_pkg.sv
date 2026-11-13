package fifo_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    parameter int FIFO_WIDTH = 8;
    parameter int FIFO_DEPTH = 8;
    typedef enum bit [1:0] {idle =2'b00,wr_only =2'b01,rd_only=2'b10,rd_wr =2'b11}operation_t;

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
