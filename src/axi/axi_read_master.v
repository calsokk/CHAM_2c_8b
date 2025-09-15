// Converted to Verilog-2001 (no SystemVerilog features)
// default_nettype of none prevents implicit wire declaration.
`default_nettype none

module axi_read_master #(
  // Address width of the AXI interface
  parameter C_M_AXI_ADDR_WIDTH  = 64,
  // Data width of the AXI interface: 32, 64, 128, 256, 512, 1024
  parameter C_M_AXI_DATA_WIDTH  = 32,
  // Width of ctrl_xfer_size_in_bytes
  parameter C_XFER_SIZE_WIDTH   = C_M_AXI_ADDR_WIDTH,
  // Max outstanding transactions
  parameter C_MAX_OUTSTANDING   = 16,
  // Include FIFO (not instantiated in this Verilog version; pass-through used)
  parameter C_INCLUDE_DATA_FIFO = 1
)(
  // System
  input  wire                          aclk,
  input  wire                          areset,

  // Control
  input  wire                          ctrl_start,
  output wire                          ctrl_done,

  input  wire [C_M_AXI_ADDR_WIDTH-1:0] ctrl_addr_offset,
  input  wire [C_XFER_SIZE_WIDTH-1:0]  ctrl_xfer_size_in_bytes,

  // AXI4 master (read)
  output wire                          m_axi_arvalid,
  input  wire                          m_axi_arready,
  output wire [C_M_AXI_ADDR_WIDTH-1:0] m_axi_araddr,
  output wire [8-1:0]                  m_axi_arlen,

  input  wire                          m_axi_rvalid,
  output wire                          m_axi_rready,
  input  wire [C_M_AXI_DATA_WIDTH-1:0] m_axi_rdata,
  input  wire                          m_axi_rlast,

  // AXI4-Stream master
  output wire                          m_axis_tvalid,
  input  wire                          m_axis_tready,
  output wire [C_M_AXI_DATA_WIDTH-1:0] m_axis_tdata,
  output wire                          m_axis_tlast
);

///////////////////////////////////////////////////////////////////////////////
// Utility functions (Verilog-2001 compatible)
///////////////////////////////////////////////////////////////////////////////
function integer clog2;
  input integer value;
  integer v;
  begin
    v = value - 1;
    clog2 = 0;
    while (v > 0) begin
      v = v >> 1;
      clog2 = clog2 + 1;
    end
  end
endfunction

///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////
localparam integer LP_DW_BYTES               = (C_M_AXI_DATA_WIDTH/8);
localparam integer LP_LOG_DW_BYTES           = clog2(LP_DW_BYTES);

localparam integer LP_MAX_BURST_LENGTH       = 256;   // AXI max beats per burst
localparam integer LP_MAX_BURST_BYTES        = 4096;  // AXI max bytes per burst
localparam integer LP_AXI_BURST_LEN          =
  ((LP_MAX_BURST_BYTES/LP_DW_BYTES) < LP_MAX_BURST_LENGTH) ?
    (LP_MAX_BURST_BYTES/LP_DW_BYTES) : LP_MAX_BURST_LENGTH;

localparam integer LP_LOG_BURST_LEN          = clog2(LP_AXI_BURST_LEN);
localparam integer LP_OUTSTANDING_CNTR_WIDTH = clog2(C_MAX_OUTSTANDING+1);
localparam integer LP_TOTAL_LEN_WIDTH        = C_XFER_SIZE_WIDTH - LP_LOG_DW_BYTES;
localparam integer LP_TRANSACTION_CNTR_WIDTH = LP_TOTAL_LEN_WIDTH - LP_LOG_BURST_LEN;

// Address mask for 4kB alignment of burst (bytes_per_beat * beats_per_burst - 1)
localparam [C_M_AXI_ADDR_WIDTH-1:0] LP_ADDR_MASK =
  (LP_DW_BYTES*LP_AXI_BURST_LEN) - 1;

// FIFO params (not used in this pass-through variant)
localparam integer LP_FIFO_DEPTH       = (1 << clog2(LP_AXI_BURST_LEN*C_MAX_OUTSTANDING));
localparam integer LP_FIFO_READ_LATENCY= 2;
localparam integer LP_FIFO_COUNT_WIDTH = clog2(LP_FIFO_DEPTH)+1;

///////////////////////////////////////////////////////////////////////////////
// Registers / Wires
///////////////////////////////////////////////////////////////////////////////

// Control / status
reg                                      done;
reg                                      start_d1;
reg  [C_M_AXI_ADDR_WIDTH-1:0]            addr_offset_r;
reg                                      start;
reg  [LP_TOTAL_LEN_WIDTH-1:0]            total_len_r;
wire [LP_TRANSACTION_CNTR_WIDTH-1:0]     num_transactions;
reg  [LP_LOG_BURST_LEN-1:0]              final_burst_len;
wire                                     single_transaction;
wire                                     has_partial_bursts;

// AR channel
wire                                     arxfer;
reg                                      arvalid_r;
reg  [C_M_AXI_ADDR_WIDTH-1:0]            addr;
reg                                      ar_idle;
wire                                     ar_done;
wire [LP_TRANSACTION_CNTR_WIDTH-1:0]     ar_transactions_to_go;
wire                                     ar_final_transaction;
wire                                     stall_ar;

// R channel
wire                                     rxfer;
wire                                     r_completed;
reg                                      decr_r_transaction_cntr;
wire [LP_TRANSACTION_CNTR_WIDTH-1:0]     r_transactions_to_go;
wire                                     r_final_transaction;
wire [LP_OUTSTANDING_CNTR_WIDTH-1:0]     outstanding_vacancy_count;

// Helpers
wire [LP_TOTAL_LEN_WIDTH-1:0] beats_rounded_up;
wire [LP_LOG_BURST_LEN-1:0]   total_len_low_bits;
wire [LP_TRANSACTION_CNTR_WIDTH-1:0] total_len_high_bits;

///////////////////////////////////////////////////////////////////////////////
// Control Logic
///////////////////////////////////////////////////////////////////////////////

always @(posedge aclk) begin
  if (areset) begin
    done <= 1'b0;
  end else begin
    // pulse done when final R transfer completes
    done <= (rxfer & m_axi_rlast & r_final_transaction) ? 1'b1
            : (ctrl_done ? 1'b0 : done);
  end
end

assign ctrl_done = done;

always @(posedge aclk) begin
  if (areset) begin
    start_d1 <= 1'b0;
  end else begin
    start_d1 <= ctrl_start;
  end
end

// Round transfer size up to interface width (in beats), then subtract 1.
// Also align starting address to 4kB boundary of the burst (by masking lower bits).
assign beats_rounded_up = ( (ctrl_xfer_size_in_bytes + (LP_DW_BYTES-1)) >> LP_LOG_DW_BYTES );
always @(posedge aclk) begin
  if (areset) begin
    total_len_r   <= {LP_TOTAL_LEN_WIDTH{1'b0}};
    addr_offset_r <= {C_M_AXI_ADDR_WIDTH{1'b0}};
  end else if (ctrl_start) begin
    total_len_r   <= (beats_rounded_up == 0) ? {LP_TOTAL_LEN_WIDTH{1'b0}}
                                             : (beats_rounded_up - 1);
    addr_offset_r <= ctrl_addr_offset & ~LP_ADDR_MASK;
  end
end

// Decompose total_len_r into {num_transactions, final_burst_len}
assign total_len_low_bits  = total_len_r[LP_LOG_BURST_LEN-1:0];
assign total_len_high_bits = total_len_r[LP_TOTAL_LEN_WIDTH-1:LP_LOG_BURST_LEN];

assign num_transactions    = total_len_high_bits;
assign has_partial_bursts  = (total_len_low_bits == {LP_LOG_BURST_LEN{1'b1}}) ? 1'b0 : 1'b1;

always @(posedge aclk) begin
  if (areset) begin
    start           <= 1'b0;
    final_burst_len <= {LP_LOG_BURST_LEN{1'b0}};
  end else begin
    start           <= start_d1;
    final_burst_len <= total_len_low_bits;
  end
end

assign single_transaction = (num_transactions == {LP_TRANSACTION_CNTR_WIDTH{1'b0}}) ? 1'b1 : 1'b0;

///////////////////////////////////////////////////////////////////////////////
// AXI Read Address Channel
///////////////////////////////////////////////////////////////////////////////
assign m_axi_arvalid = arvalid_r;
assign m_axi_araddr  = addr;
assign m_axi_arlen   = (ar_final_transaction || (start & single_transaction)) ?
                        final_burst_len : (LP_AXI_BURST_LEN - 1);

assign arxfer = m_axi_arvalid & m_axi_arready;

always @(posedge aclk) begin
  if (areset) begin
    arvalid_r <= 1'b0;
  end else begin
    arvalid_r <= (~ar_idle & ~stall_ar & ~arvalid_r) ? 1'b1
               : (m_axi_arready ? 1'b0 : arvalid_r);
  end
end

// AR idle state
always @(posedge aclk) begin
  if (areset) begin
    ar_idle <= 1'b1;
  end else begin
    ar_idle <= start   ? 1'b0 :
               ar_done ? 1'b1 :
                         ar_idle;
  end
end

// AR address progression
always @(posedge aclk) begin
  if (areset) begin
    addr <= {C_M_AXI_ADDR_WIDTH{1'b0}};
  end else begin
    addr <= start  ? addr_offset_r
         : arxfer ? (addr + (LP_AXI_BURST_LEN * (C_M_AXI_DATA_WIDTH/8)))
                  : addr;
  end
end

// AR transactions-to-go counter
counter #(
  .C_WIDTH ( LP_TRANSACTION_CNTR_WIDTH         ),
  .C_INIT  ( {LP_TRANSACTION_CNTR_WIDTH{1'b0}} )
) inst_ar_transaction_cntr (
  .clk        ( aclk                   ),
  .clken      ( 1'b1                   ),
  .rst        ( areset                 ),
  .load       ( start                  ),
  .incr       ( 1'b0                   ),
  .decr       ( arxfer                 ),
  .load_value ( num_transactions       ),
  .count      ( ar_transactions_to_go  ),
  .is_zero    ( ar_final_transaction   )
);

assign ar_done = ar_final_transaction && arxfer;

// Outstanding transactions counter (limits issuance to avoid FIFO overflow)
counter #(
  .C_WIDTH ( LP_OUTSTANDING_CNTR_WIDTH                       ),
  .C_INIT  ( C_MAX_OUTSTANDING[0+:LP_OUTSTANDING_CNTR_WIDTH] )
) inst_ar_to_r_transaction_cntr (
  .clk        ( aclk                              ),
  .clken      ( 1'b1                              ),
  .rst        ( areset                            ),
  .load       ( 1'b0                              ),
  .incr       ( r_completed                       ),
  .decr       ( arxfer                            ),
  .load_value ( {LP_OUTSTANDING_CNTR_WIDTH{1'b0}} ),
  .count      ( outstanding_vacancy_count         ),
  .is_zero    ( stall_ar                          )
);

///////////////////////////////////////////////////////////////////////////////
// AXI Read Data Channel  (pass-through; no XPM FIFO here)
///////////////////////////////////////////////////////////////////////////////

// Pass-through from AXI R to AXIS
assign m_axis_tvalid = m_axi_rvalid;
assign m_axis_tdata  = m_axi_rdata;
assign m_axi_rready  = m_axis_tready;
assign m_axis_tlast  = m_axi_rlast;

assign rxfer       = m_axi_rready & m_axi_rvalid;
assign r_completed = m_axis_tvalid & m_axis_tready & m_axis_tlast;

always @* begin
  decr_r_transaction_cntr = (rxfer & m_axi_rlast);
end

// R transactions-to-go counter
counter #(
  .C_WIDTH ( LP_TRANSACTION_CNTR_WIDTH         ),
  .C_INIT  ( {LP_TRANSACTION_CNTR_WIDTH{1'b0}} )
) inst_r_transaction_cntr (
  .clk        ( aclk                    ),
  .clken      ( 1'b1                    ),
  .rst        ( areset                  ),
  .load       ( start                   ),
  .incr       ( 1'b0                    ),
  .decr       ( decr_r_transaction_cntr ),
  .load_value ( num_transactions        ),
  .count      ( r_transactions_to_go    ),
  .is_zero    ( r_final_transaction     )
);

endmodule
`default_nettype wire
