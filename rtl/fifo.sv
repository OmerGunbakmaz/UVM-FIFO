module fifo #(
  parameter int DEPTH = 8,
  parameter int WIDTH = 8
) (
  input  logic             clk,
  input  logic             rst_n,

  input  logic             wr_en,
  input  logic [WIDTH-1:0] wdata,

  input  logic             rd_en,
  output logic [WIDTH-1:0] rdata,

  output logic             full,
  output logic             empty
);

  localparam int PTR_W = $clog2(DEPTH);
  localparam int CNT_W = $clog2(DEPTH + 1);

  logic [WIDTH-1:0] mem [DEPTH];
  logic [PTR_W-1:0] wr_ptr, rd_ptr;
  logic [CNT_W-1:0] count;

  logic wr_accept, rd_accept;

  // Flags
`ifdef BUG_FULL_OFF_BY_ONE
  assign full  = (count == CNT_W'(DEPTH - 1));
`else
  assign full  = (count == CNT_W'(DEPTH));
`endif
  assign empty = (count == '0);

  // Accept logic
  assign rd_accept = rd_en && !empty;
`ifdef BUG_WRITE_WHEN_FULL
  assign wr_accept = wr_en;
`else
  assign wr_accept = wr_en && (!full || rd_en);
`endif

  // Pointer increment
  function automatic logic [PTR_W-1:0] next_ptr(logic [PTR_W-1:0] ptr, logic [PTR_W-1:0] last);
    return (ptr == last) ? '0 : ptr + 1'b1;
  endfunction

  // Write
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wr_ptr <= '0;
    end else if (wr_accept) begin
      mem[wr_ptr] <= wdata;
`ifdef BUG_PTR_WRAP
      wr_ptr      <= next_ptr(wr_ptr, PTR_W'(DEPTH - 2));
`else
      wr_ptr      <= next_ptr(wr_ptr, PTR_W'(DEPTH - 1));
`endif
    end
  end

  // Read(registered rdata)
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_ptr <= '0;
      rdata  <= '0;
    end else if (rd_accept) begin
      rdata  <= mem[rd_ptr];
      rd_ptr <= next_ptr(rd_ptr, PTR_W'(DEPTH - 1));
    end
  end

  //counter
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      count <= '0;
    end else begin
      case ({wr_accept, rd_accept})
        2'b10:   count <= count + 1'b1;
        2'b01:   count <= count - 1'b1;
        default: count <= count;
      endcase
    end
  end

endmodule
