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

    function void do_copy(uvm_object rhs);
        fifo_item RHS;
        if(rhs== null)
            `uvm_fatal("FIFO_ITEM","Tried to copy a null object");
        if(!$cast(RHS,rhs))
            `uvm_fatal("FIFO_ITEM","Failed casting");
        super.do_copy(rhs);
        wr_en   =RHS.wr_en;
        rd_en   =RHS.rd_en;
        wdata   =RHS.wdata;
        rdata   =RHS.rdata;
        full    =RHS.full;
        empty   =RHS.empty;
    endfunction


endclass
