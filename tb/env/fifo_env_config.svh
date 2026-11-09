class fifo_env_config;

    virtual fifo_if vif;

    function new(virtual fifo_if vif);
        this.vif = vif;
    endfunction : new

endclass
