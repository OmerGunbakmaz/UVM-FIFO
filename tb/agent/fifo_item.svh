class fifo_item extends uvm_sequence_item;

    `uvm_object_utils(fifo_item);

    function new(string name = "fifo_item");
        super.new(name);
    endfunction : new

    rand bit                    wr_en;
    rand bit                    rd_en;
    rand bit [FIFO_WIDTH-1 : 0] wdata;
    logic    [FIFO_WIDTH-1 : 0] rdata;
    logic                       full;
    logic                       empty;

    function string convert2string();
        return $sformatf(
            "wr_en = %0b rd_en=%0b wdata = 0x%0h rdata=0x%0h full = %0b empty=%0b",
            wr_en,
            rd_en,
            wdata,
            rdata,
            full,
            empty
        );
    endfunction

endclass
