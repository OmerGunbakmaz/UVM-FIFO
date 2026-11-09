class fifo_driver extends uvm_driver #(fifo_item);

    `uvm_component_utils(fifo_driver);
    virtual fifo_if vif;

    task run_phase(uvm_phase phase);
        fifo_item fitem;
        vif.do_reset();
        forever begin
            seq_item_port.get_next_item(fitem);
            vif.drv_cb.wr_en <= fitem.wr_en;
            vif.drv_cb.rd_en <= fitem.rd_en;
            vif.drv_cb.wdata <= fitem.wdata;
            @(vif.drv_cb);
            seq_item_port.item_done();
        end
    endtask : run_phase

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new
endclass
