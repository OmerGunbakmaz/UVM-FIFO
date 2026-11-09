class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env);
    fifo_agent agent_h;
    fifo_agent_config agent_config_h;

    fifo_coverage coverage_h;
    fifo_scoreboard scoreboard_h;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);

        fifo_env_config env_config_h;

        if (!uvm_config_db#(fifo_env_config)::get(this, "", "config", env_config_h))
            `uvm_fatal("FIFO_ENV", "Failed to get class config");

        agent_config_h = new(.vif(env_config_h.vif), .is_active(UVM_ACTIVE));
        
        uvm_config_db#(fifo_agent_config)::set(this, "agent_h*", "config", agent_config_h);
        agent_h = fifo_agent::type_id::create("agent_h", this);
        coverage_h = fifo_coverage::type_id::create("coverage_h",this);
        scoreboard_h = fifo_scoreboard::type_id::create("scoreboard_h",this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        agent_h.ap.connect(coverage_h.analysis_export);
        agent_h.ap.connect(scoreboard_h.analysis_export);
    endfunction

endclass
