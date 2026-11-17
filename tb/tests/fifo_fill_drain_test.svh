class fifo_fill_drain_test extends fifo_base_test;
    `uvm_component_utils(fifo_fill_drain_test)

    function void build_phase(uvm_phase phase);
        fifo_base_seq::type_id::set_type_override(fifo_fill_drain_seq::get_type());
        super.build_phase(phase);
    endfunction

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass
