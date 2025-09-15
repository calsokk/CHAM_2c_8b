module axi_data_rd_top #(
    parameter AXI_ADDR_WIDTH        = 64,
    parameter AXI_DATA_WIDTH        = 128,
    parameter AXI_XFER_SIZE_WIDTH   = 32,
    parameter INCLUDE_DATA_FIFO     = 0,
    parameter PRE_DATA_WIDTH        = 35,
    parameter RAM_DELAY             = 3
)(
    // System
    input  wire                           clk,
    input  wire                           rst_n,

    // AXI4 input (read)
    output wire                           mvp_axi_arvalid,
    input  wire                           mvp_axi_arready,
    output wire [AXI_ADDR_WIDTH-1:0]      mvp_axi_araddr,
    output wire [7:0]                     mvp_axi_arlen,
    input  wire                           mvp_axi_rvalid,
    output wire                           mvp_axi_rready,
    input  wire [AXI_DATA_WIDTH-1:0]      mvp_axi_rdata,
    input  wire                           mvp_axi_rlast,

    // Control
    input  wire                           i_axird_initstart, // begin a vec+mat transfer
    input  wire                           i_axird_start,     // advance batches
    output wire                           o_axird_done,      // done for current phase
    output wire                           o_axird_alldone,   // back to IDLE

    // Pointers/sizes
    input  wire [AXI_ADDR_WIDTH-1:0]      mat_ptr,
    input  wire [AXI_ADDR_WIDTH-1:0]      vec_ptr,
    input  wire [AXI_XFER_SIZE_WIDTH-1:0] mat_size_bytes,
    input  wire [AXI_XFER_SIZE_WIDTH-1:0] vec_size_bytes,
    input  wire [14:0]                    data_size_batches, // one more bit for vec_size

    // Preprocess write-out
    output wire [47:0]                    o_axird_pre_wren,   // p5b7..p0b0
    output wire [71:0]                    o_axird_pre_wraddr, // 9*8
    output wire [8*PRE_DATA_WIDTH-1:0]    o_axird_pre_wrdata,
    input  wire [31:0]                    i_axird_command    // 0 - init, 1 - run    
);
    /////////////////
    // Parameters & locals
    /////////////////
    localparam S_IDLE     = 2'd0;
    localparam S_PRE_XFER = 2'd1;
    localparam S_PRE_HALT = 2'd2;

    /////////////////
    // AXI2BRAM glue (always vec+mat)
    /////////////////
    wire [AXI_ADDR_WIDTH-1:0]      input_ptr  = vec_ptr; // assume mat follows vec in address map if needed by your fabric
    wire [AXI_XFER_SIZE_WIDTH-1:0] input_size = vec_size_bytes + mat_size_bytes;

    wire                           a2b_done;
    wire                           a2b_wren;
    wire [31:0]                    a2b_addr;
    wire [AXI_DATA_WIDTH-1:0]      a2b_data;

    // only write into preprocess path
    wire                           ibuf_wren = a2b_wren;
    wire [31:0]                    ibuf_addr = a2b_addr; // adjusted below per batch

    wire                           ibuf_done;
    reg [1:0] state, state_nxt;
    reg [14:0] count_batch;

    axi_axi2bram #(
        .AXI_ADDR_WIDTH       ( AXI_ADDR_WIDTH      ),
        .AXI_DATA_WIDTH       ( AXI_DATA_WIDTH      ),
        .AXI_XFER_SIZE_WIDTH  ( AXI_XFER_SIZE_WIDTH ),
        .BRAM_DELAY           ( RAM_DELAY           ),
        .INCLUDE_DATA_FIFO    ( INCLUDE_DATA_FIFO   )
    ) i_axi2bram (
        .clk                   ( clk                 ),
        .rst_n                 ( rst_n               ),
        .i_a2b_start           ( i_axird_initstart   ),
        .o_a2b_done            ( a2b_done            ),
        .i_a2b_ready           ( state == S_PRE_XFER ),
        .i_a2b_data_addr       ( input_ptr           ),
        .i_a2b_data_size_bytes ( input_size          ),
        .m_axi_arvalid         ( mvp_axi_arvalid     ),
        .m_axi_arready         ( mvp_axi_arready     ),
        .m_axi_araddr          ( mvp_axi_araddr      ),
        .m_axi_arlen           ( mvp_axi_arlen       ),
        .m_axi_rvalid          ( mvp_axi_rvalid      ),
        .m_axi_rready          ( mvp_axi_rready      ),
        .m_axi_rdata           ( mvp_axi_rdata       ),
        .m_axi_rlast           ( mvp_axi_rlast       ),
        .o_a2b_wren            ( a2b_wren            ),
        .o_a2b_wraddr          ( a2b_addr            ),
        .o_a2b_wrdata          ( a2b_data            )
    );

    /////////////////
    // State machine (preprocess-only)
    /////////////////
    //reg [1:0] state, state_nxt;
    //reg [14:0] count_batch;

    // each batch is 0x800 addresses (as in your original)
    wire [31:0] ibuf_addr_adj = a2b_addr - count_batch * 12'h800;

    always @(*) begin
        state_nxt = state;
        case (state)
            S_IDLE:     if (i_axird_initstart)     state_nxt = S_PRE_XFER;
            S_PRE_XFER: if (ibuf_addr_adj[11:0] == 12'h7ff && a2b_wren)
                                                    state_nxt = S_PRE_HALT;
            S_PRE_HALT: if (count_batch == data_size_batches && ibuf_done)
                                                    state_nxt = S_IDLE;
                        else if (i_axird_start)     state_nxt = S_PRE_XFER;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= S_IDLE;
        else        state <= state_nxt;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)                        count_batch <= 'd0;
        else if (state==S_PRE_XFER &&
                 state_nxt==S_PRE_HALT)    count_batch <= count_batch + 1'b1;
        else if (state==S_IDLE)            count_batch <= 'd0;
    end

    // done flags (same behavior as your preprocess path)
    wire o_axird_done_w = (state == S_IDLE) || (state == S_PRE_HALT && ibuf_done);
    reg  o_axird_done_r;

    assign o_axird_done    = o_axird_done_r;
    assign o_axird_alldone = (state == S_IDLE);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)                    o_axird_done_r <= 1'b1;
        else if (i_axird_start |
                 i_axird_initstart)    o_axird_done_r <= 1'b0;
        else if (o_axird_done_w)       o_axird_done_r <= 1'b1;
    end

    /////////////////
    // Preprocess path (trim + transpose)
    /////////////////
    wire [AXI_DATA_WIDTH-1:0]      ibuf_din = a2b_data;
    wire [2*PRE_DATA_WIDTH-1:0]    ibuf_din_trim;
    //wire                           ibuf_done;

    data_trimmer #(
        .IN_WIDTH   ( 64               ),
        .OUT_WIDTH  ( PRE_DATA_WIDTH   ),
        .DATA_COUNT ( 2                )
    ) i_pre_input_trimmer (
        .trim_in    ( ibuf_din         ),
        .trim_out   ( ibuf_din_trim    )
    );

    pre_input_transposer #(
        .DATA_WIDTH ( PRE_DATA_WIDTH   )
    ) i_pre_input_transposer (
        .clk        ( clk                      ),
        .rst_n      ( rst_n                    ),
        .i_ibuf_reset ( 1'b0                   ),
        .o_ibuf_done  ( ibuf_done              ),
        .i_ibuf_wren  ( ibuf_wren              ),
        .i_ibuf_addr  ( ibuf_addr_adj[11:0]    ),
        .i_ibuf_data  ( ibuf_din_trim          ),
        .o_ibuf_wren  ( o_axird_pre_wren       ),
        .o_ibuf_addr  ( o_axird_pre_wraddr     ),
        .o_ibuf_data  ( o_axird_pre_wrdata     )
    );

endmodule
