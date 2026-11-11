interface fifo_if #(
    parameter int WIDTH = 8
) (
    input logic clk
);

    logic             rst_n;

    logic             wr_en;
    logic [WIDTH-1:0] wdata;

    logic             rd_en;
    logic [WIDTH-1:0] rdata;

    logic             full;
    logic             empty;

    clocking drv_cb @(posedge clk);
        default input #1step output #1;
        output wr_en, rd_en, wdata;
        input full, empty, rdata;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #1step;
        input rst_n,wr_en, rd_en, wdata, full, empty, rdata;
    endclocking

    modport DRV(clocking drv_cb, output rst_n);
    modport MON(clocking mon_cb);

    task do_reset();
        rst_n = 0;
        drv_cb.wr_en <= 0;
        drv_cb.rd_en <= 0;
        repeat(3)@(posedge clk);
        @(negedge clk);
        rst_n = 1;
    endtask

endinterface
