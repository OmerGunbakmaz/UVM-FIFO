`timescale 1ns / 1ps
module tb_top;
    import uvm_pkg::*;
    import fifo_pkg::*;
    `include "uvm_macros.svh"

    logic clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    fifo_if #(.WIDTH(fifo_pkg::FIFO_WIDTH,fifo_pkg::FIFO_DEPTH)) vif (.clk(clk));

    initial begin
        uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", vif);
        run_test();
    end

    fifo DUT (
        .clk  (clk),
        .rst_n(vif.rst_n),
        .wr_en(vif.wr_en),
        .wdata(vif.wdata),
        .rd_en(vif.rd_en),
        .rdata(vif.rdata),
        .full (vif.full),
        .empty(vif.empty)
    );

endmodule
