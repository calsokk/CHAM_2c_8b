module intt_17314086913(
  input         clock,
  input         reset,
  input         io_ntt_start,
  output        io_ntt_done,
  output        io_wr_l_en_0,
  output        io_wr_l_en_1,
  output        io_wr_l_en_2,
  output        io_wr_l_en_3,
  output        io_wr_l_en_4,
  output        io_wr_l_en_5,
  output        io_wr_l_en_6,
  output        io_wr_l_en_7,
  output [8:0]  io_wr_l_addr_0,
  output [8:0]  io_wr_l_addr_1,
  output [8:0]  io_wr_l_addr_2,
  output [8:0]  io_wr_l_addr_3,
  output [8:0]  io_wr_l_addr_4,
  output [8:0]  io_wr_l_addr_5,
  output [8:0]  io_wr_l_addr_6,
  output [8:0]  io_wr_l_addr_7,
  output [34:0] io_wr_l_data_0,
  output [34:0] io_wr_l_data_1,
  output [34:0] io_wr_l_data_2,
  output [34:0] io_wr_l_data_3,
  output [34:0] io_wr_l_data_4,
  output [34:0] io_wr_l_data_5,
  output [34:0] io_wr_l_data_6,
  output [34:0] io_wr_l_data_7,
  output        io_wr_r_en_0,
  output        io_wr_r_en_1,
  output        io_wr_r_en_2,
  output        io_wr_r_en_3,
  output        io_wr_r_en_4,
  output        io_wr_r_en_5,
  output        io_wr_r_en_6,
  output        io_wr_r_en_7,
  output [8:0]  io_wr_r_addr_0,
  output [8:0]  io_wr_r_addr_1,
  output [8:0]  io_wr_r_addr_2,
  output [8:0]  io_wr_r_addr_3,
  output [8:0]  io_wr_r_addr_4,
  output [8:0]  io_wr_r_addr_5,
  output [8:0]  io_wr_r_addr_6,
  output [8:0]  io_wr_r_addr_7,
  output [34:0] io_wr_r_data_0,
  output [34:0] io_wr_r_data_1,
  output [34:0] io_wr_r_data_2,
  output [34:0] io_wr_r_data_3,
  output [34:0] io_wr_r_data_4,
  output [34:0] io_wr_r_data_5,
  output [34:0] io_wr_r_data_6,
  output [34:0] io_wr_r_data_7,
  output [8:0]  io_rd_l_addr_0,
  output [8:0]  io_rd_l_addr_1,
  output [8:0]  io_rd_l_addr_2,
  output [8:0]  io_rd_l_addr_3,
  output [8:0]  io_rd_l_addr_4,
  output [8:0]  io_rd_l_addr_5,
  output [8:0]  io_rd_l_addr_6,
  output [8:0]  io_rd_l_addr_7,
  input  [34:0] io_rd_l_data_0,
  input  [34:0] io_rd_l_data_1,
  input  [34:0] io_rd_l_data_2,
  input  [34:0] io_rd_l_data_3,
  input  [34:0] io_rd_l_data_4,
  input  [34:0] io_rd_l_data_5,
  input  [34:0] io_rd_l_data_6,
  input  [34:0] io_rd_l_data_7,
  output [8:0]  io_rd_r_addr_0,
  output [8:0]  io_rd_r_addr_1,
  output [8:0]  io_rd_r_addr_2,
  output [8:0]  io_rd_r_addr_3,
  output [8:0]  io_rd_r_addr_4,
  output [8:0]  io_rd_r_addr_5,
  output [8:0]  io_rd_r_addr_6,
  output [8:0]  io_rd_r_addr_7,
  input  [34:0] io_rd_r_data_0,
  input  [34:0] io_rd_r_data_1,
  input  [34:0] io_rd_r_data_2,
  input  [34:0] io_rd_r_data_3,
  input  [34:0] io_rd_r_data_4,
  input  [34:0] io_rd_r_data_5,
  input  [34:0] io_rd_r_data_6,
  input  [34:0] io_rd_r_data_7,
  output        io_o_we_result
);
  wire  u_intt_clk; // @[INTT.scala 47:24]
  wire  u_intt_rst_n; // @[INTT.scala 47:24]
  wire  u_intt_ntt_start; // @[INTT.scala 47:24]
  wire  u_intt_ntt_done; // @[INTT.scala 47:24]
  wire [279:0] u_intt_i_data_b_l; // @[INTT.scala 47:24]
  wire [279:0] u_intt_i_data_b_r; // @[INTT.scala 47:24]
  wire [279:0] u_intt_o_data_a; // @[INTT.scala 47:24]
  wire  u_intt_o_we_a_l; // @[INTT.scala 47:24]
  wire  u_intt_o_we_a_r; // @[INTT.scala 47:24]
  wire [8:0] u_intt_o_addr_a_l; // @[INTT.scala 47:24]
  wire [8:0] u_intt_o_addr_a_r; // @[INTT.scala 47:24]
  wire [8:0] u_intt_o_addr_b_l; // @[INTT.scala 47:24]
  wire [8:0] u_intt_o_addr_b_r; // @[INTT.scala 47:24]
  wire  u_intt_o_we_result; // @[INTT.scala 47:24]
  wire [7:0] lo_lo = {u_intt_o_data_a[7],u_intt_o_data_a[6],u_intt_o_data_a[5],u_intt_o_data_a[4],u_intt_o_data_a[3],
    u_intt_o_data_a[2],u_intt_o_data_a[1],u_intt_o_data_a[0]}; // @[Common.scala 26:15]
  wire [16:0] lo = {u_intt_o_data_a[16],u_intt_o_data_a[15],u_intt_o_data_a[14],u_intt_o_data_a[13],u_intt_o_data_a[12],
    u_intt_o_data_a[11],u_intt_o_data_a[10],u_intt_o_data_a[9],u_intt_o_data_a[8],lo_lo}; // @[Common.scala 26:15]
  wire [8:0] hi_lo = {u_intt_o_data_a[25],u_intt_o_data_a[24],u_intt_o_data_a[23],u_intt_o_data_a[22],u_intt_o_data_a[21
    ],u_intt_o_data_a[20],u_intt_o_data_a[19],u_intt_o_data_a[18],u_intt_o_data_a[17]}; // @[Common.scala 26:15]
  wire [17:0] hi = {u_intt_o_data_a[34],u_intt_o_data_a[33],u_intt_o_data_a[32],u_intt_o_data_a[31],u_intt_o_data_a[30],
    u_intt_o_data_a[29],u_intt_o_data_a[28],u_intt_o_data_a[27],u_intt_o_data_a[26],hi_lo}; // @[Common.scala 26:15]
  wire [7:0] lo_lo_1 = {u_intt_o_data_a[42],u_intt_o_data_a[41],u_intt_o_data_a[40],u_intt_o_data_a[39],u_intt_o_data_a[
    38],u_intt_o_data_a[37],u_intt_o_data_a[36],u_intt_o_data_a[35]}; // @[Common.scala 26:15]
  wire [16:0] lo_1 = {u_intt_o_data_a[51],u_intt_o_data_a[50],u_intt_o_data_a[49],u_intt_o_data_a[48],u_intt_o_data_a[47
    ],u_intt_o_data_a[46],u_intt_o_data_a[45],u_intt_o_data_a[44],u_intt_o_data_a[43],lo_lo_1}; // @[Common.scala 26:15]
  wire [8:0] hi_lo_1 = {u_intt_o_data_a[60],u_intt_o_data_a[59],u_intt_o_data_a[58],u_intt_o_data_a[57],u_intt_o_data_a[
    56],u_intt_o_data_a[55],u_intt_o_data_a[54],u_intt_o_data_a[53],u_intt_o_data_a[52]}; // @[Common.scala 26:15]
  wire [17:0] hi_1 = {u_intt_o_data_a[69],u_intt_o_data_a[68],u_intt_o_data_a[67],u_intt_o_data_a[66],u_intt_o_data_a[65
    ],u_intt_o_data_a[64],u_intt_o_data_a[63],u_intt_o_data_a[62],u_intt_o_data_a[61],hi_lo_1}; // @[Common.scala 26:15]
  wire [7:0] lo_lo_2 = {u_intt_o_data_a[77],u_intt_o_data_a[76],u_intt_o_data_a[75],u_intt_o_data_a[74],u_intt_o_data_a[
    73],u_intt_o_data_a[72],u_intt_o_data_a[71],u_intt_o_data_a[70]}; // @[Common.scala 26:15]
  wire [16:0] lo_2 = {u_intt_o_data_a[86],u_intt_o_data_a[85],u_intt_o_data_a[84],u_intt_o_data_a[83],u_intt_o_data_a[82
    ],u_intt_o_data_a[81],u_intt_o_data_a[80],u_intt_o_data_a[79],u_intt_o_data_a[78],lo_lo_2}; // @[Common.scala 26:15]
  wire [8:0] hi_lo_2 = {u_intt_o_data_a[95],u_intt_o_data_a[94],u_intt_o_data_a[93],u_intt_o_data_a[92],u_intt_o_data_a[
    91],u_intt_o_data_a[90],u_intt_o_data_a[89],u_intt_o_data_a[88],u_intt_o_data_a[87]}; // @[Common.scala 26:15]
  wire [17:0] hi_2 = {u_intt_o_data_a[104],u_intt_o_data_a[103],u_intt_o_data_a[102],u_intt_o_data_a[101],
    u_intt_o_data_a[100],u_intt_o_data_a[99],u_intt_o_data_a[98],u_intt_o_data_a[97],u_intt_o_data_a[96],hi_lo_2}; // @[Common.scala 26:15]
  wire [7:0] lo_lo_3 = {u_intt_o_data_a[112],u_intt_o_data_a[111],u_intt_o_data_a[110],u_intt_o_data_a[109],
    u_intt_o_data_a[108],u_intt_o_data_a[107],u_intt_o_data_a[106],u_intt_o_data_a[105]}; // @[Common.scala 26:15]
  wire [16:0] lo_3 = {u_intt_o_data_a[121],u_intt_o_data_a[120],u_intt_o_data_a[119],u_intt_o_data_a[118],
    u_intt_o_data_a[117],u_intt_o_data_a[116],u_intt_o_data_a[115],u_intt_o_data_a[114],u_intt_o_data_a[113],lo_lo_3}; // @[Common.scala 26:15]
  wire [8:0] hi_lo_3 = {u_intt_o_data_a[130],u_intt_o_data_a[129],u_intt_o_data_a[128],u_intt_o_data_a[127],
    u_intt_o_data_a[126],u_intt_o_data_a[125],u_intt_o_data_a[124],u_intt_o_data_a[123],u_intt_o_data_a[122]}; // @[Common.scala 26:15]
  wire [17:0] hi_3 = {u_intt_o_data_a[139],u_intt_o_data_a[138],u_intt_o_data_a[137],u_intt_o_data_a[136],
    u_intt_o_data_a[135],u_intt_o_data_a[134],u_intt_o_data_a[133],u_intt_o_data_a[132],u_intt_o_data_a[131],hi_lo_3}; // @[Common.scala 26:15]
  wire [7:0] lo_lo_4 = {u_intt_o_data_a[147],u_intt_o_data_a[146],u_intt_o_data_a[145],u_intt_o_data_a[144],
    u_intt_o_data_a[143],u_intt_o_data_a[142],u_intt_o_data_a[141],u_intt_o_data_a[140]}; // @[Common.scala 26:15]
  wire [16:0] lo_4 = {u_intt_o_data_a[156],u_intt_o_data_a[155],u_intt_o_data_a[154],u_intt_o_data_a[153],
    u_intt_o_data_a[152],u_intt_o_data_a[151],u_intt_o_data_a[150],u_intt_o_data_a[149],u_intt_o_data_a[148],lo_lo_4}; // @[Common.scala 26:15]
  wire [8:0] hi_lo_4 = {u_intt_o_data_a[165],u_intt_o_data_a[164],u_intt_o_data_a[163],u_intt_o_data_a[162],
    u_intt_o_data_a[161],u_intt_o_data_a[160],u_intt_o_data_a[159],u_intt_o_data_a[158],u_intt_o_data_a[157]}; // @[Common.scala 26:15]
  wire [17:0] hi_4 = {u_intt_o_data_a[174],u_intt_o_data_a[173],u_intt_o_data_a[172],u_intt_o_data_a[171],
    u_intt_o_data_a[170],u_intt_o_data_a[169],u_intt_o_data_a[168],u_intt_o_data_a[167],u_intt_o_data_a[166],hi_lo_4}; // @[Common.scala 26:15]
  wire [7:0] lo_lo_5 = {u_intt_o_data_a[182],u_intt_o_data_a[181],u_intt_o_data_a[180],u_intt_o_data_a[179],
    u_intt_o_data_a[178],u_intt_o_data_a[177],u_intt_o_data_a[176],u_intt_o_data_a[175]}; // @[Common.scala 26:15]
  wire [16:0] lo_5 = {u_intt_o_data_a[191],u_intt_o_data_a[190],u_intt_o_data_a[189],u_intt_o_data_a[188],
    u_intt_o_data_a[187],u_intt_o_data_a[186],u_intt_o_data_a[185],u_intt_o_data_a[184],u_intt_o_data_a[183],lo_lo_5}; // @[Common.scala 26:15]
  wire [8:0] hi_lo_5 = {u_intt_o_data_a[200],u_intt_o_data_a[199],u_intt_o_data_a[198],u_intt_o_data_a[197],
    u_intt_o_data_a[196],u_intt_o_data_a[195],u_intt_o_data_a[194],u_intt_o_data_a[193],u_intt_o_data_a[192]}; // @[Common.scala 26:15]
  wire [17:0] hi_5 = {u_intt_o_data_a[209],u_intt_o_data_a[208],u_intt_o_data_a[207],u_intt_o_data_a[206],
    u_intt_o_data_a[205],u_intt_o_data_a[204],u_intt_o_data_a[203],u_intt_o_data_a[202],u_intt_o_data_a[201],hi_lo_5}; // @[Common.scala 26:15]
  wire [7:0] lo_lo_6 = {u_intt_o_data_a[217],u_intt_o_data_a[216],u_intt_o_data_a[215],u_intt_o_data_a[214],
    u_intt_o_data_a[213],u_intt_o_data_a[212],u_intt_o_data_a[211],u_intt_o_data_a[210]}; // @[Common.scala 26:15]
  wire [16:0] lo_6 = {u_intt_o_data_a[226],u_intt_o_data_a[225],u_intt_o_data_a[224],u_intt_o_data_a[223],
    u_intt_o_data_a[222],u_intt_o_data_a[221],u_intt_o_data_a[220],u_intt_o_data_a[219],u_intt_o_data_a[218],lo_lo_6}; // @[Common.scala 26:15]
  wire [8:0] hi_lo_6 = {u_intt_o_data_a[235],u_intt_o_data_a[234],u_intt_o_data_a[233],u_intt_o_data_a[232],
    u_intt_o_data_a[231],u_intt_o_data_a[230],u_intt_o_data_a[229],u_intt_o_data_a[228],u_intt_o_data_a[227]}; // @[Common.scala 26:15]
  wire [17:0] hi_6 = {u_intt_o_data_a[244],u_intt_o_data_a[243],u_intt_o_data_a[242],u_intt_o_data_a[241],
    u_intt_o_data_a[240],u_intt_o_data_a[239],u_intt_o_data_a[238],u_intt_o_data_a[237],u_intt_o_data_a[236],hi_lo_6}; // @[Common.scala 26:15]
  wire [7:0] lo_lo_7 = {u_intt_o_data_a[252],u_intt_o_data_a[251],u_intt_o_data_a[250],u_intt_o_data_a[249],
    u_intt_o_data_a[248],u_intt_o_data_a[247],u_intt_o_data_a[246],u_intt_o_data_a[245]}; // @[Common.scala 26:15]
  wire [16:0] lo_7 = {u_intt_o_data_a[261],u_intt_o_data_a[260],u_intt_o_data_a[259],u_intt_o_data_a[258],
    u_intt_o_data_a[257],u_intt_o_data_a[256],u_intt_o_data_a[255],u_intt_o_data_a[254],u_intt_o_data_a[253],lo_lo_7}; // @[Common.scala 26:15]
  wire [8:0] hi_lo_7 = {u_intt_o_data_a[270],u_intt_o_data_a[269],u_intt_o_data_a[268],u_intt_o_data_a[267],
    u_intt_o_data_a[266],u_intt_o_data_a[265],u_intt_o_data_a[264],u_intt_o_data_a[263],u_intt_o_data_a[262]}; // @[Common.scala 26:15]
  wire [17:0] hi_7 = {u_intt_o_data_a[279],u_intt_o_data_a[278],u_intt_o_data_a[277],u_intt_o_data_a[276],
    u_intt_o_data_a[275],u_intt_o_data_a[274],u_intt_o_data_a[273],u_intt_o_data_a[272],u_intt_o_data_a[271],hi_lo_7}; // @[Common.scala 26:15]
  wire [139:0] u_intt_io_i_data_b_l_lo = {io_rd_l_data_3,io_rd_l_data_2,io_rd_l_data_1,io_rd_l_data_0}; // @[INTT.scala 65:45]
  wire [139:0] u_intt_io_i_data_b_l_hi = {io_rd_l_data_7,io_rd_l_data_6,io_rd_l_data_5,io_rd_l_data_4}; // @[INTT.scala 65:45]
  wire [139:0] u_intt_io_i_data_b_r_lo = {io_rd_r_data_3,io_rd_r_data_2,io_rd_r_data_1,io_rd_r_data_0}; // @[INTT.scala 68:45]
  wire [139:0] u_intt_io_i_data_b_r_hi = {io_rd_r_data_7,io_rd_r_data_6,io_rd_r_data_5,io_rd_r_data_4}; // @[INTT.scala 68:45]
  intt_core #(.COE_WIDTH(35), .Q_TYPE(0), .COMMON_BRAM_DELAY(1)) u_intt ( // @[INTT.scala 47:24]
    .clk(u_intt_clk),
    .rst_n(u_intt_rst_n),
    .ntt_start(u_intt_ntt_start),
    .ntt_done(u_intt_ntt_done),
    .i_data_b_l(u_intt_i_data_b_l),
    .i_data_b_r(u_intt_i_data_b_r),
    .o_data_a(u_intt_o_data_a),
    .o_we_a_l(u_intt_o_we_a_l),
    .o_we_a_r(u_intt_o_we_a_r),
    .o_addr_a_l(u_intt_o_addr_a_l),
    .o_addr_a_r(u_intt_o_addr_a_r),
    .o_addr_b_l(u_intt_o_addr_b_l),
    .o_addr_b_r(u_intt_o_addr_b_r),
    .o_we_result(u_intt_o_we_result)
  );
  assign io_ntt_done = u_intt_ntt_done; // @[INTT.scala 54:21]
  assign io_wr_l_en_0 = u_intt_o_we_a_l; // @[Common.scala 31:{16,16}]
  assign io_wr_l_en_1 = u_intt_o_we_a_l; // @[Common.scala 31:{16,16}]
  assign io_wr_l_en_2 = u_intt_o_we_a_l; // @[Common.scala 31:{16,16}]
  assign io_wr_l_en_3 = u_intt_o_we_a_l; // @[Common.scala 31:{16,16}]
  assign io_wr_l_en_4 = u_intt_o_we_a_l; // @[Common.scala 31:{16,16}]
  assign io_wr_l_en_5 = u_intt_o_we_a_l; // @[Common.scala 31:{16,16}]
  assign io_wr_l_en_6 = u_intt_o_we_a_l; // @[Common.scala 31:{16,16}]
  assign io_wr_l_en_7 = u_intt_o_we_a_l; // @[Common.scala 31:{16,16}]
  assign io_wr_l_addr_0 = u_intt_o_addr_a_l; // @[Common.scala 31:{16,16}]
  assign io_wr_l_addr_1 = u_intt_o_addr_a_l; // @[Common.scala 31:{16,16}]
  assign io_wr_l_addr_2 = u_intt_o_addr_a_l; // @[Common.scala 31:{16,16}]
  assign io_wr_l_addr_3 = u_intt_o_addr_a_l; // @[Common.scala 31:{16,16}]
  assign io_wr_l_addr_4 = u_intt_o_addr_a_l; // @[Common.scala 31:{16,16}]
  assign io_wr_l_addr_5 = u_intt_o_addr_a_l; // @[Common.scala 31:{16,16}]
  assign io_wr_l_addr_6 = u_intt_o_addr_a_l; // @[Common.scala 31:{16,16}]
  assign io_wr_l_addr_7 = u_intt_o_addr_a_l; // @[Common.scala 31:{16,16}]
  assign io_wr_l_data_0 = {hi,lo}; // @[Common.scala 26:15]
  assign io_wr_l_data_1 = {hi_1,lo_1}; // @[Common.scala 26:15]
  assign io_wr_l_data_2 = {hi_2,lo_2}; // @[Common.scala 26:15]
  assign io_wr_l_data_3 = {hi_3,lo_3}; // @[Common.scala 26:15]
  assign io_wr_l_data_4 = {hi_4,lo_4}; // @[Common.scala 26:15]
  assign io_wr_l_data_5 = {hi_5,lo_5}; // @[Common.scala 26:15]
  assign io_wr_l_data_6 = {hi_6,lo_6}; // @[Common.scala 26:15]
  assign io_wr_l_data_7 = {hi_7,lo_7}; // @[Common.scala 26:15]
  assign io_wr_r_en_0 = u_intt_o_we_a_r; // @[Common.scala 31:{16,16}]
  assign io_wr_r_en_1 = u_intt_o_we_a_r; // @[Common.scala 31:{16,16}]
  assign io_wr_r_en_2 = u_intt_o_we_a_r; // @[Common.scala 31:{16,16}]
  assign io_wr_r_en_3 = u_intt_o_we_a_r; // @[Common.scala 31:{16,16}]
  assign io_wr_r_en_4 = u_intt_o_we_a_r; // @[Common.scala 31:{16,16}]
  assign io_wr_r_en_5 = u_intt_o_we_a_r; // @[Common.scala 31:{16,16}]
  assign io_wr_r_en_6 = u_intt_o_we_a_r; // @[Common.scala 31:{16,16}]
  assign io_wr_r_en_7 = u_intt_o_we_a_r; // @[Common.scala 31:{16,16}]
  assign io_wr_r_addr_0 = u_intt_o_addr_a_r; // @[Common.scala 31:{16,16}]
  assign io_wr_r_addr_1 = u_intt_o_addr_a_r; // @[Common.scala 31:{16,16}]
  assign io_wr_r_addr_2 = u_intt_o_addr_a_r; // @[Common.scala 31:{16,16}]
  assign io_wr_r_addr_3 = u_intt_o_addr_a_r; // @[Common.scala 31:{16,16}]
  assign io_wr_r_addr_4 = u_intt_o_addr_a_r; // @[Common.scala 31:{16,16}]
  assign io_wr_r_addr_5 = u_intt_o_addr_a_r; // @[Common.scala 31:{16,16}]
  assign io_wr_r_addr_6 = u_intt_o_addr_a_r; // @[Common.scala 31:{16,16}]
  assign io_wr_r_addr_7 = u_intt_o_addr_a_r; // @[Common.scala 31:{16,16}]
  assign io_wr_r_data_0 = {hi,lo}; // @[Common.scala 26:15]
  assign io_wr_r_data_1 = {hi_1,lo_1}; // @[Common.scala 26:15]
  assign io_wr_r_data_2 = {hi_2,lo_2}; // @[Common.scala 26:15]
  assign io_wr_r_data_3 = {hi_3,lo_3}; // @[Common.scala 26:15]
  assign io_wr_r_data_4 = {hi_4,lo_4}; // @[Common.scala 26:15]
  assign io_wr_r_data_5 = {hi_5,lo_5}; // @[Common.scala 26:15]
  assign io_wr_r_data_6 = {hi_6,lo_6}; // @[Common.scala 26:15]
  assign io_wr_r_data_7 = {hi_7,lo_7}; // @[Common.scala 26:15]
  assign io_rd_l_addr_0 = u_intt_o_addr_b_l; // @[Common.scala 31:{16,16}]
  assign io_rd_l_addr_1 = u_intt_o_addr_b_l; // @[Common.scala 31:{16,16}]
  assign io_rd_l_addr_2 = u_intt_o_addr_b_l; // @[Common.scala 31:{16,16}]
  assign io_rd_l_addr_3 = u_intt_o_addr_b_l; // @[Common.scala 31:{16,16}]
  assign io_rd_l_addr_4 = u_intt_o_addr_b_l; // @[Common.scala 31:{16,16}]
  assign io_rd_l_addr_5 = u_intt_o_addr_b_l; // @[Common.scala 31:{16,16}]
  assign io_rd_l_addr_6 = u_intt_o_addr_b_l; // @[Common.scala 31:{16,16}]
  assign io_rd_l_addr_7 = u_intt_o_addr_b_l; // @[Common.scala 31:{16,16}]
  assign io_rd_r_addr_0 = u_intt_o_addr_b_r; // @[Common.scala 31:{16,16}]
  assign io_rd_r_addr_1 = u_intt_o_addr_b_r; // @[Common.scala 31:{16,16}]
  assign io_rd_r_addr_2 = u_intt_o_addr_b_r; // @[Common.scala 31:{16,16}]
  assign io_rd_r_addr_3 = u_intt_o_addr_b_r; // @[Common.scala 31:{16,16}]
  assign io_rd_r_addr_4 = u_intt_o_addr_b_r; // @[Common.scala 31:{16,16}]
  assign io_rd_r_addr_5 = u_intt_o_addr_b_r; // @[Common.scala 31:{16,16}]
  assign io_rd_r_addr_6 = u_intt_o_addr_b_r; // @[Common.scala 31:{16,16}]
  assign io_rd_r_addr_7 = u_intt_o_addr_b_r; // @[Common.scala 31:{16,16}]
  assign io_o_we_result = u_intt_o_we_result; // @[INTT.scala 51:20]
  assign u_intt_clk = clock; // @[INTT.scala 49:21]
  assign u_intt_rst_n = ~reset; // @[INTT.scala 50:24]
  assign u_intt_ntt_start = io_ntt_start; // @[INTT.scala 53:21]
  assign u_intt_i_data_b_l = {u_intt_io_i_data_b_l_hi,u_intt_io_i_data_b_l_lo}; // @[INTT.scala 65:45]
  assign u_intt_i_data_b_r = {u_intt_io_i_data_b_r_hi,u_intt_io_i_data_b_r_lo}; // @[INTT.scala 68:45]
endmodule
module triple_pp_buffer_35_512_8(
  input         clock,
  input         reset,
  input         io_i_done,
  input  [8:0]  io_polyvec0_rd_addr_0,
  input  [8:0]  io_polyvec0_rd_addr_1,
  input  [8:0]  io_polyvec0_rd_addr_2,
  input  [8:0]  io_polyvec0_rd_addr_3,
  input  [8:0]  io_polyvec0_rd_addr_4,
  input  [8:0]  io_polyvec0_rd_addr_5,
  input  [8:0]  io_polyvec0_rd_addr_6,
  input  [8:0]  io_polyvec0_rd_addr_7,
  output [34:0] io_polyvec0_rd_data_0,
  output [34:0] io_polyvec0_rd_data_1,
  output [34:0] io_polyvec0_rd_data_2,
  output [34:0] io_polyvec0_rd_data_3,
  output [34:0] io_polyvec0_rd_data_4,
  output [34:0] io_polyvec0_rd_data_5,
  output [34:0] io_polyvec0_rd_data_6,
  output [34:0] io_polyvec0_rd_data_7,
  input         io_polyvec0_wr_en_0,
  input         io_polyvec0_wr_en_1,
  input         io_polyvec0_wr_en_2,
  input         io_polyvec0_wr_en_3,
  input         io_polyvec0_wr_en_4,
  input         io_polyvec0_wr_en_5,
  input         io_polyvec0_wr_en_6,
  input         io_polyvec0_wr_en_7,
  input  [8:0]  io_polyvec0_wr_addr_0,
  input  [8:0]  io_polyvec0_wr_addr_1,
  input  [8:0]  io_polyvec0_wr_addr_2,
  input  [8:0]  io_polyvec0_wr_addr_3,
  input  [8:0]  io_polyvec0_wr_addr_4,
  input  [8:0]  io_polyvec0_wr_addr_5,
  input  [8:0]  io_polyvec0_wr_addr_6,
  input  [8:0]  io_polyvec0_wr_addr_7,
  input  [34:0] io_polyvec0_wr_data_0,
  input  [34:0] io_polyvec0_wr_data_1,
  input  [34:0] io_polyvec0_wr_data_2,
  input  [34:0] io_polyvec0_wr_data_3,
  input  [34:0] io_polyvec0_wr_data_4,
  input  [34:0] io_polyvec0_wr_data_5,
  input  [34:0] io_polyvec0_wr_data_6,
  input  [34:0] io_polyvec0_wr_data_7,
  input  [8:0]  io_polyvec1_rd_addr_0,
  input  [8:0]  io_polyvec1_rd_addr_1,
  input  [8:0]  io_polyvec1_rd_addr_2,
  input  [8:0]  io_polyvec1_rd_addr_3,
  input  [8:0]  io_polyvec1_rd_addr_4,
  input  [8:0]  io_polyvec1_rd_addr_5,
  input  [8:0]  io_polyvec1_rd_addr_6,
  input  [8:0]  io_polyvec1_rd_addr_7,
  output [34:0] io_polyvec1_rd_data_0,
  output [34:0] io_polyvec1_rd_data_1,
  output [34:0] io_polyvec1_rd_data_2,
  output [34:0] io_polyvec1_rd_data_3,
  output [34:0] io_polyvec1_rd_data_4,
  output [34:0] io_polyvec1_rd_data_5,
  output [34:0] io_polyvec1_rd_data_6,
  output [34:0] io_polyvec1_rd_data_7,
  input         io_polyvec1_wr_en_0,
  input         io_polyvec1_wr_en_1,
  input         io_polyvec1_wr_en_2,
  input         io_polyvec1_wr_en_3,
  input         io_polyvec1_wr_en_4,
  input         io_polyvec1_wr_en_5,
  input         io_polyvec1_wr_en_6,
  input         io_polyvec1_wr_en_7,
  input  [8:0]  io_polyvec1_wr_addr_0,
  input  [8:0]  io_polyvec1_wr_addr_1,
  input  [8:0]  io_polyvec1_wr_addr_2,
  input  [8:0]  io_polyvec1_wr_addr_3,
  input  [8:0]  io_polyvec1_wr_addr_4,
  input  [8:0]  io_polyvec1_wr_addr_5,
  input  [8:0]  io_polyvec1_wr_addr_6,
  input  [8:0]  io_polyvec1_wr_addr_7,
  input  [34:0] io_polyvec1_wr_data_0,
  input  [34:0] io_polyvec1_wr_data_1,
  input  [34:0] io_polyvec1_wr_data_2,
  input  [34:0] io_polyvec1_wr_data_3,
  input  [34:0] io_polyvec1_wr_data_4,
  input  [34:0] io_polyvec1_wr_data_5,
  input  [34:0] io_polyvec1_wr_data_6,
  input  [34:0] io_polyvec1_wr_data_7,
  output [8:0]  io_banks_rd_0_addr_0,
  output [8:0]  io_banks_rd_0_addr_1,
  output [8:0]  io_banks_rd_0_addr_2,
  output [8:0]  io_banks_rd_0_addr_3,
  output [8:0]  io_banks_rd_0_addr_4,
  output [8:0]  io_banks_rd_0_addr_5,
  output [8:0]  io_banks_rd_0_addr_6,
  output [8:0]  io_banks_rd_0_addr_7,
  input  [34:0] io_banks_rd_0_data_0,
  input  [34:0] io_banks_rd_0_data_1,
  input  [34:0] io_banks_rd_0_data_2,
  input  [34:0] io_banks_rd_0_data_3,
  input  [34:0] io_banks_rd_0_data_4,
  input  [34:0] io_banks_rd_0_data_5,
  input  [34:0] io_banks_rd_0_data_6,
  input  [34:0] io_banks_rd_0_data_7,
  output [8:0]  io_banks_rd_1_addr_0,
  output [8:0]  io_banks_rd_1_addr_1,
  output [8:0]  io_banks_rd_1_addr_2,
  output [8:0]  io_banks_rd_1_addr_3,
  output [8:0]  io_banks_rd_1_addr_4,
  output [8:0]  io_banks_rd_1_addr_5,
  output [8:0]  io_banks_rd_1_addr_6,
  output [8:0]  io_banks_rd_1_addr_7,
  input  [34:0] io_banks_rd_1_data_0,
  input  [34:0] io_banks_rd_1_data_1,
  input  [34:0] io_banks_rd_1_data_2,
  input  [34:0] io_banks_rd_1_data_3,
  input  [34:0] io_banks_rd_1_data_4,
  input  [34:0] io_banks_rd_1_data_5,
  input  [34:0] io_banks_rd_1_data_6,
  input  [34:0] io_banks_rd_1_data_7,
  output [8:0]  io_banks_rd_2_addr_0,
  output [8:0]  io_banks_rd_2_addr_1,
  output [8:0]  io_banks_rd_2_addr_2,
  output [8:0]  io_banks_rd_2_addr_3,
  output [8:0]  io_banks_rd_2_addr_4,
  output [8:0]  io_banks_rd_2_addr_5,
  output [8:0]  io_banks_rd_2_addr_6,
  output [8:0]  io_banks_rd_2_addr_7,
  input  [34:0] io_banks_rd_2_data_0,
  input  [34:0] io_banks_rd_2_data_1,
  input  [34:0] io_banks_rd_2_data_2,
  input  [34:0] io_banks_rd_2_data_3,
  input  [34:0] io_banks_rd_2_data_4,
  input  [34:0] io_banks_rd_2_data_5,
  input  [34:0] io_banks_rd_2_data_6,
  input  [34:0] io_banks_rd_2_data_7,
  output        io_banks_wr_0_en_0,
  output        io_banks_wr_0_en_1,
  output        io_banks_wr_0_en_2,
  output        io_banks_wr_0_en_3,
  output        io_banks_wr_0_en_4,
  output        io_banks_wr_0_en_5,
  output        io_banks_wr_0_en_6,
  output        io_banks_wr_0_en_7,
  output [8:0]  io_banks_wr_0_addr_0,
  output [8:0]  io_banks_wr_0_addr_1,
  output [8:0]  io_banks_wr_0_addr_2,
  output [8:0]  io_banks_wr_0_addr_3,
  output [8:0]  io_banks_wr_0_addr_4,
  output [8:0]  io_banks_wr_0_addr_5,
  output [8:0]  io_banks_wr_0_addr_6,
  output [8:0]  io_banks_wr_0_addr_7,
  output [34:0] io_banks_wr_0_data_0,
  output [34:0] io_banks_wr_0_data_1,
  output [34:0] io_banks_wr_0_data_2,
  output [34:0] io_banks_wr_0_data_3,
  output [34:0] io_banks_wr_0_data_4,
  output [34:0] io_banks_wr_0_data_5,
  output [34:0] io_banks_wr_0_data_6,
  output [34:0] io_banks_wr_0_data_7,
  output        io_banks_wr_1_en_0,
  output        io_banks_wr_1_en_1,
  output        io_banks_wr_1_en_2,
  output        io_banks_wr_1_en_3,
  output        io_banks_wr_1_en_4,
  output        io_banks_wr_1_en_5,
  output        io_banks_wr_1_en_6,
  output        io_banks_wr_1_en_7,
  output [8:0]  io_banks_wr_1_addr_0,
  output [8:0]  io_banks_wr_1_addr_1,
  output [8:0]  io_banks_wr_1_addr_2,
  output [8:0]  io_banks_wr_1_addr_3,
  output [8:0]  io_banks_wr_1_addr_4,
  output [8:0]  io_banks_wr_1_addr_5,
  output [8:0]  io_banks_wr_1_addr_6,
  output [8:0]  io_banks_wr_1_addr_7,
  output [34:0] io_banks_wr_1_data_0,
  output [34:0] io_banks_wr_1_data_1,
  output [34:0] io_banks_wr_1_data_2,
  output [34:0] io_banks_wr_1_data_3,
  output [34:0] io_banks_wr_1_data_4,
  output [34:0] io_banks_wr_1_data_5,
  output [34:0] io_banks_wr_1_data_6,
  output [34:0] io_banks_wr_1_data_7,
  output        io_banks_wr_2_en_0,
  output        io_banks_wr_2_en_1,
  output        io_banks_wr_2_en_2,
  output        io_banks_wr_2_en_3,
  output        io_banks_wr_2_en_4,
  output        io_banks_wr_2_en_5,
  output        io_banks_wr_2_en_6,
  output        io_banks_wr_2_en_7,
  output [8:0]  io_banks_wr_2_addr_0,
  output [8:0]  io_banks_wr_2_addr_1,
  output [8:0]  io_banks_wr_2_addr_2,
  output [8:0]  io_banks_wr_2_addr_3,
  output [8:0]  io_banks_wr_2_addr_4,
  output [8:0]  io_banks_wr_2_addr_5,
  output [8:0]  io_banks_wr_2_addr_6,
  output [8:0]  io_banks_wr_2_addr_7,
  output [34:0] io_banks_wr_2_data_0,
  output [34:0] io_banks_wr_2_data_1,
  output [34:0] io_banks_wr_2_data_2,
  output [34:0] io_banks_wr_2_data_3,
  output [34:0] io_banks_wr_2_data_4,
  output [34:0] io_banks_wr_2_data_5,
  output [34:0] io_banks_wr_2_data_6,
  output [34:0] io_banks_wr_2_data_7
);
  reg  done_r; // @[Buffer.scala 125:23]
  reg [1:0] state; // @[Buffer.scala 128:22]
  wire  _state_T = 2'h0 == state; // @[Mux.scala 81:61]
  wire [1:0] _state_T_1 = 2'h0 == state ? 2'h1 : 2'h0; // @[Mux.scala 81:58]
  wire  _state_T_2 = 2'h1 == state; // @[Mux.scala 81:61]
  wire  _state_T_4 = 2'h2 == state; // @[Mux.scala 81:61]
  wire [8:0] _GEN_1 = _state_T_4 ? io_polyvec0_rd_addr_0 : 9'h0; // @[Buffer.scala 160:10 147:13 167:17]
  wire [8:0] _GEN_2 = _state_T_4 ? io_polyvec0_rd_addr_1 : 9'h0; // @[Buffer.scala 160:10 147:13 167:17]
  wire [8:0] _GEN_3 = _state_T_4 ? io_polyvec0_rd_addr_2 : 9'h0; // @[Buffer.scala 160:10 147:13 167:17]
  wire [8:0] _GEN_4 = _state_T_4 ? io_polyvec0_rd_addr_3 : 9'h0; // @[Buffer.scala 160:10 147:13 167:17]
  wire [8:0] _GEN_5 = _state_T_4 ? io_polyvec0_rd_addr_4 : 9'h0; // @[Buffer.scala 160:10 147:13 167:17]
  wire [8:0] _GEN_6 = _state_T_4 ? io_polyvec0_rd_addr_5 : 9'h0; // @[Buffer.scala 160:10 147:13 167:17]
  wire [8:0] _GEN_7 = _state_T_4 ? io_polyvec0_rd_addr_6 : 9'h0; // @[Buffer.scala 160:10 147:13 167:17]
  wire [8:0] _GEN_8 = _state_T_4 ? io_polyvec0_rd_addr_7 : 9'h0; // @[Buffer.scala 160:10 147:13 167:17]
  wire [34:0] _GEN_9 = _state_T_4 ? io_banks_rd_1_data_0 : 35'h0; // @[Buffer.scala 160:10 167:17 150:23]
  wire [34:0] _GEN_10 = _state_T_4 ? io_banks_rd_1_data_1 : 35'h0; // @[Buffer.scala 160:10 167:17 150:23]
  wire [34:0] _GEN_11 = _state_T_4 ? io_banks_rd_1_data_2 : 35'h0; // @[Buffer.scala 160:10 167:17 150:23]
  wire [34:0] _GEN_12 = _state_T_4 ? io_banks_rd_1_data_3 : 35'h0; // @[Buffer.scala 160:10 167:17 150:23]
  wire [34:0] _GEN_13 = _state_T_4 ? io_banks_rd_1_data_4 : 35'h0; // @[Buffer.scala 160:10 167:17 150:23]
  wire [34:0] _GEN_14 = _state_T_4 ? io_banks_rd_1_data_5 : 35'h0; // @[Buffer.scala 160:10 167:17 150:23]
  wire [34:0] _GEN_15 = _state_T_4 ? io_banks_rd_1_data_6 : 35'h0; // @[Buffer.scala 160:10 167:17 150:23]
  wire [34:0] _GEN_16 = _state_T_4 ? io_banks_rd_1_data_7 : 35'h0; // @[Buffer.scala 160:10 167:17 150:23]
  wire  _GEN_17 = _state_T_4 & io_polyvec0_wr_en_0; // @[Buffer.scala 161:10 142:13 167:17]
  wire  _GEN_18 = _state_T_4 & io_polyvec0_wr_en_1; // @[Buffer.scala 161:10 142:13 167:17]
  wire  _GEN_19 = _state_T_4 & io_polyvec0_wr_en_2; // @[Buffer.scala 161:10 142:13 167:17]
  wire  _GEN_20 = _state_T_4 & io_polyvec0_wr_en_3; // @[Buffer.scala 161:10 142:13 167:17]
  wire  _GEN_21 = _state_T_4 & io_polyvec0_wr_en_4; // @[Buffer.scala 161:10 142:13 167:17]
  wire  _GEN_22 = _state_T_4 & io_polyvec0_wr_en_5; // @[Buffer.scala 161:10 142:13 167:17]
  wire  _GEN_23 = _state_T_4 & io_polyvec0_wr_en_6; // @[Buffer.scala 161:10 142:13 167:17]
  wire  _GEN_24 = _state_T_4 & io_polyvec0_wr_en_7; // @[Buffer.scala 161:10 142:13 167:17]
  wire [8:0] _GEN_25 = _state_T_4 ? io_polyvec0_wr_addr_0 : 9'h0; // @[Buffer.scala 161:10 143:13 167:17]
  wire [8:0] _GEN_26 = _state_T_4 ? io_polyvec0_wr_addr_1 : 9'h0; // @[Buffer.scala 161:10 143:13 167:17]
  wire [8:0] _GEN_27 = _state_T_4 ? io_polyvec0_wr_addr_2 : 9'h0; // @[Buffer.scala 161:10 143:13 167:17]
  wire [8:0] _GEN_28 = _state_T_4 ? io_polyvec0_wr_addr_3 : 9'h0; // @[Buffer.scala 161:10 143:13 167:17]
  wire [8:0] _GEN_29 = _state_T_4 ? io_polyvec0_wr_addr_4 : 9'h0; // @[Buffer.scala 161:10 143:13 167:17]
  wire [8:0] _GEN_30 = _state_T_4 ? io_polyvec0_wr_addr_5 : 9'h0; // @[Buffer.scala 161:10 143:13 167:17]
  wire [8:0] _GEN_31 = _state_T_4 ? io_polyvec0_wr_addr_6 : 9'h0; // @[Buffer.scala 161:10 143:13 167:17]
  wire [8:0] _GEN_32 = _state_T_4 ? io_polyvec0_wr_addr_7 : 9'h0; // @[Buffer.scala 161:10 143:13 167:17]
  wire [34:0] _GEN_33 = _state_T_4 ? io_polyvec0_wr_data_0 : 35'h0; // @[Buffer.scala 161:10 144:13 167:17]
  wire [34:0] _GEN_34 = _state_T_4 ? io_polyvec0_wr_data_1 : 35'h0; // @[Buffer.scala 161:10 144:13 167:17]
  wire [34:0] _GEN_35 = _state_T_4 ? io_polyvec0_wr_data_2 : 35'h0; // @[Buffer.scala 161:10 144:13 167:17]
  wire [34:0] _GEN_36 = _state_T_4 ? io_polyvec0_wr_data_3 : 35'h0; // @[Buffer.scala 161:10 144:13 167:17]
  wire [34:0] _GEN_37 = _state_T_4 ? io_polyvec0_wr_data_4 : 35'h0; // @[Buffer.scala 161:10 144:13 167:17]
  wire [34:0] _GEN_38 = _state_T_4 ? io_polyvec0_wr_data_5 : 35'h0; // @[Buffer.scala 161:10 144:13 167:17]
  wire [34:0] _GEN_39 = _state_T_4 ? io_polyvec0_wr_data_6 : 35'h0; // @[Buffer.scala 161:10 144:13 167:17]
  wire [34:0] _GEN_40 = _state_T_4 ? io_polyvec0_wr_data_7 : 35'h0; // @[Buffer.scala 161:10 144:13 167:17]
  wire [8:0] _GEN_41 = _state_T_4 ? io_polyvec1_rd_addr_0 : 9'h0; // @[Buffer.scala 160:10 147:13 167:17]
  wire [8:0] _GEN_42 = _state_T_4 ? io_polyvec1_rd_addr_1 : 9'h0; // @[Buffer.scala 160:10 147:13 167:17]
  wire [8:0] _GEN_43 = _state_T_4 ? io_polyvec1_rd_addr_2 : 9'h0; // @[Buffer.scala 160:10 147:13 167:17]
  wire [8:0] _GEN_44 = _state_T_4 ? io_polyvec1_rd_addr_3 : 9'h0; // @[Buffer.scala 160:10 147:13 167:17]
  wire [8:0] _GEN_45 = _state_T_4 ? io_polyvec1_rd_addr_4 : 9'h0; // @[Buffer.scala 160:10 147:13 167:17]
  wire [8:0] _GEN_46 = _state_T_4 ? io_polyvec1_rd_addr_5 : 9'h0; // @[Buffer.scala 160:10 147:13 167:17]
  wire [8:0] _GEN_47 = _state_T_4 ? io_polyvec1_rd_addr_6 : 9'h0; // @[Buffer.scala 160:10 147:13 167:17]
  wire [8:0] _GEN_48 = _state_T_4 ? io_polyvec1_rd_addr_7 : 9'h0; // @[Buffer.scala 160:10 147:13 167:17]
  wire [34:0] _GEN_49 = _state_T_4 ? io_banks_rd_2_data_0 : 35'h0; // @[Buffer.scala 160:10 167:17 151:23]
  wire [34:0] _GEN_50 = _state_T_4 ? io_banks_rd_2_data_1 : 35'h0; // @[Buffer.scala 160:10 167:17 151:23]
  wire [34:0] _GEN_51 = _state_T_4 ? io_banks_rd_2_data_2 : 35'h0; // @[Buffer.scala 160:10 167:17 151:23]
  wire [34:0] _GEN_52 = _state_T_4 ? io_banks_rd_2_data_3 : 35'h0; // @[Buffer.scala 160:10 167:17 151:23]
  wire [34:0] _GEN_53 = _state_T_4 ? io_banks_rd_2_data_4 : 35'h0; // @[Buffer.scala 160:10 167:17 151:23]
  wire [34:0] _GEN_54 = _state_T_4 ? io_banks_rd_2_data_5 : 35'h0; // @[Buffer.scala 160:10 167:17 151:23]
  wire [34:0] _GEN_55 = _state_T_4 ? io_banks_rd_2_data_6 : 35'h0; // @[Buffer.scala 160:10 167:17 151:23]
  wire [34:0] _GEN_56 = _state_T_4 ? io_banks_rd_2_data_7 : 35'h0; // @[Buffer.scala 160:10 167:17 151:23]
  wire  _GEN_57 = _state_T_4 & io_polyvec1_wr_en_0; // @[Buffer.scala 161:10 142:13 167:17]
  wire  _GEN_58 = _state_T_4 & io_polyvec1_wr_en_1; // @[Buffer.scala 161:10 142:13 167:17]
  wire  _GEN_59 = _state_T_4 & io_polyvec1_wr_en_2; // @[Buffer.scala 161:10 142:13 167:17]
  wire  _GEN_60 = _state_T_4 & io_polyvec1_wr_en_3; // @[Buffer.scala 161:10 142:13 167:17]
  wire  _GEN_61 = _state_T_4 & io_polyvec1_wr_en_4; // @[Buffer.scala 161:10 142:13 167:17]
  wire  _GEN_62 = _state_T_4 & io_polyvec1_wr_en_5; // @[Buffer.scala 161:10 142:13 167:17]
  wire  _GEN_63 = _state_T_4 & io_polyvec1_wr_en_6; // @[Buffer.scala 161:10 142:13 167:17]
  wire  _GEN_64 = _state_T_4 & io_polyvec1_wr_en_7; // @[Buffer.scala 161:10 142:13 167:17]
  wire [8:0] _GEN_65 = _state_T_4 ? io_polyvec1_wr_addr_0 : 9'h0; // @[Buffer.scala 161:10 143:13 167:17]
  wire [8:0] _GEN_66 = _state_T_4 ? io_polyvec1_wr_addr_1 : 9'h0; // @[Buffer.scala 161:10 143:13 167:17]
  wire [8:0] _GEN_67 = _state_T_4 ? io_polyvec1_wr_addr_2 : 9'h0; // @[Buffer.scala 161:10 143:13 167:17]
  wire [8:0] _GEN_68 = _state_T_4 ? io_polyvec1_wr_addr_3 : 9'h0; // @[Buffer.scala 161:10 143:13 167:17]
  wire [8:0] _GEN_69 = _state_T_4 ? io_polyvec1_wr_addr_4 : 9'h0; // @[Buffer.scala 161:10 143:13 167:17]
  wire [8:0] _GEN_70 = _state_T_4 ? io_polyvec1_wr_addr_5 : 9'h0; // @[Buffer.scala 161:10 143:13 167:17]
  wire [8:0] _GEN_71 = _state_T_4 ? io_polyvec1_wr_addr_6 : 9'h0; // @[Buffer.scala 161:10 143:13 167:17]
  wire [8:0] _GEN_72 = _state_T_4 ? io_polyvec1_wr_addr_7 : 9'h0; // @[Buffer.scala 161:10 143:13 167:17]
  wire [34:0] _GEN_73 = _state_T_4 ? io_polyvec1_wr_data_0 : 35'h0; // @[Buffer.scala 161:10 144:13 167:17]
  wire [34:0] _GEN_74 = _state_T_4 ? io_polyvec1_wr_data_1 : 35'h0; // @[Buffer.scala 161:10 144:13 167:17]
  wire [34:0] _GEN_75 = _state_T_4 ? io_polyvec1_wr_data_2 : 35'h0; // @[Buffer.scala 161:10 144:13 167:17]
  wire [34:0] _GEN_76 = _state_T_4 ? io_polyvec1_wr_data_3 : 35'h0; // @[Buffer.scala 161:10 144:13 167:17]
  wire [34:0] _GEN_77 = _state_T_4 ? io_polyvec1_wr_data_4 : 35'h0; // @[Buffer.scala 161:10 144:13 167:17]
  wire [34:0] _GEN_78 = _state_T_4 ? io_polyvec1_wr_data_5 : 35'h0; // @[Buffer.scala 161:10 144:13 167:17]
  wire [34:0] _GEN_79 = _state_T_4 ? io_polyvec1_wr_data_6 : 35'h0; // @[Buffer.scala 161:10 144:13 167:17]
  wire [34:0] _GEN_80 = _state_T_4 ? io_polyvec1_wr_data_7 : 35'h0; // @[Buffer.scala 161:10 144:13 167:17]
  wire [8:0] _GEN_121 = _state_T_2 ? io_polyvec0_rd_addr_0 : _GEN_41; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_122 = _state_T_2 ? io_polyvec0_rd_addr_1 : _GEN_42; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_123 = _state_T_2 ? io_polyvec0_rd_addr_2 : _GEN_43; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_124 = _state_T_2 ? io_polyvec0_rd_addr_3 : _GEN_44; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_125 = _state_T_2 ? io_polyvec0_rd_addr_4 : _GEN_45; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_126 = _state_T_2 ? io_polyvec0_rd_addr_5 : _GEN_46; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_127 = _state_T_2 ? io_polyvec0_rd_addr_6 : _GEN_47; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_128 = _state_T_2 ? io_polyvec0_rd_addr_7 : _GEN_48; // @[Buffer.scala 160:10 167:17]
  wire [34:0] _GEN_129 = _state_T_2 ? io_banks_rd_2_data_0 : _GEN_9; // @[Buffer.scala 160:10 167:17]
  wire [34:0] _GEN_130 = _state_T_2 ? io_banks_rd_2_data_1 : _GEN_10; // @[Buffer.scala 160:10 167:17]
  wire [34:0] _GEN_131 = _state_T_2 ? io_banks_rd_2_data_2 : _GEN_11; // @[Buffer.scala 160:10 167:17]
  wire [34:0] _GEN_132 = _state_T_2 ? io_banks_rd_2_data_3 : _GEN_12; // @[Buffer.scala 160:10 167:17]
  wire [34:0] _GEN_133 = _state_T_2 ? io_banks_rd_2_data_4 : _GEN_13; // @[Buffer.scala 160:10 167:17]
  wire [34:0] _GEN_134 = _state_T_2 ? io_banks_rd_2_data_5 : _GEN_14; // @[Buffer.scala 160:10 167:17]
  wire [34:0] _GEN_135 = _state_T_2 ? io_banks_rd_2_data_6 : _GEN_15; // @[Buffer.scala 160:10 167:17]
  wire [34:0] _GEN_136 = _state_T_2 ? io_banks_rd_2_data_7 : _GEN_16; // @[Buffer.scala 160:10 167:17]
  wire  _GEN_137 = _state_T_2 ? io_polyvec0_wr_en_0 : _GEN_57; // @[Buffer.scala 161:10 167:17]
  wire  _GEN_138 = _state_T_2 ? io_polyvec0_wr_en_1 : _GEN_58; // @[Buffer.scala 161:10 167:17]
  wire  _GEN_139 = _state_T_2 ? io_polyvec0_wr_en_2 : _GEN_59; // @[Buffer.scala 161:10 167:17]
  wire  _GEN_140 = _state_T_2 ? io_polyvec0_wr_en_3 : _GEN_60; // @[Buffer.scala 161:10 167:17]
  wire  _GEN_141 = _state_T_2 ? io_polyvec0_wr_en_4 : _GEN_61; // @[Buffer.scala 161:10 167:17]
  wire  _GEN_142 = _state_T_2 ? io_polyvec0_wr_en_5 : _GEN_62; // @[Buffer.scala 161:10 167:17]
  wire  _GEN_143 = _state_T_2 ? io_polyvec0_wr_en_6 : _GEN_63; // @[Buffer.scala 161:10 167:17]
  wire  _GEN_144 = _state_T_2 ? io_polyvec0_wr_en_7 : _GEN_64; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_145 = _state_T_2 ? io_polyvec0_wr_addr_0 : _GEN_65; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_146 = _state_T_2 ? io_polyvec0_wr_addr_1 : _GEN_66; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_147 = _state_T_2 ? io_polyvec0_wr_addr_2 : _GEN_67; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_148 = _state_T_2 ? io_polyvec0_wr_addr_3 : _GEN_68; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_149 = _state_T_2 ? io_polyvec0_wr_addr_4 : _GEN_69; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_150 = _state_T_2 ? io_polyvec0_wr_addr_5 : _GEN_70; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_151 = _state_T_2 ? io_polyvec0_wr_addr_6 : _GEN_71; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_152 = _state_T_2 ? io_polyvec0_wr_addr_7 : _GEN_72; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_153 = _state_T_2 ? io_polyvec0_wr_data_0 : _GEN_73; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_154 = _state_T_2 ? io_polyvec0_wr_data_1 : _GEN_74; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_155 = _state_T_2 ? io_polyvec0_wr_data_2 : _GEN_75; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_156 = _state_T_2 ? io_polyvec0_wr_data_3 : _GEN_76; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_157 = _state_T_2 ? io_polyvec0_wr_data_4 : _GEN_77; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_158 = _state_T_2 ? io_polyvec0_wr_data_5 : _GEN_78; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_159 = _state_T_2 ? io_polyvec0_wr_data_6 : _GEN_79; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_160 = _state_T_2 ? io_polyvec0_wr_data_7 : _GEN_80; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_161 = _state_T_2 ? io_polyvec1_rd_addr_0 : 9'h0; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_162 = _state_T_2 ? io_polyvec1_rd_addr_1 : 9'h0; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_163 = _state_T_2 ? io_polyvec1_rd_addr_2 : 9'h0; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_164 = _state_T_2 ? io_polyvec1_rd_addr_3 : 9'h0; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_165 = _state_T_2 ? io_polyvec1_rd_addr_4 : 9'h0; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_166 = _state_T_2 ? io_polyvec1_rd_addr_5 : 9'h0; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_167 = _state_T_2 ? io_polyvec1_rd_addr_6 : 9'h0; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_168 = _state_T_2 ? io_polyvec1_rd_addr_7 : 9'h0; // @[Buffer.scala 160:10 167:17]
  wire [34:0] _GEN_169 = _state_T_2 ? io_banks_rd_0_data_0 : _GEN_49; // @[Buffer.scala 160:10 167:17]
  wire [34:0] _GEN_170 = _state_T_2 ? io_banks_rd_0_data_1 : _GEN_50; // @[Buffer.scala 160:10 167:17]
  wire [34:0] _GEN_171 = _state_T_2 ? io_banks_rd_0_data_2 : _GEN_51; // @[Buffer.scala 160:10 167:17]
  wire [34:0] _GEN_172 = _state_T_2 ? io_banks_rd_0_data_3 : _GEN_52; // @[Buffer.scala 160:10 167:17]
  wire [34:0] _GEN_173 = _state_T_2 ? io_banks_rd_0_data_4 : _GEN_53; // @[Buffer.scala 160:10 167:17]
  wire [34:0] _GEN_174 = _state_T_2 ? io_banks_rd_0_data_5 : _GEN_54; // @[Buffer.scala 160:10 167:17]
  wire [34:0] _GEN_175 = _state_T_2 ? io_banks_rd_0_data_6 : _GEN_55; // @[Buffer.scala 160:10 167:17]
  wire [34:0] _GEN_176 = _state_T_2 ? io_banks_rd_0_data_7 : _GEN_56; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_185 = _state_T_2 ? io_polyvec1_wr_addr_0 : 9'h0; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_186 = _state_T_2 ? io_polyvec1_wr_addr_1 : 9'h0; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_187 = _state_T_2 ? io_polyvec1_wr_addr_2 : 9'h0; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_188 = _state_T_2 ? io_polyvec1_wr_addr_3 : 9'h0; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_189 = _state_T_2 ? io_polyvec1_wr_addr_4 : 9'h0; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_190 = _state_T_2 ? io_polyvec1_wr_addr_5 : 9'h0; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_191 = _state_T_2 ? io_polyvec1_wr_addr_6 : 9'h0; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_192 = _state_T_2 ? io_polyvec1_wr_addr_7 : 9'h0; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_193 = _state_T_2 ? io_polyvec1_wr_data_0 : 35'h0; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_194 = _state_T_2 ? io_polyvec1_wr_data_1 : 35'h0; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_195 = _state_T_2 ? io_polyvec1_wr_data_2 : 35'h0; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_196 = _state_T_2 ? io_polyvec1_wr_data_3 : 35'h0; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_197 = _state_T_2 ? io_polyvec1_wr_data_4 : 35'h0; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_198 = _state_T_2 ? io_polyvec1_wr_data_5 : 35'h0; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_199 = _state_T_2 ? io_polyvec1_wr_data_6 : 35'h0; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_200 = _state_T_2 ? io_polyvec1_wr_data_7 : 35'h0; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_201 = _state_T_2 ? 9'h0 : _GEN_1; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_202 = _state_T_2 ? 9'h0 : _GEN_2; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_203 = _state_T_2 ? 9'h0 : _GEN_3; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_204 = _state_T_2 ? 9'h0 : _GEN_4; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_205 = _state_T_2 ? 9'h0 : _GEN_5; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_206 = _state_T_2 ? 9'h0 : _GEN_6; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_207 = _state_T_2 ? 9'h0 : _GEN_7; // @[Buffer.scala 160:10 167:17]
  wire [8:0] _GEN_208 = _state_T_2 ? 9'h0 : _GEN_8; // @[Buffer.scala 160:10 167:17]
  wire  _GEN_217 = _state_T_2 ? 1'h0 : _GEN_17; // @[Buffer.scala 161:10 167:17]
  wire  _GEN_218 = _state_T_2 ? 1'h0 : _GEN_18; // @[Buffer.scala 161:10 167:17]
  wire  _GEN_219 = _state_T_2 ? 1'h0 : _GEN_19; // @[Buffer.scala 161:10 167:17]
  wire  _GEN_220 = _state_T_2 ? 1'h0 : _GEN_20; // @[Buffer.scala 161:10 167:17]
  wire  _GEN_221 = _state_T_2 ? 1'h0 : _GEN_21; // @[Buffer.scala 161:10 167:17]
  wire  _GEN_222 = _state_T_2 ? 1'h0 : _GEN_22; // @[Buffer.scala 161:10 167:17]
  wire  _GEN_223 = _state_T_2 ? 1'h0 : _GEN_23; // @[Buffer.scala 161:10 167:17]
  wire  _GEN_224 = _state_T_2 ? 1'h0 : _GEN_24; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_225 = _state_T_2 ? 9'h0 : _GEN_25; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_226 = _state_T_2 ? 9'h0 : _GEN_26; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_227 = _state_T_2 ? 9'h0 : _GEN_27; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_228 = _state_T_2 ? 9'h0 : _GEN_28; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_229 = _state_T_2 ? 9'h0 : _GEN_29; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_230 = _state_T_2 ? 9'h0 : _GEN_30; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_231 = _state_T_2 ? 9'h0 : _GEN_31; // @[Buffer.scala 161:10 167:17]
  wire [8:0] _GEN_232 = _state_T_2 ? 9'h0 : _GEN_32; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_233 = _state_T_2 ? 35'h0 : _GEN_33; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_234 = _state_T_2 ? 35'h0 : _GEN_34; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_235 = _state_T_2 ? 35'h0 : _GEN_35; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_236 = _state_T_2 ? 35'h0 : _GEN_36; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_237 = _state_T_2 ? 35'h0 : _GEN_37; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_238 = _state_T_2 ? 35'h0 : _GEN_38; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_239 = _state_T_2 ? 35'h0 : _GEN_39; // @[Buffer.scala 161:10 167:17]
  wire [34:0] _GEN_240 = _state_T_2 ? 35'h0 : _GEN_40; // @[Buffer.scala 161:10 167:17]
  assign io_polyvec0_rd_data_0 = _state_T ? io_banks_rd_0_data_0 : _GEN_129; // @[Buffer.scala 160:10 167:17]
  assign io_polyvec0_rd_data_1 = _state_T ? io_banks_rd_0_data_1 : _GEN_130; // @[Buffer.scala 160:10 167:17]
  assign io_polyvec0_rd_data_2 = _state_T ? io_banks_rd_0_data_2 : _GEN_131; // @[Buffer.scala 160:10 167:17]
  assign io_polyvec0_rd_data_3 = _state_T ? io_banks_rd_0_data_3 : _GEN_132; // @[Buffer.scala 160:10 167:17]
  assign io_polyvec0_rd_data_4 = _state_T ? io_banks_rd_0_data_4 : _GEN_133; // @[Buffer.scala 160:10 167:17]
  assign io_polyvec0_rd_data_5 = _state_T ? io_banks_rd_0_data_5 : _GEN_134; // @[Buffer.scala 160:10 167:17]
  assign io_polyvec0_rd_data_6 = _state_T ? io_banks_rd_0_data_6 : _GEN_135; // @[Buffer.scala 160:10 167:17]
  assign io_polyvec0_rd_data_7 = _state_T ? io_banks_rd_0_data_7 : _GEN_136; // @[Buffer.scala 160:10 167:17]
  assign io_polyvec1_rd_data_0 = _state_T ? io_banks_rd_1_data_0 : _GEN_169; // @[Buffer.scala 160:10 167:17]
  assign io_polyvec1_rd_data_1 = _state_T ? io_banks_rd_1_data_1 : _GEN_170; // @[Buffer.scala 160:10 167:17]
  assign io_polyvec1_rd_data_2 = _state_T ? io_banks_rd_1_data_2 : _GEN_171; // @[Buffer.scala 160:10 167:17]
  assign io_polyvec1_rd_data_3 = _state_T ? io_banks_rd_1_data_3 : _GEN_172; // @[Buffer.scala 160:10 167:17]
  assign io_polyvec1_rd_data_4 = _state_T ? io_banks_rd_1_data_4 : _GEN_173; // @[Buffer.scala 160:10 167:17]
  assign io_polyvec1_rd_data_5 = _state_T ? io_banks_rd_1_data_5 : _GEN_174; // @[Buffer.scala 160:10 167:17]
  assign io_polyvec1_rd_data_6 = _state_T ? io_banks_rd_1_data_6 : _GEN_175; // @[Buffer.scala 160:10 167:17]
  assign io_polyvec1_rd_data_7 = _state_T ? io_banks_rd_1_data_7 : _GEN_176; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_0_addr_0 = _state_T ? io_polyvec0_rd_addr_0 : _GEN_161; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_0_addr_1 = _state_T ? io_polyvec0_rd_addr_1 : _GEN_162; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_0_addr_2 = _state_T ? io_polyvec0_rd_addr_2 : _GEN_163; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_0_addr_3 = _state_T ? io_polyvec0_rd_addr_3 : _GEN_164; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_0_addr_4 = _state_T ? io_polyvec0_rd_addr_4 : _GEN_165; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_0_addr_5 = _state_T ? io_polyvec0_rd_addr_5 : _GEN_166; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_0_addr_6 = _state_T ? io_polyvec0_rd_addr_6 : _GEN_167; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_0_addr_7 = _state_T ? io_polyvec0_rd_addr_7 : _GEN_168; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_1_addr_0 = _state_T ? io_polyvec1_rd_addr_0 : _GEN_201; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_1_addr_1 = _state_T ? io_polyvec1_rd_addr_1 : _GEN_202; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_1_addr_2 = _state_T ? io_polyvec1_rd_addr_2 : _GEN_203; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_1_addr_3 = _state_T ? io_polyvec1_rd_addr_3 : _GEN_204; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_1_addr_4 = _state_T ? io_polyvec1_rd_addr_4 : _GEN_205; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_1_addr_5 = _state_T ? io_polyvec1_rd_addr_5 : _GEN_206; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_1_addr_6 = _state_T ? io_polyvec1_rd_addr_6 : _GEN_207; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_1_addr_7 = _state_T ? io_polyvec1_rd_addr_7 : _GEN_208; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_2_addr_0 = _state_T ? 9'h0 : _GEN_121; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_2_addr_1 = _state_T ? 9'h0 : _GEN_122; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_2_addr_2 = _state_T ? 9'h0 : _GEN_123; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_2_addr_3 = _state_T ? 9'h0 : _GEN_124; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_2_addr_4 = _state_T ? 9'h0 : _GEN_125; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_2_addr_5 = _state_T ? 9'h0 : _GEN_126; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_2_addr_6 = _state_T ? 9'h0 : _GEN_127; // @[Buffer.scala 160:10 167:17]
  assign io_banks_rd_2_addr_7 = _state_T ? 9'h0 : _GEN_128; // @[Buffer.scala 160:10 167:17]
  assign io_banks_wr_0_en_0 = _state_T ? io_polyvec0_wr_en_0 : _state_T_2 & io_polyvec1_wr_en_0; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_en_1 = _state_T ? io_polyvec0_wr_en_1 : _state_T_2 & io_polyvec1_wr_en_1; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_en_2 = _state_T ? io_polyvec0_wr_en_2 : _state_T_2 & io_polyvec1_wr_en_2; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_en_3 = _state_T ? io_polyvec0_wr_en_3 : _state_T_2 & io_polyvec1_wr_en_3; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_en_4 = _state_T ? io_polyvec0_wr_en_4 : _state_T_2 & io_polyvec1_wr_en_4; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_en_5 = _state_T ? io_polyvec0_wr_en_5 : _state_T_2 & io_polyvec1_wr_en_5; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_en_6 = _state_T ? io_polyvec0_wr_en_6 : _state_T_2 & io_polyvec1_wr_en_6; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_en_7 = _state_T ? io_polyvec0_wr_en_7 : _state_T_2 & io_polyvec1_wr_en_7; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_addr_0 = _state_T ? io_polyvec0_wr_addr_0 : _GEN_185; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_addr_1 = _state_T ? io_polyvec0_wr_addr_1 : _GEN_186; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_addr_2 = _state_T ? io_polyvec0_wr_addr_2 : _GEN_187; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_addr_3 = _state_T ? io_polyvec0_wr_addr_3 : _GEN_188; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_addr_4 = _state_T ? io_polyvec0_wr_addr_4 : _GEN_189; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_addr_5 = _state_T ? io_polyvec0_wr_addr_5 : _GEN_190; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_addr_6 = _state_T ? io_polyvec0_wr_addr_6 : _GEN_191; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_addr_7 = _state_T ? io_polyvec0_wr_addr_7 : _GEN_192; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_data_0 = _state_T ? io_polyvec0_wr_data_0 : _GEN_193; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_data_1 = _state_T ? io_polyvec0_wr_data_1 : _GEN_194; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_data_2 = _state_T ? io_polyvec0_wr_data_2 : _GEN_195; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_data_3 = _state_T ? io_polyvec0_wr_data_3 : _GEN_196; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_data_4 = _state_T ? io_polyvec0_wr_data_4 : _GEN_197; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_data_5 = _state_T ? io_polyvec0_wr_data_5 : _GEN_198; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_data_6 = _state_T ? io_polyvec0_wr_data_6 : _GEN_199; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_0_data_7 = _state_T ? io_polyvec0_wr_data_7 : _GEN_200; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_en_0 = _state_T ? io_polyvec1_wr_en_0 : _GEN_217; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_en_1 = _state_T ? io_polyvec1_wr_en_1 : _GEN_218; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_en_2 = _state_T ? io_polyvec1_wr_en_2 : _GEN_219; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_en_3 = _state_T ? io_polyvec1_wr_en_3 : _GEN_220; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_en_4 = _state_T ? io_polyvec1_wr_en_4 : _GEN_221; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_en_5 = _state_T ? io_polyvec1_wr_en_5 : _GEN_222; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_en_6 = _state_T ? io_polyvec1_wr_en_6 : _GEN_223; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_en_7 = _state_T ? io_polyvec1_wr_en_7 : _GEN_224; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_addr_0 = _state_T ? io_polyvec1_wr_addr_0 : _GEN_225; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_addr_1 = _state_T ? io_polyvec1_wr_addr_1 : _GEN_226; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_addr_2 = _state_T ? io_polyvec1_wr_addr_2 : _GEN_227; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_addr_3 = _state_T ? io_polyvec1_wr_addr_3 : _GEN_228; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_addr_4 = _state_T ? io_polyvec1_wr_addr_4 : _GEN_229; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_addr_5 = _state_T ? io_polyvec1_wr_addr_5 : _GEN_230; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_addr_6 = _state_T ? io_polyvec1_wr_addr_6 : _GEN_231; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_addr_7 = _state_T ? io_polyvec1_wr_addr_7 : _GEN_232; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_data_0 = _state_T ? io_polyvec1_wr_data_0 : _GEN_233; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_data_1 = _state_T ? io_polyvec1_wr_data_1 : _GEN_234; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_data_2 = _state_T ? io_polyvec1_wr_data_2 : _GEN_235; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_data_3 = _state_T ? io_polyvec1_wr_data_3 : _GEN_236; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_data_4 = _state_T ? io_polyvec1_wr_data_4 : _GEN_237; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_data_5 = _state_T ? io_polyvec1_wr_data_5 : _GEN_238; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_data_6 = _state_T ? io_polyvec1_wr_data_6 : _GEN_239; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_1_data_7 = _state_T ? io_polyvec1_wr_data_7 : _GEN_240; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_en_0 = _state_T ? 1'h0 : _GEN_137; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_en_1 = _state_T ? 1'h0 : _GEN_138; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_en_2 = _state_T ? 1'h0 : _GEN_139; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_en_3 = _state_T ? 1'h0 : _GEN_140; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_en_4 = _state_T ? 1'h0 : _GEN_141; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_en_5 = _state_T ? 1'h0 : _GEN_142; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_en_6 = _state_T ? 1'h0 : _GEN_143; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_en_7 = _state_T ? 1'h0 : _GEN_144; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_addr_0 = _state_T ? 9'h0 : _GEN_145; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_addr_1 = _state_T ? 9'h0 : _GEN_146; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_addr_2 = _state_T ? 9'h0 : _GEN_147; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_addr_3 = _state_T ? 9'h0 : _GEN_148; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_addr_4 = _state_T ? 9'h0 : _GEN_149; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_addr_5 = _state_T ? 9'h0 : _GEN_150; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_addr_6 = _state_T ? 9'h0 : _GEN_151; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_addr_7 = _state_T ? 9'h0 : _GEN_152; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_data_0 = _state_T ? 35'h0 : _GEN_153; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_data_1 = _state_T ? 35'h0 : _GEN_154; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_data_2 = _state_T ? 35'h0 : _GEN_155; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_data_3 = _state_T ? 35'h0 : _GEN_156; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_data_4 = _state_T ? 35'h0 : _GEN_157; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_data_5 = _state_T ? 35'h0 : _GEN_158; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_data_6 = _state_T ? 35'h0 : _GEN_159; // @[Buffer.scala 161:10 167:17]
  assign io_banks_wr_2_data_7 = _state_T ? 35'h0 : _GEN_160; // @[Buffer.scala 161:10 167:17]
  always @(posedge clock) begin
    if (reset) begin // @[Buffer.scala 125:23]
      done_r <= 1'h0; // @[Buffer.scala 125:23]
    end else begin
      done_r <= io_i_done; // @[Buffer.scala 125:23]
    end
    if (reset) begin // @[Buffer.scala 128:22]
      state <= 2'h0; // @[Buffer.scala 128:22]
    end else if (io_i_done & ~done_r) begin // @[Buffer.scala 130:30]
      if (2'h2 == state) begin // @[Mux.scala 81:58]
        state <= 2'h0;
      end else if (2'h1 == state) begin // @[Mux.scala 81:58]
        state <= 2'h2;
      end else begin
        state <= _state_T_1;
      end
    end
  end
endmodule
module poly_wr_interface_35_512_8(
  input         io_vpu_wr_en,
  input  [11:0] io_vpu_wr_addr,
  input  [34:0] io_vpu_wr_data,
  output        io_buf_wr_en_0,
  output        io_buf_wr_en_1,
  output        io_buf_wr_en_2,
  output        io_buf_wr_en_3,
  output        io_buf_wr_en_4,
  output        io_buf_wr_en_5,
  output        io_buf_wr_en_6,
  output        io_buf_wr_en_7,
  output [8:0]  io_buf_wr_addr_0,
  output [8:0]  io_buf_wr_addr_1,
  output [8:0]  io_buf_wr_addr_2,
  output [8:0]  io_buf_wr_addr_3,
  output [8:0]  io_buf_wr_addr_4,
  output [8:0]  io_buf_wr_addr_5,
  output [8:0]  io_buf_wr_addr_6,
  output [8:0]  io_buf_wr_addr_7,
  output [34:0] io_buf_wr_data_0,
  output [34:0] io_buf_wr_data_1,
  output [34:0] io_buf_wr_data_2,
  output [34:0] io_buf_wr_data_3,
  output [34:0] io_buf_wr_data_4,
  output [34:0] io_buf_wr_data_5,
  output [34:0] io_buf_wr_data_6,
  output [34:0] io_buf_wr_data_7
);
  wire [3:0] lo_addr_lo = {io_vpu_wr_addr[3],io_vpu_wr_addr[2],io_vpu_wr_addr[1],io_vpu_wr_addr[0]}; // @[Common.scala 18:49]
  wire [4:0] lo_addr_hi = {io_vpu_wr_addr[8],io_vpu_wr_addr[7],io_vpu_wr_addr[6],io_vpu_wr_addr[5],io_vpu_wr_addr[4]}; // @[Common.scala 18:49]
  wire [2:0] hi_addr = {io_vpu_wr_addr[11],io_vpu_wr_addr[10],io_vpu_wr_addr[9]}; // @[Common.scala 18:49]
  wire [7:0] _T = 8'h1 << hi_addr; // @[OneHot.scala 57:35]
  assign io_buf_wr_en_0 = io_vpu_wr_en & _T[0]; // @[Buffer.scala 52:25 53:22 55:22]
  assign io_buf_wr_en_1 = io_vpu_wr_en & _T[1]; // @[Buffer.scala 52:25 53:22 55:22]
  assign io_buf_wr_en_2 = io_vpu_wr_en & _T[2]; // @[Buffer.scala 52:25 53:22 55:22]
  assign io_buf_wr_en_3 = io_vpu_wr_en & _T[3]; // @[Buffer.scala 52:25 53:22 55:22]
  assign io_buf_wr_en_4 = io_vpu_wr_en & _T[4]; // @[Buffer.scala 52:25 53:22 55:22]
  assign io_buf_wr_en_5 = io_vpu_wr_en & _T[5]; // @[Buffer.scala 52:25 53:22 55:22]
  assign io_buf_wr_en_6 = io_vpu_wr_en & _T[6]; // @[Buffer.scala 52:25 53:22 55:22]
  assign io_buf_wr_en_7 = io_vpu_wr_en & _T[7]; // @[Buffer.scala 52:25 53:22 55:22]
  assign io_buf_wr_addr_0 = {lo_addr_hi,lo_addr_lo}; // @[Common.scala 18:49]
  assign io_buf_wr_addr_1 = {lo_addr_hi,lo_addr_lo}; // @[Common.scala 18:49]
  assign io_buf_wr_addr_2 = {lo_addr_hi,lo_addr_lo}; // @[Common.scala 18:49]
  assign io_buf_wr_addr_3 = {lo_addr_hi,lo_addr_lo}; // @[Common.scala 18:49]
  assign io_buf_wr_addr_4 = {lo_addr_hi,lo_addr_lo}; // @[Common.scala 18:49]
  assign io_buf_wr_addr_5 = {lo_addr_hi,lo_addr_lo}; // @[Common.scala 18:49]
  assign io_buf_wr_addr_6 = {lo_addr_hi,lo_addr_lo}; // @[Common.scala 18:49]
  assign io_buf_wr_addr_7 = {lo_addr_hi,lo_addr_lo}; // @[Common.scala 18:49]
  assign io_buf_wr_data_0 = io_vpu_wr_data; // @[Common.scala 31:{16,16}]
  assign io_buf_wr_data_1 = io_vpu_wr_data; // @[Common.scala 31:{16,16}]
  assign io_buf_wr_data_2 = io_vpu_wr_data; // @[Common.scala 31:{16,16}]
  assign io_buf_wr_data_3 = io_vpu_wr_data; // @[Common.scala 31:{16,16}]
  assign io_buf_wr_data_4 = io_vpu_wr_data; // @[Common.scala 31:{16,16}]
  assign io_buf_wr_data_5 = io_vpu_wr_data; // @[Common.scala 31:{16,16}]
  assign io_buf_wr_data_6 = io_vpu_wr_data; // @[Common.scala 31:{16,16}]
  assign io_buf_wr_data_7 = io_vpu_wr_data; // @[Common.scala 31:{16,16}]
endmodule
module poly_rd_interface_35_512_8_1(
  input         clock,
  input  [11:0] io_vpu_rd_addr,
  output [34:0] io_vpu_rd_data,
  output [8:0]  io_buf_rd_addr_0,
  output [8:0]  io_buf_rd_addr_1,
  output [8:0]  io_buf_rd_addr_2,
  output [8:0]  io_buf_rd_addr_3,
  output [8:0]  io_buf_rd_addr_4,
  output [8:0]  io_buf_rd_addr_5,
  output [8:0]  io_buf_rd_addr_6,
  output [8:0]  io_buf_rd_addr_7,
  input  [34:0] io_buf_rd_data_0,
  input  [34:0] io_buf_rd_data_1,
  input  [34:0] io_buf_rd_data_2,
  input  [34:0] io_buf_rd_data_3,
  input  [34:0] io_buf_rd_data_4,
  input  [34:0] io_buf_rd_data_5,
  input  [34:0] io_buf_rd_data_6,
  input  [34:0] io_buf_rd_data_7
);
  wire [3:0] lo_addr_lo = {io_vpu_rd_addr[3],io_vpu_rd_addr[2],io_vpu_rd_addr[1],io_vpu_rd_addr[0]}; // @[Common.scala 18:49]
  wire [4:0] lo_addr_hi = {io_vpu_rd_addr[8],io_vpu_rd_addr[7],io_vpu_rd_addr[6],io_vpu_rd_addr[5],io_vpu_rd_addr[4]}; // @[Common.scala 18:49]
  wire [1:0] hi_addr_hi = {io_vpu_rd_addr[11],io_vpu_rd_addr[10]}; // @[Common.scala 18:49]
  reg [2:0] io_vpu_rd_data_r; // @[Reg.scala 16:16]
  wire [34:0] _io_vpu_rd_data_T_1 = 3'h1 == io_vpu_rd_data_r ? io_buf_rd_data_1 : io_buf_rd_data_0; // @[Mux.scala 81:58]
  wire [34:0] _io_vpu_rd_data_T_3 = 3'h2 == io_vpu_rd_data_r ? io_buf_rd_data_2 : _io_vpu_rd_data_T_1; // @[Mux.scala 81:58]
  wire [34:0] _io_vpu_rd_data_T_5 = 3'h3 == io_vpu_rd_data_r ? io_buf_rd_data_3 : _io_vpu_rd_data_T_3; // @[Mux.scala 81:58]
  wire [34:0] _io_vpu_rd_data_T_7 = 3'h4 == io_vpu_rd_data_r ? io_buf_rd_data_4 : _io_vpu_rd_data_T_5; // @[Mux.scala 81:58]
  wire [34:0] _io_vpu_rd_data_T_9 = 3'h5 == io_vpu_rd_data_r ? io_buf_rd_data_5 : _io_vpu_rd_data_T_7; // @[Mux.scala 81:58]
  wire [34:0] _io_vpu_rd_data_T_11 = 3'h6 == io_vpu_rd_data_r ? io_buf_rd_data_6 : _io_vpu_rd_data_T_9; // @[Mux.scala 81:58]
  assign io_vpu_rd_data = 3'h7 == io_vpu_rd_data_r ? io_buf_rd_data_7 : _io_vpu_rd_data_T_11; // @[Mux.scala 81:58]
  assign io_buf_rd_addr_0 = {lo_addr_hi,lo_addr_lo}; // @[Common.scala 18:49]
  assign io_buf_rd_addr_1 = {lo_addr_hi,lo_addr_lo}; // @[Common.scala 18:49]
  assign io_buf_rd_addr_2 = {lo_addr_hi,lo_addr_lo}; // @[Common.scala 18:49]
  assign io_buf_rd_addr_3 = {lo_addr_hi,lo_addr_lo}; // @[Common.scala 18:49]
  assign io_buf_rd_addr_4 = {lo_addr_hi,lo_addr_lo}; // @[Common.scala 18:49]
  assign io_buf_rd_addr_5 = {lo_addr_hi,lo_addr_lo}; // @[Common.scala 18:49]
  assign io_buf_rd_addr_6 = {lo_addr_hi,lo_addr_lo}; // @[Common.scala 18:49]
  assign io_buf_rd_addr_7 = {lo_addr_hi,lo_addr_lo}; // @[Common.scala 18:49]
  always @(posedge clock) begin
    io_vpu_rd_data_r <= {hi_addr_hi,io_vpu_rd_addr[9]}; // @[Common.scala 18:49]
  end
endmodule
module preprocess_top_chisel(
  input          clock,
  input          reset,
  input          io_i_intt_start,
  output         io_o_intt_done,
  input          io_i_pre_switch,
  input          io_i_mux_done,
  input  [11:0]  io_i_coeff_index,
  input          io_dp1_wr_0_en,
  input  [11:0]  io_dp1_wr_0_addr,
  input  [34:0]  io_dp1_wr_0_data,
  input  [11:0]  io_dp1_rd_0_addr,
  output [34:0]  io_dp1_rd_0_data,
  output [279:0] io_o_intt_concat,
  output [71:0]  io_o_intt_addr,
  output         io_o_intt_we_result,
  output [7:0]   io_inttWrEnPacked,
  output [71:0]  io_inttWrAddrPacked,
  output [279:0] io_inttWrDataPacked,
  output [71:0]  io_inttRdAddrPacked,
  input  [279:0] io_inttRdDataPacked,
  output [23:0]  tppWrEnPacked,
  output [215:0] tppWrAddrPacked,
  output [839:0] tppWrDataPacked,
  output [215:0] tppRdAddrPacked,
  input  [839:0] tppRdDataPacked
);
  wire  u_intt_0_clock; // @[Preprocess.scala 47:46]
  wire  u_intt_0_reset; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_ntt_start; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_ntt_done; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_wr_l_en_0; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_wr_l_en_1; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_wr_l_en_2; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_wr_l_en_3; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_wr_l_en_4; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_wr_l_en_5; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_wr_l_en_6; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_wr_l_en_7; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_wr_l_addr_0; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_wr_l_addr_1; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_wr_l_addr_2; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_wr_l_addr_3; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_wr_l_addr_4; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_wr_l_addr_5; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_wr_l_addr_6; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_wr_l_addr_7; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_wr_l_data_0; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_wr_l_data_1; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_wr_l_data_2; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_wr_l_data_3; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_wr_l_data_4; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_wr_l_data_5; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_wr_l_data_6; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_wr_l_data_7; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_wr_r_en_0; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_wr_r_en_1; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_wr_r_en_2; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_wr_r_en_3; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_wr_r_en_4; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_wr_r_en_5; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_wr_r_en_6; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_wr_r_en_7; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_wr_r_addr_0; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_wr_r_addr_1; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_wr_r_addr_2; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_wr_r_addr_3; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_wr_r_addr_4; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_wr_r_addr_5; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_wr_r_addr_6; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_wr_r_addr_7; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_wr_r_data_0; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_wr_r_data_1; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_wr_r_data_2; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_wr_r_data_3; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_wr_r_data_4; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_wr_r_data_5; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_wr_r_data_6; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_wr_r_data_7; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_rd_l_addr_0; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_rd_l_addr_1; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_rd_l_addr_2; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_rd_l_addr_3; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_rd_l_addr_4; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_rd_l_addr_5; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_rd_l_addr_6; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_rd_l_addr_7; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_rd_l_data_0; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_rd_l_data_1; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_rd_l_data_2; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_rd_l_data_3; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_rd_l_data_4; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_rd_l_data_5; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_rd_l_data_6; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_rd_l_data_7; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_rd_r_addr_0; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_rd_r_addr_1; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_rd_r_addr_2; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_rd_r_addr_3; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_rd_r_addr_4; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_rd_r_addr_5; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_rd_r_addr_6; // @[Preprocess.scala 47:46]
  wire [8:0] u_intt_0_io_rd_r_addr_7; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_rd_r_data_0; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_rd_r_data_1; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_rd_r_data_2; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_rd_r_data_3; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_rd_r_data_4; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_rd_r_data_5; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_rd_r_data_6; // @[Preprocess.scala 47:46]
  wire [34:0] u_intt_0_io_rd_r_data_7; // @[Preprocess.scala 47:46]
  wire  u_intt_0_io_o_we_result; // @[Preprocess.scala 47:46]
  wire  u_tpp_0_clock; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_reset; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_i_done; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec0_rd_addr_0; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec0_rd_addr_1; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec0_rd_addr_2; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec0_rd_addr_3; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec0_rd_addr_4; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec0_rd_addr_5; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec0_rd_addr_6; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec0_rd_addr_7; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec0_rd_data_0; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec0_rd_data_1; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec0_rd_data_2; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec0_rd_data_3; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec0_rd_data_4; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec0_rd_data_5; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec0_rd_data_6; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec0_rd_data_7; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_polyvec0_wr_en_0; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_polyvec0_wr_en_1; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_polyvec0_wr_en_2; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_polyvec0_wr_en_3; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_polyvec0_wr_en_4; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_polyvec0_wr_en_5; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_polyvec0_wr_en_6; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_polyvec0_wr_en_7; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec0_wr_addr_0; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec0_wr_addr_1; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec0_wr_addr_2; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec0_wr_addr_3; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec0_wr_addr_4; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec0_wr_addr_5; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec0_wr_addr_6; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec0_wr_addr_7; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec0_wr_data_0; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec0_wr_data_1; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec0_wr_data_2; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec0_wr_data_3; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec0_wr_data_4; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec0_wr_data_5; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec0_wr_data_6; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec0_wr_data_7; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec1_rd_addr_0; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec1_rd_addr_1; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec1_rd_addr_2; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec1_rd_addr_3; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec1_rd_addr_4; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec1_rd_addr_5; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec1_rd_addr_6; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec1_rd_addr_7; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec1_rd_data_0; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec1_rd_data_1; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec1_rd_data_2; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec1_rd_data_3; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec1_rd_data_4; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec1_rd_data_5; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec1_rd_data_6; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec1_rd_data_7; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_polyvec1_wr_en_0; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_polyvec1_wr_en_1; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_polyvec1_wr_en_2; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_polyvec1_wr_en_3; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_polyvec1_wr_en_4; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_polyvec1_wr_en_5; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_polyvec1_wr_en_6; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_polyvec1_wr_en_7; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec1_wr_addr_0; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec1_wr_addr_1; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec1_wr_addr_2; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec1_wr_addr_3; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec1_wr_addr_4; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec1_wr_addr_5; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec1_wr_addr_6; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_polyvec1_wr_addr_7; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec1_wr_data_0; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec1_wr_data_1; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec1_wr_data_2; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec1_wr_data_3; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec1_wr_data_4; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec1_wr_data_5; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec1_wr_data_6; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_polyvec1_wr_data_7; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_0_addr_0; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_0_addr_1; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_0_addr_2; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_0_addr_3; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_0_addr_4; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_0_addr_5; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_0_addr_6; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_0_addr_7; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_0_data_0; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_0_data_1; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_0_data_2; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_0_data_3; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_0_data_4; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_0_data_5; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_0_data_6; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_0_data_7; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_1_addr_0; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_1_addr_1; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_1_addr_2; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_1_addr_3; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_1_addr_4; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_1_addr_5; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_1_addr_6; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_1_addr_7; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_1_data_0; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_1_data_1; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_1_data_2; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_1_data_3; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_1_data_4; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_1_data_5; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_1_data_6; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_1_data_7; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_2_addr_0; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_2_addr_1; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_2_addr_2; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_2_addr_3; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_2_addr_4; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_2_addr_5; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_2_addr_6; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_rd_2_addr_7; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_2_data_0; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_2_data_1; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_2_data_2; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_2_data_3; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_2_data_4; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_2_data_5; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_2_data_6; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_rd_2_data_7; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_0_en_0; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_0_en_1; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_0_en_2; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_0_en_3; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_0_en_4; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_0_en_5; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_0_en_6; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_0_en_7; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_0_addr_0; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_0_addr_1; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_0_addr_2; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_0_addr_3; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_0_addr_4; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_0_addr_5; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_0_addr_6; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_0_addr_7; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_0_data_0; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_0_data_1; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_0_data_2; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_0_data_3; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_0_data_4; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_0_data_5; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_0_data_6; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_0_data_7; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_1_en_0; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_1_en_1; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_1_en_2; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_1_en_3; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_1_en_4; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_1_en_5; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_1_en_6; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_1_en_7; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_1_addr_0; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_1_addr_1; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_1_addr_2; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_1_addr_3; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_1_addr_4; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_1_addr_5; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_1_addr_6; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_1_addr_7; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_1_data_0; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_1_data_1; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_1_data_2; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_1_data_3; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_1_data_4; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_1_data_5; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_1_data_6; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_1_data_7; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_2_en_0; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_2_en_1; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_2_en_2; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_2_en_3; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_2_en_4; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_2_en_5; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_2_en_6; // @[Preprocess.scala 50:11]
  wire  u_tpp_0_io_banks_wr_2_en_7; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_2_addr_0; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_2_addr_1; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_2_addr_2; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_2_addr_3; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_2_addr_4; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_2_addr_5; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_2_addr_6; // @[Preprocess.scala 50:11]
  wire [8:0] u_tpp_0_io_banks_wr_2_addr_7; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_2_data_0; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_2_data_1; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_2_data_2; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_2_data_3; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_2_data_4; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_2_data_5; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_2_data_6; // @[Preprocess.scala 50:11]
  wire [34:0] u_tpp_0_io_banks_wr_2_data_7; // @[Preprocess.scala 50:11]
  wire  u_dp1_wr_itf_0_io_vpu_wr_en; // @[Preprocess.scala 54:11]
  wire [11:0] u_dp1_wr_itf_0_io_vpu_wr_addr; // @[Preprocess.scala 54:11]
  wire [34:0] u_dp1_wr_itf_0_io_vpu_wr_data; // @[Preprocess.scala 54:11]
  wire  u_dp1_wr_itf_0_io_buf_wr_en_0; // @[Preprocess.scala 54:11]
  wire  u_dp1_wr_itf_0_io_buf_wr_en_1; // @[Preprocess.scala 54:11]
  wire  u_dp1_wr_itf_0_io_buf_wr_en_2; // @[Preprocess.scala 54:11]
  wire  u_dp1_wr_itf_0_io_buf_wr_en_3; // @[Preprocess.scala 54:11]
  wire  u_dp1_wr_itf_0_io_buf_wr_en_4; // @[Preprocess.scala 54:11]
  wire  u_dp1_wr_itf_0_io_buf_wr_en_5; // @[Preprocess.scala 54:11]
  wire  u_dp1_wr_itf_0_io_buf_wr_en_6; // @[Preprocess.scala 54:11]
  wire  u_dp1_wr_itf_0_io_buf_wr_en_7; // @[Preprocess.scala 54:11]
  wire [8:0] u_dp1_wr_itf_0_io_buf_wr_addr_0; // @[Preprocess.scala 54:11]
  wire [8:0] u_dp1_wr_itf_0_io_buf_wr_addr_1; // @[Preprocess.scala 54:11]
  wire [8:0] u_dp1_wr_itf_0_io_buf_wr_addr_2; // @[Preprocess.scala 54:11]
  wire [8:0] u_dp1_wr_itf_0_io_buf_wr_addr_3; // @[Preprocess.scala 54:11]
  wire [8:0] u_dp1_wr_itf_0_io_buf_wr_addr_4; // @[Preprocess.scala 54:11]
  wire [8:0] u_dp1_wr_itf_0_io_buf_wr_addr_5; // @[Preprocess.scala 54:11]
  wire [8:0] u_dp1_wr_itf_0_io_buf_wr_addr_6; // @[Preprocess.scala 54:11]
  wire [8:0] u_dp1_wr_itf_0_io_buf_wr_addr_7; // @[Preprocess.scala 54:11]
  wire [34:0] u_dp1_wr_itf_0_io_buf_wr_data_0; // @[Preprocess.scala 54:11]
  wire [34:0] u_dp1_wr_itf_0_io_buf_wr_data_1; // @[Preprocess.scala 54:11]
  wire [34:0] u_dp1_wr_itf_0_io_buf_wr_data_2; // @[Preprocess.scala 54:11]
  wire [34:0] u_dp1_wr_itf_0_io_buf_wr_data_3; // @[Preprocess.scala 54:11]
  wire [34:0] u_dp1_wr_itf_0_io_buf_wr_data_4; // @[Preprocess.scala 54:11]
  wire [34:0] u_dp1_wr_itf_0_io_buf_wr_data_5; // @[Preprocess.scala 54:11]
  wire [34:0] u_dp1_wr_itf_0_io_buf_wr_data_6; // @[Preprocess.scala 54:11]
  wire [34:0] u_dp1_wr_itf_0_io_buf_wr_data_7; // @[Preprocess.scala 54:11]
  wire  u_dp1_rd_itf_0_clock; // @[Preprocess.scala 57:11]
  wire [11:0] u_dp1_rd_itf_0_io_vpu_rd_addr; // @[Preprocess.scala 57:11]
  wire [34:0] u_dp1_rd_itf_0_io_vpu_rd_data; // @[Preprocess.scala 57:11]
  wire [8:0] u_dp1_rd_itf_0_io_buf_rd_addr_0; // @[Preprocess.scala 57:11]
  wire [8:0] u_dp1_rd_itf_0_io_buf_rd_addr_1; // @[Preprocess.scala 57:11]
  wire [8:0] u_dp1_rd_itf_0_io_buf_rd_addr_2; // @[Preprocess.scala 57:11]
  wire [8:0] u_dp1_rd_itf_0_io_buf_rd_addr_3; // @[Preprocess.scala 57:11]
  wire [8:0] u_dp1_rd_itf_0_io_buf_rd_addr_4; // @[Preprocess.scala 57:11]
  wire [8:0] u_dp1_rd_itf_0_io_buf_rd_addr_5; // @[Preprocess.scala 57:11]
  wire [8:0] u_dp1_rd_itf_0_io_buf_rd_addr_6; // @[Preprocess.scala 57:11]
  wire [8:0] u_dp1_rd_itf_0_io_buf_rd_addr_7; // @[Preprocess.scala 57:11]
  wire [34:0] u_dp1_rd_itf_0_io_buf_rd_data_0; // @[Preprocess.scala 57:11]
  wire [34:0] u_dp1_rd_itf_0_io_buf_rd_data_1; // @[Preprocess.scala 57:11]
  wire [34:0] u_dp1_rd_itf_0_io_buf_rd_data_2; // @[Preprocess.scala 57:11]
  wire [34:0] u_dp1_rd_itf_0_io_buf_rd_data_3; // @[Preprocess.scala 57:11]
  wire [34:0] u_dp1_rd_itf_0_io_buf_rd_data_4; // @[Preprocess.scala 57:11]
  wire [34:0] u_dp1_rd_itf_0_io_buf_rd_data_5; // @[Preprocess.scala 57:11]
  wire [34:0] u_dp1_rd_itf_0_io_buf_rd_data_6; // @[Preprocess.scala 57:11]
  wire [34:0] u_dp1_rd_itf_0_io_buf_rd_data_7; // @[Preprocess.scala 57:11]
  wire  wrEnBits__1 = u_intt_0_io_wr_r_en_1; // @[Preprocess.scala 64:26 70:24]
  wire  wrEnBits__0 = u_intt_0_io_wr_r_en_0; // @[Preprocess.scala 64:26 70:24]
  wire  wrEnBits__3 = u_intt_0_io_wr_r_en_3; // @[Preprocess.scala 64:26 70:24]
  wire  wrEnBits__2 = u_intt_0_io_wr_r_en_2; // @[Preprocess.scala 64:26 70:24]
  wire [3:0] io_inttWrEnPacked_lo = {wrEnBits__3,wrEnBits__2,wrEnBits__1,wrEnBits__0}; // @[Cat.scala 31:58]
  wire  wrEnBits__5 = u_intt_0_io_wr_r_en_5; // @[Preprocess.scala 64:26 70:24]
  wire  wrEnBits__4 = u_intt_0_io_wr_r_en_4; // @[Preprocess.scala 64:26 70:24]
  wire  wrEnBits__7 = u_intt_0_io_wr_r_en_7; // @[Preprocess.scala 64:26 70:24]
  wire  wrEnBits__6 = u_intt_0_io_wr_r_en_6; // @[Preprocess.scala 64:26 70:24]
  wire [3:0] io_inttWrEnPacked_hi = {wrEnBits__7,wrEnBits__6,wrEnBits__5,wrEnBits__4}; // @[Cat.scala 31:58]
  wire [8:0] wrAddrBits__1 = u_intt_0_io_wr_r_addr_1; // @[Preprocess.scala 65:26 71:24]
  wire [8:0] wrAddrBits__0 = u_intt_0_io_wr_r_addr_0; // @[Preprocess.scala 65:26 71:24]
  wire [8:0] wrAddrBits__3 = u_intt_0_io_wr_r_addr_3; // @[Preprocess.scala 65:26 71:24]
  wire [8:0] wrAddrBits__2 = u_intt_0_io_wr_r_addr_2; // @[Preprocess.scala 65:26 71:24]
  wire [35:0] io_inttWrAddrPacked_lo = {wrAddrBits__3,wrAddrBits__2,wrAddrBits__1,wrAddrBits__0}; // @[Cat.scala 31:58]
  wire [8:0] wrAddrBits__5 = u_intt_0_io_wr_r_addr_5; // @[Preprocess.scala 65:26 71:24]
  wire [8:0] wrAddrBits__4 = u_intt_0_io_wr_r_addr_4; // @[Preprocess.scala 65:26 71:24]
  wire [8:0] wrAddrBits__7 = u_intt_0_io_wr_r_addr_7; // @[Preprocess.scala 65:26 71:24]
  wire [8:0] wrAddrBits__6 = u_intt_0_io_wr_r_addr_6; // @[Preprocess.scala 65:26 71:24]
  wire [35:0] io_inttWrAddrPacked_hi = {wrAddrBits__7,wrAddrBits__6,wrAddrBits__5,wrAddrBits__4}; // @[Cat.scala 31:58]
  wire [34:0] wrDataBits__1 = u_intt_0_io_wr_r_data_1; // @[Preprocess.scala 66:26 72:24]
  wire [34:0] wrDataBits__0 = u_intt_0_io_wr_r_data_0; // @[Preprocess.scala 66:26 72:24]
  wire [34:0] wrDataBits__3 = u_intt_0_io_wr_r_data_3; // @[Preprocess.scala 66:26 72:24]
  wire [34:0] wrDataBits__2 = u_intt_0_io_wr_r_data_2; // @[Preprocess.scala 66:26 72:24]
  wire [139:0] io_inttWrDataPacked_lo = {wrDataBits__3,wrDataBits__2,wrDataBits__1,wrDataBits__0}; // @[Cat.scala 31:58]
  wire [34:0] wrDataBits__5 = u_intt_0_io_wr_r_data_5; // @[Preprocess.scala 66:26 72:24]
  wire [34:0] wrDataBits__4 = u_intt_0_io_wr_r_data_4; // @[Preprocess.scala 66:26 72:24]
  wire [34:0] wrDataBits__7 = u_intt_0_io_wr_r_data_7; // @[Preprocess.scala 66:26 72:24]
  wire [34:0] wrDataBits__6 = u_intt_0_io_wr_r_data_6; // @[Preprocess.scala 66:26 72:24]
  wire [139:0] io_inttWrDataPacked_hi = {wrDataBits__7,wrDataBits__6,wrDataBits__5,wrDataBits__4}; // @[Cat.scala 31:58]
  wire [8:0] rdAddrBits__1 = u_intt_0_io_rd_r_addr_1; // @[Preprocess.scala 67:26 74:24]
  wire [8:0] rdAddrBits__0 = u_intt_0_io_rd_r_addr_0; // @[Preprocess.scala 67:26 74:24]
  wire [8:0] rdAddrBits__3 = u_intt_0_io_rd_r_addr_3; // @[Preprocess.scala 67:26 74:24]
  wire [8:0] rdAddrBits__2 = u_intt_0_io_rd_r_addr_2; // @[Preprocess.scala 67:26 74:24]
  wire [35:0] io_inttRdAddrPacked_lo = {rdAddrBits__3,rdAddrBits__2,rdAddrBits__1,rdAddrBits__0}; // @[Cat.scala 31:58]
  wire [8:0] rdAddrBits__5 = u_intt_0_io_rd_r_addr_5; // @[Preprocess.scala 67:26 74:24]
  wire [8:0] rdAddrBits__4 = u_intt_0_io_rd_r_addr_4; // @[Preprocess.scala 67:26 74:24]
  wire [8:0] rdAddrBits__7 = u_intt_0_io_rd_r_addr_7; // @[Preprocess.scala 67:26 74:24]
  wire [8:0] rdAddrBits__6 = u_intt_0_io_rd_r_addr_6; // @[Preprocess.scala 67:26 74:24]
  wire [35:0] io_inttRdAddrPacked_hi = {rdAddrBits__7,rdAddrBits__6,rdAddrBits__5,rdAddrBits__4}; // @[Cat.scala 31:58]
  wire  wrEnBits_1_2 = u_tpp_0_io_banks_wr_0_en_2; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_1 = u_tpp_0_io_banks_wr_0_en_1; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_0 = u_tpp_0_io_banks_wr_0_en_0; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_5 = u_tpp_0_io_banks_wr_0_en_5; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_4 = u_tpp_0_io_banks_wr_0_en_4; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_3 = u_tpp_0_io_banks_wr_0_en_3; // @[Preprocess.scala 104:26 113:23]
  wire [5:0] tppWrEnPacked_lo_lo = {wrEnBits_1_5,wrEnBits_1_4,wrEnBits_1_3,wrEnBits_1_2,wrEnBits_1_1,wrEnBits_1_0}; // @[Cat.scala 31:58]
  wire  wrEnBits_1_8 = u_tpp_0_io_banks_wr_1_en_0; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_7 = u_tpp_0_io_banks_wr_0_en_7; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_6 = u_tpp_0_io_banks_wr_0_en_6; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_11 = u_tpp_0_io_banks_wr_1_en_3; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_10 = u_tpp_0_io_banks_wr_1_en_2; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_9 = u_tpp_0_io_banks_wr_1_en_1; // @[Preprocess.scala 104:26 113:23]
  wire [11:0] tppWrEnPacked_lo = {wrEnBits_1_11,wrEnBits_1_10,wrEnBits_1_9,wrEnBits_1_8,wrEnBits_1_7,wrEnBits_1_6,
    tppWrEnPacked_lo_lo}; // @[Cat.scala 31:58]
  wire  wrEnBits_1_14 = u_tpp_0_io_banks_wr_1_en_6; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_13 = u_tpp_0_io_banks_wr_1_en_5; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_12 = u_tpp_0_io_banks_wr_1_en_4; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_17 = u_tpp_0_io_banks_wr_2_en_1; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_16 = u_tpp_0_io_banks_wr_2_en_0; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_15 = u_tpp_0_io_banks_wr_1_en_7; // @[Preprocess.scala 104:26 113:23]
  wire [5:0] tppWrEnPacked_hi_lo = {wrEnBits_1_17,wrEnBits_1_16,wrEnBits_1_15,wrEnBits_1_14,wrEnBits_1_13,wrEnBits_1_12}
    ; // @[Cat.scala 31:58]
  wire  wrEnBits_1_20 = u_tpp_0_io_banks_wr_2_en_4; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_19 = u_tpp_0_io_banks_wr_2_en_3; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_18 = u_tpp_0_io_banks_wr_2_en_2; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_23 = u_tpp_0_io_banks_wr_2_en_7; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_22 = u_tpp_0_io_banks_wr_2_en_6; // @[Preprocess.scala 104:26 113:23]
  wire  wrEnBits_1_21 = u_tpp_0_io_banks_wr_2_en_5; // @[Preprocess.scala 104:26 113:23]
  wire [11:0] tppWrEnPacked_hi = {wrEnBits_1_23,wrEnBits_1_22,wrEnBits_1_21,wrEnBits_1_20,wrEnBits_1_19,wrEnBits_1_18,
    tppWrEnPacked_hi_lo}; // @[Cat.scala 31:58]
  wire [8:0] wrAddrBits_1_2 = u_tpp_0_io_banks_wr_0_addr_2; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_1 = u_tpp_0_io_banks_wr_0_addr_1; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_0 = u_tpp_0_io_banks_wr_0_addr_0; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_5 = u_tpp_0_io_banks_wr_0_addr_5; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_4 = u_tpp_0_io_banks_wr_0_addr_4; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_3 = u_tpp_0_io_banks_wr_0_addr_3; // @[Preprocess.scala 105:26 114:23]
  wire [53:0] tppWrAddrPacked_lo_lo = {wrAddrBits_1_5,wrAddrBits_1_4,wrAddrBits_1_3,wrAddrBits_1_2,wrAddrBits_1_1,
    wrAddrBits_1_0}; // @[Cat.scala 31:58]
  wire [8:0] wrAddrBits_1_8 = u_tpp_0_io_banks_wr_1_addr_0; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_7 = u_tpp_0_io_banks_wr_0_addr_7; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_6 = u_tpp_0_io_banks_wr_0_addr_6; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_11 = u_tpp_0_io_banks_wr_1_addr_3; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_10 = u_tpp_0_io_banks_wr_1_addr_2; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_9 = u_tpp_0_io_banks_wr_1_addr_1; // @[Preprocess.scala 105:26 114:23]
  wire [107:0] tppWrAddrPacked_lo = {wrAddrBits_1_11,wrAddrBits_1_10,wrAddrBits_1_9,wrAddrBits_1_8,wrAddrBits_1_7,
    wrAddrBits_1_6,tppWrAddrPacked_lo_lo}; // @[Cat.scala 31:58]
  wire [8:0] wrAddrBits_1_14 = u_tpp_0_io_banks_wr_1_addr_6; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_13 = u_tpp_0_io_banks_wr_1_addr_5; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_12 = u_tpp_0_io_banks_wr_1_addr_4; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_17 = u_tpp_0_io_banks_wr_2_addr_1; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_16 = u_tpp_0_io_banks_wr_2_addr_0; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_15 = u_tpp_0_io_banks_wr_1_addr_7; // @[Preprocess.scala 105:26 114:23]
  wire [53:0] tppWrAddrPacked_hi_lo = {wrAddrBits_1_17,wrAddrBits_1_16,wrAddrBits_1_15,wrAddrBits_1_14,wrAddrBits_1_13,
    wrAddrBits_1_12}; // @[Cat.scala 31:58]
  wire [8:0] wrAddrBits_1_20 = u_tpp_0_io_banks_wr_2_addr_4; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_19 = u_tpp_0_io_banks_wr_2_addr_3; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_18 = u_tpp_0_io_banks_wr_2_addr_2; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_23 = u_tpp_0_io_banks_wr_2_addr_7; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_22 = u_tpp_0_io_banks_wr_2_addr_6; // @[Preprocess.scala 105:26 114:23]
  wire [8:0] wrAddrBits_1_21 = u_tpp_0_io_banks_wr_2_addr_5; // @[Preprocess.scala 105:26 114:23]
  wire [107:0] tppWrAddrPacked_hi = {wrAddrBits_1_23,wrAddrBits_1_22,wrAddrBits_1_21,wrAddrBits_1_20,wrAddrBits_1_19,
    wrAddrBits_1_18,tppWrAddrPacked_hi_lo}; // @[Cat.scala 31:58]
  wire [34:0] wrDataBits_1_2 = u_tpp_0_io_banks_wr_0_data_2; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_1 = u_tpp_0_io_banks_wr_0_data_1; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_0 = u_tpp_0_io_banks_wr_0_data_0; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_5 = u_tpp_0_io_banks_wr_0_data_5; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_4 = u_tpp_0_io_banks_wr_0_data_4; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_3 = u_tpp_0_io_banks_wr_0_data_3; // @[Preprocess.scala 106:26 115:23]
  wire [209:0] tppWrDataPacked_lo_lo = {wrDataBits_1_5,wrDataBits_1_4,wrDataBits_1_3,wrDataBits_1_2,wrDataBits_1_1,
    wrDataBits_1_0}; // @[Cat.scala 31:58]
  wire [34:0] wrDataBits_1_8 = u_tpp_0_io_banks_wr_1_data_0; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_7 = u_tpp_0_io_banks_wr_0_data_7; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_6 = u_tpp_0_io_banks_wr_0_data_6; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_11 = u_tpp_0_io_banks_wr_1_data_3; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_10 = u_tpp_0_io_banks_wr_1_data_2; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_9 = u_tpp_0_io_banks_wr_1_data_1; // @[Preprocess.scala 106:26 115:23]
  wire [419:0] tppWrDataPacked_lo = {wrDataBits_1_11,wrDataBits_1_10,wrDataBits_1_9,wrDataBits_1_8,wrDataBits_1_7,
    wrDataBits_1_6,tppWrDataPacked_lo_lo}; // @[Cat.scala 31:58]
  wire [34:0] wrDataBits_1_14 = u_tpp_0_io_banks_wr_1_data_6; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_13 = u_tpp_0_io_banks_wr_1_data_5; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_12 = u_tpp_0_io_banks_wr_1_data_4; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_17 = u_tpp_0_io_banks_wr_2_data_1; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_16 = u_tpp_0_io_banks_wr_2_data_0; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_15 = u_tpp_0_io_banks_wr_1_data_7; // @[Preprocess.scala 106:26 115:23]
  wire [209:0] tppWrDataPacked_hi_lo = {wrDataBits_1_17,wrDataBits_1_16,wrDataBits_1_15,wrDataBits_1_14,wrDataBits_1_13,
    wrDataBits_1_12}; // @[Cat.scala 31:58]
  wire [34:0] wrDataBits_1_20 = u_tpp_0_io_banks_wr_2_data_4; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_19 = u_tpp_0_io_banks_wr_2_data_3; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_18 = u_tpp_0_io_banks_wr_2_data_2; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_23 = u_tpp_0_io_banks_wr_2_data_7; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_22 = u_tpp_0_io_banks_wr_2_data_6; // @[Preprocess.scala 106:26 115:23]
  wire [34:0] wrDataBits_1_21 = u_tpp_0_io_banks_wr_2_data_5; // @[Preprocess.scala 106:26 115:23]
  wire [419:0] tppWrDataPacked_hi = {wrDataBits_1_23,wrDataBits_1_22,wrDataBits_1_21,wrDataBits_1_20,wrDataBits_1_19,
    wrDataBits_1_18,tppWrDataPacked_hi_lo}; // @[Cat.scala 31:58]
  wire [8:0] rdAddrBits_1_2 = u_tpp_0_io_banks_rd_0_addr_2; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_1 = u_tpp_0_io_banks_rd_0_addr_1; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_0 = u_tpp_0_io_banks_rd_0_addr_0; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_5 = u_tpp_0_io_banks_rd_0_addr_5; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_4 = u_tpp_0_io_banks_rd_0_addr_4; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_3 = u_tpp_0_io_banks_rd_0_addr_3; // @[Preprocess.scala 107:26 117:23]
  wire [53:0] tppRdAddrPacked_lo_lo = {rdAddrBits_1_5,rdAddrBits_1_4,rdAddrBits_1_3,rdAddrBits_1_2,rdAddrBits_1_1,
    rdAddrBits_1_0}; // @[Cat.scala 31:58]
  wire [8:0] rdAddrBits_1_8 = u_tpp_0_io_banks_rd_1_addr_0; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_7 = u_tpp_0_io_banks_rd_0_addr_7; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_6 = u_tpp_0_io_banks_rd_0_addr_6; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_11 = u_tpp_0_io_banks_rd_1_addr_3; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_10 = u_tpp_0_io_banks_rd_1_addr_2; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_9 = u_tpp_0_io_banks_rd_1_addr_1; // @[Preprocess.scala 107:26 117:23]
  wire [107:0] tppRdAddrPacked_lo = {rdAddrBits_1_11,rdAddrBits_1_10,rdAddrBits_1_9,rdAddrBits_1_8,rdAddrBits_1_7,
    rdAddrBits_1_6,tppRdAddrPacked_lo_lo}; // @[Cat.scala 31:58]
  wire [8:0] rdAddrBits_1_14 = u_tpp_0_io_banks_rd_1_addr_6; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_13 = u_tpp_0_io_banks_rd_1_addr_5; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_12 = u_tpp_0_io_banks_rd_1_addr_4; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_17 = u_tpp_0_io_banks_rd_2_addr_1; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_16 = u_tpp_0_io_banks_rd_2_addr_0; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_15 = u_tpp_0_io_banks_rd_1_addr_7; // @[Preprocess.scala 107:26 117:23]
  wire [53:0] tppRdAddrPacked_hi_lo = {rdAddrBits_1_17,rdAddrBits_1_16,rdAddrBits_1_15,rdAddrBits_1_14,rdAddrBits_1_13,
    rdAddrBits_1_12}; // @[Cat.scala 31:58]
  wire [8:0] rdAddrBits_1_20 = u_tpp_0_io_banks_rd_2_addr_4; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_19 = u_tpp_0_io_banks_rd_2_addr_3; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_18 = u_tpp_0_io_banks_rd_2_addr_2; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_23 = u_tpp_0_io_banks_rd_2_addr_7; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_22 = u_tpp_0_io_banks_rd_2_addr_6; // @[Preprocess.scala 107:26 117:23]
  wire [8:0] rdAddrBits_1_21 = u_tpp_0_io_banks_rd_2_addr_5; // @[Preprocess.scala 107:26 117:23]
  wire [107:0] tppRdAddrPacked_hi = {rdAddrBits_1_23,rdAddrBits_1_22,rdAddrBits_1_21,rdAddrBits_1_20,rdAddrBits_1_19,
    rdAddrBits_1_18,tppRdAddrPacked_hi_lo}; // @[Cat.scala 31:58]
  wire [139:0] io_o_intt_concat_lo = {u_intt_0_io_wr_l_data_3,u_intt_0_io_wr_l_data_2,u_intt_0_io_wr_l_data_1,
    u_intt_0_io_wr_l_data_0}; // @[Cat.scala 31:58]
  wire [139:0] io_o_intt_concat_hi = {u_intt_0_io_wr_l_data_7,u_intt_0_io_wr_l_data_6,u_intt_0_io_wr_l_data_5,
    u_intt_0_io_wr_l_data_4}; // @[Cat.scala 31:58]
  wire [35:0] io_o_intt_addr_lo = {u_intt_0_io_wr_l_addr_3,u_intt_0_io_wr_l_addr_2,u_intt_0_io_wr_l_addr_1,
    u_intt_0_io_wr_l_addr_0}; // @[Cat.scala 31:58]
  wire [35:0] io_o_intt_addr_hi = {u_intt_0_io_wr_l_addr_7,u_intt_0_io_wr_l_addr_6,u_intt_0_io_wr_l_addr_5,
    u_intt_0_io_wr_l_addr_4}; // @[Cat.scala 31:58]
  intt_17314086913 u_intt_0 ( // @[Preprocess.scala 47:46]
    .clock(u_intt_0_clock),
    .reset(u_intt_0_reset),
    .io_ntt_start(u_intt_0_io_ntt_start),
    .io_ntt_done(u_intt_0_io_ntt_done),
    .io_wr_l_en_0(u_intt_0_io_wr_l_en_0),
    .io_wr_l_en_1(u_intt_0_io_wr_l_en_1),
    .io_wr_l_en_2(u_intt_0_io_wr_l_en_2),
    .io_wr_l_en_3(u_intt_0_io_wr_l_en_3),
    .io_wr_l_en_4(u_intt_0_io_wr_l_en_4),
    .io_wr_l_en_5(u_intt_0_io_wr_l_en_5),
    .io_wr_l_en_6(u_intt_0_io_wr_l_en_6),
    .io_wr_l_en_7(u_intt_0_io_wr_l_en_7),
    .io_wr_l_addr_0(u_intt_0_io_wr_l_addr_0),
    .io_wr_l_addr_1(u_intt_0_io_wr_l_addr_1),
    .io_wr_l_addr_2(u_intt_0_io_wr_l_addr_2),
    .io_wr_l_addr_3(u_intt_0_io_wr_l_addr_3),
    .io_wr_l_addr_4(u_intt_0_io_wr_l_addr_4),
    .io_wr_l_addr_5(u_intt_0_io_wr_l_addr_5),
    .io_wr_l_addr_6(u_intt_0_io_wr_l_addr_6),
    .io_wr_l_addr_7(u_intt_0_io_wr_l_addr_7),
    .io_wr_l_data_0(u_intt_0_io_wr_l_data_0),
    .io_wr_l_data_1(u_intt_0_io_wr_l_data_1),
    .io_wr_l_data_2(u_intt_0_io_wr_l_data_2),
    .io_wr_l_data_3(u_intt_0_io_wr_l_data_3),
    .io_wr_l_data_4(u_intt_0_io_wr_l_data_4),
    .io_wr_l_data_5(u_intt_0_io_wr_l_data_5),
    .io_wr_l_data_6(u_intt_0_io_wr_l_data_6),
    .io_wr_l_data_7(u_intt_0_io_wr_l_data_7),
    .io_wr_r_en_0(u_intt_0_io_wr_r_en_0),
    .io_wr_r_en_1(u_intt_0_io_wr_r_en_1),
    .io_wr_r_en_2(u_intt_0_io_wr_r_en_2),
    .io_wr_r_en_3(u_intt_0_io_wr_r_en_3),
    .io_wr_r_en_4(u_intt_0_io_wr_r_en_4),
    .io_wr_r_en_5(u_intt_0_io_wr_r_en_5),
    .io_wr_r_en_6(u_intt_0_io_wr_r_en_6),
    .io_wr_r_en_7(u_intt_0_io_wr_r_en_7),
    .io_wr_r_addr_0(u_intt_0_io_wr_r_addr_0),
    .io_wr_r_addr_1(u_intt_0_io_wr_r_addr_1),
    .io_wr_r_addr_2(u_intt_0_io_wr_r_addr_2),
    .io_wr_r_addr_3(u_intt_0_io_wr_r_addr_3),
    .io_wr_r_addr_4(u_intt_0_io_wr_r_addr_4),
    .io_wr_r_addr_5(u_intt_0_io_wr_r_addr_5),
    .io_wr_r_addr_6(u_intt_0_io_wr_r_addr_6),
    .io_wr_r_addr_7(u_intt_0_io_wr_r_addr_7),
    .io_wr_r_data_0(u_intt_0_io_wr_r_data_0),
    .io_wr_r_data_1(u_intt_0_io_wr_r_data_1),
    .io_wr_r_data_2(u_intt_0_io_wr_r_data_2),
    .io_wr_r_data_3(u_intt_0_io_wr_r_data_3),
    .io_wr_r_data_4(u_intt_0_io_wr_r_data_4),
    .io_wr_r_data_5(u_intt_0_io_wr_r_data_5),
    .io_wr_r_data_6(u_intt_0_io_wr_r_data_6),
    .io_wr_r_data_7(u_intt_0_io_wr_r_data_7),
    .io_rd_l_addr_0(u_intt_0_io_rd_l_addr_0),
    .io_rd_l_addr_1(u_intt_0_io_rd_l_addr_1),
    .io_rd_l_addr_2(u_intt_0_io_rd_l_addr_2),
    .io_rd_l_addr_3(u_intt_0_io_rd_l_addr_3),
    .io_rd_l_addr_4(u_intt_0_io_rd_l_addr_4),
    .io_rd_l_addr_5(u_intt_0_io_rd_l_addr_5),
    .io_rd_l_addr_6(u_intt_0_io_rd_l_addr_6),
    .io_rd_l_addr_7(u_intt_0_io_rd_l_addr_7),
    .io_rd_l_data_0(u_intt_0_io_rd_l_data_0),
    .io_rd_l_data_1(u_intt_0_io_rd_l_data_1),
    .io_rd_l_data_2(u_intt_0_io_rd_l_data_2),
    .io_rd_l_data_3(u_intt_0_io_rd_l_data_3),
    .io_rd_l_data_4(u_intt_0_io_rd_l_data_4),
    .io_rd_l_data_5(u_intt_0_io_rd_l_data_5),
    .io_rd_l_data_6(u_intt_0_io_rd_l_data_6),
    .io_rd_l_data_7(u_intt_0_io_rd_l_data_7),
    .io_rd_r_addr_0(u_intt_0_io_rd_r_addr_0),
    .io_rd_r_addr_1(u_intt_0_io_rd_r_addr_1),
    .io_rd_r_addr_2(u_intt_0_io_rd_r_addr_2),
    .io_rd_r_addr_3(u_intt_0_io_rd_r_addr_3),
    .io_rd_r_addr_4(u_intt_0_io_rd_r_addr_4),
    .io_rd_r_addr_5(u_intt_0_io_rd_r_addr_5),
    .io_rd_r_addr_6(u_intt_0_io_rd_r_addr_6),
    .io_rd_r_addr_7(u_intt_0_io_rd_r_addr_7),
    .io_rd_r_data_0(u_intt_0_io_rd_r_data_0),
    .io_rd_r_data_1(u_intt_0_io_rd_r_data_1),
    .io_rd_r_data_2(u_intt_0_io_rd_r_data_2),
    .io_rd_r_data_3(u_intt_0_io_rd_r_data_3),
    .io_rd_r_data_4(u_intt_0_io_rd_r_data_4),
    .io_rd_r_data_5(u_intt_0_io_rd_r_data_5),
    .io_rd_r_data_6(u_intt_0_io_rd_r_data_6),
    .io_rd_r_data_7(u_intt_0_io_rd_r_data_7),
    .io_o_we_result(u_intt_0_io_o_we_result)
  );
  triple_pp_buffer_35_512_8 u_tpp_0 ( // @[Preprocess.scala 50:11]
    .clock(u_tpp_0_clock),
    .reset(u_tpp_0_reset),
    .io_i_done(u_tpp_0_io_i_done),
    .io_polyvec0_rd_addr_0(u_tpp_0_io_polyvec0_rd_addr_0),
    .io_polyvec0_rd_addr_1(u_tpp_0_io_polyvec0_rd_addr_1),
    .io_polyvec0_rd_addr_2(u_tpp_0_io_polyvec0_rd_addr_2),
    .io_polyvec0_rd_addr_3(u_tpp_0_io_polyvec0_rd_addr_3),
    .io_polyvec0_rd_addr_4(u_tpp_0_io_polyvec0_rd_addr_4),
    .io_polyvec0_rd_addr_5(u_tpp_0_io_polyvec0_rd_addr_5),
    .io_polyvec0_rd_addr_6(u_tpp_0_io_polyvec0_rd_addr_6),
    .io_polyvec0_rd_addr_7(u_tpp_0_io_polyvec0_rd_addr_7),
    .io_polyvec0_rd_data_0(u_tpp_0_io_polyvec0_rd_data_0),
    .io_polyvec0_rd_data_1(u_tpp_0_io_polyvec0_rd_data_1),
    .io_polyvec0_rd_data_2(u_tpp_0_io_polyvec0_rd_data_2),
    .io_polyvec0_rd_data_3(u_tpp_0_io_polyvec0_rd_data_3),
    .io_polyvec0_rd_data_4(u_tpp_0_io_polyvec0_rd_data_4),
    .io_polyvec0_rd_data_5(u_tpp_0_io_polyvec0_rd_data_5),
    .io_polyvec0_rd_data_6(u_tpp_0_io_polyvec0_rd_data_6),
    .io_polyvec0_rd_data_7(u_tpp_0_io_polyvec0_rd_data_7),
    .io_polyvec0_wr_en_0(u_tpp_0_io_polyvec0_wr_en_0),
    .io_polyvec0_wr_en_1(u_tpp_0_io_polyvec0_wr_en_1),
    .io_polyvec0_wr_en_2(u_tpp_0_io_polyvec0_wr_en_2),
    .io_polyvec0_wr_en_3(u_tpp_0_io_polyvec0_wr_en_3),
    .io_polyvec0_wr_en_4(u_tpp_0_io_polyvec0_wr_en_4),
    .io_polyvec0_wr_en_5(u_tpp_0_io_polyvec0_wr_en_5),
    .io_polyvec0_wr_en_6(u_tpp_0_io_polyvec0_wr_en_6),
    .io_polyvec0_wr_en_7(u_tpp_0_io_polyvec0_wr_en_7),
    .io_polyvec0_wr_addr_0(u_tpp_0_io_polyvec0_wr_addr_0),
    .io_polyvec0_wr_addr_1(u_tpp_0_io_polyvec0_wr_addr_1),
    .io_polyvec0_wr_addr_2(u_tpp_0_io_polyvec0_wr_addr_2),
    .io_polyvec0_wr_addr_3(u_tpp_0_io_polyvec0_wr_addr_3),
    .io_polyvec0_wr_addr_4(u_tpp_0_io_polyvec0_wr_addr_4),
    .io_polyvec0_wr_addr_5(u_tpp_0_io_polyvec0_wr_addr_5),
    .io_polyvec0_wr_addr_6(u_tpp_0_io_polyvec0_wr_addr_6),
    .io_polyvec0_wr_addr_7(u_tpp_0_io_polyvec0_wr_addr_7),
    .io_polyvec0_wr_data_0(u_tpp_0_io_polyvec0_wr_data_0),
    .io_polyvec0_wr_data_1(u_tpp_0_io_polyvec0_wr_data_1),
    .io_polyvec0_wr_data_2(u_tpp_0_io_polyvec0_wr_data_2),
    .io_polyvec0_wr_data_3(u_tpp_0_io_polyvec0_wr_data_3),
    .io_polyvec0_wr_data_4(u_tpp_0_io_polyvec0_wr_data_4),
    .io_polyvec0_wr_data_5(u_tpp_0_io_polyvec0_wr_data_5),
    .io_polyvec0_wr_data_6(u_tpp_0_io_polyvec0_wr_data_6),
    .io_polyvec0_wr_data_7(u_tpp_0_io_polyvec0_wr_data_7),
    .io_polyvec1_rd_addr_0(u_tpp_0_io_polyvec1_rd_addr_0),
    .io_polyvec1_rd_addr_1(u_tpp_0_io_polyvec1_rd_addr_1),
    .io_polyvec1_rd_addr_2(u_tpp_0_io_polyvec1_rd_addr_2),
    .io_polyvec1_rd_addr_3(u_tpp_0_io_polyvec1_rd_addr_3),
    .io_polyvec1_rd_addr_4(u_tpp_0_io_polyvec1_rd_addr_4),
    .io_polyvec1_rd_addr_5(u_tpp_0_io_polyvec1_rd_addr_5),
    .io_polyvec1_rd_addr_6(u_tpp_0_io_polyvec1_rd_addr_6),
    .io_polyvec1_rd_addr_7(u_tpp_0_io_polyvec1_rd_addr_7),
    .io_polyvec1_rd_data_0(u_tpp_0_io_polyvec1_rd_data_0),
    .io_polyvec1_rd_data_1(u_tpp_0_io_polyvec1_rd_data_1),
    .io_polyvec1_rd_data_2(u_tpp_0_io_polyvec1_rd_data_2),
    .io_polyvec1_rd_data_3(u_tpp_0_io_polyvec1_rd_data_3),
    .io_polyvec1_rd_data_4(u_tpp_0_io_polyvec1_rd_data_4),
    .io_polyvec1_rd_data_5(u_tpp_0_io_polyvec1_rd_data_5),
    .io_polyvec1_rd_data_6(u_tpp_0_io_polyvec1_rd_data_6),
    .io_polyvec1_rd_data_7(u_tpp_0_io_polyvec1_rd_data_7),
    .io_polyvec1_wr_en_0(u_tpp_0_io_polyvec1_wr_en_0),
    .io_polyvec1_wr_en_1(u_tpp_0_io_polyvec1_wr_en_1),
    .io_polyvec1_wr_en_2(u_tpp_0_io_polyvec1_wr_en_2),
    .io_polyvec1_wr_en_3(u_tpp_0_io_polyvec1_wr_en_3),
    .io_polyvec1_wr_en_4(u_tpp_0_io_polyvec1_wr_en_4),
    .io_polyvec1_wr_en_5(u_tpp_0_io_polyvec1_wr_en_5),
    .io_polyvec1_wr_en_6(u_tpp_0_io_polyvec1_wr_en_6),
    .io_polyvec1_wr_en_7(u_tpp_0_io_polyvec1_wr_en_7),
    .io_polyvec1_wr_addr_0(u_tpp_0_io_polyvec1_wr_addr_0),
    .io_polyvec1_wr_addr_1(u_tpp_0_io_polyvec1_wr_addr_1),
    .io_polyvec1_wr_addr_2(u_tpp_0_io_polyvec1_wr_addr_2),
    .io_polyvec1_wr_addr_3(u_tpp_0_io_polyvec1_wr_addr_3),
    .io_polyvec1_wr_addr_4(u_tpp_0_io_polyvec1_wr_addr_4),
    .io_polyvec1_wr_addr_5(u_tpp_0_io_polyvec1_wr_addr_5),
    .io_polyvec1_wr_addr_6(u_tpp_0_io_polyvec1_wr_addr_6),
    .io_polyvec1_wr_addr_7(u_tpp_0_io_polyvec1_wr_addr_7),
    .io_polyvec1_wr_data_0(u_tpp_0_io_polyvec1_wr_data_0),
    .io_polyvec1_wr_data_1(u_tpp_0_io_polyvec1_wr_data_1),
    .io_polyvec1_wr_data_2(u_tpp_0_io_polyvec1_wr_data_2),
    .io_polyvec1_wr_data_3(u_tpp_0_io_polyvec1_wr_data_3),
    .io_polyvec1_wr_data_4(u_tpp_0_io_polyvec1_wr_data_4),
    .io_polyvec1_wr_data_5(u_tpp_0_io_polyvec1_wr_data_5),
    .io_polyvec1_wr_data_6(u_tpp_0_io_polyvec1_wr_data_6),
    .io_polyvec1_wr_data_7(u_tpp_0_io_polyvec1_wr_data_7),
    .io_banks_rd_0_addr_0(u_tpp_0_io_banks_rd_0_addr_0),
    .io_banks_rd_0_addr_1(u_tpp_0_io_banks_rd_0_addr_1),
    .io_banks_rd_0_addr_2(u_tpp_0_io_banks_rd_0_addr_2),
    .io_banks_rd_0_addr_3(u_tpp_0_io_banks_rd_0_addr_3),
    .io_banks_rd_0_addr_4(u_tpp_0_io_banks_rd_0_addr_4),
    .io_banks_rd_0_addr_5(u_tpp_0_io_banks_rd_0_addr_5),
    .io_banks_rd_0_addr_6(u_tpp_0_io_banks_rd_0_addr_6),
    .io_banks_rd_0_addr_7(u_tpp_0_io_banks_rd_0_addr_7),
    .io_banks_rd_0_data_0(u_tpp_0_io_banks_rd_0_data_0),
    .io_banks_rd_0_data_1(u_tpp_0_io_banks_rd_0_data_1),
    .io_banks_rd_0_data_2(u_tpp_0_io_banks_rd_0_data_2),
    .io_banks_rd_0_data_3(u_tpp_0_io_banks_rd_0_data_3),
    .io_banks_rd_0_data_4(u_tpp_0_io_banks_rd_0_data_4),
    .io_banks_rd_0_data_5(u_tpp_0_io_banks_rd_0_data_5),
    .io_banks_rd_0_data_6(u_tpp_0_io_banks_rd_0_data_6),
    .io_banks_rd_0_data_7(u_tpp_0_io_banks_rd_0_data_7),
    .io_banks_rd_1_addr_0(u_tpp_0_io_banks_rd_1_addr_0),
    .io_banks_rd_1_addr_1(u_tpp_0_io_banks_rd_1_addr_1),
    .io_banks_rd_1_addr_2(u_tpp_0_io_banks_rd_1_addr_2),
    .io_banks_rd_1_addr_3(u_tpp_0_io_banks_rd_1_addr_3),
    .io_banks_rd_1_addr_4(u_tpp_0_io_banks_rd_1_addr_4),
    .io_banks_rd_1_addr_5(u_tpp_0_io_banks_rd_1_addr_5),
    .io_banks_rd_1_addr_6(u_tpp_0_io_banks_rd_1_addr_6),
    .io_banks_rd_1_addr_7(u_tpp_0_io_banks_rd_1_addr_7),
    .io_banks_rd_1_data_0(u_tpp_0_io_banks_rd_1_data_0),
    .io_banks_rd_1_data_1(u_tpp_0_io_banks_rd_1_data_1),
    .io_banks_rd_1_data_2(u_tpp_0_io_banks_rd_1_data_2),
    .io_banks_rd_1_data_3(u_tpp_0_io_banks_rd_1_data_3),
    .io_banks_rd_1_data_4(u_tpp_0_io_banks_rd_1_data_4),
    .io_banks_rd_1_data_5(u_tpp_0_io_banks_rd_1_data_5),
    .io_banks_rd_1_data_6(u_tpp_0_io_banks_rd_1_data_6),
    .io_banks_rd_1_data_7(u_tpp_0_io_banks_rd_1_data_7),
    .io_banks_rd_2_addr_0(u_tpp_0_io_banks_rd_2_addr_0),
    .io_banks_rd_2_addr_1(u_tpp_0_io_banks_rd_2_addr_1),
    .io_banks_rd_2_addr_2(u_tpp_0_io_banks_rd_2_addr_2),
    .io_banks_rd_2_addr_3(u_tpp_0_io_banks_rd_2_addr_3),
    .io_banks_rd_2_addr_4(u_tpp_0_io_banks_rd_2_addr_4),
    .io_banks_rd_2_addr_5(u_tpp_0_io_banks_rd_2_addr_5),
    .io_banks_rd_2_addr_6(u_tpp_0_io_banks_rd_2_addr_6),
    .io_banks_rd_2_addr_7(u_tpp_0_io_banks_rd_2_addr_7),
    .io_banks_rd_2_data_0(u_tpp_0_io_banks_rd_2_data_0),
    .io_banks_rd_2_data_1(u_tpp_0_io_banks_rd_2_data_1),
    .io_banks_rd_2_data_2(u_tpp_0_io_banks_rd_2_data_2),
    .io_banks_rd_2_data_3(u_tpp_0_io_banks_rd_2_data_3),
    .io_banks_rd_2_data_4(u_tpp_0_io_banks_rd_2_data_4),
    .io_banks_rd_2_data_5(u_tpp_0_io_banks_rd_2_data_5),
    .io_banks_rd_2_data_6(u_tpp_0_io_banks_rd_2_data_6),
    .io_banks_rd_2_data_7(u_tpp_0_io_banks_rd_2_data_7),
    .io_banks_wr_0_en_0(u_tpp_0_io_banks_wr_0_en_0),
    .io_banks_wr_0_en_1(u_tpp_0_io_banks_wr_0_en_1),
    .io_banks_wr_0_en_2(u_tpp_0_io_banks_wr_0_en_2),
    .io_banks_wr_0_en_3(u_tpp_0_io_banks_wr_0_en_3),
    .io_banks_wr_0_en_4(u_tpp_0_io_banks_wr_0_en_4),
    .io_banks_wr_0_en_5(u_tpp_0_io_banks_wr_0_en_5),
    .io_banks_wr_0_en_6(u_tpp_0_io_banks_wr_0_en_6),
    .io_banks_wr_0_en_7(u_tpp_0_io_banks_wr_0_en_7),
    .io_banks_wr_0_addr_0(u_tpp_0_io_banks_wr_0_addr_0),
    .io_banks_wr_0_addr_1(u_tpp_0_io_banks_wr_0_addr_1),
    .io_banks_wr_0_addr_2(u_tpp_0_io_banks_wr_0_addr_2),
    .io_banks_wr_0_addr_3(u_tpp_0_io_banks_wr_0_addr_3),
    .io_banks_wr_0_addr_4(u_tpp_0_io_banks_wr_0_addr_4),
    .io_banks_wr_0_addr_5(u_tpp_0_io_banks_wr_0_addr_5),
    .io_banks_wr_0_addr_6(u_tpp_0_io_banks_wr_0_addr_6),
    .io_banks_wr_0_addr_7(u_tpp_0_io_banks_wr_0_addr_7),
    .io_banks_wr_0_data_0(u_tpp_0_io_banks_wr_0_data_0),
    .io_banks_wr_0_data_1(u_tpp_0_io_banks_wr_0_data_1),
    .io_banks_wr_0_data_2(u_tpp_0_io_banks_wr_0_data_2),
    .io_banks_wr_0_data_3(u_tpp_0_io_banks_wr_0_data_3),
    .io_banks_wr_0_data_4(u_tpp_0_io_banks_wr_0_data_4),
    .io_banks_wr_0_data_5(u_tpp_0_io_banks_wr_0_data_5),
    .io_banks_wr_0_data_6(u_tpp_0_io_banks_wr_0_data_6),
    .io_banks_wr_0_data_7(u_tpp_0_io_banks_wr_0_data_7),
    .io_banks_wr_1_en_0(u_tpp_0_io_banks_wr_1_en_0),
    .io_banks_wr_1_en_1(u_tpp_0_io_banks_wr_1_en_1),
    .io_banks_wr_1_en_2(u_tpp_0_io_banks_wr_1_en_2),
    .io_banks_wr_1_en_3(u_tpp_0_io_banks_wr_1_en_3),
    .io_banks_wr_1_en_4(u_tpp_0_io_banks_wr_1_en_4),
    .io_banks_wr_1_en_5(u_tpp_0_io_banks_wr_1_en_5),
    .io_banks_wr_1_en_6(u_tpp_0_io_banks_wr_1_en_6),
    .io_banks_wr_1_en_7(u_tpp_0_io_banks_wr_1_en_7),
    .io_banks_wr_1_addr_0(u_tpp_0_io_banks_wr_1_addr_0),
    .io_banks_wr_1_addr_1(u_tpp_0_io_banks_wr_1_addr_1),
    .io_banks_wr_1_addr_2(u_tpp_0_io_banks_wr_1_addr_2),
    .io_banks_wr_1_addr_3(u_tpp_0_io_banks_wr_1_addr_3),
    .io_banks_wr_1_addr_4(u_tpp_0_io_banks_wr_1_addr_4),
    .io_banks_wr_1_addr_5(u_tpp_0_io_banks_wr_1_addr_5),
    .io_banks_wr_1_addr_6(u_tpp_0_io_banks_wr_1_addr_6),
    .io_banks_wr_1_addr_7(u_tpp_0_io_banks_wr_1_addr_7),
    .io_banks_wr_1_data_0(u_tpp_0_io_banks_wr_1_data_0),
    .io_banks_wr_1_data_1(u_tpp_0_io_banks_wr_1_data_1),
    .io_banks_wr_1_data_2(u_tpp_0_io_banks_wr_1_data_2),
    .io_banks_wr_1_data_3(u_tpp_0_io_banks_wr_1_data_3),
    .io_banks_wr_1_data_4(u_tpp_0_io_banks_wr_1_data_4),
    .io_banks_wr_1_data_5(u_tpp_0_io_banks_wr_1_data_5),
    .io_banks_wr_1_data_6(u_tpp_0_io_banks_wr_1_data_6),
    .io_banks_wr_1_data_7(u_tpp_0_io_banks_wr_1_data_7),
    .io_banks_wr_2_en_0(u_tpp_0_io_banks_wr_2_en_0),
    .io_banks_wr_2_en_1(u_tpp_0_io_banks_wr_2_en_1),
    .io_banks_wr_2_en_2(u_tpp_0_io_banks_wr_2_en_2),
    .io_banks_wr_2_en_3(u_tpp_0_io_banks_wr_2_en_3),
    .io_banks_wr_2_en_4(u_tpp_0_io_banks_wr_2_en_4),
    .io_banks_wr_2_en_5(u_tpp_0_io_banks_wr_2_en_5),
    .io_banks_wr_2_en_6(u_tpp_0_io_banks_wr_2_en_6),
    .io_banks_wr_2_en_7(u_tpp_0_io_banks_wr_2_en_7),
    .io_banks_wr_2_addr_0(u_tpp_0_io_banks_wr_2_addr_0),
    .io_banks_wr_2_addr_1(u_tpp_0_io_banks_wr_2_addr_1),
    .io_banks_wr_2_addr_2(u_tpp_0_io_banks_wr_2_addr_2),
    .io_banks_wr_2_addr_3(u_tpp_0_io_banks_wr_2_addr_3),
    .io_banks_wr_2_addr_4(u_tpp_0_io_banks_wr_2_addr_4),
    .io_banks_wr_2_addr_5(u_tpp_0_io_banks_wr_2_addr_5),
    .io_banks_wr_2_addr_6(u_tpp_0_io_banks_wr_2_addr_6),
    .io_banks_wr_2_addr_7(u_tpp_0_io_banks_wr_2_addr_7),
    .io_banks_wr_2_data_0(u_tpp_0_io_banks_wr_2_data_0),
    .io_banks_wr_2_data_1(u_tpp_0_io_banks_wr_2_data_1),
    .io_banks_wr_2_data_2(u_tpp_0_io_banks_wr_2_data_2),
    .io_banks_wr_2_data_3(u_tpp_0_io_banks_wr_2_data_3),
    .io_banks_wr_2_data_4(u_tpp_0_io_banks_wr_2_data_4),
    .io_banks_wr_2_data_5(u_tpp_0_io_banks_wr_2_data_5),
    .io_banks_wr_2_data_6(u_tpp_0_io_banks_wr_2_data_6),
    .io_banks_wr_2_data_7(u_tpp_0_io_banks_wr_2_data_7)
  );
  poly_wr_interface_35_512_8 u_dp1_wr_itf_0 ( // @[Preprocess.scala 54:11]
    .io_vpu_wr_en(u_dp1_wr_itf_0_io_vpu_wr_en),
    .io_vpu_wr_addr(u_dp1_wr_itf_0_io_vpu_wr_addr),
    .io_vpu_wr_data(u_dp1_wr_itf_0_io_vpu_wr_data),
    .io_buf_wr_en_0(u_dp1_wr_itf_0_io_buf_wr_en_0),
    .io_buf_wr_en_1(u_dp1_wr_itf_0_io_buf_wr_en_1),
    .io_buf_wr_en_2(u_dp1_wr_itf_0_io_buf_wr_en_2),
    .io_buf_wr_en_3(u_dp1_wr_itf_0_io_buf_wr_en_3),
    .io_buf_wr_en_4(u_dp1_wr_itf_0_io_buf_wr_en_4),
    .io_buf_wr_en_5(u_dp1_wr_itf_0_io_buf_wr_en_5),
    .io_buf_wr_en_6(u_dp1_wr_itf_0_io_buf_wr_en_6),
    .io_buf_wr_en_7(u_dp1_wr_itf_0_io_buf_wr_en_7),
    .io_buf_wr_addr_0(u_dp1_wr_itf_0_io_buf_wr_addr_0),
    .io_buf_wr_addr_1(u_dp1_wr_itf_0_io_buf_wr_addr_1),
    .io_buf_wr_addr_2(u_dp1_wr_itf_0_io_buf_wr_addr_2),
    .io_buf_wr_addr_3(u_dp1_wr_itf_0_io_buf_wr_addr_3),
    .io_buf_wr_addr_4(u_dp1_wr_itf_0_io_buf_wr_addr_4),
    .io_buf_wr_addr_5(u_dp1_wr_itf_0_io_buf_wr_addr_5),
    .io_buf_wr_addr_6(u_dp1_wr_itf_0_io_buf_wr_addr_6),
    .io_buf_wr_addr_7(u_dp1_wr_itf_0_io_buf_wr_addr_7),
    .io_buf_wr_data_0(u_dp1_wr_itf_0_io_buf_wr_data_0),
    .io_buf_wr_data_1(u_dp1_wr_itf_0_io_buf_wr_data_1),
    .io_buf_wr_data_2(u_dp1_wr_itf_0_io_buf_wr_data_2),
    .io_buf_wr_data_3(u_dp1_wr_itf_0_io_buf_wr_data_3),
    .io_buf_wr_data_4(u_dp1_wr_itf_0_io_buf_wr_data_4),
    .io_buf_wr_data_5(u_dp1_wr_itf_0_io_buf_wr_data_5),
    .io_buf_wr_data_6(u_dp1_wr_itf_0_io_buf_wr_data_6),
    .io_buf_wr_data_7(u_dp1_wr_itf_0_io_buf_wr_data_7)
  );
  poly_rd_interface_35_512_8_1 u_dp1_rd_itf_0 ( // @[Preprocess.scala 57:11]
    .clock(u_dp1_rd_itf_0_clock),
    .io_vpu_rd_addr(u_dp1_rd_itf_0_io_vpu_rd_addr),
    .io_vpu_rd_data(u_dp1_rd_itf_0_io_vpu_rd_data),
    .io_buf_rd_addr_0(u_dp1_rd_itf_0_io_buf_rd_addr_0),
    .io_buf_rd_addr_1(u_dp1_rd_itf_0_io_buf_rd_addr_1),
    .io_buf_rd_addr_2(u_dp1_rd_itf_0_io_buf_rd_addr_2),
    .io_buf_rd_addr_3(u_dp1_rd_itf_0_io_buf_rd_addr_3),
    .io_buf_rd_addr_4(u_dp1_rd_itf_0_io_buf_rd_addr_4),
    .io_buf_rd_addr_5(u_dp1_rd_itf_0_io_buf_rd_addr_5),
    .io_buf_rd_addr_6(u_dp1_rd_itf_0_io_buf_rd_addr_6),
    .io_buf_rd_addr_7(u_dp1_rd_itf_0_io_buf_rd_addr_7),
    .io_buf_rd_data_0(u_dp1_rd_itf_0_io_buf_rd_data_0),
    .io_buf_rd_data_1(u_dp1_rd_itf_0_io_buf_rd_data_1),
    .io_buf_rd_data_2(u_dp1_rd_itf_0_io_buf_rd_data_2),
    .io_buf_rd_data_3(u_dp1_rd_itf_0_io_buf_rd_data_3),
    .io_buf_rd_data_4(u_dp1_rd_itf_0_io_buf_rd_data_4),
    .io_buf_rd_data_5(u_dp1_rd_itf_0_io_buf_rd_data_5),
    .io_buf_rd_data_6(u_dp1_rd_itf_0_io_buf_rd_data_6),
    .io_buf_rd_data_7(u_dp1_rd_itf_0_io_buf_rd_data_7)
  );
  assign io_o_intt_done = u_intt_0_io_ntt_done; // @[Preprocess.scala 160:19]
  assign io_dp1_rd_0_data = u_dp1_rd_itf_0_io_vpu_rd_data; // @[Preprocess.scala 136:29]
  assign io_o_intt_concat = {io_o_intt_concat_hi,io_o_intt_concat_lo}; // @[Cat.scala 31:58]
  assign io_o_intt_addr = {io_o_intt_addr_hi,io_o_intt_addr_lo}; // @[Cat.scala 31:58]
  assign io_o_intt_we_result = u_intt_0_io_o_we_result; // @[Preprocess.scala 161:23]
  assign io_inttWrEnPacked = {io_inttWrEnPacked_hi,io_inttWrEnPacked_lo}; // @[Cat.scala 31:58]
  assign io_inttWrAddrPacked = {io_inttWrAddrPacked_hi,io_inttWrAddrPacked_lo}; // @[Cat.scala 31:58]
  assign io_inttWrDataPacked = {io_inttWrDataPacked_hi,io_inttWrDataPacked_lo}; // @[Cat.scala 31:58]
  assign io_inttRdAddrPacked = {io_inttRdAddrPacked_hi,io_inttRdAddrPacked_lo}; // @[Cat.scala 31:58]
  assign tppWrEnPacked = {tppWrEnPacked_hi,tppWrEnPacked_lo}; // @[Cat.scala 31:58]
  assign tppWrAddrPacked = {tppWrAddrPacked_hi,tppWrAddrPacked_lo}; // @[Cat.scala 31:58]
  assign tppWrDataPacked = {tppWrDataPacked_hi,tppWrDataPacked_lo}; // @[Cat.scala 31:58]
  assign tppRdAddrPacked = {tppRdAddrPacked_hi,tppRdAddrPacked_lo}; // @[Cat.scala 31:58]
  assign u_intt_0_clock = clock;
  assign u_intt_0_reset = reset;
  assign u_intt_0_io_ntt_start = io_i_intt_start; // @[Preprocess.scala 159:19]
  assign u_intt_0_io_rd_l_data_0 = u_tpp_0_io_polyvec1_rd_data_0; // @[Preprocess.scala 141:29]
  assign u_intt_0_io_rd_l_data_1 = u_tpp_0_io_polyvec1_rd_data_1; // @[Preprocess.scala 141:29]
  assign u_intt_0_io_rd_l_data_2 = u_tpp_0_io_polyvec1_rd_data_2; // @[Preprocess.scala 141:29]
  assign u_intt_0_io_rd_l_data_3 = u_tpp_0_io_polyvec1_rd_data_3; // @[Preprocess.scala 141:29]
  assign u_intt_0_io_rd_l_data_4 = u_tpp_0_io_polyvec1_rd_data_4; // @[Preprocess.scala 141:29]
  assign u_intt_0_io_rd_l_data_5 = u_tpp_0_io_polyvec1_rd_data_5; // @[Preprocess.scala 141:29]
  assign u_intt_0_io_rd_l_data_6 = u_tpp_0_io_polyvec1_rd_data_6; // @[Preprocess.scala 141:29]
  assign u_intt_0_io_rd_l_data_7 = u_tpp_0_io_polyvec1_rd_data_7; // @[Preprocess.scala 141:29]
  assign u_intt_0_io_rd_r_data_0 = io_inttRdDataPacked[34:0]; // @[Preprocess.scala 78:58]
  assign u_intt_0_io_rd_r_data_1 = io_inttRdDataPacked[69:35]; // @[Preprocess.scala 78:58]
  assign u_intt_0_io_rd_r_data_2 = io_inttRdDataPacked[104:70]; // @[Preprocess.scala 78:58]
  assign u_intt_0_io_rd_r_data_3 = io_inttRdDataPacked[139:105]; // @[Preprocess.scala 78:58]
  assign u_intt_0_io_rd_r_data_4 = io_inttRdDataPacked[174:140]; // @[Preprocess.scala 78:58]
  assign u_intt_0_io_rd_r_data_5 = io_inttRdDataPacked[209:175]; // @[Preprocess.scala 78:58]
  assign u_intt_0_io_rd_r_data_6 = io_inttRdDataPacked[244:210]; // @[Preprocess.scala 78:58]
  assign u_intt_0_io_rd_r_data_7 = io_inttRdDataPacked[279:245]; // @[Preprocess.scala 78:58]
  assign u_tpp_0_clock = clock;
  assign u_tpp_0_reset = reset;
  assign u_tpp_0_io_i_done = io_i_pre_switch; // @[Preprocess.scala 147:24]
  assign u_tpp_0_io_polyvec0_rd_addr_0 = u_dp1_rd_itf_0_io_buf_rd_addr_0; // @[Preprocess.scala 139:29]
  assign u_tpp_0_io_polyvec0_rd_addr_1 = u_dp1_rd_itf_0_io_buf_rd_addr_1; // @[Preprocess.scala 139:29]
  assign u_tpp_0_io_polyvec0_rd_addr_2 = u_dp1_rd_itf_0_io_buf_rd_addr_2; // @[Preprocess.scala 139:29]
  assign u_tpp_0_io_polyvec0_rd_addr_3 = u_dp1_rd_itf_0_io_buf_rd_addr_3; // @[Preprocess.scala 139:29]
  assign u_tpp_0_io_polyvec0_rd_addr_4 = u_dp1_rd_itf_0_io_buf_rd_addr_4; // @[Preprocess.scala 139:29]
  assign u_tpp_0_io_polyvec0_rd_addr_5 = u_dp1_rd_itf_0_io_buf_rd_addr_5; // @[Preprocess.scala 139:29]
  assign u_tpp_0_io_polyvec0_rd_addr_6 = u_dp1_rd_itf_0_io_buf_rd_addr_6; // @[Preprocess.scala 139:29]
  assign u_tpp_0_io_polyvec0_rd_addr_7 = u_dp1_rd_itf_0_io_buf_rd_addr_7; // @[Preprocess.scala 139:29]
  assign u_tpp_0_io_polyvec0_wr_en_0 = u_dp1_wr_itf_0_io_buf_wr_en_0; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_en_1 = u_dp1_wr_itf_0_io_buf_wr_en_1; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_en_2 = u_dp1_wr_itf_0_io_buf_wr_en_2; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_en_3 = u_dp1_wr_itf_0_io_buf_wr_en_3; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_en_4 = u_dp1_wr_itf_0_io_buf_wr_en_4; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_en_5 = u_dp1_wr_itf_0_io_buf_wr_en_5; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_en_6 = u_dp1_wr_itf_0_io_buf_wr_en_6; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_en_7 = u_dp1_wr_itf_0_io_buf_wr_en_7; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_addr_0 = u_dp1_wr_itf_0_io_buf_wr_addr_0; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_addr_1 = u_dp1_wr_itf_0_io_buf_wr_addr_1; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_addr_2 = u_dp1_wr_itf_0_io_buf_wr_addr_2; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_addr_3 = u_dp1_wr_itf_0_io_buf_wr_addr_3; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_addr_4 = u_dp1_wr_itf_0_io_buf_wr_addr_4; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_addr_5 = u_dp1_wr_itf_0_io_buf_wr_addr_5; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_addr_6 = u_dp1_wr_itf_0_io_buf_wr_addr_6; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_addr_7 = u_dp1_wr_itf_0_io_buf_wr_addr_7; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_data_0 = u_dp1_wr_itf_0_io_buf_wr_data_0; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_data_1 = u_dp1_wr_itf_0_io_buf_wr_data_1; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_data_2 = u_dp1_wr_itf_0_io_buf_wr_data_2; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_data_3 = u_dp1_wr_itf_0_io_buf_wr_data_3; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_data_4 = u_dp1_wr_itf_0_io_buf_wr_data_4; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_data_5 = u_dp1_wr_itf_0_io_buf_wr_data_5; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_data_6 = u_dp1_wr_itf_0_io_buf_wr_data_6; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec0_wr_data_7 = u_dp1_wr_itf_0_io_buf_wr_data_7; // @[Preprocess.scala 138:29]
  assign u_tpp_0_io_polyvec1_rd_addr_0 = u_intt_0_io_rd_l_addr_0; // @[Preprocess.scala 141:29]
  assign u_tpp_0_io_polyvec1_rd_addr_1 = u_intt_0_io_rd_l_addr_1; // @[Preprocess.scala 141:29]
  assign u_tpp_0_io_polyvec1_rd_addr_2 = u_intt_0_io_rd_l_addr_2; // @[Preprocess.scala 141:29]
  assign u_tpp_0_io_polyvec1_rd_addr_3 = u_intt_0_io_rd_l_addr_3; // @[Preprocess.scala 141:29]
  assign u_tpp_0_io_polyvec1_rd_addr_4 = u_intt_0_io_rd_l_addr_4; // @[Preprocess.scala 141:29]
  assign u_tpp_0_io_polyvec1_rd_addr_5 = u_intt_0_io_rd_l_addr_5; // @[Preprocess.scala 141:29]
  assign u_tpp_0_io_polyvec1_rd_addr_6 = u_intt_0_io_rd_l_addr_6; // @[Preprocess.scala 141:29]
  assign u_tpp_0_io_polyvec1_rd_addr_7 = u_intt_0_io_rd_l_addr_7; // @[Preprocess.scala 141:29]
  assign u_tpp_0_io_polyvec1_wr_en_0 = u_intt_0_io_wr_l_en_0; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_en_1 = u_intt_0_io_wr_l_en_1; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_en_2 = u_intt_0_io_wr_l_en_2; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_en_3 = u_intt_0_io_wr_l_en_3; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_en_4 = u_intt_0_io_wr_l_en_4; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_en_5 = u_intt_0_io_wr_l_en_5; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_en_6 = u_intt_0_io_wr_l_en_6; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_en_7 = u_intt_0_io_wr_l_en_7; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_addr_0 = u_intt_0_io_wr_l_addr_0; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_addr_1 = u_intt_0_io_wr_l_addr_1; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_addr_2 = u_intt_0_io_wr_l_addr_2; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_addr_3 = u_intt_0_io_wr_l_addr_3; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_addr_4 = u_intt_0_io_wr_l_addr_4; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_addr_5 = u_intt_0_io_wr_l_addr_5; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_addr_6 = u_intt_0_io_wr_l_addr_6; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_addr_7 = u_intt_0_io_wr_l_addr_7; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_data_0 = u_intt_0_io_wr_l_data_0; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_data_1 = u_intt_0_io_wr_l_data_1; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_data_2 = u_intt_0_io_wr_l_data_2; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_data_3 = u_intt_0_io_wr_l_data_3; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_data_4 = u_intt_0_io_wr_l_data_4; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_data_5 = u_intt_0_io_wr_l_data_5; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_data_6 = u_intt_0_io_wr_l_data_6; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_polyvec1_wr_data_7 = u_intt_0_io_wr_l_data_7; // @[Preprocess.scala 140:29]
  assign u_tpp_0_io_banks_rd_0_data_0 = tppRdDataPacked[34:0]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_0_data_1 = tppRdDataPacked[69:35]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_0_data_2 = tppRdDataPacked[104:70]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_0_data_3 = tppRdDataPacked[139:105]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_0_data_4 = tppRdDataPacked[174:140]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_0_data_5 = tppRdDataPacked[209:175]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_0_data_6 = tppRdDataPacked[244:210]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_0_data_7 = tppRdDataPacked[279:245]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_1_data_0 = tppRdDataPacked[314:280]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_1_data_1 = tppRdDataPacked[349:315]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_1_data_2 = tppRdDataPacked[384:350]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_1_data_3 = tppRdDataPacked[419:385]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_1_data_4 = tppRdDataPacked[454:420]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_1_data_5 = tppRdDataPacked[489:455]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_1_data_6 = tppRdDataPacked[524:490]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_1_data_7 = tppRdDataPacked[559:525]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_2_data_0 = tppRdDataPacked[594:560]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_2_data_1 = tppRdDataPacked[629:595]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_2_data_2 = tppRdDataPacked[664:630]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_2_data_3 = tppRdDataPacked[699:665]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_2_data_4 = tppRdDataPacked[734:700]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_2_data_5 = tppRdDataPacked[769:735]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_2_data_6 = tppRdDataPacked[804:770]; // @[Preprocess.scala 121:59]
  assign u_tpp_0_io_banks_rd_2_data_7 = tppRdDataPacked[839:805]; // @[Preprocess.scala 121:59]
  assign u_dp1_wr_itf_0_io_vpu_wr_en = io_dp1_wr_0_en; // @[Preprocess.scala 135:29]
  assign u_dp1_wr_itf_0_io_vpu_wr_addr = io_dp1_wr_0_addr; // @[Preprocess.scala 135:29]
  assign u_dp1_wr_itf_0_io_vpu_wr_data = io_dp1_wr_0_data; // @[Preprocess.scala 135:29]
  assign u_dp1_rd_itf_0_clock = clock;
  assign u_dp1_rd_itf_0_io_vpu_rd_addr = io_dp1_rd_0_addr; // @[Preprocess.scala 136:29]
  assign u_dp1_rd_itf_0_io_buf_rd_data_0 = u_tpp_0_io_polyvec0_rd_data_0; // @[Preprocess.scala 139:29]
  assign u_dp1_rd_itf_0_io_buf_rd_data_1 = u_tpp_0_io_polyvec0_rd_data_1; // @[Preprocess.scala 139:29]
  assign u_dp1_rd_itf_0_io_buf_rd_data_2 = u_tpp_0_io_polyvec0_rd_data_2; // @[Preprocess.scala 139:29]
  assign u_dp1_rd_itf_0_io_buf_rd_data_3 = u_tpp_0_io_polyvec0_rd_data_3; // @[Preprocess.scala 139:29]
  assign u_dp1_rd_itf_0_io_buf_rd_data_4 = u_tpp_0_io_polyvec0_rd_data_4; // @[Preprocess.scala 139:29]
  assign u_dp1_rd_itf_0_io_buf_rd_data_5 = u_tpp_0_io_polyvec0_rd_data_5; // @[Preprocess.scala 139:29]
  assign u_dp1_rd_itf_0_io_buf_rd_data_6 = u_tpp_0_io_polyvec0_rd_data_6; // @[Preprocess.scala 139:29]
  assign u_dp1_rd_itf_0_io_buf_rd_data_7 = u_tpp_0_io_polyvec0_rd_data_7; // @[Preprocess.scala 139:29]
endmodule
