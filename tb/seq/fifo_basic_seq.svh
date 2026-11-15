class fifo_basic_seq extends fifo_base_seq;
    `uvm_object_utils(fifo_basic_seq);

    function new(string name = "fifo_basic_seq");
        super.new(name);
    endfunction

    task body();
        repeat (5)
            do_op(.wr(1),.rd(0));
        repeat (5)
            do_op(.wr(0),.rd(1));
    endtask : body


endclass
