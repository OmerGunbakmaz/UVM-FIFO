class fifo_coverage extends uvm_subscriber #(fifo_item);
    `uvm_component_utils(fifo_coverage)

    fifo_item t_h;
    operation_t op;
    int level;  //(independent of DUT)
    bit [1:0] state;
    int n_wr_acc;
    bit first = 1;  // first cycle after reset

    covergroup fifo_cg;
        cp_level: coverpoint level {
            bins empty = {0};
            bins low = {[1 : 3]};
            bins high = {[4 : FIFO_DEPTH - 1]};
            bins full = {FIFO_DEPTH};
            bins to_1 = (0 => 1);
            bins from_1 = (1 => 0);
            bins to_full = (FIFO_DEPTH - 1 => FIFO_DEPTH);
            bins from_full = (FIFO_DEPTH => FIFO_DEPTH - 1);
        }

        cp_op: coverpoint op;  // one bin per enum value

        cp_state: coverpoint state {bins empty = {0}; bins mid = {1}; bins full = {2};}

        cx_op_state : cross cp_op, cp_state{ignore_bins idle = binsof (cp_op) intersect {idle};}

        cp_wraps: coverpoint (n_wr_acc / FIFO_DEPTH) {
            bins one = {1}; bins two = {2}; bins more = {[3 : $]};
        }

        cp_reset_flags: coverpoint {t_h.empty, t_h.full} iff (first) {bins ok = {2'b10};}
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        fifo_cg = new();
    endfunction

    function void write(fifo_item t);
        bit rd_acc, wr_acc;
        t_h = t;

        op    = operation_t'({t_h.rd_en, t_h.wr_en});
        state = (level == 0) ? 0 : (level == FIFO_DEPTH) ? 2 : 1;

        fifo_cg.sample();
        first  = 0;

        rd_acc = t_h.rd_en && (level > 0);
        wr_acc = t_h.wr_en && (level < FIFO_DEPTH || rd_acc);
        if (wr_acc) n_wr_acc++;
        if (wr_acc && !rd_acc) level++;
        else if (rd_acc && !wr_acc) level--;
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("FIFO_COV", $sformatf("Coverage = %0.2f%%", fifo_cg.get_coverage()), UVM_LOW)
    endfunction
endclass
