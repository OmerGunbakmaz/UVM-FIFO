virtual class fifo_base_test extends uvm_test;

    virtual fifo_if vif;
    fifo_env env_h;
    fifo_env_config env_config_h;
    fifo_sequencer sequencer_h;

    function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_fatal("BASE_TEST", "Failed to get class vif");

        env_config_h = new(vif);
        uvm_config_db#(fifo_env_config)::set(this, "env_h*", "config", env_config_h);

        env_h = fifo_env::type_id::create("env_h", this);
    endfunction : build_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        sequencer_h = env_h.agent_h.sequencer_h;
    endfunction

    task run_phase(uvm_phase phase);
        fifo_base_seq base_seq;
        base_seq = fifo_base_seq::type_id::create("base_seq", this);

        phase.raise_objection(this);
        base_seq.start(sequencer_h);
        repeat (3) @(vif.mon_cb);
        phase.drop_objection(this);

    endtask

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass
