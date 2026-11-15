class fifo_base_seq extends uvm_sequence #(fifo_item);
    `uvm_object_utils(fifo_base_seq)

    fifo_item item;
    int level;
    virtual task body();
        `uvm_warning("BASE_SEQ", "fifo_base_seq body ran - sequence override missing in test?")
    endtask
    function void update_level();
        bit rd_acc = item.rd_en && (level > 0);
        bit wr_acc = item.wr_en && (level < FIFO_DEPTH || rd_acc);
        if (wr_acc && !rd_acc) level++;
        else if (rd_acc && !wr_acc) level--;
    endfunction
    task do_op(bit wr, bit rd);
        item = fifo_item::type_id::create("item");
        start_item(item);
        if (!item.randomize() with {
                wr_en == wr;
                rd_en == rd;
            })
            `uvm_error("BASE_SEQ", "Randomize Failed!");
        update_level();
        finish_item(item);
    endtask

    task write_data(bit [FIFO_WIDTH -1 : 0] d);
        item = fifo_item::type_id::create("item");
        start_item(item);
        if (!item.randomize() with {
                wr_en == 1;
                rd_en == 0;
                wdata == d;
            })
            `uvm_error("BASE_SEQ", "Randomize Failed!");
        update_level();

        finish_item(item);
    endtask

    task write_n(int n);
        repeat (n) do_op(.wr(1), .rd(0));
    endtask

    task read_n(int n);
        repeat (n) do_op(.wr(0), .rd(1));
    endtask

    task fill_to(int n);
        if (level > n) read_n(level - n);
        else if(level<n) write_n(n-level);
    endtask

    task do_random();
        item = fifo_item::type_id::create("item");
        start_item(item);
        if (!item.randomize()) `uvm_error("BASE_SEQ", "Randomize Failed!");
        update_level();
        finish_item(item);
    endtask


    function new(string name = "fifo_base_seq");
        super.new(name);
    endfunction


endclass
