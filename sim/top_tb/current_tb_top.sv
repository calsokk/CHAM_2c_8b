//////////////////////////////////////////////////
//
// File:            tb_top.sv
// Project Name:    MVP v1.2 top testbench
// Module Name:     tb_top
// Description:     MVP v1.2 top testbench
//
// Author:          Heng Liu(taotao), Xuanle Ren(qianxuan)
// Email:           xuanle.rxl@alibaba-inc.com
// Setup Data:      13/08/2021
// Modify Date:     03/04/2022
//
//////////////////////////////////////////////////

`include "common_defines.vh"
`define PERIOD  4

module tb_top;

    parameter C_DATA_AXI_ADDR_WIDTH = 64;
    parameter C_DATA_AXI_DATA_WIDTH_MVP = 128;
    parameter C_DATA_AXI_DATA_WIDTH_AXI_BRAM = 512;
    parameter C_S_AXI_CONTROL_ADDR_WIDTH = 12;
    parameter C_S_AXI_CONTROL_DATA_WIDTH = 32;

    parameter N_STAGE = 11;
    parameter ADDR_WIDTH = 12;
    parameter LEVEL_WIDTH = 4;
    parameter COE_WIDTH = 39;
    parameter P = 39'h40_0080_0001;
    parameter Q0 = 35'h4_0800_0001;
    parameter Q1 = 35'h4_0008_0001;

    parameter LEVEL = 2;
    parameter COL_SIZE = 4096;
    parameter N_SPLIT = 1;
    parameter N_INDEX = 1;
    parameter MAT_LEN = 4;

    localparam  N_RSLT_POLY        = 4;
    localparam  N_KSK_POLY         = 144;

    localparam  TB_DDR_DATA_SIZE   = (N_SPLIT * 6 + MAT_LEN * 3 + N_KSK_POLY + N_RSLT_POLY) << 15;
    localparam  TB_DDR_ADDR_WIDTH  = $clog2(TB_DDR_DATA_SIZE);
    localparam  DDR_MEM_DEPTH      = (2 ** TB_DDR_ADDR_WIDTH) >> 6;

    localparam  DDR_MEM_VEC_DEPTH  = (N_SPLIT * 4) << 9;
    localparam  DDR_MEM_MAT_DEPTH  = (MAT_LEN * 2) << 9;
    localparam  DDR_MEM_KSK_DEPTH  = N_KSK_POLY << 9;
    localparam  DDR_MEM_RSLT_DEPTH = N_RSLT_POLY << 9;

    localparam  VEC_START_LINE     = 0;
    localparam  MAT_START_LINE     = VEC_START_LINE + DDR_MEM_VEC_DEPTH;
    localparam  KSK_START_LINE     = MAT_START_LINE + DDR_MEM_MAT_DEPTH;
    localparam  RSLT_START_LINE    = KSK_START_LINE + DDR_MEM_KSK_DEPTH;

    localparam  VEC_START_ADDR     = VEC_START_LINE << 6;
    localparam  MAT_START_ADDR     = MAT_START_LINE << 6;
    localparam  KSK_START_ADDR     = KSK_START_LINE << 6;
    localparam  RSLT_START_ADDR    = RSLT_START_LINE << 6;

    localparam  PARTIAL_START_LINE      = 0;
    localparam  DDR_MEM_PARTIAL_DEPTH   = 6 << 9;

    localparam  POLY_SIZE = 1 << ADDR_WIDTH;

    `define REG_BASE_ADDR       12'h0
    `define AXI_RD              u_dut_top.u_axi_data_rd_top
    `define AXI_WR              u_dut_top.u_axi_data_wr_top
    `define DP                  u_dut_top.u_dp_top
    `define PP0                 u_dut_top.u_preprocess_top0.u_dp2_top
    `define PP1                 u_dut_top.u_preprocess_top1.u_dp2_top
    `define RT                  u_dut_top.u_reduce_trace
    `define CNTL                u_dut_top.u_control
    `define KSK_RAM             u_dut_top.u_axi_data_rd_top.i_ksk_buffer
    `define RB                  u_dut_top.u_reduce_buffer

    `ifdef PARTIAL_TEST
        localparam PARTIAL_TEST       = 1; 
    `else
        localparam PARTIAL_TEST       = 0;
    `endif

    `ifdef DEBUG_SINGLE_STAGE
        localparam DEBUG_SINGLE_STAGE = 1;
    `else
        localparam DEBUG_SINGLE_STAGE = 0;
    `endif
    
    localparam RUN_DIR          = "../../../../../";


    `ifdef INIT_KSK
    /*
        defparam `KSK_RAM.gen_ksk_uram[0].i_ksk_uram_spdram.MEMORY_PRIMITIVE="block";
        defparam `KSK_RAM.gen_ksk_uram[0].i_ksk_uram_spdram.MEMORY_INIT_FILE="uram_k0.mem";
        defparam `KSK_RAM.gen_ksk_uram[1].i_ksk_uram_spdram.MEMORY_PRIMITIVE="block";
        defparam `KSK_RAM.gen_ksk_uram[1].i_ksk_uram_spdram.MEMORY_INIT_FILE="uram_k1.mem";
        defparam `KSK_RAM.gen_ksk_uram[2].i_ksk_uram_spdram.MEMORY_PRIMITIVE="block";
        defparam `KSK_RAM.gen_ksk_uram[2].i_ksk_uram_spdram.MEMORY_INIT_FILE="uram_k2.mem";
        defparam `KSK_RAM.gen_ksk_uram[3].i_ksk_uram_spdram.MEMORY_PRIMITIVE="block";
        defparam `KSK_RAM.gen_ksk_uram[3].i_ksk_uram_spdram.MEMORY_INIT_FILE="uram_k3.mem";
        defparam `KSK_RAM.gen_ksk_uram[4].i_ksk_uram_spdram.MEMORY_PRIMITIVE="block";
        defparam `KSK_RAM.gen_ksk_uram[4].i_ksk_uram_spdram.MEMORY_INIT_FILE="uram_k4.mem";
        defparam `KSK_RAM.gen_ksk_uram[5].i_ksk_uram_spdram.MEMORY_PRIMITIVE="block";
        defparam `KSK_RAM.gen_ksk_uram[5].i_ksk_uram_spdram.MEMORY_INIT_FILE="uram_k5.mem";
        defparam `KSK_RAM.gen_ksk_uram[6].i_ksk_uram_spdram.MEMORY_PRIMITIVE="block";
        defparam `KSK_RAM.gen_ksk_uram[6].i_ksk_uram_spdram.MEMORY_INIT_FILE="uram_k6.mem";
        defparam `KSK_RAM.gen_ksk_uram[7].i_ksk_uram_spdram.MEMORY_PRIMITIVE="block";
        defparam `KSK_RAM.gen_ksk_uram[7].i_ksk_uram_spdram.MEMORY_INIT_FILE="uram_k7.mem";
        defparam `KSK_RAM.gen_ksk_uram[8].i_ksk_uram_spdram.MEMORY_PRIMITIVE="block";
        defparam `KSK_RAM.gen_ksk_uram[8].i_ksk_uram_spdram.MEMORY_INIT_FILE="uram_k8.mem";
        defparam `KSK_RAM.gen_ksk_uram[9].i_ksk_uram_spdram.MEMORY_PRIMITIVE="block";
        defparam `KSK_RAM.gen_ksk_uram[9].i_ksk_uram_spdram.MEMORY_INIT_FILE="uram_k9.mem";
        defparam `KSK_RAM.gen_ksk_uram[10].i_ksk_uram_spdram.MEMORY_PRIMITIVE="block";
        defparam `KSK_RAM.gen_ksk_uram[10].i_ksk_uram_spdram.MEMORY_INIT_FILE="uram_k10.mem";
        defparam `KSK_RAM.gen_ksk_uram[11].i_ksk_uram_spdram.MEMORY_PRIMITIVE="block";
        defparam `KSK_RAM.gen_ksk_uram[11].i_ksk_uram_spdram.MEMORY_INIT_FILE="uram_k11.mem";
        */
    `endif

    int                                     fd, rt, i, ii;

    bit                                     clk, rst_n;
    bit                                     start, interrupt;
    bit [C_DATA_AXI_DATA_WIDTH_AXI_BRAM/8-1:0]       tmp[7:0];
    bit [511:0]                             gold_mem;
    bit [COE_WIDTH*8-1:0]                   ksk_mem;
    bit [511:0]                             temp_mem [0:DDR_MEM_DEPTH-1];
    bit                                     stage0_mode;
    bit                                     init;
    bit                                     switch_mode;
    bit [N_STAGE-1:0]                       stage_status_partial_test;
    bit [N_STAGE-1:0]                       stage_status_single_stage;
    bit [N_STAGE-1:0]                       stage_status;
    bit [N_STAGE-1:0]                       stage_start_partial_test;
    bit [N_STAGE-1:0]                       stage_start_d1;
    bit [N_STAGE-1:0]                       stage_start_d2;
    bit [N_STAGE-1:0]                       stage_start_d3;
    bit [N_STAGE-1:0]                       stage_start_d4;
    bit [N_STAGE-1:0]                       stage_start_d5;
    bit [N_STAGE-1:0]                       stage_start_d6;
    bit [N_STAGE-1:0]                       stage_start_d7;
    bit [N_STAGE-1:0]                       stage_start_partial_test_pre;
    bit [N_STAGE-1:0]                       stage_done;
    bit                                     stage_10_done_delay;
    bit                                     stage_10_done_pulse;
    wire                                    in_a_row_done;
    reg                                     done_delay, done_pulse_d1, done_pulse_d2, done_pulse_d3, done_pulse_d4, done_pulse_d5;
    wire                                    done_pulse;
    bit [LEVEL_WIDTH-1:0]                   level_partial_test;
    bit [LEVEL_WIDTH-1:0]                   level_minus_one_partial_test;
    bit [LEVEL_WIDTH*5-1:0]                 level_partial_test_x5;
    bit [ADDR_WIDTH-1:0]                    index_partial_test;
    bit [LEVEL_WIDTH-1:0]                   rt_buffer_wr_index;
    string                                  testname;
    int                                     ts_single_stage;
    int                                     ts_full;
    int                                     ts_row;
    int                                     ts;
    int                                     is_stall;
    int                                     is_trace;
    string                                  ts_str, timeslot;
    string                                  test_data_dir;
    string                                  cmod_data_dir;
    string                                  test_size;

    // AXI4 master interface
    wire                                    data_axi_awvalid;
    wire                                    data_axi_awready;
    wire    [C_DATA_AXI_ADDR_WIDTH-1:0]     data_axi_awaddr;
    wire    [7:0]                           data_axi_awlen;
    wire                                    data_axi_wvalid;
    wire                                    data_axi_wready;
    wire    [C_DATA_AXI_DATA_WIDTH_AXI_BRAM-1:0]     data_axi_wdata;
    wire    [C_DATA_AXI_DATA_WIDTH_AXI_BRAM/2-1:0]   data_axi_wstrb;
    wire                                    data_axi_wlast;
    wire                                    data_axi_bvalid;
    wire                                    data_axi_bready;
    wire                                    data_axi_arvalid;
    wire                                    data_axi_arready;
    wire    [C_DATA_AXI_ADDR_WIDTH-1:0]     data_axi_araddr;
    wire    [7:0]                           data_axi_arlen;
    wire                                    data_axi_rvalid;
    wire                                    data_axi_rready;
    wire    [C_DATA_AXI_DATA_WIDTH_AXI_BRAM-1:0]     data_axi_rdata;
    wire                                    data_axi_rlast;
    wire    [279:0]                         io_o_intt_concat;
    wire                                    io_o_intt_we_result;

    // AXI4-Lite slave interface
    // reg                                     s_axi_control_awvalid;
    // wire                                    s_axi_control_awready;
    // reg  [C_S_AXI_CONTROL_ADDR_WIDTH-1:0]   s_axi_control_awaddr ;
    // reg                                     s_axi_control_wvalid ;
    // wire                                    s_axi_control_wready ;
    // reg  [C_S_AXI_CONTROL_DATA_WIDTH-1:0]   s_axi_control_wdata  ;
    // reg  [C_S_AXI_CONTROL_DATA_WIDTH/8-1:0] s_axi_control_wstrb  ;
    // reg                                     s_axi_control_arvalid;
    // wire                                    s_axi_control_arready;
    // reg  [C_S_AXI_CONTROL_ADDR_WIDTH-1:0]   s_axi_control_araddr ;
    // wire                                    s_axi_control_rvalid ;
    // reg                                     s_axi_control_rready ;
    // wire [C_S_AXI_CONTROL_DATA_WIDTH-1:0]   s_axi_control_rdata  ;
    // wire [2-1:0]                            s_axi_control_rresp  ;
    // wire                                    s_axi_control_bvalid ;
    // reg                                     s_axi_control_bready ;
    // wire [2-1:0]                            s_axi_control_bresp  ;


    /******************************************************************************/
    /**************************** Clock Value Generation **************************/
    /******************************************************************************/
    initial begin
        clk = 1'b1;
    end

    always #(`PERIOD/2) clk = ~clk;


    /*******************************************************************************/
    /*************** AXI-Lite interface init value Generation **********************/
    /*******************************************************************************/
    // initial begin
    //     s_axi_control_awvalid = 1'b0;
    //     s_axi_control_awaddr  = {(C_S_AXI_CONTROL_ADDR_WIDTH){1'b0}};
    //     s_axi_control_wvalid  = 1'b0;
    //     s_axi_control_wdata   = {(C_S_AXI_CONTROL_DATA_WIDTH){1'b0}};
    //     s_axi_control_wstrb   = {(C_S_AXI_CONTROL_DATA_WIDTH/8){1'b0}};
    //     s_axi_control_arvalid = 1'b0;
    //     s_axi_control_araddr  = {(C_S_AXI_CONTROL_ADDR_WIDTH){1'b0}};
    //     s_axi_control_rready  = 1'b1;
    //     s_axi_control_bready  = 1'b1;
    // end


    /*******************************************************************************/
    /******************* Module Instantiation in Testbench *************************/
    /*******************************************************************************/

    // BRAM with AXI interface to mimic memory with AXI interface in Vitis Shell
    tb_axi_bram #(
    .C_S_AXI_DATA_WIDTH (C_DATA_AXI_DATA_WIDTH_AXI_BRAM),
    .C_S_AXI_ADDR_WIDTH (TB_DDR_ADDR_WIDTH)
    ) i_ddr_mem (
        .s_axi_aclk   (clk),
        .s_axi_aresetn(rst_n),
        .s_axi_awid   (4'd0),
        .s_axi_awaddr (data_axi_awaddr[TB_DDR_ADDR_WIDTH-1:0]),
        .s_axi_awlen  (data_axi_awlen),
        .s_axi_awsize (3'd6),
        .s_axi_awburst(2'd1),
        .s_axi_awlock (1'd0),
        .s_axi_awcache(4'd3),
        .s_axi_awprot (3'd0),
        .s_axi_awvalid(data_axi_awvalid),
        .s_axi_awready(data_axi_awready),
        .s_axi_wdata  (data_axi_wdata),
        .s_axi_wstrb  (data_axi_wstrb),
        .s_axi_wlast  (data_axi_wlast),
        .s_axi_wvalid (data_axi_wvalid),
        .s_axi_wready (data_axi_wready),
        .s_axi_bid    (),
        .s_axi_bresp  (),
        .s_axi_bvalid (data_axi_bvalid),
        .s_axi_bready (data_axi_bready),
        .s_axi_arid   (4'd0),
        .s_axi_araddr (data_axi_araddr),
        .s_axi_arlen  (data_axi_arlen),
        .s_axi_arsize (3'd6),
        .s_axi_arburst(2'd1),
        .s_axi_arlock (1'd0),
        .s_axi_arcache(4'd3),
        .s_axi_arprot (3'd0),
        .s_axi_arvalid(data_axi_arvalid),
        .s_axi_arready(data_axi_arready),
        .s_axi_rid    (),
        .s_axi_rdata  (data_axi_rdata),
        .s_axi_rresp  (),
        .s_axi_rlast  (data_axi_rlast),
        .s_axi_rvalid (data_axi_rvalid),
        .s_axi_rready (data_axi_rready) 
    );

    // MVP Top-level Design Instantiation
    bit [31:0]                          csr_test1    ;  // out
    bit                                 csr_ap_start ;  // TODO
    bit [31:0]                          csr_ap_done  ;  // out
    bit                                 csr_ap_idle  ;  // out
    bit                                 csr_ap_ready ;  // out
    bit [31:0]                          csr_command  ;  // TODO
    bit [31:0]                          csr_level    ;
    bit [31:0]                          csr_col_size ;
    bit [31:0]                          csr_split    ;
    bit [31:0]                          csr_index    ;
    bit [31:0]                          csr_mat_len  ;
    bit [C_DATA_AXI_ADDR_WIDTH-1:0]     csr_ksk_ptr  ;  // TODO
    bit [C_DATA_AXI_ADDR_WIDTH-1:0]     csr_mat_ptr  ;  // TODO
    bit [C_DATA_AXI_ADDR_WIDTH-1:0]     csr_vec_ptr  ;  // TODO
    bit [C_DATA_AXI_ADDR_WIDTH-1:0]     csr_rslt_ptr ;  // TODO


    // -------------------------------------------------------------------
    // TB-side constants for external polyvec RAM wiring
    // (match these to your DUT config)
    // -------------------------------------------------------------------
    localparam int TB_NUM_BASE_BANK = 8;   // == NUM_BASE_BANK
    localparam int TB_NUM_POLY      = 1;   // == N_POLY
    localparam int TB_ADDR_WIDTH    = 9;   // == ADDR_WIDTH_L
    localparam int TB_COE_WIDTH     = 39;  // == COE_WIDTH_L

    // === External polyvec RAM interfaces exposed by mvp_top ===
    // Polyvec0
    logic [TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]                 tb_polyvec_wea0;
    logic [TB_ADDR_WIDTH*TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]   tb_polyvec_addra0;
    logic [TB_COE_WIDTH*TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]    tb_polyvec_dina0;
    logic [TB_ADDR_WIDTH*TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]   tb_polyvec_addrb0;
    logic [TB_COE_WIDTH*TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]    tb_polyvec_doutb0;

    // Polyvec1
    logic [TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]                 tb_polyvec_wea1;
    logic [TB_ADDR_WIDTH*TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]   tb_polyvec_addra1;
    logic [TB_COE_WIDTH*TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]    tb_polyvec_dina1;
    logic [TB_ADDR_WIDTH*TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]   tb_polyvec_addrb1;
    logic [TB_COE_WIDTH*TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]    tb_polyvec_doutb1;

    // Polyvec2
    logic [TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]                 tb_polyvec_wea2;
    logic [TB_ADDR_WIDTH*TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]   tb_polyvec_addra2;
    logic [TB_COE_WIDTH*TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]    tb_polyvec_dina2;
    logic [TB_ADDR_WIDTH*TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]   tb_polyvec_addrb2;
    logic [TB_COE_WIDTH*TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]    tb_polyvec_doutb2;

    // ---------------- Polyvec RAM wires (TB side) ----------------
    wire [TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]                  o_poly_wea;
    wire [TB_ADDR_WIDTH*TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]    o_poly_addra;
    wire [TB_COE_WIDTH*TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]     o_poly_dina;
    wire [TB_ADDR_WIDTH*TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]    o_poly_addrb;
    wire [TB_COE_WIDTH*TB_NUM_BASE_BANK*TB_NUM_POLY-1:0]     i_poly_doutb;

    /***** Preprocess TPP Banks *****/
    localparam integer PV_NPV   = 3;   // number of polyvecs
    localparam integer PV_NBANK = 8;   // banks per polyvec
    localparam integer PV_AW    = 9;   // bank address width
    localparam integer PV_DW    = 35;  // bank data width

    wire [PV_NPV*PV_NBANK      -1:0] tppWrEnPacked;    // [23:0]
    wire [PV_NPV*PV_NBANK*PV_AW-1:0] tppWrAddrPacked;  // [215:0]
    wire [PV_NPV*PV_NBANK*PV_DW-1:0] tppWrDataPacked;  // [839:0]
    wire [PV_NPV*PV_NBANK*PV_AW-1:0] tppRdAddrPacked;  // [215:0]
    wire [PV_NPV*PV_NBANK*PV_DW-1:0] tppRdDataPacked;  // [839:0]

    // Packed INTT buses (from preprocess_top)
    wire [7:0]    io_inttWrEnPacked;
    wire [71:0]   io_inttWrAddrPacked;   // 8 * 9
    wire [279:0]  io_inttWrDataPacked;   // 8 * 35
    wire [71:0]   io_inttRdAddrPacked;   // 8 * 9
    wire [279:0]  io_inttRdDataPacked;   // 8 * 35

    wire    [10-1:0]                 o_start_w;
    wire                             o_mvp_start_w;
    wire    [1:0]                    dp_tpp_mode;
    wire                            axi_alldone_w;
    wire                            axird_done;

    mvp_top # (
        .AXI_ADDR_WIDTH     ( C_DATA_AXI_ADDR_WIDTH ),
        .AXI_DATA_WIDTH     ( C_DATA_AXI_DATA_WIDTH_MVP )
    ) u_dut_top (
        .clk    ( clk   ),
        .rst_n  ( rst_n ),
        .o_mvp_start_w          (o_mvp_start_w)        ,
        .o_start_w              (o_start_w)            ,
        .mem_init_all_done      (axi_alldone_w)    ,
        .mem_init_stage_done    (axird_done)         ,         

        // AXI Interface
        /*
        .data_axi_awvalid   ( data_axi_awvalid  ),
        .data_axi_awready   ( data_axi_awready  ),
        .data_axi_awaddr    ( data_axi_awaddr   ),
        .data_axi_awlen     ( data_axi_awlen    ),
        .data_axi_wvalid    ( data_axi_wvalid   ),
        .data_axi_wready    ( data_axi_wready   ),
        .data_axi_wdata     ( data_axi_wdata    ),
        .data_axi_wstrb     ( data_axi_wstrb    ),
        .data_axi_wlast     ( data_axi_wlast    ),
        .data_axi_bvalid    ( data_axi_bvalid   ),
        .data_axi_bready    ( data_axi_bready   ),
        .data_axi_arvalid   ( data_axi_arvalid  ),
        .data_axi_arready   ( data_axi_arready  ),
        .data_axi_araddr    ( data_axi_araddr   ),
        .data_axi_arlen     ( data_axi_arlen    ),
        .data_axi_rvalid    ( data_axi_rvalid   ),
        .data_axi_rready    ( data_axi_rready   ),
        .data_axi_rdata     ( data_axi_rdata    ),
        .data_axi_rlast     ( data_axi_rlast    ),
        */

        // Control
        .test1      ( csr_test1     ),  // out
        .ap_start   ( csr_ap_start  ),
        .ap_done    ( csr_ap_done   ),  // out
        .ap_idle    ( csr_ap_idle   ),  // out
        .ap_ready   ( csr_ap_ready  ),  // out
        .command    ( csr_command   ),
        .level      ( csr_level     ),
        .col_size   ( csr_col_size  ),
        .split      ( csr_split     ),
        .index      ( csr_index     ),
        .mat_len    ( csr_mat_len   ),
        .ksk_ptr    ( csr_ksk_ptr   ),
        .mat_ptr    ( csr_mat_ptr   ),
        .vec_ptr    ( csr_vec_ptr   ),
        .data_ptr   ( csr_rslt_ptr  ),
        
        .io_o_intt_concat(io_o_intt_concat),
        .io_o_intt_we_result(io_o_intt_we_result),
        .dp_tpp_mode(dp_tpp_mode),

        // === External polyvec banks ===
        .o_polyvec_wea0   (tb_polyvec_wea0),
        .o_polyvec_addra0 (tb_polyvec_addra0),
        .o_polyvec_dina0  (tb_polyvec_dina0),
        .o_polyvec_addrb0 (tb_polyvec_addrb0),
        .i_polyvec_doutb0 (tb_polyvec_doutb0),

        .o_polyvec_wea1   (tb_polyvec_wea1),
        .o_polyvec_addra1 (tb_polyvec_addra1),
        .o_polyvec_dina1  (tb_polyvec_dina1),
        .o_polyvec_addrb1 (tb_polyvec_addrb1),
        .i_polyvec_doutb1 (tb_polyvec_doutb1),

        .o_polyvec_wea2   (tb_polyvec_wea2),
        .o_polyvec_addra2 (tb_polyvec_addra2),
        .o_polyvec_dina2  (tb_polyvec_dina2),
        .o_polyvec_addrb2 (tb_polyvec_addrb2),
        .i_polyvec_doutb2 (tb_polyvec_doutb2),

        .tppWrEnPacked       (tppWrEnPacked   ), // output [23:0]
        .tppWrAddrPacked     (tppWrAddrPacked ), // output [215:0]
        .tppWrDataPacked     (tppWrDataPacked ), // output [839:0]
        .tppRdAddrPacked     (tppRdAddrPacked ), // output [215:0]
        .tppRdDataPacked     (tppRdDataPacked ),  //  input [839:0]

        // ---------------- Polyvec RAM ports ----------------
        .o_poly_wea(o_poly_wea),
        .o_poly_addra(o_poly_addra),
        .o_poly_dina(o_poly_dina),
        .o_poly_addrb(o_poly_addrb),
        .i_poly_doutb(i_poly_doutb),

        // ---- NEW: pass-through packed INTT buses ----
        .io_inttWrEnPacked   (io_inttWrEnPacked),
        .io_inttWrAddrPacked (io_inttWrAddrPacked),
        .io_inttWrDataPacked (io_inttWrDataPacked),
        .io_inttRdAddrPacked (io_inttRdAddrPacked),
        .io_inttRdDataPacked (io_inttRdDataPacked)

    );

    // -------------------------------------------------------------------
    // TB instantiation of the externalized polyvec banks
    // Uses TB_* params and the per-bank wires you already declared.
    // -------------------------------------------------------------------
    localparam int TB_Q_TYPE             = 0;
    localparam int TB_COMMON_BRAM_DELAY  = 1;   // match DUT if needed

    wire    [TB_NUM_POLY *2 * 3 * TB_NUM_BASE_BANK-1:0]             axi_dp_we_w;
    wire    [TB_NUM_POLY * 2 * TB_NUM_BASE_BANK-1:0]        axi_dp_we_2_w;
    wire    [TB_NUM_BASE_BANK * TB_ADDR_WIDTH-1:0]     axi_dp_waddr_w; 
    wire    [TB_NUM_BASE_BANK * TB_COE_WIDTH-1:0]      axi_dp_wdata_w; 

    assign axi_dp_we_2_w =
    { axi_dp_we_w[45], axi_dp_we_w[39], axi_dp_we_w[33], axi_dp_we_w[27], axi_dp_we_w[21],axi_dp_we_w[15],axi_dp_we_w[9],axi_dp_we_w[3],
        axi_dp_we_w[42], axi_dp_we_w[36], axi_dp_we_w[30], axi_dp_we_w[24], axi_dp_we_w[18],axi_dp_we_w[12],axi_dp_we_w[6],axi_dp_we_w[0]};

    // polyvec_0
    polyvec_ram #(
    .COE_WIDTH         (TB_COE_WIDTH),
    .Q_TYPE            (TB_Q_TYPE),
    .ADDR_WIDTH        (TB_ADDR_WIDTH),
    .NUM_POLY          (TB_NUM_POLY),
    .NUM_BASE_BANK     (TB_NUM_BASE_BANK),
    .COMMON_BRAM_DELAY (TB_COMMON_BRAM_DELAY)
    ) tb_polyvec_0 (
    .clk   (clk),
    .wea   ((dp_tpp_mode == 2'd0) ? axi_dp_we_2_w    : tb_polyvec_wea0),
    .addra ((dp_tpp_mode == 2'd0) ? axi_dp_waddr_w : tb_polyvec_addra0),
    .dina  ((dp_tpp_mode == 2'd0) ? axi_dp_wdata_w : tb_polyvec_dina0),
    .addrb (tb_polyvec_addrb0),
    .doutb (tb_polyvec_doutb0)
    );

    // polyvec_1
    polyvec_ram #(
    .COE_WIDTH         (TB_COE_WIDTH),
    .Q_TYPE            (TB_Q_TYPE),
    .ADDR_WIDTH        (TB_ADDR_WIDTH),
    .NUM_POLY          (TB_NUM_POLY),
    .NUM_BASE_BANK     (TB_NUM_BASE_BANK),
    .COMMON_BRAM_DELAY (TB_COMMON_BRAM_DELAY)
    ) tb_polyvec_1 (
    .clk   (clk),
    .wea   ((dp_tpp_mode == 2'd2) ? axi_dp_we_2_w    : tb_polyvec_wea1),
    .addra ((dp_tpp_mode == 2'd2) ? axi_dp_waddr_w : tb_polyvec_addra1),
    .dina  ((dp_tpp_mode == 2'd2) ? axi_dp_wdata_w : tb_polyvec_dina1),
    .addrb (tb_polyvec_addrb1),
    .doutb (tb_polyvec_doutb1)
    );

    // polyvec_2
    polyvec_ram #(
    .COE_WIDTH         (TB_COE_WIDTH),
    .Q_TYPE            (TB_Q_TYPE),
    .ADDR_WIDTH        (TB_ADDR_WIDTH),
    .NUM_POLY          (TB_NUM_POLY),
    .NUM_BASE_BANK     (TB_NUM_BASE_BANK),
    .COMMON_BRAM_DELAY (TB_COMMON_BRAM_DELAY)
    ) tb_polyvec_2 (
    .clk   (clk),
    .wea   ((dp_tpp_mode == 2'd1) ? axi_dp_we_2_w    : tb_polyvec_wea2),
    .addra ((dp_tpp_mode == 2'd1) ? axi_dp_waddr_w : tb_polyvec_addra2),
    .dina  ((dp_tpp_mode == 2'd1) ? axi_dp_wdata_w : tb_polyvec_dina2),
    .addrb (tb_polyvec_addrb2),
    .doutb (tb_polyvec_doutb2)
    );


    // ---------------- Polyvec 0 banks ----------------
    poly_ram_35_9_8 tppBank_0 (
    .clock        (clk),

    .io_wr_en_0   (tppWrEnPacked   [(0*PV_NBANK)+0]),
    .io_wr_en_1   (tppWrEnPacked   [(0*PV_NBANK)+1]),
    .io_wr_en_2   (tppWrEnPacked   [(0*PV_NBANK)+2]),
    .io_wr_en_3   (tppWrEnPacked   [(0*PV_NBANK)+3]),
    .io_wr_en_4   (tppWrEnPacked   [(0*PV_NBANK)+4]),
    .io_wr_en_5   (tppWrEnPacked   [(0*PV_NBANK)+5]),
    .io_wr_en_6   (tppWrEnPacked   [(0*PV_NBANK)+6]),
    .io_wr_en_7   (tppWrEnPacked   [(0*PV_NBANK)+7]),

    .io_wr_addr_0 (tppWrAddrPacked [(((0*PV_NBANK)+0)*PV_AW) +: PV_AW]),
    .io_wr_addr_1 (tppWrAddrPacked [(((0*PV_NBANK)+1)*PV_AW) +: PV_AW]),
    .io_wr_addr_2 (tppWrAddrPacked [(((0*PV_NBANK)+2)*PV_AW) +: PV_AW]),
    .io_wr_addr_3 (tppWrAddrPacked [(((0*PV_NBANK)+3)*PV_AW) +: PV_AW]),
    .io_wr_addr_4 (tppWrAddrPacked [(((0*PV_NBANK)+4)*PV_AW) +: PV_AW]),
    .io_wr_addr_5 (tppWrAddrPacked [(((0*PV_NBANK)+5)*PV_AW) +: PV_AW]),
    .io_wr_addr_6 (tppWrAddrPacked [(((0*PV_NBANK)+6)*PV_AW) +: PV_AW]),
    .io_wr_addr_7 (tppWrAddrPacked [(((0*PV_NBANK)+7)*PV_AW) +: PV_AW]),

    .io_wr_data_0 (tppWrDataPacked [(((0*PV_NBANK)+0)*PV_DW) +: PV_DW]),
    .io_wr_data_1 (tppWrDataPacked [(((0*PV_NBANK)+1)*PV_DW) +: PV_DW]),
    .io_wr_data_2 (tppWrDataPacked [(((0*PV_NBANK)+2)*PV_DW) +: PV_DW]),
    .io_wr_data_3 (tppWrDataPacked [(((0*PV_NBANK)+3)*PV_DW) +: PV_DW]),
    .io_wr_data_4 (tppWrDataPacked [(((0*PV_NBANK)+4)*PV_DW) +: PV_DW]),
    .io_wr_data_5 (tppWrDataPacked [(((0*PV_NBANK)+5)*PV_DW) +: PV_DW]),
    .io_wr_data_6 (tppWrDataPacked [(((0*PV_NBANK)+6)*PV_DW) +: PV_DW]),
    .io_wr_data_7 (tppWrDataPacked [(((0*PV_NBANK)+7)*PV_DW) +: PV_DW]),

    .io_rd_addr_0 (tppRdAddrPacked [(((0*PV_NBANK)+0)*PV_AW) +: PV_AW]),
    .io_rd_addr_1 (tppRdAddrPacked [(((0*PV_NBANK)+1)*PV_AW) +: PV_AW]),
    .io_rd_addr_2 (tppRdAddrPacked [(((0*PV_NBANK)+2)*PV_AW) +: PV_AW]),
    .io_rd_addr_3 (tppRdAddrPacked [(((0*PV_NBANK)+3)*PV_AW) +: PV_AW]),
    .io_rd_addr_4 (tppRdAddrPacked [(((0*PV_NBANK)+4)*PV_AW) +: PV_AW]),
    .io_rd_addr_5 (tppRdAddrPacked [(((0*PV_NBANK)+5)*PV_AW) +: PV_AW]),
    .io_rd_addr_6 (tppRdAddrPacked [(((0*PV_NBANK)+6)*PV_AW) +: PV_AW]),
    .io_rd_addr_7 (tppRdAddrPacked [(((0*PV_NBANK)+7)*PV_AW) +: PV_AW]),

    .io_rd_data_0 (tppRdDataPacked [(((0*PV_NBANK)+0)*PV_DW) +: PV_DW]),
    .io_rd_data_1 (tppRdDataPacked [(((0*PV_NBANK)+1)*PV_DW) +: PV_DW]),
    .io_rd_data_2 (tppRdDataPacked [(((0*PV_NBANK)+2)*PV_DW) +: PV_DW]),
    .io_rd_data_3 (tppRdDataPacked [(((0*PV_NBANK)+3)*PV_DW) +: PV_DW]),
    .io_rd_data_4 (tppRdDataPacked [(((0*PV_NBANK)+4)*PV_DW) +: PV_DW]),
    .io_rd_data_5 (tppRdDataPacked [(((0*PV_NBANK)+5)*PV_DW) +: PV_DW]),
    .io_rd_data_6 (tppRdDataPacked [(((0*PV_NBANK)+6)*PV_DW) +: PV_DW]),
    .io_rd_data_7 (tppRdDataPacked [(((0*PV_NBANK)+7)*PV_DW) +: PV_DW])
    );

    // ---------------- Polyvec 1 banks ----------------
    poly_ram_35_9_8 tppBank_1 (
    .clock        (clk),

    .io_wr_en_0   (tppWrEnPacked   [(1*PV_NBANK)+0]),
    .io_wr_en_1   (tppWrEnPacked   [(1*PV_NBANK)+1]),
    .io_wr_en_2   (tppWrEnPacked   [(1*PV_NBANK)+2]),
    .io_wr_en_3   (tppWrEnPacked   [(1*PV_NBANK)+3]),
    .io_wr_en_4   (tppWrEnPacked   [(1*PV_NBANK)+4]),
    .io_wr_en_5   (tppWrEnPacked   [(1*PV_NBANK)+5]),
    .io_wr_en_6   (tppWrEnPacked   [(1*PV_NBANK)+6]),
    .io_wr_en_7   (tppWrEnPacked   [(1*PV_NBANK)+7]),

    .io_wr_addr_0 (tppWrAddrPacked [(((1*PV_NBANK)+0)*PV_AW) +: PV_AW]),
    .io_wr_addr_1 (tppWrAddrPacked [(((1*PV_NBANK)+1)*PV_AW) +: PV_AW]),
    .io_wr_addr_2 (tppWrAddrPacked [(((1*PV_NBANK)+2)*PV_AW) +: PV_AW]),
    .io_wr_addr_3 (tppWrAddrPacked [(((1*PV_NBANK)+3)*PV_AW) +: PV_AW]),
    .io_wr_addr_4 (tppWrAddrPacked [(((1*PV_NBANK)+4)*PV_AW) +: PV_AW]),
    .io_wr_addr_5 (tppWrAddrPacked [(((1*PV_NBANK)+5)*PV_AW) +: PV_AW]),
    .io_wr_addr_6 (tppWrAddrPacked [(((1*PV_NBANK)+6)*PV_AW) +: PV_AW]),
    .io_wr_addr_7 (tppWrAddrPacked [(((1*PV_NBANK)+7)*PV_AW) +: PV_AW]),

    .io_wr_data_0 (tppWrDataPacked [(((1*PV_NBANK)+0)*PV_DW) +: PV_DW]),
    .io_wr_data_1 (tppWrDataPacked [(((1*PV_NBANK)+1)*PV_DW) +: PV_DW]),
    .io_wr_data_2 (tppWrDataPacked [(((1*PV_NBANK)+2)*PV_DW) +: PV_DW]),
    .io_wr_data_3 (tppWrDataPacked [(((1*PV_NBANK)+3)*PV_DW) +: PV_DW]),
    .io_wr_data_4 (tppWrDataPacked [(((1*PV_NBANK)+4)*PV_DW) +: PV_DW]),
    .io_wr_data_5 (tppWrDataPacked [(((1*PV_NBANK)+5)*PV_DW) +: PV_DW]),
    .io_wr_data_6 (tppWrDataPacked [(((1*PV_NBANK)+6)*PV_DW) +: PV_DW]),
    .io_wr_data_7 (tppWrDataPacked [(((1*PV_NBANK)+7)*PV_DW) +: PV_DW]),

    .io_rd_addr_0 (tppRdAddrPacked [(((1*PV_NBANK)+0)*PV_AW) +: PV_AW]),
    .io_rd_addr_1 (tppRdAddrPacked [(((1*PV_NBANK)+1)*PV_AW) +: PV_AW]),
    .io_rd_addr_2 (tppRdAddrPacked [(((1*PV_NBANK)+2)*PV_AW) +: PV_AW]),
    .io_rd_addr_3 (tppRdAddrPacked [(((1*PV_NBANK)+3)*PV_AW) +: PV_AW]),
    .io_rd_addr_4 (tppRdAddrPacked [(((1*PV_NBANK)+4)*PV_AW) +: PV_AW]),
    .io_rd_addr_5 (tppRdAddrPacked [(((1*PV_NBANK)+5)*PV_AW) +: PV_AW]),
    .io_rd_addr_6 (tppRdAddrPacked [(((1*PV_NBANK)+6)*PV_AW) +: PV_AW]),
    .io_rd_addr_7 (tppRdAddrPacked [(((1*PV_NBANK)+7)*PV_AW) +: PV_AW]),

    .io_rd_data_0 (tppRdDataPacked [(((1*PV_NBANK)+0)*PV_DW) +: PV_DW]),
    .io_rd_data_1 (tppRdDataPacked [(((1*PV_NBANK)+1)*PV_DW) +: PV_DW]),
    .io_rd_data_2 (tppRdDataPacked [(((1*PV_NBANK)+2)*PV_DW) +: PV_DW]),
    .io_rd_data_3 (tppRdDataPacked [(((1*PV_NBANK)+3)*PV_DW) +: PV_DW]),
    .io_rd_data_4 (tppRdDataPacked [(((1*PV_NBANK)+4)*PV_DW) +: PV_DW]),
    .io_rd_data_5 (tppRdDataPacked [(((1*PV_NBANK)+5)*PV_DW) +: PV_DW]),
    .io_rd_data_6 (tppRdDataPacked [(((1*PV_NBANK)+6)*PV_DW) +: PV_DW]),
    .io_rd_data_7 (tppRdDataPacked [(((1*PV_NBANK)+7)*PV_DW) +: PV_DW])
    );

    // ---------------- Polyvec 2 banks ----------------
    poly_ram_35_9_8 tppBank_2 (
    .clock        (clk),

    .io_wr_en_0   (tppWrEnPacked   [(2*PV_NBANK)+0]),
    .io_wr_en_1   (tppWrEnPacked   [(2*PV_NBANK)+1]),
    .io_wr_en_2   (tppWrEnPacked   [(2*PV_NBANK)+2]),
    .io_wr_en_3   (tppWrEnPacked   [(2*PV_NBANK)+3]),
    .io_wr_en_4   (tppWrEnPacked   [(2*PV_NBANK)+4]),
    .io_wr_en_5   (tppWrEnPacked   [(2*PV_NBANK)+5]),
    .io_wr_en_6   (tppWrEnPacked   [(2*PV_NBANK)+6]),
    .io_wr_en_7   (tppWrEnPacked   [(2*PV_NBANK)+7]),

    .io_wr_addr_0 (tppWrAddrPacked [(((2*PV_NBANK)+0)*PV_AW) +: PV_AW]),
    .io_wr_addr_1 (tppWrAddrPacked [(((2*PV_NBANK)+1)*PV_AW) +: PV_AW]),
    .io_wr_addr_2 (tppWrAddrPacked [(((2*PV_NBANK)+2)*PV_AW) +: PV_AW]),
    .io_wr_addr_3 (tppWrAddrPacked [(((2*PV_NBANK)+3)*PV_AW) +: PV_AW]),
    .io_wr_addr_4 (tppWrAddrPacked [(((2*PV_NBANK)+4)*PV_AW) +: PV_AW]),
    .io_wr_addr_5 (tppWrAddrPacked [(((2*PV_NBANK)+5)*PV_AW) +: PV_AW]),
    .io_wr_addr_6 (tppWrAddrPacked [(((2*PV_NBANK)+6)*PV_AW) +: PV_AW]),
    .io_wr_addr_7 (tppWrAddrPacked [(((2*PV_NBANK)+7)*PV_AW) +: PV_AW]),

    .io_wr_data_0 (tppWrDataPacked [(((2*PV_NBANK)+0)*PV_DW) +: PV_DW]),
    .io_wr_data_1 (tppWrDataPacked [(((2*PV_NBANK)+1)*PV_DW) +: PV_DW]),
    .io_wr_data_2 (tppWrDataPacked [(((2*PV_NBANK)+2)*PV_DW) +: PV_DW]),
    .io_wr_data_3 (tppWrDataPacked [(((2*PV_NBANK)+3)*PV_DW) +: PV_DW]),
    .io_wr_data_4 (tppWrDataPacked [(((2*PV_NBANK)+4)*PV_DW) +: PV_DW]),
    .io_wr_data_5 (tppWrDataPacked [(((2*PV_NBANK)+5)*PV_DW) +: PV_DW]),
    .io_wr_data_6 (tppWrDataPacked [(((2*PV_NBANK)+6)*PV_DW) +: PV_DW]),
    .io_wr_data_7 (tppWrDataPacked [(((2*PV_NBANK)+7)*PV_DW) +: PV_DW]),

    .io_rd_addr_0 (tppRdAddrPacked [(((2*PV_NBANK)+0)*PV_AW) +: PV_AW]),
    .io_rd_addr_1 (tppRdAddrPacked [(((2*PV_NBANK)+1)*PV_AW) +: PV_AW]),
    .io_rd_addr_2 (tppRdAddrPacked [(((2*PV_NBANK)+2)*PV_AW) +: PV_AW]),
    .io_rd_addr_3 (tppRdAddrPacked [(((2*PV_NBANK)+3)*PV_AW) +: PV_AW]),
    .io_rd_addr_4 (tppRdAddrPacked [(((2*PV_NBANK)+4)*PV_AW) +: PV_AW]),
    .io_rd_addr_5 (tppRdAddrPacked [(((2*PV_NBANK)+5)*PV_AW) +: PV_AW]),
    .io_rd_addr_6 (tppRdAddrPacked [(((2*PV_NBANK)+6)*PV_AW) +: PV_AW]),
    .io_rd_addr_7 (tppRdAddrPacked [(((2*PV_NBANK)+7)*PV_AW) +: PV_AW]),

    .io_rd_data_0 (tppRdDataPacked [(((2*PV_NBANK)+0)*PV_DW) +: PV_DW]),
    .io_rd_data_1 (tppRdDataPacked [(((2*PV_NBANK)+1)*PV_DW) +: PV_DW]),
    .io_rd_data_2 (tppRdDataPacked [(((2*PV_NBANK)+2)*PV_DW) +: PV_DW]),
    .io_rd_data_3 (tppRdDataPacked [(((2*PV_NBANK)+3)*PV_DW) +: PV_DW]),
    .io_rd_data_4 (tppRdDataPacked [(((2*PV_NBANK)+4)*PV_DW) +: PV_DW]),
    .io_rd_data_5 (tppRdDataPacked [(((2*PV_NBANK)+5)*PV_DW) +: PV_DW]),
    .io_rd_data_6 (tppRdDataPacked [(((2*PV_NBANK)+6)*PV_DW) +: PV_DW]),
    .io_rd_data_7 (tppRdDataPacked [(((2*PV_NBANK)+7)*PV_DW) +: PV_DW])
    );

    /* NTT exclusive buffer */
    polyvec_ram#(
        .COE_WIDTH(39),
        .Q_TYPE(TB_Q_TYPE),
        .ADDR_WIDTH(TB_ADDR_WIDTH),                    // Depth of ram is 1<<ADDR_WIDTH
        .NUM_POLY(TB_NUM_POLY),                        // number of polys in one polyvec
        .NUM_BASE_BANK(TB_NUM_BASE_BANK),              // number of banks for one poly
        .COMMON_BRAM_DELAY(TB_COMMON_BRAM_DELAY)
    )
    polyvec_ntt(
        .clk(clk),
        .wea(o_poly_wea),
        .addra(o_poly_addra),
        .dina(o_poly_dina),
        .addrb(o_poly_addrb),
        .doutb(i_poly_doutb)
    );

    /* INTT exclusive buffer */
    // Capture RAM read data per lane to re-pack upward
    wire [34:0] intt_rd_data_0;
    wire [34:0] intt_rd_data_1;
    wire [34:0] intt_rd_data_2;
    wire [34:0] intt_rd_data_3;
    wire [34:0] intt_rd_data_4;
    wire [34:0] intt_rd_data_5;
    wire [34:0] intt_rd_data_6;
    wire [34:0] intt_rd_data_7;

    poly_ram_35_9_8 u_intt_buf_0 (
    .clock           (clk),

    // ---- WR.EN (1b each) ----
    .io_wr_en_0      (io_inttWrEnPacked[0]),
    .io_wr_en_1      (io_inttWrEnPacked[1]),
    .io_wr_en_2      (io_inttWrEnPacked[2]),
    .io_wr_en_3      (io_inttWrEnPacked[3]),
    .io_wr_en_4      (io_inttWrEnPacked[4]),
    .io_wr_en_5      (io_inttWrEnPacked[5]),
    .io_wr_en_6      (io_inttWrEnPacked[6]),
    .io_wr_en_7      (io_inttWrEnPacked[7]),

    // ---- WR.ADDR (9b each) ----
    .io_wr_addr_0    (io_inttWrAddrPacked[  0*9 +: 9]),
    .io_wr_addr_1    (io_inttWrAddrPacked[  1*9 +: 9]),
    .io_wr_addr_2    (io_inttWrAddrPacked[  2*9 +: 9]),
    .io_wr_addr_3    (io_inttWrAddrPacked[  3*9 +: 9]),
    .io_wr_addr_4    (io_inttWrAddrPacked[  4*9 +: 9]),
    .io_wr_addr_5    (io_inttWrAddrPacked[  5*9 +: 9]),
    .io_wr_addr_6    (io_inttWrAddrPacked[  6*9 +: 9]),
    .io_wr_addr_7    (io_inttWrAddrPacked[  7*9 +: 9]),

    // ---- WR.DATA (35b each) ----
    .io_wr_data_0    (io_inttWrDataPacked[  0*35 +: 35]),
    .io_wr_data_1    (io_inttWrDataPacked[  1*35 +: 35]),
    .io_wr_data_2    (io_inttWrDataPacked[  2*35 +: 35]),
    .io_wr_data_3    (io_inttWrDataPacked[  3*35 +: 35]),
    .io_wr_data_4    (io_inttWrDataPacked[  4*35 +: 35]),
    .io_wr_data_5    (io_inttWrDataPacked[  5*35 +: 35]),
    .io_wr_data_6    (io_inttWrDataPacked[  6*35 +: 35]),
    .io_wr_data_7    (io_inttWrDataPacked[  7*35 +: 35]),

    // ---- RD.ADDR (9b each) ----
    .io_rd_addr_0    (io_inttRdAddrPacked[  0*9 +: 9]),
    .io_rd_addr_1    (io_inttRdAddrPacked[  1*9 +: 9]),
    .io_rd_addr_2    (io_inttRdAddrPacked[  2*9 +: 9]),
    .io_rd_addr_3    (io_inttRdAddrPacked[  3*9 +: 9]),
    .io_rd_addr_4    (io_inttRdAddrPacked[  4*9 +: 9]),
    .io_rd_addr_5    (io_inttRdAddrPacked[  5*9 +: 9]),
    .io_rd_addr_6    (io_inttRdAddrPacked[  6*9 +: 9]),
    .io_rd_addr_7    (io_inttRdAddrPacked[  7*9 +: 9]),

    // ---- RD.DATA (35b each) ----
    .io_rd_data_0    (intt_rd_data_0),
    .io_rd_data_1    (intt_rd_data_1),
    .io_rd_data_2    (intt_rd_data_2),
    .io_rd_data_3    (intt_rd_data_3),
    .io_rd_data_4    (intt_rd_data_4),
    .io_rd_data_5    (intt_rd_data_5),
    .io_rd_data_6    (intt_rd_data_6),
    .io_rd_data_7    (intt_rd_data_7)
    );

    // Re-pack RAM RD.DATA up to the DUT
    assign io_inttRdDataPacked = {
    intt_rd_data_7,
    intt_rd_data_6,
    intt_rd_data_5,
    intt_rd_data_4,
    intt_rd_data_3,
    intt_rd_data_2,
    intt_rd_data_1,
    intt_rd_data_0
    };


    assign interrupt = csr_ap_done[0];  // TODO
    
    /*
    // KSK URAM module for stg_0_0 ksk write result check 
    wire                    wea   [0:11];
    wire [12:0]             addra [0:11];
    wire [8*COE_WIDTH-1:0]  dina  [0:11];

    genvar kk;
    generate 
        for (kk = 0; kk < 12; kk = kk + 1) begin : gen_ksk_model

            assign wea[kk]   = `KSK_RAM.gen_ksk_uram[kk].wren;
            assign addra[kk] = `KSK_RAM.gen_ksk_uram[kk].wraddr;
            assign dina[kk]  = `KSK_RAM.gen_ksk_uram[kk].wrdata;

            ram_model #(
                .COE_WIDTH         (8*COE_WIDTH),        
                .ADDR_WIDTH        (13),        
                .N_BANK            (1) 
            )
            i_ksk_uram_model (
                .clk(clk),      
                .doutb(),   
                .addra(addra[kk]),
                .addrb(),
                .dina(dina[kk]),               
                .wea(wea[kk]) 
            );
        end
    endgenerate
    */
    parameter AXI_XFER_WIDTH    = 32;
    parameter COMMON_URAM_DELAY = 4;
    reg     [AXI_XFER_WIDTH-1:0]    mat_size_bytes_r;
    wire    [AXI_XFER_WIDTH-1:0]    mat_size_bytes_w;
    reg     [AXI_XFER_WIDTH-1:0]    vec_size_bytes_r;
    wire    [AXI_XFER_WIDTH-1:0]    vec_size_bytes_w;
    wire    [            15-1:0]    data_size_batches;
    
    assign mat_size_bytes_w = mat_size_bytes_r; //for 200M; break the critical path
    assign vec_size_bytes_w = vec_size_bytes_r; //for 250M; break the critical path
    assign data_size_batches = csr_mat_len[14:1] + csr_split[2:0];

    always@(posedge clk or negedge rst_n)
        if(!rst_n)
            mat_size_bytes_r <= 'b0;
        else
            mat_size_bytes_r <= 20'h18000 * csr_mat_len;

    always@(posedge clk or negedge rst_n)
        if(!rst_n)
            vec_size_bytes_r <= 'b0;
        else
            vec_size_bytes_r <= 20'h30000 * csr_split[2:0];

    axi_data_rd_top #(
        .AXI_ADDR_WIDTH         ( C_DATA_AXI_ADDR_WIDTH    ),
        .AXI_DATA_WIDTH         ( C_DATA_AXI_DATA_WIDTH_MVP    ),
        .AXI_XFER_SIZE_WIDTH    ( AXI_XFER_WIDTH    ),
        .INCLUDE_DATA_FIFO      ( 0 ),
        //.KSK_DATA_WIDTH       ( COE_WIDTH_L       ),
        .PRE_DATA_WIDTH         ( TB_COE_WIDTH       ),
        .RAM_DELAY              ( COMMON_URAM_DELAY )
    )
    u_axi_data_rd_top(
        .clk                    ( clk               ),
        .rst_n                  ( rst_n             ),
        // AXI read
        .mvp_axi_arvalid        ( data_axi_arvalid  ),
        .mvp_axi_arready        ( data_axi_arready  ),
        .mvp_axi_araddr         ( data_axi_araddr   ),
        .mvp_axi_arlen          ( data_axi_arlen    ),
        .mvp_axi_rvalid         ( data_axi_rvalid   ),
        .mvp_axi_rready         ( data_axi_rready   ),
        .mvp_axi_rdata          ( data_axi_rdata    ),
        .mvp_axi_rlast          ( data_axi_rlast    ),
        // control
        .i_axird_command        ( csr_command           ),
        .i_axird_initstart      ( o_mvp_start_w       ),
        .i_axird_start          ( o_start_w[0]        ),
        .o_axird_done           ( axird_done        ),
        .o_axird_alldone        ( axi_alldone_w     ),
        //.ksk_ptr                ( ksk_ptr           ),
        .mat_ptr                ( csr_mat_ptr           ),
        .vec_ptr                ( csr_vec_ptr           ),
        .mat_size_bytes         ( mat_size_bytes_w  ),
        .vec_size_bytes         ( vec_size_bytes_w  ),
        //.ksk_size_bytes         ( ksk_size_bytes    ),
        .data_size_batches      ( data_size_batches ),
        // KSK
        //.i_axird_ksk_stage      ( level_s7_w        ),
        //.i_axird_ksk_rdaddr     ( ksk_raddr_w       ),
        //.o_axird_ksk_rddata     ( ksk_rdata_w       ),
        // Preprocess
        .o_axird_pre_wren       ( axi_dp_we_w       ),
        .o_axird_pre_wraddr     ( axi_dp_waddr_w    ),
        .o_axird_pre_wrdata     ( axi_dp_wdata_w    )
    );

    wire                    rslt_wea  ;
    wire [10:0]             rslt_addra;
    wire [511:0]            rslt_dina ;

    assign rslt_wea   = i_ddr_mem.i_ddr_mem_bank_512b.base_bank.wea;
    assign rslt_addra = i_ddr_mem.i_ddr_mem_bank_512b.base_bank.addra[10:0] - (RSLT_START_LINE & {11{1'b1}});
    assign rslt_dina  = i_ddr_mem.i_ddr_mem_bank_512b.base_bank.dina;

    ram_model #(
        .COE_WIDTH         (512),
        .ADDR_WIDTH        (11),
        .N_BANK            (1) 
    )
    i_rslt_mem_model (
        .clk(clk),
        .doutb(),
        .addra(rslt_addra),
        .addrb(),
        .dina(rslt_dina),
        .wea(rslt_wea) 
    );

    assign stage_done = {
        1'd1,   // stg10
        5'b11111,          // stg5-9
        1'd1,
        `PP0.io_o_intt_done,    // stg3
        `DP.o_madd_done,        // stg2
        `DP.o_ntt_done,         // stg1
        axird_done    // stg0
    };
    assign stage_status = (PARTIAL_TEST == 1) ? ((DEBUG_SINGLE_STAGE == 1) ? stage_status_single_stage : stage_status_partial_test) : `CNTL.mvp_status_r;
    assign level_minus_one_partial_test = level_partial_test - 1'b1;

    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            stage_10_done_delay <= 1'b0;
        else 
            stage_10_done_delay <= stage_done[N_STAGE-1];
    end
    assign stage_10_done_pulse = stage_done[N_STAGE-1] && (!stage_10_done_delay);

    if(PARTIAL_TEST) begin
        initial begin
            force o_mvp_start_w = stage_start_partial_test[0];
            force o_start_w[0]     = stage_start_partial_test[0];
            force `AXI_WR.i_axiwr_start     = stage_start_partial_test[10];
            force `DP.i_ntt_start           = stage_start_partial_test[1];
            force `DP.i_madd_start          = stage_start_partial_test[2];
            force `PP0.io_i_intt_start      = stage_start_partial_test[3];
            force `PP0.io_i_vpu4_start      = stage_start_partial_test[4];
            force `RT.i_start_x5            = stage_start_partial_test[9:5];
            force `DP.i_mode                = 2'b10;
            force `PP0.io_i_coeff_index     = index_partial_test;
            force `RT.i_level_x5            = level_partial_test_x5;
            force `RT.i_switch_mode         = switch_mode;
            force `RT.i_stall               = 1'b0;
            force `RT.i_is_trace            = 1'b0;
            force `KSK_RAM.i_ksk_rd_stage   = level_minus_one_partial_test;
            assert(`PP0.io_i_intt_start == `PP1.io_i_intt_start);
            assert(`PP0.io_i_vpu4_start == `PP1.io_i_vpu4_start);
            assert(`PP0.io_i_coeff_index == `PP1.io_i_coeff_index);
        end

        assign rt_buffer_wr_index = 0;
        assign is_stall = 0;
        assign is_trace = 0;

        always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n) begin
                stage_start_d1 <= 'b0;
                stage_start_d2 <= 'b0;
                stage_start_d3 <= 'b0;
                stage_start_d4 <= 'b0;
                stage_start_d5 <= 'b0;
                stage_start_d6 <= 'b0;
                stage_start_d7 <= 'b0;
            end
            else begin
                stage_start_d1 <= stage_start_partial_test;
                stage_start_d2 <= stage_start_d1;
                stage_start_d3 <= stage_start_d2;
                stage_start_d4 <= stage_start_d3;
                stage_start_d5 <= stage_start_d4;
                stage_start_d6 <= stage_start_d5;
                stage_start_d7 <= stage_start_d6;
            end
        end

        assign test_data_dir = {RUN_DIR, "../tv/basic/"};

        if (DEBUG_SINGLE_STAGE) begin
            assign level_partial_test_x5 = {5{level_partial_test}};
            always_ff @ (posedge clk or negedge rst_n) begin
                if(!rst_n)
                    stage_start_partial_test <= 1'b0;
                else
                    stage_start_partial_test <= stage_start_partial_test_pre;
            end
        end

        else begin
            assign stage_status_partial_test = ctrl.status_r;

            control_tb #(
                .LEVEL_WIDTH(LEVEL_WIDTH),
                .N_STAGE(N_STAGE)
            ) ctrl (
                .clk(clk),
                .rst_n(rst_n),
                .i_init(init),
                .o_start(stage_start_partial_test),
                .i_done(stage_done),
                .o_switch_mode(switch_mode),
                .i_level(level_partial_test),
                .o_level_x5(level_partial_test_x5),
                .*
            );

            assign in_a_row_done = stage_status_partial_test[N_STAGE-1] & stage_done[N_STAGE-1];
        end

    end
    else begin

        assign is_stall           = `CNTL.stall_r;
        assign is_trace           = `CNTL.reduce_trace_r;
        assign rt_buffer_wr_index = `CNTL.o_uram_index;

        always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n) begin
                stage_start_d1 <= 'b0;
                stage_start_d2 <= 'b0;
                stage_start_d3 <= 'b0;
                stage_start_d4 <= 'b0;
                stage_start_d5 <= 'b0;
                stage_start_d6 <= 'b0;
                stage_start_d7 <= 'b0;
            end
            else begin

                stage_start_d1 <= {/*`AXI_WR.i_axiwr_start, `RT.i_start_x5, `PP0.io_i_vpu4_start,*/ 1'd0, 5'd0, 1'd0,
                    `PP0.io_i_intt_start, `DP.i_madd_start, `DP.i_ntt_start, o_mvp_start_w};
                stage_start_d2 <= stage_start_d1;
                stage_start_d3 <= stage_start_d2;
                stage_start_d4 <= stage_start_d3;
                stage_start_d5 <= stage_start_d4;
                stage_start_d6 <= stage_start_d5;
                stage_start_d7 <= stage_start_d6;
            end
        end

        assign done_pulse = (&stage_done[N_STAGE-1:0]) && (!done_delay) && stage0_mode;

        always_ff@(posedge clk or negedge rst_n) begin
            if(~rst_n)
            begin
                done_delay    <= 0;
                done_pulse_d1 <= 0;
                done_pulse_d2 <= 0;
                done_pulse_d3 <= 0;
                done_pulse_d4 <= 0;
                done_pulse_d5 <= 0;
            end
            else
            begin
                done_delay    <= &stage_done[N_STAGE-1:0];
                done_pulse_d1 <= done_pulse;
                done_pulse_d2 <= done_pulse_d1;
                done_pulse_d3 <= done_pulse_d2;
                done_pulse_d4 <= done_pulse_d3;
                done_pulse_d5 <= done_pulse_d4;
            end
        end
        
        always_ff@(posedge clk or negedge rst_n) begin
            if(~rst_n)
                ts_full <= 0;
            else if(done_pulse_d5)
                ts_full <= ts_full + 1;
        end

        always_comb begin
            ts_str.itoa(ts_full - 1);
            timeslot = $sformatf("%04d", ts_full - 1);
        end

        assign ts            = ts_full - 1;
        assign test_size     = "4x4096";
        assign cmod_data_dir = {RUN_DIR, "../tv/", test_size, "/"};
        assign test_data_dir = {cmod_data_dir, "t", timeslot, "/"};
    end


    /*******************************************************************************/
    /******************************* Test Flow Generation **************************/
    /*******************************************************************************/
    initial begin

        if($value$plusargs("TESTNAME=%s", testname)) begin
            $display("Running test {%0s}......\n", testname);
        end
        else begin
            $display("ERROR! Test {%0s} does not exist!\n", testname);
            $finish;
        end

        stage0_mode = 1;

        rst_n = 1'b1;
        wait_some_cycles();
        rst_n = 1'b0;
        wait_some_cycles();
        rst_n = 1'b1;
        wait_some_cycles();
        wait_some_cycles();

        `include "testcase.sv"

        wait_some_cycles();

        $display("Simulation Done!");
        $finish;
    end

    initial begin
        #(`PERIOD*1000000) $display("Simulation Timeout!");
        $finish;
    end


    /*******************************************************************************/
    /************************ Waveform Setup in Testbench **************************/
    /*******************************************************************************/
    initial begin
        // $fsdbAutoSwitchDumpfile(1000, "waveform.fsdb", 50);
        // $fsdbDumpvars(0,tb_top,"+mda");
    end

    /*******************************************************************************/
    /************************ Monitors for RAM init and check **********************/
    /*******************************************************************************/
    `include "monitor.sv"

    /*******************************************************************************/
    /********************** Task Definition in Testbench ***************************/
    /*******************************************************************************/
    task wait_some_cycles();
        #(`PERIOD*4);
    endtask

    task wait_one_cycle();
        #(`PERIOD);
    endtask

    task wait_half_cycle();
        #(`PERIOD/2);
    endtask

    task wait_quarter_cycle();
        #(`PERIOD/4);
    endtask

    task read_level(string filename);
        wait_one_cycle();
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
        rt = $fscanf(fd, "%h", level_partial_test);
        $fclose(fd);
        wait_one_cycle();
    endtask

    task read_index(string filename);
        wait_one_cycle();
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
        rt = $fscanf(fd, "%h", index_partial_test);
        $fclose(fd);
        wait_one_cycle();
    endtask

    task initialize_ddr_vec(string file);
        fd = $fopen(file, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", file);
            // $finish;
        end
        else begin
            //initialize input memory matrix
            for (i = 0; i < DDR_MEM_VEC_DEPTH; i++) begin
                rt = $fscanf(fd, "%h", tmp[0]);
                rt = $fscanf(fd, "%h", tmp[1]);
                //rt = $fscanf(fd, "%h", tmp[2]);
                //rt = $fscanf(fd, "%h", tmp[3]);
                //rt = $fscanf(fd, "%h", tmp[4]);
                //rt = $fscanf(fd, "%h", tmp[5]);
                //rt = $fscanf(fd, "%h", tmp[6]);
                //rt = $fscanf(fd, "%h", tmp[7]);
                temp_mem[VEC_START_LINE + i] = {/*tmp[7], tmp[6], tmp[5], tmp[4], tmp[3], tmp[2],*/ tmp[1], tmp[0]};
            end
            $fclose(fd);
        end
    endtask

    task initialize_ddr_partial(string file);
        fd = $fopen(file, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", file);
            // $finish;
        end
        else begin
            //initialize input memory matrix
            for (i = 0; i < DDR_MEM_PARTIAL_DEPTH; i++) begin
                rt = $fscanf(fd, "%h", tmp[0]);
                rt = $fscanf(fd, "%h", tmp[1]);
                rt = $fscanf(fd, "%h", tmp[2]);
                rt = $fscanf(fd, "%h", tmp[3]);
                rt = $fscanf(fd, "%h", tmp[4]);
                rt = $fscanf(fd, "%h", tmp[5]);
                rt = $fscanf(fd, "%h", tmp[6]);
                rt = $fscanf(fd, "%h", tmp[7]);
                temp_mem[PARTIAL_START_LINE + i] = {tmp[7], tmp[6], tmp[5], tmp[4], tmp[3], tmp[2], tmp[1], tmp[0]};
            end
            $fclose(fd);
        end
    endtask

    task initialize_ddr_mat(string file);
        fd = $fopen(file, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", file);
            // $finish;
        end
        else begin
            //initialize input memory matrix
            for (i = 0; i < DDR_MEM_MAT_DEPTH; i++) begin
                rt = $fscanf(fd, "%h", tmp[0]);
                rt = $fscanf(fd, "%h", tmp[1]);
                //rt = $fscanf(fd, "%h", tmp[2]);
                //rt = $fscanf(fd, "%h", tmp[3]);
                //rt = $fscanf(fd, "%h", tmp[4]);
                //rt = $fscanf(fd, "%h", tmp[5]);
                //rt = $fscanf(fd, "%h", tmp[6]);
                //rt = $fscanf(fd, "%h", tmp[7]);
                temp_mem[MAT_START_LINE + i] = {/*tmp[7], tmp[6], tmp[5], tmp[4], tmp[3], tmp[2],*/ tmp[1], tmp[0]};
            end
            $fclose(fd);
        end
    endtask

    task initialize_ddr_ksk(string file);
        fd = $fopen(file, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", file);
            // $finish;
        end
        else begin
            //initialize input ksk ram 
            for (i = 0; i < DDR_MEM_KSK_DEPTH; i++) begin
                rt = $fscanf(fd, "%h", tmp[0]);
                rt = $fscanf(fd, "%h", tmp[1]);
                rt = $fscanf(fd, "%h", tmp[2]);
                rt = $fscanf(fd, "%h", tmp[3]);
                rt = $fscanf(fd, "%h", tmp[4]);
                rt = $fscanf(fd, "%h", tmp[5]);
                rt = $fscanf(fd, "%h", tmp[6]);
                rt = $fscanf(fd, "%h", tmp[7]);
                temp_mem[KSK_START_LINE + i] = {tmp[7], tmp[6], tmp[5], tmp[4], tmp[3], tmp[2], tmp[1], tmp[0]};
            end
            $fclose(fd);
        end
    endtask

    integer idx;
    task initialize_ddr_mem(string file_vec, string file_mat, string file_ksk);
        initialize_ddr_vec(file_vec);
        initialize_ddr_mat(file_mat);
        initialize_ddr_ksk(file_ksk);
        for (idx = 0; idx < DDR_MEM_DEPTH; idx=idx+1) force i_ddr_mem.i_ddr_mem_bank_512b.base_bank.mem_bank[idx] = temp_mem[idx]; 
        wait_one_cycle();
    endtask

    task initialize_ddr_mem_partial(string file_in, string file_ksk);
        initialize_ddr_partial(file_in);
        initialize_ddr_ksk(file_ksk);
        for (idx = 0; idx < DDR_MEM_DEPTH; idx=idx+1) force i_ddr_mem.i_ddr_mem_bank_512b.base_bank.mem_bank[idx] = temp_mem[idx]; 
        wait_one_cycle();
    endtask

    task check_ddr_mem(string filename);  
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end

        for (i = 0; i < DDR_MEM_RSLT_DEPTH; i++) begin
            rt = $fscanf(fd, "%h", tmp[0]);
            rt = $fscanf(fd, "%h", tmp[1]);
            rt = $fscanf(fd, "%h", tmp[2]);
            rt = $fscanf(fd, "%h", tmp[3]);
            rt = $fscanf(fd, "%h", tmp[4]);
            rt = $fscanf(fd, "%h", tmp[5]);
            rt = $fscanf(fd, "%h", tmp[6]);
            rt = $fscanf(fd, "%h", tmp[7]);
            gold_mem = {tmp[7], tmp[6], tmp[5], tmp[4], tmp[3], tmp[2], tmp[1], tmp[0]};
            if(i_rslt_mem_model.base_bank.mem_bank[i] == gold_mem) begin end
            else begin
                $display("i_rslt_mem_model.base_bank.mem_bank[%d] out value %d wrong!!! Correct value should be %d !!!\n", i, i_rslt_mem_model.base_bank.mem_bank[i], gold_mem);
                $display("i_rslt_mem_model.base_bank.mem_bank[%d] out value %h wrong!!! Correct value should be %h !!!\n", i, i_rslt_mem_model.base_bank.mem_bank[i], gold_mem);
                $finish;
            end
        end
        $fclose(fd);

    endtask

    task config_kernel_init(); // mvp config for ksk uram init process
        csr_command     = 32'h0             ;
        csr_ksk_ptr     = KSK_START_ADDR    ;
    endtask

    task config_kernel_run(); //mvp config for a complete run except ksk uram init
        csr_command     =  32'h1            ;
        csr_level       =  LEVEL            ;
        csr_col_size    =  COL_SIZE         ;
        csr_index       =  N_INDEX          ;
        csr_split       =  N_SPLIT          ;
        csr_mat_len     =  MAT_LEN          ;
        csr_vec_ptr     =  VEC_START_ADDR   ;
        csr_mat_ptr     =  MAT_START_ADDR   ;
        csr_rslt_ptr    =  RSLT_START_ADDR  ;
    endtask

    task mvp_start();
        wait_half_cycle();
        csr_ap_start    =  1'b1             ;
        wait_some_cycles();
        csr_ap_start    =  1'b0             ;
        wait_one_cycle();
    endtask

    task single_test(int index);
        stage_status_single_stage[index] = 1'b1;
        wait_some_cycles();

        wait_half_cycle();
        stage_start_partial_test_pre[index] = 1'b1;
        wait_one_cycle();
        stage_start_partial_test_pre[index] = 1'b0;
        wait_some_cycles();

        wait(stage_done[index]);
        wait_some_cycles();
        stage_status_single_stage[index] = 1'b0;
    endtask

    task basic_test();
        initialize_ddr_mem_partial({test_data_dir, "ddr_in_partial.txt"}, {test_data_dir, "ddr_in_ksk.txt"});
        initialize_dp_ctxt_uram("uram_vec.mem", 1);
        config_kernel_run();
        read_index({test_data_dir, "stg4_coeff_index.txt"});
        read_level({test_data_dir, "stg5_level.txt"});

        init = 1'b1;
        wait_one_cycle();
        init = 1'b0;

        wait(in_a_row_done == 1'b1);
        wait_some_cycles();
    endtask

    task full_test_no_uram();
        stage0_mode = 1;
        initialize_ddr_mem({test_data_dir, "ddr_in_vec.txt"}, 
            {test_data_dir, "ddr_in_mat.txt"}, {test_data_dir, "ddr_in_ksk.txt"});
        config_kernel_run();
        mvp_start();
        wait(interrupt);
        wait_some_cycles();
    endtask

    task full_test();
        stage0_mode = 1;
        initialize_ddr_mem({test_data_dir, "ddr_in_vec.txt"}, 
            {test_data_dir, "ddr_in_mat.txt"}, {test_data_dir, "ddr_in_ksk.txt"});
        config_kernel_run();
        mvp_start();
        wait(interrupt);
        wait_some_cycles();
    endtask

    `include "task.sv"

endmodule
