class fifo_override_test extends fifo_random_test;
    `uvm_component_utils(fifo_override_test)

    function void build_phase(uvm_phase phase);
        fifo_item::type_id::set_type_override(fifo_wr_heavy_item::get_type());
        super.build_phase(phase);
    endfunction

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass
