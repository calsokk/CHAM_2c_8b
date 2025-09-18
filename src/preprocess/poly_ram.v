//////////////////////////////////////////////////
// Engineer: Chen Zhaohui (xinming)
// Email: chenzhaohui.czh@alibaba-inc.com
//
// Project Name: MVP
// Module Name: poly_ram
// Modify Date: 07/26/2021 16:10

// Description: wrapper for a polynomial ram
//////////////////////////////////////////////////

`include "common_defines.vh"
module poly_ram#(
    parameter COE_WIDTH          = 39,
    parameter Q_TYPE             = 0,
    parameter ADDR_WIDTH         = 9,         // Depth of ram is 1<<ADDR_WIDTH
    parameter NUM_BASE_BANK      = 8,         // number of banks for one poly
    parameter COMMON_BRAM_DELAY  = `COMMON_BRAM_DELAY
)(
    input                                   clk,
    input   [NUM_BASE_BANK-1:0]             wea,
    input   [ADDR_WIDTH*NUM_BASE_BANK-1:0]  addra,
    input   [COE_WIDTH*NUM_BASE_BANK-1:0]   dina,
    input   [ADDR_WIDTH*NUM_BASE_BANK-1:0]  addrb,
    output  [COE_WIDTH*NUM_BASE_BANK-1:0]   doutb
);

/* generate #NUM_BASE_BANK banks to store a polynomial */
genvar index_bank_ram;
generate
    for(index_bank_ram = 0; index_bank_ram<NUM_BASE_BANK; index_bank_ram = index_bank_ram+1) begin: genblk1
        simple_dual_ram#(
            .COE_WIDTH(COE_WIDTH),
            .Q_TYPE (Q_TYPE),
            .ADDR_WIDTH(ADDR_WIDTH),
            .COMMON_BRAM_DELAY(COMMON_BRAM_DELAY)
        )
        base_bank(
            .clk(clk),
            .wea(wea[index_bank_ram]),
            .addra(addra[(index_bank_ram+1)*ADDR_WIDTH-1 -: ADDR_WIDTH]),
            .dina(dina[(index_bank_ram+1)*COE_WIDTH-1 -: COE_WIDTH]),
            .addrb(addrb[(index_bank_ram+1)*ADDR_WIDTH-1 -: ADDR_WIDTH]),
            .doutb(doutb[(index_bank_ram+1)*COE_WIDTH-1 -: COE_WIDTH])
        );
    end
endgenerate

endmodule

module poly_ram_35_9_8(
  input         clock,
  input         io_wr_en_0,
  input         io_wr_en_1,
  input         io_wr_en_2,
  input         io_wr_en_3,
  input         io_wr_en_4,
  input         io_wr_en_5,
  input         io_wr_en_6,
  input         io_wr_en_7,
  input  [8:0]  io_wr_addr_0,
  input  [8:0]  io_wr_addr_1,
  input  [8:0]  io_wr_addr_2,
  input  [8:0]  io_wr_addr_3,
  input  [8:0]  io_wr_addr_4,
  input  [8:0]  io_wr_addr_5,
  input  [8:0]  io_wr_addr_6,
  input  [8:0]  io_wr_addr_7,
  input  [34:0] io_wr_data_0,
  input  [34:0] io_wr_data_1,
  input  [34:0] io_wr_data_2,
  input  [34:0] io_wr_data_3,
  input  [34:0] io_wr_data_4,
  input  [34:0] io_wr_data_5,
  input  [34:0] io_wr_data_6,
  input  [34:0] io_wr_data_7,
  input  [8:0]  io_rd_addr_0,
  input  [8:0]  io_rd_addr_1,
  input  [8:0]  io_rd_addr_2,
  input  [8:0]  io_rd_addr_3,
  input  [8:0]  io_rd_addr_4,
  input  [8:0]  io_rd_addr_5,
  input  [8:0]  io_rd_addr_6,
  input  [8:0]  io_rd_addr_7,
  output [34:0] io_rd_data_0,
  output [34:0] io_rd_data_1,
  output [34:0] io_rd_data_2,
  output [34:0] io_rd_data_3,
  output [34:0] io_rd_data_4,
  output [34:0] io_rd_data_5,
  output [34:0] io_rd_data_6,
  output [34:0] io_rd_data_7
);
  wire  u_ram_clk; // @[PolyRam.scala 33:23]
  wire [7:0] u_ram_wea; // @[PolyRam.scala 33:23]
  wire [71:0] u_ram_addra; // @[PolyRam.scala 33:23]
  wire [279:0] u_ram_dina; // @[PolyRam.scala 33:23]
  wire [71:0] u_ram_addrb; // @[PolyRam.scala 33:23]
  wire [279:0] u_ram_doutb; // @[PolyRam.scala 33:23]
  wire [3:0] u_ram_io_wea_lo = {io_wr_en_3,io_wr_en_2,io_wr_en_1,io_wr_en_0}; // @[PolyRam.scala 36:33]
  wire [3:0] u_ram_io_wea_hi = {io_wr_en_7,io_wr_en_6,io_wr_en_5,io_wr_en_4}; // @[PolyRam.scala 36:33]
  wire [35:0] u_ram_io_addra_lo = {io_wr_addr_3,io_wr_addr_2,io_wr_addr_1,io_wr_addr_0}; // @[PolyRam.scala 37:35]
  wire [35:0] u_ram_io_addra_hi = {io_wr_addr_7,io_wr_addr_6,io_wr_addr_5,io_wr_addr_4}; // @[PolyRam.scala 37:35]
  wire [139:0] u_ram_io_dina_lo = {io_wr_data_3,io_wr_data_2,io_wr_data_1,io_wr_data_0}; // @[PolyRam.scala 38:35]
  wire [139:0] u_ram_io_dina_hi = {io_wr_data_7,io_wr_data_6,io_wr_data_5,io_wr_data_4}; // @[PolyRam.scala 38:35]
  wire [35:0] u_ram_io_addrb_lo = {io_rd_addr_3,io_rd_addr_2,io_rd_addr_1,io_rd_addr_0}; // @[PolyRam.scala 39:35]
  wire [35:0] u_ram_io_addrb_hi = {io_rd_addr_7,io_rd_addr_6,io_rd_addr_5,io_rd_addr_4}; // @[PolyRam.scala 39:35]
  wire [7:0] lo_lo = {u_ram_doutb[7],u_ram_doutb[6],u_ram_doutb[5],u_ram_doutb[4],u_ram_doutb[3],u_ram_doutb[2],
    u_ram_doutb[1],u_ram_doutb[0]}; // @[Common.scala 26:15]
  wire [16:0] lo = {u_ram_doutb[16],u_ram_doutb[15],u_ram_doutb[14],u_ram_doutb[13],u_ram_doutb[12],u_ram_doutb[11],
    u_ram_doutb[10],u_ram_doutb[9],u_ram_doutb[8],lo_lo}; // @[Common.scala 26:15]
  wire [8:0] hi_lo = {u_ram_doutb[25],u_ram_doutb[24],u_ram_doutb[23],u_ram_doutb[22],u_ram_doutb[21],u_ram_doutb[20],
    u_ram_doutb[19],u_ram_doutb[18],u_ram_doutb[17]}; // @[Common.scala 26:15]
  wire [17:0] hi = {u_ram_doutb[34],u_ram_doutb[33],u_ram_doutb[32],u_ram_doutb[31],u_ram_doutb[30],u_ram_doutb[29],
    u_ram_doutb[28],u_ram_doutb[27],u_ram_doutb[26],hi_lo}; // @[Common.scala 26:15]
  wire [7:0] lo_lo_1 = {u_ram_doutb[42],u_ram_doutb[41],u_ram_doutb[40],u_ram_doutb[39],u_ram_doutb[38],u_ram_doutb[37],
    u_ram_doutb[36],u_ram_doutb[35]}; // @[Common.scala 26:15]
  wire [16:0] lo_1 = {u_ram_doutb[51],u_ram_doutb[50],u_ram_doutb[49],u_ram_doutb[48],u_ram_doutb[47],u_ram_doutb[46],
    u_ram_doutb[45],u_ram_doutb[44],u_ram_doutb[43],lo_lo_1}; // @[Common.scala 26:15]
  wire [8:0] hi_lo_1 = {u_ram_doutb[60],u_ram_doutb[59],u_ram_doutb[58],u_ram_doutb[57],u_ram_doutb[56],u_ram_doutb[55],
    u_ram_doutb[54],u_ram_doutb[53],u_ram_doutb[52]}; // @[Common.scala 26:15]
  wire [17:0] hi_1 = {u_ram_doutb[69],u_ram_doutb[68],u_ram_doutb[67],u_ram_doutb[66],u_ram_doutb[65],u_ram_doutb[64],
    u_ram_doutb[63],u_ram_doutb[62],u_ram_doutb[61],hi_lo_1}; // @[Common.scala 26:15]
  wire [7:0] lo_lo_2 = {u_ram_doutb[77],u_ram_doutb[76],u_ram_doutb[75],u_ram_doutb[74],u_ram_doutb[73],u_ram_doutb[72],
    u_ram_doutb[71],u_ram_doutb[70]}; // @[Common.scala 26:15]
  wire [16:0] lo_2 = {u_ram_doutb[86],u_ram_doutb[85],u_ram_doutb[84],u_ram_doutb[83],u_ram_doutb[82],u_ram_doutb[81],
    u_ram_doutb[80],u_ram_doutb[79],u_ram_doutb[78],lo_lo_2}; // @[Common.scala 26:15]
  wire [8:0] hi_lo_2 = {u_ram_doutb[95],u_ram_doutb[94],u_ram_doutb[93],u_ram_doutb[92],u_ram_doutb[91],u_ram_doutb[90],
    u_ram_doutb[89],u_ram_doutb[88],u_ram_doutb[87]}; // @[Common.scala 26:15]
  wire [17:0] hi_2 = {u_ram_doutb[104],u_ram_doutb[103],u_ram_doutb[102],u_ram_doutb[101],u_ram_doutb[100],u_ram_doutb[
    99],u_ram_doutb[98],u_ram_doutb[97],u_ram_doutb[96],hi_lo_2}; // @[Common.scala 26:15]
  wire [7:0] lo_lo_3 = {u_ram_doutb[112],u_ram_doutb[111],u_ram_doutb[110],u_ram_doutb[109],u_ram_doutb[108],u_ram_doutb
    [107],u_ram_doutb[106],u_ram_doutb[105]}; // @[Common.scala 26:15]
  wire [16:0] lo_3 = {u_ram_doutb[121],u_ram_doutb[120],u_ram_doutb[119],u_ram_doutb[118],u_ram_doutb[117],u_ram_doutb[
    116],u_ram_doutb[115],u_ram_doutb[114],u_ram_doutb[113],lo_lo_3}; // @[Common.scala 26:15]
  wire [8:0] hi_lo_3 = {u_ram_doutb[130],u_ram_doutb[129],u_ram_doutb[128],u_ram_doutb[127],u_ram_doutb[126],u_ram_doutb
    [125],u_ram_doutb[124],u_ram_doutb[123],u_ram_doutb[122]}; // @[Common.scala 26:15]
  wire [17:0] hi_3 = {u_ram_doutb[139],u_ram_doutb[138],u_ram_doutb[137],u_ram_doutb[136],u_ram_doutb[135],u_ram_doutb[
    134],u_ram_doutb[133],u_ram_doutb[132],u_ram_doutb[131],hi_lo_3}; // @[Common.scala 26:15]
  wire [7:0] lo_lo_4 = {u_ram_doutb[147],u_ram_doutb[146],u_ram_doutb[145],u_ram_doutb[144],u_ram_doutb[143],u_ram_doutb
    [142],u_ram_doutb[141],u_ram_doutb[140]}; // @[Common.scala 26:15]
  wire [16:0] lo_4 = {u_ram_doutb[156],u_ram_doutb[155],u_ram_doutb[154],u_ram_doutb[153],u_ram_doutb[152],u_ram_doutb[
    151],u_ram_doutb[150],u_ram_doutb[149],u_ram_doutb[148],lo_lo_4}; // @[Common.scala 26:15]
  wire [8:0] hi_lo_4 = {u_ram_doutb[165],u_ram_doutb[164],u_ram_doutb[163],u_ram_doutb[162],u_ram_doutb[161],u_ram_doutb
    [160],u_ram_doutb[159],u_ram_doutb[158],u_ram_doutb[157]}; // @[Common.scala 26:15]
  wire [17:0] hi_4 = {u_ram_doutb[174],u_ram_doutb[173],u_ram_doutb[172],u_ram_doutb[171],u_ram_doutb[170],u_ram_doutb[
    169],u_ram_doutb[168],u_ram_doutb[167],u_ram_doutb[166],hi_lo_4}; // @[Common.scala 26:15]
  wire [7:0] lo_lo_5 = {u_ram_doutb[182],u_ram_doutb[181],u_ram_doutb[180],u_ram_doutb[179],u_ram_doutb[178],u_ram_doutb
    [177],u_ram_doutb[176],u_ram_doutb[175]}; // @[Common.scala 26:15]
  wire [16:0] lo_5 = {u_ram_doutb[191],u_ram_doutb[190],u_ram_doutb[189],u_ram_doutb[188],u_ram_doutb[187],u_ram_doutb[
    186],u_ram_doutb[185],u_ram_doutb[184],u_ram_doutb[183],lo_lo_5}; // @[Common.scala 26:15]
  wire [8:0] hi_lo_5 = {u_ram_doutb[200],u_ram_doutb[199],u_ram_doutb[198],u_ram_doutb[197],u_ram_doutb[196],u_ram_doutb
    [195],u_ram_doutb[194],u_ram_doutb[193],u_ram_doutb[192]}; // @[Common.scala 26:15]
  wire [17:0] hi_5 = {u_ram_doutb[209],u_ram_doutb[208],u_ram_doutb[207],u_ram_doutb[206],u_ram_doutb[205],u_ram_doutb[
    204],u_ram_doutb[203],u_ram_doutb[202],u_ram_doutb[201],hi_lo_5}; // @[Common.scala 26:15]
  wire [7:0] lo_lo_6 = {u_ram_doutb[217],u_ram_doutb[216],u_ram_doutb[215],u_ram_doutb[214],u_ram_doutb[213],u_ram_doutb
    [212],u_ram_doutb[211],u_ram_doutb[210]}; // @[Common.scala 26:15]
  wire [16:0] lo_6 = {u_ram_doutb[226],u_ram_doutb[225],u_ram_doutb[224],u_ram_doutb[223],u_ram_doutb[222],u_ram_doutb[
    221],u_ram_doutb[220],u_ram_doutb[219],u_ram_doutb[218],lo_lo_6}; // @[Common.scala 26:15]
  wire [8:0] hi_lo_6 = {u_ram_doutb[235],u_ram_doutb[234],u_ram_doutb[233],u_ram_doutb[232],u_ram_doutb[231],u_ram_doutb
    [230],u_ram_doutb[229],u_ram_doutb[228],u_ram_doutb[227]}; // @[Common.scala 26:15]
  wire [17:0] hi_6 = {u_ram_doutb[244],u_ram_doutb[243],u_ram_doutb[242],u_ram_doutb[241],u_ram_doutb[240],u_ram_doutb[
    239],u_ram_doutb[238],u_ram_doutb[237],u_ram_doutb[236],hi_lo_6}; // @[Common.scala 26:15]
  wire [7:0] lo_lo_7 = {u_ram_doutb[252],u_ram_doutb[251],u_ram_doutb[250],u_ram_doutb[249],u_ram_doutb[248],u_ram_doutb
    [247],u_ram_doutb[246],u_ram_doutb[245]}; // @[Common.scala 26:15]
  wire [16:0] lo_7 = {u_ram_doutb[261],u_ram_doutb[260],u_ram_doutb[259],u_ram_doutb[258],u_ram_doutb[257],u_ram_doutb[
    256],u_ram_doutb[255],u_ram_doutb[254],u_ram_doutb[253],lo_lo_7}; // @[Common.scala 26:15]
  wire [8:0] hi_lo_7 = {u_ram_doutb[270],u_ram_doutb[269],u_ram_doutb[268],u_ram_doutb[267],u_ram_doutb[266],u_ram_doutb
    [265],u_ram_doutb[264],u_ram_doutb[263],u_ram_doutb[262]}; // @[Common.scala 26:15]
  wire [17:0] hi_7 = {u_ram_doutb[279],u_ram_doutb[278],u_ram_doutb[277],u_ram_doutb[276],u_ram_doutb[275],u_ram_doutb[
    274],u_ram_doutb[273],u_ram_doutb[272],u_ram_doutb[271],hi_lo_7}; // @[Common.scala 26:15]
  poly_ram #(.COE_WIDTH(35), .ADDR_WIDTH(9), .NUM_BASE_BANK(8)) u_ram ( // @[PolyRam.scala 33:23]
    .clk(u_ram_clk),
    .wea(u_ram_wea),
    .addra(u_ram_addra),
    .dina(u_ram_dina),
    .addrb(u_ram_addrb),
    .doutb(u_ram_doutb)
  );
  assign io_rd_data_0 = {hi,lo}; // @[Common.scala 26:15]
  assign io_rd_data_1 = {hi_1,lo_1}; // @[Common.scala 26:15]
  assign io_rd_data_2 = {hi_2,lo_2}; // @[Common.scala 26:15]
  assign io_rd_data_3 = {hi_3,lo_3}; // @[Common.scala 26:15]
  assign io_rd_data_4 = {hi_4,lo_4}; // @[Common.scala 26:15]
  assign io_rd_data_5 = {hi_5,lo_5}; // @[Common.scala 26:15]
  assign io_rd_data_6 = {hi_6,lo_6}; // @[Common.scala 26:15]
  assign io_rd_data_7 = {hi_7,lo_7}; // @[Common.scala 26:15]
  assign u_ram_clk = clock; // @[PolyRam.scala 35:21]
  assign u_ram_wea = {u_ram_io_wea_hi,u_ram_io_wea_lo}; // @[PolyRam.scala 36:33]
  assign u_ram_addra = {u_ram_io_addra_hi,u_ram_io_addra_lo}; // @[PolyRam.scala 37:35]
  assign u_ram_dina = {u_ram_io_dina_hi,u_ram_io_dina_lo}; // @[PolyRam.scala 38:35]
  assign u_ram_addrb = {u_ram_io_addrb_hi,u_ram_io_addrb_lo}; // @[PolyRam.scala 39:35]
endmodule