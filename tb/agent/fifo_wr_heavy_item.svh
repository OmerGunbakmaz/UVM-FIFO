class fifo_wr_heavy_item extends fifo_item;

    `uvm_object_utils(fifo_wr_heavy_item)

    constraint c_wr_heavy {
        wr_en dist {
            1 := 80,
            0 := 20
        };
        rd_en dist {
            1 := 40,
            0 := 60
        };
    }
    function new(string name = "fifo_wr_heavy_item");
        super.new(name);
    endfunction : new
endclass
