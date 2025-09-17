//================================================
//
//  mvp
//  mvp_top for FPGA
//  Author: Yanheng Lu(yanheng.lyh@ablibaba-inc.com)
//  Date: 20211228
//
//================================================

module mvp(
     input  wire            pcie_link_up        ,
     input  wire            s_axil_test_aclk    ,  
     input  wire            s_axil_test_aresetn ,
                                  
     input  wire [31 : 0]   s_axil_test_awaddr  ,
     input  wire [2 : 0]    s_axil_test_awprot  ,
     input  wire            s_axil_test_awvalid ,
     output wire            s_axil_test_awready ,
                                  
     input  wire [31 : 0]   s_axil_test_wdata   ,
     input  wire [3 : 0]    s_axil_test_wstrb   ,
     input  wire            s_axil_test_wvalid  ,
     output wire            s_axil_test_wready  ,
                                  
     output wire            s_axil_test_bvalid  ,
     output wire [1 : 0]    s_axil_test_bresp   ,
     input  wire            s_axil_test_bready  ,
                                  
     input  wire [31 : 0]   s_axil_test_araddr  ,
     input  wire [2 : 0]    s_axil_test_arprot  ,
     input  wire            s_axil_test_arvalid ,
     output wire            s_axil_test_arready ,
                                  
     output wire [31 : 0]   s_axil_test_rdata   ,
     output wire [1 : 0]    s_axil_test_rresp   ,
     output wire            s_axil_test_rvalid  ,
     input  wire            s_axil_test_rready  ,
	 
     input  wire            sys_rst             ,
     //DDR4//
     input  wire            c0_ddr4_ui_clk           ,       
     input  wire            c0_ddr4_ui_clk_sync_rst  ,
     input  wire            c0_init_calib_complete   ,
     output  wire[11 : 0]   test_axi_c0_awid         ,      
     output  wire[63 : 0]   test_axi_c0_awaddr       ,
     output  wire[7 : 0]    test_axi_c0_awlen        ,
     output  wire[2 : 0]    test_axi_c0_awsize       ,
     output  wire[1 : 0]    test_axi_c0_awburst      ,
     output  wire           test_axi_c0_awlock       ,
     output  wire[3 : 0]    test_axi_c0_awcache      ,
     output  wire[2 : 0]    test_axi_c0_awprot       ,
     output  wire           test_axi_c0_awvalid      ,
     input  wire            test_axi_c0_awready      ,
     output  wire[511 : 0]  test_axi_c0_wdata        ,
     output  wire[63 : 0]   test_axi_c0_wstrb        ,
     output  wire           test_axi_c0_wlast        ,
     output  wire           test_axi_c0_wvalid       ,
     input   wire           test_axi_c0_wready       ,
     input   wire[11 : 0]   test_axi_c0_bid          ,
     input   wire[1 : 0]    test_axi_c0_bresp        ,
     input   wire           test_axi_c0_bvalid       ,
     output  wire           test_axi_c0_bready       ,
     output  wire[11 : 0]   test_axi_c0_arid         ,
     output  wire[63 : 0]   test_axi_c0_araddr       ,
     output  wire[7 : 0]    test_axi_c0_arlen        ,
     output  wire[2 : 0]    test_axi_c0_arsize       ,
     output  wire[1 : 0]    test_axi_c0_arburst      ,
     output  wire           test_axi_c0_arlock       ,
     output  wire[3 : 0]    test_axi_c0_arcache      ,
     output  wire[2 : 0]    test_axi_c0_arprot       ,
     output  wire           test_axi_c0_arvalid      ,
     input   wire           test_axi_c0_arready      ,
     input   wire[11 : 0]   test_axi_c0_rid          ,
     input   wire[511 : 0]  test_axi_c0_rdata        ,
     input   wire[1 : 0]    test_axi_c0_rresp        ,
     input   wire           test_axi_c0_rlast        ,
     input   wire           test_axi_c0_rvalid       ,
     output  wire           test_axi_c0_rready       ,
     
     input  wire            c1_ddr4_ui_clk           ,       
     input  wire            c1_ddr4_ui_clk_sync_rst  ,
     input  wire            c1_init_calib_complete   ,
     output  wire[11 : 0]   test_axi_c1_awid         ,      
     output  wire[63 : 0]   test_axi_c1_awaddr       ,
     output  wire[7 : 0]    test_axi_c1_awlen        ,
     output  wire[2 : 0]    test_axi_c1_awsize       ,
     output  wire[1 : 0]    test_axi_c1_awburst      ,
     output  wire           test_axi_c1_awlock       ,
     output  wire[3 : 0]    test_axi_c1_awcache      ,
     output  wire[2 : 0]    test_axi_c1_awprot       ,
     output  wire           test_axi_c1_awvalid      ,
     input  wire            test_axi_c1_awready      ,
     output  wire[511 : 0]  test_axi_c1_wdata        ,
     output  wire[63 : 0]   test_axi_c1_wstrb        ,
     output  wire           test_axi_c1_wlast        ,
     output  wire           test_axi_c1_wvalid       ,
     input   wire           test_axi_c1_wready       ,
     input   wire[11 : 0]   test_axi_c1_bid          ,
     input   wire[1 : 0]    test_axi_c1_bresp        ,
     input   wire           test_axi_c1_bvalid       ,
     output  wire           test_axi_c1_bready       ,
     output  wire[11 : 0]   test_axi_c1_arid         ,
     output  wire[63 : 0]   test_axi_c1_araddr       ,
     output  wire[7 : 0]    test_axi_c1_arlen        ,
     output  wire[2 : 0]    test_axi_c1_arsize       ,
     output  wire[1 : 0]    test_axi_c1_arburst      ,
     output  wire           test_axi_c1_arlock       ,
     output  wire[3 : 0]    test_axi_c1_arcache      ,
     output  wire[2 : 0]    test_axi_c1_arprot       ,
     output  wire           test_axi_c1_arvalid      ,
     input   wire           test_axi_c1_arready      ,
     input   wire[11 : 0]   test_axi_c1_rid          ,
     input   wire[511 : 0]  test_axi_c1_rdata        ,
     input   wire[1 : 0]    test_axi_c1_rresp        ,
     input   wire           test_axi_c1_rlast        ,
     input   wire           test_axi_c1_rvalid       ,
     output  wire           test_axi_c1_rready       ,
     
     input  wire            c2_ddr4_ui_clk           ,       
     input  wire            c2_ddr4_ui_clk_sync_rst  ,
     input  wire            c2_init_calib_complete   ,
     output  wire[11 : 0]   test_axi_c2_awid         ,      
     output  wire[63 : 0]   test_axi_c2_awaddr       ,
     output  wire[7 : 0]    test_axi_c2_awlen        ,
     output  wire[2 : 0]    test_axi_c2_awsize       ,
     output  wire[1 : 0]    test_axi_c2_awburst      ,
     output  wire           test_axi_c2_awlock       ,
     output  wire[3 : 0]    test_axi_c2_awcache      ,
     output  wire[2 : 0]    test_axi_c2_awprot       ,
     output  wire           test_axi_c2_awvalid      ,
     input  wire            test_axi_c2_awready      ,
     output  wire[511 : 0]  test_axi_c2_wdata        ,
     output  wire[63 : 0]   test_axi_c2_wstrb        ,
     output  wire           test_axi_c2_wlast        ,
     output  wire           test_axi_c2_wvalid       ,
     input   wire           test_axi_c2_wready       ,
     input   wire[11 : 0]   test_axi_c2_bid          ,
     input   wire[1 : 0]    test_axi_c2_bresp        ,
     input   wire           test_axi_c2_bvalid       ,
     output  wire           test_axi_c2_bready       ,
     output  wire[11 : 0]   test_axi_c2_arid         ,
     output  wire[63 : 0]   test_axi_c2_araddr       ,
     output  wire[7 : 0]    test_axi_c2_arlen        ,
     output  wire[2 : 0]    test_axi_c2_arsize       ,
     output  wire[1 : 0]    test_axi_c2_arburst      ,
     output  wire           test_axi_c2_arlock       ,
     output  wire[3 : 0]    test_axi_c2_arcache      ,
     output  wire[2 : 0]    test_axi_c2_arprot       ,
     output  wire           test_axi_c2_arvalid      ,
     input   wire           test_axi_c2_arready      ,
     input   wire[11 : 0]   test_axi_c2_rid          ,
     input   wire[511 : 0]  test_axi_c2_rdata        ,
     input   wire[1 : 0]    test_axi_c2_rresp        ,
     input   wire           test_axi_c2_rlast        ,
     input   wire           test_axi_c2_rvalid       ,
     output  wire           test_axi_c2_rready       ,
     
     input  wire            c3_ddr4_ui_clk           ,       
     input  wire            c3_ddr4_ui_clk_sync_rst  ,
     input  wire            c3_init_calib_complete   ,
     output  wire[11 : 0]   test_axi_c3_awid         ,      
     output  wire[63 : 0]   test_axi_c3_awaddr       ,
     output  wire[7 : 0]    test_axi_c3_awlen        ,
     output  wire[2 : 0]    test_axi_c3_awsize       ,
     output  wire[1 : 0]    test_axi_c3_awburst      ,
     output  wire           test_axi_c3_awlock       ,
     output  wire[3 : 0]    test_axi_c3_awcache      ,
     output  wire[2 : 0]    test_axi_c3_awprot       ,
     output  wire           test_axi_c3_awvalid      ,
     input  wire            test_axi_c3_awready      ,
     output  wire[511 : 0]  test_axi_c3_wdata        ,
     output  wire[63 : 0]   test_axi_c3_wstrb        ,
     output  wire           test_axi_c3_wlast        ,
     output  wire           test_axi_c3_wvalid       ,
     input   wire           test_axi_c3_wready       ,
     input   wire[11 : 0]   test_axi_c3_bid          ,
     input   wire[1 : 0]    test_axi_c3_bresp        ,
     input   wire           test_axi_c3_bvalid       ,
     output  wire           test_axi_c3_bready       ,
     output  wire[11 : 0]   test_axi_c3_arid         ,
     output  wire[63 : 0]   test_axi_c3_araddr       ,
     output  wire[7 : 0]    test_axi_c3_arlen        ,
     output  wire[2 : 0]    test_axi_c3_arsize       ,
     output  wire[1 : 0]    test_axi_c3_arburst      ,
     output  wire           test_axi_c3_arlock       ,
     output  wire[3 : 0]    test_axi_c3_arcache      ,
     output  wire[2 : 0]    test_axi_c3_arprot       ,
     output  wire           test_axi_c3_arvalid      ,
     input   wire           test_axi_c3_arready      ,
     input   wire[11 : 0]   test_axi_c3_rid          ,
     input   wire[511 : 0]  test_axi_c3_rdata        ,
     input   wire[1 : 0]    test_axi_c3_rresp        ,
     input   wire           test_axi_c3_rlast        ,
     input   wire           test_axi_c3_rvalid       ,
     output  wire           test_axi_c3_rready       
 ); 
 
 
wire [32-1:0]                       command                       ;
wire [32-1:0]                       split                         ;
wire [32-1:0]                       level                         ;
wire [32-1:0]                       col_size                      ;
wire [32-1:0]                       index                         ;
wire [32-1:0]                       mat_len                       ;
wire [64-1:0]                       ksk_ptr                       ;
wire [64-1:0]                       mat_ptr                       ;
wire [64-1:0]                       vec_ptr                       ;
wire [64-1:0]                       output_ptr                    ;
wire                                ap_start                      ;
wire [32-1:0]                       ap_done                       ;
wire [32-1:0]                       test1                         ;

 
 ////DDR4////
  assign test_axi_c0_awaddr[63:33]=31'h0;
  assign test_axi_c1_awaddr[63:33]=31'h1;
  assign test_axi_c2_awaddr[63:33]=31'h2;
  assign test_axi_c3_awaddr[63:33]=31'h3;
  
  assign test_axi_c0_araddr[63:33]=31'h0; 
  assign test_axi_c1_araddr[63:33]=31'h1;
  assign test_axi_c2_araddr[63:33]=31'h2; 
  assign test_axi_c3_araddr[63:33]=31'h3;
  
  
 wire    [63:0]              tmp_awaddr         ;
 wire    [63:0]              tmp_araddr         ;
 assign test_axi_c0_awid = 'd0;
 assign test_axi_c0_awsize = 'd6;
 assign test_axi_c0_awburst = 'd1;
 assign test_axi_c0_awcache = 'd3;
 assign test_axi_c0_awlock = 'd0;
 assign test_axi_c0_awprot = 'd0;
 assign test_axi_c0_arid = 'd0;
 assign test_axi_c0_arsize = 'd6;
 assign test_axi_c0_arburst = 'd1;
 assign test_axi_c0_arcache = 'd3;
 assign test_axi_c0_arlock = 'd0;
 assign test_axi_c0_arprot = 'd0;
 assign test_axi_c0_awaddr[32 : 0] = tmp_awaddr[32 : 0];
 assign test_axi_c0_araddr[32 : 0] = tmp_araddr[33 - 1 : 0];

parameter C_MVP_AXI_ADDR_WIDTH = 'd64;
parameter C_MVP_AXI_DATA_WIDTH = 'd512;

wire mvp_rst;
assign mvp_rst = !sys_rst & !command[8];

mvp_top #(
    .AXI_ADDR_WIDTH         ( C_MVP_AXI_ADDR_WIDTH  ),
    .AXI_DATA_WIDTH         ( C_MVP_AXI_DATA_WIDTH  )
)
u_mvp_top (
    .clk                    ( c0_ddr4_ui_clk            ),
//    .rst_n                  ( mvp_rst                   ),
    .rst_n                  ( !sys_rst                  ),
    .data_axi_awvalid       ( test_axi_c0_awvalid       ),
    .data_axi_awready       ( test_axi_c0_awready       ),
    .data_axi_awaddr        ( tmp_awaddr                ),
    .data_axi_awlen         ( test_axi_c0_awlen         ),
    .data_axi_wvalid        ( test_axi_c0_wvalid        ),
    .data_axi_wready        ( test_axi_c0_wready        ),
    .data_axi_wdata         ( test_axi_c0_wdata         ),
    .data_axi_wstrb         ( test_axi_c0_wstrb         ),
    .data_axi_wlast         ( test_axi_c0_wlast         ),
    .data_axi_bvalid        ( test_axi_c0_bvalid        ),
    .data_axi_bready        ( test_axi_c0_bready        ),
    .data_axi_arvalid       ( test_axi_c0_arvalid       ),
    .data_axi_arready       ( test_axi_c0_arready       ),
    .data_axi_araddr        ( tmp_araddr                ),
    .data_axi_arlen         ( test_axi_c0_arlen         ),
    .data_axi_rvalid        ( test_axi_c0_rvalid        ),
    .data_axi_rready        ( test_axi_c0_rready        ),
    .data_axi_rdata         ( test_axi_c0_rdata         ),
    .data_axi_rlast         ( test_axi_c0_rlast         ),
    .ap_start               ( ap_start              ),
    .ap_done                ( ap_done               ),
    .ap_idle                (                       ),
    .ap_ready               (                       ),
    .test1                  ( test1                 ),
    .command                ( command               ),
    .level                  ( level                 ),
    .col_size               ( col_size              ),
    .split                  ( split                 ),
    .index                  ( index                 ),
    .mat_len                ( mat_len               ),
    .ksk_ptr                ( ksk_ptr               ),
    .mat_ptr                ( mat_ptr               ),
    .vec_ptr                ( vec_ptr               ),
    .data_ptr               ( output_ptr            ),
    // ---- New array I/Os to external polyvec RAMs ----
    .o_polyvec_wea          (),
    .o_polyvec_addra        (),
    .o_polyvec_dina         (),
    .o_polyvec_addrb        (),
    .i_polyvec_doutb        ()
);

  assign test_axi_c1_awid = 'b0;
  assign test_axi_c1_awaddr[33-1:0] = 'b0;
  assign test_axi_c1_awlen = 'b0;
  assign test_axi_c1_awsize = 'b0;
  assign test_axi_c1_awlock = 'b0;
  assign test_axi_c1_awburst = 'b0;
  assign test_axi_c1_awcache = 'b0;
  assign test_axi_c1_awprot = 'b0;
  assign test_axi_c1_awvalid = 'b0;
  assign test_axi_c1_wdata = 'b0;
  assign test_axi_c1_wstrb = 'b0;
  assign test_axi_c1_wlast = 'b0;
  assign test_axi_c1_wvalid = 'b0;
  assign test_axi_c1_bready = 'b0;
  assign test_axi_c1_arid = 'b0;
  assign test_axi_c1_araddr[33-1:0] = 'b0;
  assign test_axi_c1_arlen = 'b0;
  assign test_axi_c1_arsize = 'b0;
  assign test_axi_c1_arlock = 'b0;
  assign test_axi_c1_arburst = 'b0;
  assign test_axi_c1_arcache = 'b0;
  assign test_axi_c1_arprot = 'b0;
  assign test_axi_c1_arvalid = 'b0;
  assign test_axi_c1_rready = 'b0;

  assign test_axi_c2_awid = 'b0;
  assign test_axi_c2_awaddr[33-1:0] = 'b0;
  assign test_axi_c2_awlen = 'b0;
  assign test_axi_c2_awsize = 'b0;
  assign test_axi_c2_awlock = 'b0;
  assign test_axi_c2_awburst = 'b0;
  assign test_axi_c2_awcache = 'b0;
  assign test_axi_c2_awprot = 'b0;
  assign test_axi_c2_awvalid = 'b0;
  assign test_axi_c2_wdata = 'b0;
  assign test_axi_c2_wstrb = 'b0;
  assign test_axi_c2_wlast = 'b0;
  assign test_axi_c2_wvalid = 'b0;
  assign test_axi_c2_bready = 'b0;
  assign test_axi_c2_arid = 'b0;
  assign test_axi_c2_araddr[33-1:0] = 'b0;
  assign test_axi_c2_arlen = 'b0;
  assign test_axi_c2_arsize = 'b0;
  assign test_axi_c2_arlock = 'b0;
  assign test_axi_c2_arburst = 'b0;
  assign test_axi_c2_arcache = 'b0;
  assign test_axi_c2_arprot = 'b0;
  assign test_axi_c2_arvalid = 'b0;
  assign test_axi_c2_rready = 'b0;

  assign test_axi_c3_awid = 'b0;
  assign test_axi_c3_awaddr[33-1:0] = 'b0;
  assign test_axi_c3_awlen = 'b0;
  assign test_axi_c3_awsize = 'b0;
  assign test_axi_c3_awlock = 'b0;
  assign test_axi_c3_awburst = 'b0;
  assign test_axi_c3_awcache = 'b0;
  assign test_axi_c3_awprot = 'b0;
  assign test_axi_c3_awvalid = 'b0;
  assign test_axi_c3_wdata = 'b0;
  assign test_axi_c3_wstrb = 'b0;
  assign test_axi_c3_wlast = 'b0;
  assign test_axi_c3_wvalid = 'b0;
  assign test_axi_c3_bready = 'b0;
  assign test_axi_c3_arid = 'b0;
  assign test_axi_c3_araddr[33-1:0] = 'b0;
  assign test_axi_c3_arlen = 'b0;
  assign test_axi_c3_arsize = 'b0;
  assign test_axi_c3_arlock = 'b0;
  assign test_axi_c3_arburst = 'b0;
  assign test_axi_c3_arcache = 'b0;
  assign test_axi_c3_arprot = 'b0;
  assign test_axi_c3_arvalid = 'b0;
  assign test_axi_c3_rready = 'b0;

mvp_axil #(
  .C_S_AXI_ADDR_WIDTH ( 32 ),
  .C_S_AXI_DATA_WIDTH ( 32 )
)
u_mvp_axil (
  .ACLK       ( s_axil_test_aclk      ),
  .ARESET     ( ~s_axil_test_aresetn  ),
  .ACLK_EN    ( 1'b1                  ),
  .AWVALID    ( s_axil_test_awvalid   ),
  .AWREADY    ( s_axil_test_awready   ),
  .AWADDR     ( s_axil_test_awaddr    ),
  .WVALID     ( s_axil_test_wvalid    ),
  .WREADY     ( s_axil_test_wready    ),
  .WDATA      ( s_axil_test_wdata     ),
  .WSTRB      ( s_axil_test_wstrb     ),
  .ARVALID    ( s_axil_test_arvalid   ),
  .ARREADY    ( s_axil_test_arready   ),
  .ARADDR     ( s_axil_test_araddr    ),
  .RVALID     ( s_axil_test_rvalid    ),
  .RREADY     ( s_axil_test_rready    ),
  .RDATA      ( s_axil_test_rdata     ),
  .RRESP      ( s_axil_test_rresp     ),
  .BVALID     ( s_axil_test_bvalid    ),
  .BREADY     ( s_axil_test_bready    ),
  .BRESP      ( s_axil_test_bresp     ),
  .ap_start   ( ap_start              ),
  .ap_done    ( ap_done               ),
  .test1      ( test1                 ),
  .command    ( command               ),
  .level      ( level                 ),
  .col_size   ( col_size              ),
  .split      ( split                 ),
  .index      ( index                 ),
  .mat_len    ( mat_len               ),
  .ksk_ptr    ( ksk_ptr               ),
  .mat_ptr    ( mat_ptr               ),
  .vec_ptr    ( vec_ptr               ),
  .output_ptr ( output_ptr            )
);

endmodule                
