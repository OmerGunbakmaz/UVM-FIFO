class fifo_basic_seq extends uvm_sequence #(fifo_item);
    `uvm_object_utils(fifo_basic_seq);

    fifo_item item;

    function new(string name = "fifo_basic_seq");
        super.new(name);
    endfunction

    task body();
        repeat (5) begin : write
            item = fifo_item::type_id::create("item");
            start_item(item);
            assert (item.randomize() with {
                wr_en == 1;
                rd_en == 0;
            })
            else `uvm_error("BASIC_SEQ", "Randomize Failed!");
            finish_item(item);
        end : write
        repeat (5) begin : read
            item = fifo_item::type_id::create("item");
            start_item(item);
            item.rd_en = 1;
            item.wr_en = 0;
            finish_item(item);
        end : read
    endtask : body


endclass
