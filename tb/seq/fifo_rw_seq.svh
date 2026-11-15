class fifo_rw_seq extends fifo_base_seq;
    `uvm_object_utils(fifo_rw_seq)

    task body();
        `uvm_info("FIFO_RW_SEQ", "Section A: Read write at empty", UVM_MEDIUM);
        repeat (3) begin
            do_op(.wr(1), .rd(1));
            do_op(.wr(0), .rd(1));
        end
        `uvm_info("FIFO_RW_SEQ", "Section B1: Read write at level=1", UVM_MEDIUM);
        fill_to(1);
        repeat (10) do_op(.wr(1), .rd(1));
        `uvm_info("FIFO_RW_SEQ", "Section B2: Read write at middle", UVM_MEDIUM);
        fill_to(FIFO_DEPTH / 2);
        repeat (10) do_op(.wr(1), .rd(1));
        `uvm_info("FIFO_RW_SEQ", "Section B3: Read write at level = Depth-1", UVM_MEDIUM);
        fill_to(FIFO_DEPTH -1);
        repeat (10) do_op(.wr(1), .rd(1));
        `uvm_info("FIFO_RW_SEQ", "Section C: Read write at full", UVM_MEDIUM);
        fill_to(FIFO_DEPTH);
        repeat (10) do_op(.wr(1), .rd(1));
        `uvm_info("FIFO_RW_SEQ", "Section D: Drain", UVM_MEDIUM);
        fill_to(0);
    endtask


    function new(string name = "fifo_rw_seq");
        super.new(name);
    endfunction

endclass
