class fifo_fill_drain_seq extends fifo_base_seq;
    `uvm_object_utils(fifo_fill_drain_seq)


    task body();
        repeat (2) begin 
            `uvm_info("FILL_DRAIN_SEQ","Section A: Fill full",UVM_MEDIUM);
            fill_to(FIFO_DEPTH);
            `uvm_info("FILL_DRAIN_SEQ","Section B: Write when full",UVM_MEDIUM);
            repeat (3) write_data(8'hEE);
            `uvm_info("FILL_DRAIN_SEQ","Section C: Transition control when full",UVM_MEDIUM);
            repeat (3) begin 
                do_op(.wr(0), .rd(1));
                do_op(.wr(1), .rd(0));
            end
            `uvm_info("FILL_DRAIN_SEQ","Section D: Drain to Empty",UVM_MEDIUM);
            fill_to(0);
            `uvm_info("FILL_DRAIN_SEQ","Section E: Read when Empty",UVM_MEDIUM);
            read_n(3);
            `uvm_info("FILL_DRAIN_SEQ","Section F: Transition control when empty",UVM_MEDIUM);
            repeat (3) begin
                do_op(.wr(1), .rd(0));
                do_op(.wr(0), .rd(1));
            end
        end
    endtask


    function new(string name = "fifo_fill_drain_seq");
        super.new(name);
    endfunction

endclass
