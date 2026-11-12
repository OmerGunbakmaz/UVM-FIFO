class fifo_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_monitor);
    virtual fifo_if vif;

    uvm_analysis_port #(fifo_item) ap;

    function void build_phase(uvm_phase phase);
        ap = new("ap", this);
    endfunction

    task run_phase(uvm_phase phase);
        fifo_item fitem;
        fifo_item tmp;
        bit pending;
        fitem = fifo_item::type_id::create("fitem");
        forever begin
            @(vif.mon_cb);
            if (!vif.mon_cb.rst_n) begin
                pending = 0;
                continue;
            end
            if (pending) begin
                fitem.rdata = vif.mon_cb.rdata;
                if (!$cast(tmp, fitem.clone())) `uvm_fatal("FIFO_MONITOR", "Failed casting");
                ap.write(tmp);
            end

                fitem.wr_en = vif.mon_cb.wr_en;
                fitem.rd_en = vif.mon_cb.rd_en;
                fitem.wdata = vif.mon_cb.wdata;
                fitem.full  = vif.mon_cb.full;
                fitem.empty = vif.mon_cb.empty;
                pending = 1;

        end
    endtask

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction


endclass
