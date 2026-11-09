class fifo_basic_test extends fifo_base_test;
    `uvm_component_utils(fifo_basic_test);

    task run_phase(uvm_phase phase);
        fifo_basic_seq basic_seq;
        basic_seq = fifo_basic_seq::type_id::create("basic_seq", this);

        phase.raise_objection(this);
        basic_seq.start(sequencer_h);
        phase.drop_objection(this);

    endtask

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass
