//////////////////////////////////////////////////
// Engineer: Chen Zhaohui (xinming)
// Email: chenzhaohui.czh@alibaba-inc.com
//
// Project Name: MVP
// Module Name: dp_triple_pp_buffer
// Modify Date: 07/26/2021 16:10
//
// Description: wrapper for a triple-pingpong buffer
//              (polyvec_ram banks externalized)
//////////////////////////////////////////////////

`include "dp_defines.vh"

module dp_triple_pp_buffer#(
    parameter COE_WIDTH          = 39,
    parameter Q_TYPE             = 0,
    parameter ADDR_WIDTH         = 9,   // Depth of ram is 1<<ADDR_WIDTH
    parameter LOG_NUM_BANK       = 3,   // width of the bank select signal
    parameter NUM_POLY           = 3,   // number of polys in one polyvec
    parameter NUM_BASE_BANK      = 8,   // number of banks for one poly
    parameter COMMON_BRAM_DELAY  = `COMMON_BRAM_DELAY
)(
    input                                                clk,
    input                                                rst_n,
    input                                                i_done,
    output  [1:0]                                        dp_tpp_mode,

    // ---------------- AXI input port ----------------
    //input  [NUM_BASE_BANK*NUM_POLY-1:0]                  i_axi_we,
    //input  [ADDR_WIDTH*NUM_BASE_BANK-1:0]                i_axi_wraddr,
    //input  [COE_WIDTH*NUM_BASE_BANK-1:0]                 i_axi_data,

    // ---------------- NTT in/out port ----------------
    input  [NUM_BASE_BANK*NUM_POLY-1:0]                  i_ntt_we,
    input  [ADDR_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]       i_ntt_wraddr,
    input  [COE_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]        i_ntt_data,
    input  [ADDR_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]       i_ntt_rdaddr,
    output reg [COE_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]    o_ntt_data,

    // ---------------- MADD output port ----------------
    input  [ADDR_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]       i_madd_rdaddr,
    output reg [COE_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]    o_madd_data,

    // ---------------- URAM tap (temp read) ----------------
    input      [ADDR_WIDTH-1:0]                          uram_rdaddr,
    output reg [COE_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]    o_temp_uram_data,

    input                                                ntt_done,

    // ---------------- Externalized polyvec_ram ports ----------------
    output reg [NUM_BASE_BANK*NUM_POLY-1:0]              o_polyvec_wea0,
    output reg [ADDR_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]   o_polyvec_addra0,
    output reg [COE_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]    o_polyvec_dina0,
    output reg [ADDR_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]   o_polyvec_addrb0,
    input      [COE_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]    i_polyvec_doutb0,

    output reg [NUM_BASE_BANK*NUM_POLY-1:0]              o_polyvec_wea1,
    output reg [ADDR_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]   o_polyvec_addra1,
    output reg [COE_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]    o_polyvec_dina1,
    output reg [ADDR_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]   o_polyvec_addrb1,
    input      [COE_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]    i_polyvec_doutb1,

    output reg [NUM_BASE_BANK*NUM_POLY-1:0]              o_polyvec_wea2,
    output reg [ADDR_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]   o_polyvec_addra2,
    output reg [COE_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]    o_polyvec_dina2,
    output reg [ADDR_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]   o_polyvec_addrb2,
    input      [COE_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]    i_polyvec_doutb2
);

  localparam S_AXI_NTT_MADD = 2'd0;
  localparam S_NTT_MADD_AXI = 2'd1;
  localparam S_MADD_AXI_NTT = 2'd2;

  reg [1:0] mode;
  reg [1:0] mode_nxt;
  reg       i_done_reg;

  assign dp_tpp_mode = mode;

  always @(posedge clk) begin
    if (!rst_n)
      i_done_reg <= 0;
    else
      i_done_reg <= i_done;
  end

  always @(posedge clk) begin
    if (!rst_n)
      mode <= S_AXI_NTT_MADD;
    else
      mode <= mode_nxt;
  end

  always @(*) begin
    if ((i_done_reg == 0) && (i_done == 1)) begin
      case (mode)
        S_AXI_NTT_MADD: mode_nxt = S_NTT_MADD_AXI;
        S_NTT_MADD_AXI: mode_nxt = S_MADD_AXI_NTT;
        S_MADD_AXI_NTT: mode_nxt = S_AXI_NTT_MADD;
        default:        mode_nxt = S_AXI_NTT_MADD;
      endcase
    end else begin
      mode_nxt = mode;
    end
  end

  // convenience wires
  //wire [NUM_BASE_BANK*NUM_POLY-1:0]            inf_mem_weaxi    = i_axi_we;
  //wire [ADDR_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0] inf_mem_addraxi  = {NUM_POLY{i_axi_wraddr}};
  //wire [COE_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0]  inf_mem_dataaxi  = {NUM_POLY{i_axi_data}};
  //wire [ADDR_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0] inf_mem_addrmadd = {NUM_POLY{i_madd_rdaddr}};
  wire [ADDR_WIDTH*NUM_BASE_BANK*NUM_POLY-1:0] temp_uram_addr   = {NUM_BASE_BANK{uram_rdaddr}};

  // muxing
  always @(*) begin
    // defaults
    o_polyvec_wea0   = 'd0; o_polyvec_addra0 = 'd0; o_polyvec_dina0 = 'd0; o_polyvec_addrb0 = 'd0;
    o_polyvec_wea1   = 'd0; o_polyvec_addra1 = 'd0; o_polyvec_dina1 = 'd0; o_polyvec_addrb1 = 'd0;
    o_polyvec_wea2   = 'd0; o_polyvec_addra2 = 'd0; o_polyvec_dina2 = 'd0; o_polyvec_addrb2 = 'd0;
    o_ntt_data       = 'd0;
    o_madd_data      = 'd0;
    o_temp_uram_data = 'd0;

    case (mode)
      S_AXI_NTT_MADD: begin
        //o_polyvec_wea0   = inf_mem_weaxi;
        //o_polyvec_addra0 = inf_mem_addraxi;
        //o_polyvec_dina0  = inf_mem_dataaxi;
        o_polyvec_wea0   = 'd0;
        o_polyvec_addra0 = 'd0;
        o_polyvec_dina0  = 'd0;
        o_polyvec_addrb0 = temp_uram_addr;
        o_temp_uram_data = i_polyvec_doutb0;

        o_polyvec_wea1   = i_ntt_we;
        o_polyvec_addra1 = i_ntt_wraddr;
        o_polyvec_dina1  = i_ntt_data;
        o_polyvec_addrb1 = i_ntt_rdaddr;
        o_ntt_data       = i_polyvec_doutb1;

        o_polyvec_addrb2 = i_madd_rdaddr;
        o_madd_data      = i_polyvec_doutb2;
      end

      S_NTT_MADD_AXI: begin
        //o_polyvec_wea2   = inf_mem_weaxi;
        //o_polyvec_addra2 = inf_mem_addraxi;
        //o_polyvec_dina2  = inf_mem_dataaxi;
        o_polyvec_wea2   = 'd0;
        o_polyvec_addra2 = 'd0;
        o_polyvec_dina2  = 'd0;
        o_polyvec_addrb2 = temp_uram_addr;
        o_temp_uram_data = i_polyvec_doutb2;

        o_polyvec_wea0   = i_ntt_we;
        o_polyvec_addra0 = i_ntt_wraddr;
        o_polyvec_dina0  = i_ntt_data;
        o_polyvec_addrb0 = i_ntt_rdaddr;
        o_ntt_data       = i_polyvec_doutb0;

        o_polyvec_addrb1 = i_madd_rdaddr;
        o_madd_data      = i_polyvec_doutb1;
      end

      S_MADD_AXI_NTT: begin
        //o_polyvec_wea1   = inf_mem_weaxi;
        //o_polyvec_addra1 = inf_mem_addraxi;
        //o_polyvec_dina1  = inf_mem_dataaxi;
        o_polyvec_wea1   = 'd0;
        o_polyvec_addra1 = 'd0;
        o_polyvec_dina1  = 'd0;

        o_polyvec_wea2   = i_ntt_we;
        o_polyvec_addra2 = i_ntt_wraddr;
        o_polyvec_dina2  = i_ntt_data;
        o_polyvec_addrb2 = (ntt_done ? temp_uram_addr : i_ntt_rdaddr);
        o_ntt_data       = i_polyvec_doutb2;
        o_temp_uram_data = i_polyvec_doutb2;

        o_polyvec_addrb0 = i_madd_rdaddr;
        o_madd_data      = i_polyvec_doutb0;
      end

      default: begin
        // keep defaults
      end
    endcase
  end


  // ===========================================================
  // Original internal polyvec_ram instances (commented out)
  // ===========================================================
  /*
  polyvec_ram #(... ) polyvec_0 (...);
  polyvec_ram #(... ) polyvec_1 (...);
  polyvec_ram #(... ) polyvec_2 (...);
  */

endmodule

  // =========================================================================
  // Banks moved outside this module — keep here for reference only.
  // =========================================================================
  /*
  polyvec_ram #( .COE_WIDTH(COE_WIDTH), .Q_TYPE(Q_TYPE), .ADDR_WIDTH(ADDR_WIDTH),
                 .NUM_POLY(NUM_POLY), .NUM_BASE_BANK(NUM_BASE_BANK),
                 .COMMON_BRAM_DELAY(COMMON_BRAM_DELAY) )
  polyvec_0 ( .clk(clk),
              .wea  (o_polyvec_wea[0]),
              .addra(o_polyvec_addra[0]),
              .dina (o_polyvec_dina[0]),
              .addrb(o_polyvec_addrb[0]),
              .doutb(i_polyvec_doutb[0]) );

  polyvec_ram #( .COE_WIDTH(COE_WIDTH), .Q_TYPE(Q_TYPE), .ADDR_WIDTH(ADDR_WIDTH),
                 .NUM_POLY(NUM_POLY), .NUM_BASE_BANK(NUM_BASE_BANK),
                 .COMMON_BRAM_DELAY(COMMON_BRAM_DELAY) )
  polyvec_1 ( .clk(clk),
              .wea  (o_polyvec_wea[1]),
              .addra(o_polyvec_addra[1]),
              .dina (o_polyvec_dina[1]),
              .addrb(o_polyvec_addrb[1]),
              .doutb(i_polyvec_doutb[1]) );

  polyvec_ram #( .COE_WIDTH(COE_WIDTH), .Q_TYPE(Q_TYPE), .ADDR_WIDTH(ADDR_WIDTH),
                 .NUM_POLY(NUM_POLY), .NUM_BASE_BANK(NUM_BASE_BANK),
                 .COMMON_BRAM_DELAY(COMMON_BRAM_DELAY) )
  polyvec_2 ( .clk(clk),
              .wea  (o_polyvec_wea[2]),
              .addra(o_polyvec_addra[2]),
              .dina (o_polyvec_dina[2]),
              .addrb(o_polyvec_addrb[2]),
              .doutb(i_polyvec_doutb[2]) );
  */
