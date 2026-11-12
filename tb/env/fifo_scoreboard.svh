class fifo_scoreboard extends uvm_subscriber #(fifo_item);
    `uvm_component_utils(fifo_scoreboard);
    bit [FIFO_WIDTH-1:0]    model_q [$];
    int n_writes,n_reads,n_pass,n_fail;

    function void write(fifo_item t);
        int lvl = model_q.size();
        bit exp_rd, exp_wr;
        bit [FIFO_WIDTH-1:0] exp;

        if (t.full !== (lvl == FIFO_DEPTH)) begin
            n_fail++;
            `uvm_error("FIFO_SCB", $sformatf("full == %0b  main model size == %0d  :", t.full, lvl
                       ));
        end
        if (t.empty !== (lvl == 0)) begin
            n_fail++;
            `uvm_error("FIFO_SCB", $sformatf("empty == %0b  main model size == %0d  :", t.empty, lvl
                       ));
        end
        exp_rd = t.rd_en && (lvl > 0);
        exp_wr = t.wr_en && (lvl < FIFO_DEPTH || exp_rd);
        if (exp_rd) begin
            exp = model_q.pop_front();
            n_reads++;
            if (exp !== t.rdata) begin
                n_fail++;
                `uvm_error("FIFO_SCB", $sformatf(
                           "Data mismatch: exp : 0x%0h rdata : 0x%0h", exp, t.rdata));
            end else n_pass++;
        end
        if (exp_wr) begin
            model_q.push_back(t.wdata);
            n_writes++;
        end

    endfunction
    function void report_phase(uvm_phase phase);
        `uvm_info("FIFO_SCB", $sformatf(
                  "writes=%0d reads=%0d pass=%0d fail=%0d", n_writes, n_reads, n_pass, n_fail),
                  UVM_LOW);
        if (!n_writes && !n_reads)
            `uvm_warning("FIFO_SCB",
                         "No transactions received - check monitor connection / vif / reset");

    endfunction

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass


