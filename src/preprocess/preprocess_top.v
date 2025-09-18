module preprocess_top #(
    parameter DATA_WIDTH = 39,
    parameter ADDR_WIDTH = 12
) (
    input  wire                       clock,
    input  wire                       reset,

    // control
    input  wire                       io_i_intt_start,
    output wire                       io_o_intt_done,
    input  wire                       io_i_vpu4_start,
    output wire                       io_o_vpu4_done,
    input  wire                       io_i_pre_switch,
    input  wire                       io_i_mux_done,

    // misc
    input  wire  [11:0]               io_i_coeff_index,

    // DP1 access (VPU<->TPP polyvec0)
    input  wire                       io_i_dp1_wren,
    input  wire  [ADDR_WIDTH-1:0]     io_i_dp1_wraddr,
    input  wire  [DATA_WIDTH-1:0]     io_i_dp1_wrdata,
    input  wire  [ADDR_WIDTH-1:0]     io_i_dp1_rdaddr,
    output wire  [DATA_WIDTH-1:0]     io_o_dp1_rddata,

    // external mux peek (kept for interface; no producer here)
    input  wire  [ADDR_WIDTH-1:0]     io_i_mux_rdaddr,
    output wire  [4*DATA_WIDTH-1:0]   io_o_mux_rddata,

    // INTT monitor
    output wire  [279:0]              io_o_intt_concat,
    output wire                       io_o_intt_we_result,
    output wire  [71:0]               io_o_intt_addr_result,

    // >>> NEW: expose packed INTT buffer buses up <<<
    output wire  [7:0]                io_inttWrEnPacked,
    output wire  [71:0]               io_inttWrAddrPacked,
    output wire  [279:0]              io_inttWrDataPacked,   // 8 * 35
    output wire  [71:0]               io_inttRdAddrPacked,
    input  wire  [279:0]              io_inttRdDataPacked,   // 8 * 35

    // >>> Expose Triple-PP packed bank buses up to test env <<<
    output wire  [23:0]               tppWrEnPacked,     // 3 polyvecs * 8 banks
    output wire  [215:0]              tppWrAddrPacked,   // 24 * 9
    output wire  [839:0]              tppWrDataPacked,   // 24 * 35
    output wire  [215:0]              tppRdAddrPacked,   // 24 * 9
    input  wire  [839:0]              tppRdDataPacked    // 24 * 35
);

    // -------------------------------------------------------------------
    // Locals that match the Chisel-generated bank geometry
    // -------------------------------------------------------------------
    localparam integer PV_DW = 35;

    // -------------------------------------------------------------------
    // Chisel-generated submodule (now RAM-less)
    // -------------------------------------------------------------------
    preprocess_top_chisel u_dp2_top (
        .clock               (clock),
        .reset               (reset),

        .io_i_intt_start     (io_i_intt_start),
        .io_o_intt_done      (io_o_intt_done),

        .io_i_pre_switch     (io_i_pre_switch),
        .io_i_mux_done       (io_i_mux_done),
        .io_i_coeff_index    (io_i_coeff_index),

        // ---- DP1 write/read (lower 35 bits used) ----
        .io_dp1_wr_0_en      (io_i_dp1_wren),
        .io_dp1_wr_0_addr    (io_i_dp1_wraddr[11:0]),
        .io_dp1_wr_0_data    (io_i_dp1_wrdata[PV_DW-1:0]),

        .io_dp1_rd_0_addr    (io_i_dp1_rdaddr[11:0]),
        .io_dp1_rd_0_data    (io_o_dp1_rddata[PV_DW-1:0]),

        // INTT taps
        .io_o_intt_concat    (io_o_intt_concat),
        .io_o_intt_addr      (io_o_intt_addr_result),
        .io_o_intt_we_result (io_o_intt_we_result),

        // ---- NEW: pass-through packed INTT buses ----
        .io_inttWrEnPacked   (io_inttWrEnPacked),
        .io_inttWrAddrPacked (io_inttWrAddrPacked),
        .io_inttWrDataPacked (io_inttWrDataPacked),
        .io_inttRdAddrPacked (io_inttRdAddrPacked),
        .io_inttRdDataPacked (io_inttRdDataPacked),

        // ---- Packed TPP bank buses (unchanged) ----
        .tppWrEnPacked       (tppWrEnPacked),
        .tppWrAddrPacked     (tppWrAddrPacked),
        .tppWrDataPacked     (tppWrDataPacked),
        .tppRdAddrPacked     (tppRdAddrPacked),
        .tppRdDataPacked     (tppRdDataPacked)
    );

    // -------------------------------------------------------------------
    // Defaults and padding
    // -------------------------------------------------------------------
    assign io_o_vpu4_done = 1'b1;

    // No banks here anymore to satisfy the mux readout,
    // so drive the whole mux bus to 0 to avoid Xs.
    assign io_o_mux_rddata = 'd0;

    // Pad DP1 read data upper bits if DATA_WIDTH > 35.
    genvar i;
    generate
        if (DATA_WIDTH > PV_DW) begin : gen_pad_dp1
            for (i = 0; i < 1; i = i + 1) begin : gen_zero_35
                assign io_o_dp1_rddata[(i+1)*DATA_WIDTH-1 : i*DATA_WIDTH+PV_DW] = 'b0;
            end
        end
    endgenerate

endmodule
