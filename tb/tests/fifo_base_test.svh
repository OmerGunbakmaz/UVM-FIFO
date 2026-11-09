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


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass
