class fifo_random_seq extends fifo_base_seq;
    `uvm_object_utils(fifo_random_seq)
    int n_items = 2000;

    task body();

        void'($value$plusargs("N_ITEMS=%d", n_items));//plus arg for user input
        
        `uvm_info("FIFO_RANDOM_SEQ", $sformatf("Sending %0d items", n_items), UVM_MEDIUM);
        repeat (n_items) do_random();
        fill_to(0);
    endtask


    function new(string name = "fifo_random_seq");
        super.new(name);
    endfunction

endclass
