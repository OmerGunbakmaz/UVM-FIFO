class fifo_agent extends uvm_agent;
    `uvm_component_utils(fifo_agent);

    fifo_agent_config agent_config_h;

    uvm_analysis_port #(fifo_item) ap;

    fifo_sequencer sequencer_h;
    fifo_monitor monitor_h;
    fifo_driver driver_h;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new


    function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(fifo_agent_config)::get(this, "", "config", agent_config_h))
            `uvm_fatal("FIFO_AGENT", "Failed to get class config");
        is_active = agent_config_h.get_is_active();

        monitor_h = fifo_monitor::type_id::create("monitor_h", this);

        if (is_active == UVM_ACTIVE) begin
            sequencer_h = fifo_sequencer::type_id::create("sequencer_h", this);
            driver_h = fifo_driver::type_id::create("driver_h", this);
        end


        ap = new("ap", this);
    endfunction

    function void connect_phase(uvm_phase phase);

        monitor_h.ap.connect(ap);
        monitor_h.vif = agent_config_h.vif;
        if (is_active == UVM_ACTIVE) begin
            driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
            driver_h.vif = agent_config_h.vif;
        end
    endfunction

endclass
