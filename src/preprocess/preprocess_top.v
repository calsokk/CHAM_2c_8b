module preprocess_top #(
    parameter DATA_WIDTH    = 39,
    parameter ADDR_WIDTH    = 12
) (
    input   wire                        clock,
    input   wire                        reset,

    input   wire                        io_i_intt_start,
    output  wire                        io_o_intt_done,
    input   wire                        io_i_vpu4_start,
    output  wire                        io_o_vpu4_done,
    input   wire                        io_i_pre_switch,
    input   wire                        io_i_mux_done,

    input   wire    [11:0]              io_i_coeff_index,

    input   wire                        io_i_dp1_wren,
    input   wire    [ADDR_WIDTH-1:0]    io_i_dp1_wraddr,
    input   wire    [1*DATA_WIDTH-1:0]  io_i_dp1_wrdata,
    input   wire    [ADDR_WIDTH-1:0]    io_i_dp1_rdaddr,
    output  wire    [1*DATA_WIDTH-1:0]  io_o_dp1_rddata,
    input   wire    [ADDR_WIDTH-1:0]    io_i_mux_rdaddr,
    output  wire    [4*DATA_WIDTH-1:0]  io_o_mux_rddata,
    output  wire    [279:0]             io_o_intt_concat,
    output  wire                        io_o_intt_we_result,
    output  wire    [71:0]              io_o_intt_addr_result
);

    preprocess_top_chisel u_dp2_top (
        .clock            (clock),
        .reset            (reset),

        .io_i_intt_start  (io_i_intt_start),
        .io_o_intt_done   (io_o_intt_done),

        .io_i_pre_switch  (io_i_pre_switch),
        .io_i_mux_done    (io_i_mux_done),
        .io_i_coeff_index (io_i_coeff_index),

        // ---- DP1 write/read: keep your original signal names & slices ----
        .io_dp1_wr_0_en   (io_i_dp1_wren),
        .io_dp1_wr_0_addr (io_i_dp1_wraddr),
        .io_dp1_wr_0_data (io_i_dp1_wrdata[0*DATA_WIDTH + 35 - 1 : 0*DATA_WIDTH]),

        .io_dp1_rd_0_addr (io_i_dp1_rdaddr),
        .io_dp1_rd_0_data (io_o_dp1_rddata[0*DATA_WIDTH + 35 - 1 : 0*DATA_WIDTH]),
        .io_o_intt_concat (io_o_intt_concat),
        .io_o_intt_we_result(io_o_intt_we_result),
        .io_o_intt_addr (io_o_intt_addr_result)
    );

    assign io_o_vpu4_done = 1'b1;

    genvar i;
    generate
        if (DATA_WIDTH > 35) begin
            for (i = 0; i < 1; i = i + 1) begin : gen_zero_35
                assign io_o_dp1_rddata[(i+1)*DATA_WIDTH-1 : i*DATA_WIDTH+35] = 'b0;
                assign io_o_mux_rddata[(i+1)*DATA_WIDTH-1 : i*DATA_WIDTH+35] = 'b0;
            end
        end
        if (DATA_WIDTH > 39) begin
            for (i = 4; i < 6; i = i + 1) begin : gen_zero_39
                assign io_o_dp1_rddata[(i+1)*DATA_WIDTH-1 : i*DATA_WIDTH+39] = 'b0;
            end
        end
    endgenerate

endmodule
