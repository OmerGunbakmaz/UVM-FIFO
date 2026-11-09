class fifo_agent_config;

    virtual fifo_if vif;
    protected uvm_active_passive_enum is_active;

    function new(virtual fifo_if vif, uvm_active_passive_enum is_active);
        this.vif = vif;
        this.is_active = is_active;
    endfunction : new

    function uvm_active_passive_enum get_is_active();
        return is_active;
    endfunction : get_is_active
    
endclass
