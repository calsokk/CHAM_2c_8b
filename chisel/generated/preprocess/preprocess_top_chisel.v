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
  input  [34:0] io_rd_r_data_7
);
  wire  u_intt_clk; // @[INTT.scala 45:24]
  wire  u_intt_rst_n; // @[INTT.scala 45:24]
  wire  u_intt_ntt_start; // @[INTT.scala 45:24]
  wire  u_intt_ntt_done; // @[INTT.scala 45:24]
  wire [279:0] u_intt_i_data_b_l; // @[INTT.scala 45:24]
  wire [279:0] u_intt_i_data_b_r; // @[INTT.scala 45:24]
  wire [279:0] u_intt_o_data_a; // @[INTT.scala 45:24]
  wire  u_intt_o_we_a_l; // @[INTT.scala 45:24]
  wire  u_intt_o_we_a_r; // @[INTT.scala 45:24]
  wire [8:0] u_intt_o_addr_a_l; // @[INTT.scala 45:24]
  wire [8:0] u_intt_o_addr_a_r; // @[INTT.scala 45:24]
  wire [8:0] u_intt_o_addr_b_l; // @[INTT.scala 45:24]
  wire [8:0] u_intt_o_addr_b_r; // @[INTT.scala 45:24]
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
  wire [139:0] u_intt_io_i_data_b_l_lo = {io_rd_l_data_3,io_rd_l_data_2,io_rd_l_data_1,io_rd_l_data_0}; // @[INTT.scala 62:45]
  wire [139:0] u_intt_io_i_data_b_l_hi = {io_rd_l_data_7,io_rd_l_data_6,io_rd_l_data_5,io_rd_l_data_4}; // @[INTT.scala 62:45]
  wire [139:0] u_intt_io_i_data_b_r_lo = {io_rd_r_data_3,io_rd_r_data_2,io_rd_r_data_1,io_rd_r_data_0}; // @[INTT.scala 65:45]
  wire [139:0] u_intt_io_i_data_b_r_hi = {io_rd_r_data_7,io_rd_r_data_6,io_rd_r_data_5,io_rd_r_data_4}; // @[INTT.scala 65:45]
  intt_core #(.COE_WIDTH(35), .Q_TYPE(0), .COMMON_BRAM_DELAY(1)) u_intt ( // @[INTT.scala 45:24]
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
    .o_addr_b_r(u_intt_o_addr_b_r)
  );
  assign io_ntt_done = u_intt_ntt_done; // @[INTT.scala 51:21]
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
  assign u_intt_clk = clock; // @[INTT.scala 47:21]
  assign u_intt_rst_n = ~reset; // @[INTT.scala 48:24]
  assign u_intt_ntt_start = io_ntt_start; // @[INTT.scala 50:21]
  assign u_intt_i_data_b_l = {u_intt_io_i_data_b_l_hi,u_intt_io_i_data_b_l_lo}; // @[INTT.scala 62:45]
  assign u_intt_i_data_b_r = {u_intt_io_i_data_b_r_hi,u_intt_io_i_data_b_r_lo}; // @[INTT.scala 65:45]
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
  input  [34:0] io_polyvec1_wr_data_7
);
  wire  u_ram_0_clock; // @[Buffer.scala 128:15]
  wire  u_ram_0_io_wr_en_0; // @[Buffer.scala 128:15]
  wire  u_ram_0_io_wr_en_1; // @[Buffer.scala 128:15]
  wire  u_ram_0_io_wr_en_2; // @[Buffer.scala 128:15]
  wire  u_ram_0_io_wr_en_3; // @[Buffer.scala 128:15]
  wire  u_ram_0_io_wr_en_4; // @[Buffer.scala 128:15]
  wire  u_ram_0_io_wr_en_5; // @[Buffer.scala 128:15]
  wire  u_ram_0_io_wr_en_6; // @[Buffer.scala 128:15]
  wire  u_ram_0_io_wr_en_7; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_0_io_wr_addr_0; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_0_io_wr_addr_1; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_0_io_wr_addr_2; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_0_io_wr_addr_3; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_0_io_wr_addr_4; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_0_io_wr_addr_5; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_0_io_wr_addr_6; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_0_io_wr_addr_7; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_0_io_wr_data_0; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_0_io_wr_data_1; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_0_io_wr_data_2; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_0_io_wr_data_3; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_0_io_wr_data_4; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_0_io_wr_data_5; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_0_io_wr_data_6; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_0_io_wr_data_7; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_0_io_rd_addr_0; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_0_io_rd_addr_1; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_0_io_rd_addr_2; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_0_io_rd_addr_3; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_0_io_rd_addr_4; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_0_io_rd_addr_5; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_0_io_rd_addr_6; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_0_io_rd_addr_7; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_0_io_rd_data_0; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_0_io_rd_data_1; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_0_io_rd_data_2; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_0_io_rd_data_3; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_0_io_rd_data_4; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_0_io_rd_data_5; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_0_io_rd_data_6; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_0_io_rd_data_7; // @[Buffer.scala 128:15]
  wire  u_ram_1_clock; // @[Buffer.scala 128:15]
  wire  u_ram_1_io_wr_en_0; // @[Buffer.scala 128:15]
  wire  u_ram_1_io_wr_en_1; // @[Buffer.scala 128:15]
  wire  u_ram_1_io_wr_en_2; // @[Buffer.scala 128:15]
  wire  u_ram_1_io_wr_en_3; // @[Buffer.scala 128:15]
  wire  u_ram_1_io_wr_en_4; // @[Buffer.scala 128:15]
  wire  u_ram_1_io_wr_en_5; // @[Buffer.scala 128:15]
  wire  u_ram_1_io_wr_en_6; // @[Buffer.scala 128:15]
  wire  u_ram_1_io_wr_en_7; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_1_io_wr_addr_0; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_1_io_wr_addr_1; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_1_io_wr_addr_2; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_1_io_wr_addr_3; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_1_io_wr_addr_4; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_1_io_wr_addr_5; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_1_io_wr_addr_6; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_1_io_wr_addr_7; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_1_io_wr_data_0; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_1_io_wr_data_1; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_1_io_wr_data_2; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_1_io_wr_data_3; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_1_io_wr_data_4; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_1_io_wr_data_5; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_1_io_wr_data_6; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_1_io_wr_data_7; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_1_io_rd_addr_0; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_1_io_rd_addr_1; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_1_io_rd_addr_2; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_1_io_rd_addr_3; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_1_io_rd_addr_4; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_1_io_rd_addr_5; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_1_io_rd_addr_6; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_1_io_rd_addr_7; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_1_io_rd_data_0; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_1_io_rd_data_1; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_1_io_rd_data_2; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_1_io_rd_data_3; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_1_io_rd_data_4; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_1_io_rd_data_5; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_1_io_rd_data_6; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_1_io_rd_data_7; // @[Buffer.scala 128:15]
  wire  u_ram_2_clock; // @[Buffer.scala 128:15]
  wire  u_ram_2_io_wr_en_0; // @[Buffer.scala 128:15]
  wire  u_ram_2_io_wr_en_1; // @[Buffer.scala 128:15]
  wire  u_ram_2_io_wr_en_2; // @[Buffer.scala 128:15]
  wire  u_ram_2_io_wr_en_3; // @[Buffer.scala 128:15]
  wire  u_ram_2_io_wr_en_4; // @[Buffer.scala 128:15]
  wire  u_ram_2_io_wr_en_5; // @[Buffer.scala 128:15]
  wire  u_ram_2_io_wr_en_6; // @[Buffer.scala 128:15]
  wire  u_ram_2_io_wr_en_7; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_2_io_wr_addr_0; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_2_io_wr_addr_1; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_2_io_wr_addr_2; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_2_io_wr_addr_3; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_2_io_wr_addr_4; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_2_io_wr_addr_5; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_2_io_wr_addr_6; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_2_io_wr_addr_7; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_2_io_wr_data_0; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_2_io_wr_data_1; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_2_io_wr_data_2; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_2_io_wr_data_3; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_2_io_wr_data_4; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_2_io_wr_data_5; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_2_io_wr_data_6; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_2_io_wr_data_7; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_2_io_rd_addr_0; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_2_io_rd_addr_1; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_2_io_rd_addr_2; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_2_io_rd_addr_3; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_2_io_rd_addr_4; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_2_io_rd_addr_5; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_2_io_rd_addr_6; // @[Buffer.scala 128:15]
  wire [8:0] u_ram_2_io_rd_addr_7; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_2_io_rd_data_0; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_2_io_rd_data_1; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_2_io_rd_data_2; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_2_io_rd_data_3; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_2_io_rd_data_4; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_2_io_rd_data_5; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_2_io_rd_data_6; // @[Buffer.scala 128:15]
  wire [34:0] u_ram_2_io_rd_data_7; // @[Buffer.scala 128:15]
  reg  done_r; // @[Buffer.scala 115:25]
  reg [1:0] state; // @[Buffer.scala 118:24]
  wire [1:0] _GEN_0 = 2'h2 == state ? 2'h0 : state; // @[Buffer.scala 118:24 120:24 123:31]
  wire [34:0] _GEN_12 = u_ram_1_io_rd_data_0; // @[Buffer.scala 145:34 146:24]
  wire [34:0] _GEN_13 = u_ram_1_io_rd_data_1; // @[Buffer.scala 145:34 146:24]
  wire [34:0] _GEN_14 = u_ram_1_io_rd_data_2; // @[Buffer.scala 145:34 146:24]
  wire [34:0] _GEN_15 = u_ram_1_io_rd_data_3; // @[Buffer.scala 145:34 146:24]
  wire [34:0] _GEN_16 = u_ram_1_io_rd_data_4; // @[Buffer.scala 145:34 146:24]
  wire [34:0] _GEN_17 = u_ram_1_io_rd_data_5; // @[Buffer.scala 145:34 146:24]
  wire [34:0] _GEN_18 = u_ram_1_io_rd_data_6; // @[Buffer.scala 145:34 146:24]
  wire [34:0] _GEN_19 = u_ram_1_io_rd_data_7; // @[Buffer.scala 145:34 146:24]
  wire [34:0] _GEN_52 = u_ram_2_io_rd_data_0; // @[Buffer.scala 145:34 148:24]
  wire [34:0] _GEN_53 = u_ram_2_io_rd_data_1; // @[Buffer.scala 145:34 148:24]
  wire [34:0] _GEN_54 = u_ram_2_io_rd_data_2; // @[Buffer.scala 145:34 148:24]
  wire [34:0] _GEN_55 = u_ram_2_io_rd_data_3; // @[Buffer.scala 145:34 148:24]
  wire [34:0] _GEN_56 = u_ram_2_io_rd_data_4; // @[Buffer.scala 145:34 148:24]
  wire [34:0] _GEN_57 = u_ram_2_io_rd_data_5; // @[Buffer.scala 145:34 148:24]
  wire [34:0] _GEN_58 = u_ram_2_io_rd_data_6; // @[Buffer.scala 145:34 148:24]
  wire [34:0] _GEN_59 = u_ram_2_io_rd_data_7; // @[Buffer.scala 145:34 148:24]
  wire [8:0] _GEN_124 = state == 2'h1 ? io_polyvec0_rd_addr_0 : io_polyvec1_rd_addr_0; // @[Buffer.scala 138:34 139:24]
  wire [8:0] _GEN_125 = state == 2'h1 ? io_polyvec0_rd_addr_1 : io_polyvec1_rd_addr_1; // @[Buffer.scala 138:34 139:24]
  wire [8:0] _GEN_126 = state == 2'h1 ? io_polyvec0_rd_addr_2 : io_polyvec1_rd_addr_2; // @[Buffer.scala 138:34 139:24]
  wire [8:0] _GEN_127 = state == 2'h1 ? io_polyvec0_rd_addr_3 : io_polyvec1_rd_addr_3; // @[Buffer.scala 138:34 139:24]
  wire [8:0] _GEN_128 = state == 2'h1 ? io_polyvec0_rd_addr_4 : io_polyvec1_rd_addr_4; // @[Buffer.scala 138:34 139:24]
  wire [8:0] _GEN_129 = state == 2'h1 ? io_polyvec0_rd_addr_5 : io_polyvec1_rd_addr_5; // @[Buffer.scala 138:34 139:24]
  wire [8:0] _GEN_130 = state == 2'h1 ? io_polyvec0_rd_addr_6 : io_polyvec1_rd_addr_6; // @[Buffer.scala 138:34 139:24]
  wire [8:0] _GEN_131 = state == 2'h1 ? io_polyvec0_rd_addr_7 : io_polyvec1_rd_addr_7; // @[Buffer.scala 138:34 139:24]
  wire [34:0] _GEN_132 = state == 2'h1 ? u_ram_2_io_rd_data_0 : _GEN_12; // @[Buffer.scala 138:34 139:24]
  wire [34:0] _GEN_133 = state == 2'h1 ? u_ram_2_io_rd_data_1 : _GEN_13; // @[Buffer.scala 138:34 139:24]
  wire [34:0] _GEN_134 = state == 2'h1 ? u_ram_2_io_rd_data_2 : _GEN_14; // @[Buffer.scala 138:34 139:24]
  wire [34:0] _GEN_135 = state == 2'h1 ? u_ram_2_io_rd_data_3 : _GEN_15; // @[Buffer.scala 138:34 139:24]
  wire [34:0] _GEN_136 = state == 2'h1 ? u_ram_2_io_rd_data_4 : _GEN_16; // @[Buffer.scala 138:34 139:24]
  wire [34:0] _GEN_137 = state == 2'h1 ? u_ram_2_io_rd_data_5 : _GEN_17; // @[Buffer.scala 138:34 139:24]
  wire [34:0] _GEN_138 = state == 2'h1 ? u_ram_2_io_rd_data_6 : _GEN_18; // @[Buffer.scala 138:34 139:24]
  wire [34:0] _GEN_139 = state == 2'h1 ? u_ram_2_io_rd_data_7 : _GEN_19; // @[Buffer.scala 138:34 139:24]
  wire  _GEN_140 = state == 2'h1 ? io_polyvec0_wr_en_0 : io_polyvec1_wr_en_0; // @[Buffer.scala 138:34 140:24]
  wire  _GEN_141 = state == 2'h1 ? io_polyvec0_wr_en_1 : io_polyvec1_wr_en_1; // @[Buffer.scala 138:34 140:24]
  wire  _GEN_142 = state == 2'h1 ? io_polyvec0_wr_en_2 : io_polyvec1_wr_en_2; // @[Buffer.scala 138:34 140:24]
  wire  _GEN_143 = state == 2'h1 ? io_polyvec0_wr_en_3 : io_polyvec1_wr_en_3; // @[Buffer.scala 138:34 140:24]
  wire  _GEN_144 = state == 2'h1 ? io_polyvec0_wr_en_4 : io_polyvec1_wr_en_4; // @[Buffer.scala 138:34 140:24]
  wire  _GEN_145 = state == 2'h1 ? io_polyvec0_wr_en_5 : io_polyvec1_wr_en_5; // @[Buffer.scala 138:34 140:24]
  wire  _GEN_146 = state == 2'h1 ? io_polyvec0_wr_en_6 : io_polyvec1_wr_en_6; // @[Buffer.scala 138:34 140:24]
  wire  _GEN_147 = state == 2'h1 ? io_polyvec0_wr_en_7 : io_polyvec1_wr_en_7; // @[Buffer.scala 138:34 140:24]
  wire [8:0] _GEN_148 = state == 2'h1 ? io_polyvec0_wr_addr_0 : io_polyvec1_wr_addr_0; // @[Buffer.scala 138:34 140:24]
  wire [8:0] _GEN_149 = state == 2'h1 ? io_polyvec0_wr_addr_1 : io_polyvec1_wr_addr_1; // @[Buffer.scala 138:34 140:24]
  wire [8:0] _GEN_150 = state == 2'h1 ? io_polyvec0_wr_addr_2 : io_polyvec1_wr_addr_2; // @[Buffer.scala 138:34 140:24]
  wire [8:0] _GEN_151 = state == 2'h1 ? io_polyvec0_wr_addr_3 : io_polyvec1_wr_addr_3; // @[Buffer.scala 138:34 140:24]
  wire [8:0] _GEN_152 = state == 2'h1 ? io_polyvec0_wr_addr_4 : io_polyvec1_wr_addr_4; // @[Buffer.scala 138:34 140:24]
  wire [8:0] _GEN_153 = state == 2'h1 ? io_polyvec0_wr_addr_5 : io_polyvec1_wr_addr_5; // @[Buffer.scala 138:34 140:24]
  wire [8:0] _GEN_154 = state == 2'h1 ? io_polyvec0_wr_addr_6 : io_polyvec1_wr_addr_6; // @[Buffer.scala 138:34 140:24]
  wire [8:0] _GEN_155 = state == 2'h1 ? io_polyvec0_wr_addr_7 : io_polyvec1_wr_addr_7; // @[Buffer.scala 138:34 140:24]
  wire [34:0] _GEN_156 = state == 2'h1 ? io_polyvec0_wr_data_0 : io_polyvec1_wr_data_0; // @[Buffer.scala 138:34 140:24]
  wire [34:0] _GEN_157 = state == 2'h1 ? io_polyvec0_wr_data_1 : io_polyvec1_wr_data_1; // @[Buffer.scala 138:34 140:24]
  wire [34:0] _GEN_158 = state == 2'h1 ? io_polyvec0_wr_data_2 : io_polyvec1_wr_data_2; // @[Buffer.scala 138:34 140:24]
  wire [34:0] _GEN_159 = state == 2'h1 ? io_polyvec0_wr_data_3 : io_polyvec1_wr_data_3; // @[Buffer.scala 138:34 140:24]
  wire [34:0] _GEN_160 = state == 2'h1 ? io_polyvec0_wr_data_4 : io_polyvec1_wr_data_4; // @[Buffer.scala 138:34 140:24]
  wire [34:0] _GEN_161 = state == 2'h1 ? io_polyvec0_wr_data_5 : io_polyvec1_wr_data_5; // @[Buffer.scala 138:34 140:24]
  wire [34:0] _GEN_162 = state == 2'h1 ? io_polyvec0_wr_data_6 : io_polyvec1_wr_data_6; // @[Buffer.scala 138:34 140:24]
  wire [34:0] _GEN_163 = state == 2'h1 ? io_polyvec0_wr_data_7 : io_polyvec1_wr_data_7; // @[Buffer.scala 138:34 140:24]
  wire [8:0] _GEN_164 = state == 2'h1 ? io_polyvec1_rd_addr_0 : 9'h0; // @[Buffer.scala 138:34 141:24]
  wire [8:0] _GEN_165 = state == 2'h1 ? io_polyvec1_rd_addr_1 : 9'h0; // @[Buffer.scala 138:34 141:24]
  wire [8:0] _GEN_166 = state == 2'h1 ? io_polyvec1_rd_addr_2 : 9'h0; // @[Buffer.scala 138:34 141:24]
  wire [8:0] _GEN_167 = state == 2'h1 ? io_polyvec1_rd_addr_3 : 9'h0; // @[Buffer.scala 138:34 141:24]
  wire [8:0] _GEN_168 = state == 2'h1 ? io_polyvec1_rd_addr_4 : 9'h0; // @[Buffer.scala 138:34 141:24]
  wire [8:0] _GEN_169 = state == 2'h1 ? io_polyvec1_rd_addr_5 : 9'h0; // @[Buffer.scala 138:34 141:24]
  wire [8:0] _GEN_170 = state == 2'h1 ? io_polyvec1_rd_addr_6 : 9'h0; // @[Buffer.scala 138:34 141:24]
  wire [8:0] _GEN_171 = state == 2'h1 ? io_polyvec1_rd_addr_7 : 9'h0; // @[Buffer.scala 138:34 141:24]
  wire [34:0] _GEN_172 = state == 2'h1 ? u_ram_0_io_rd_data_0 : _GEN_52; // @[Buffer.scala 138:34 141:24]
  wire [34:0] _GEN_173 = state == 2'h1 ? u_ram_0_io_rd_data_1 : _GEN_53; // @[Buffer.scala 138:34 141:24]
  wire [34:0] _GEN_174 = state == 2'h1 ? u_ram_0_io_rd_data_2 : _GEN_54; // @[Buffer.scala 138:34 141:24]
  wire [34:0] _GEN_175 = state == 2'h1 ? u_ram_0_io_rd_data_3 : _GEN_55; // @[Buffer.scala 138:34 141:24]
  wire [34:0] _GEN_176 = state == 2'h1 ? u_ram_0_io_rd_data_4 : _GEN_56; // @[Buffer.scala 138:34 141:24]
  wire [34:0] _GEN_177 = state == 2'h1 ? u_ram_0_io_rd_data_5 : _GEN_57; // @[Buffer.scala 138:34 141:24]
  wire [34:0] _GEN_178 = state == 2'h1 ? u_ram_0_io_rd_data_6 : _GEN_58; // @[Buffer.scala 138:34 141:24]
  wire [34:0] _GEN_179 = state == 2'h1 ? u_ram_0_io_rd_data_7 : _GEN_59; // @[Buffer.scala 138:34 141:24]
  wire  _GEN_180 = state == 2'h1 & io_polyvec1_wr_en_0; // @[Buffer.scala 138:34 142:24]
  wire  _GEN_181 = state == 2'h1 & io_polyvec1_wr_en_1; // @[Buffer.scala 138:34 142:24]
  wire  _GEN_182 = state == 2'h1 & io_polyvec1_wr_en_2; // @[Buffer.scala 138:34 142:24]
  wire  _GEN_183 = state == 2'h1 & io_polyvec1_wr_en_3; // @[Buffer.scala 138:34 142:24]
  wire  _GEN_184 = state == 2'h1 & io_polyvec1_wr_en_4; // @[Buffer.scala 138:34 142:24]
  wire  _GEN_185 = state == 2'h1 & io_polyvec1_wr_en_5; // @[Buffer.scala 138:34 142:24]
  wire  _GEN_186 = state == 2'h1 & io_polyvec1_wr_en_6; // @[Buffer.scala 138:34 142:24]
  wire  _GEN_187 = state == 2'h1 & io_polyvec1_wr_en_7; // @[Buffer.scala 138:34 142:24]
  wire [8:0] _GEN_188 = state == 2'h1 ? io_polyvec1_wr_addr_0 : 9'h0; // @[Buffer.scala 138:34 142:24]
  wire [8:0] _GEN_189 = state == 2'h1 ? io_polyvec1_wr_addr_1 : 9'h0; // @[Buffer.scala 138:34 142:24]
  wire [8:0] _GEN_190 = state == 2'h1 ? io_polyvec1_wr_addr_2 : 9'h0; // @[Buffer.scala 138:34 142:24]
  wire [8:0] _GEN_191 = state == 2'h1 ? io_polyvec1_wr_addr_3 : 9'h0; // @[Buffer.scala 138:34 142:24]
  wire [8:0] _GEN_192 = state == 2'h1 ? io_polyvec1_wr_addr_4 : 9'h0; // @[Buffer.scala 138:34 142:24]
  wire [8:0] _GEN_193 = state == 2'h1 ? io_polyvec1_wr_addr_5 : 9'h0; // @[Buffer.scala 138:34 142:24]
  wire [8:0] _GEN_194 = state == 2'h1 ? io_polyvec1_wr_addr_6 : 9'h0; // @[Buffer.scala 138:34 142:24]
  wire [8:0] _GEN_195 = state == 2'h1 ? io_polyvec1_wr_addr_7 : 9'h0; // @[Buffer.scala 138:34 142:24]
  wire [34:0] _GEN_196 = state == 2'h1 ? io_polyvec1_wr_data_0 : 35'h0; // @[Buffer.scala 138:34 142:24]
  wire [34:0] _GEN_197 = state == 2'h1 ? io_polyvec1_wr_data_1 : 35'h0; // @[Buffer.scala 138:34 142:24]
  wire [34:0] _GEN_198 = state == 2'h1 ? io_polyvec1_wr_data_2 : 35'h0; // @[Buffer.scala 138:34 142:24]
  wire [34:0] _GEN_199 = state == 2'h1 ? io_polyvec1_wr_data_3 : 35'h0; // @[Buffer.scala 138:34 142:24]
  wire [34:0] _GEN_200 = state == 2'h1 ? io_polyvec1_wr_data_4 : 35'h0; // @[Buffer.scala 138:34 142:24]
  wire [34:0] _GEN_201 = state == 2'h1 ? io_polyvec1_wr_data_5 : 35'h0; // @[Buffer.scala 138:34 142:24]
  wire [34:0] _GEN_202 = state == 2'h1 ? io_polyvec1_wr_data_6 : 35'h0; // @[Buffer.scala 138:34 142:24]
  wire [34:0] _GEN_203 = state == 2'h1 ? io_polyvec1_wr_data_7 : 35'h0; // @[Buffer.scala 138:34 142:24]
  wire [8:0] _GEN_204 = state == 2'h1 ? 9'h0 : io_polyvec0_rd_addr_0; // @[Buffer.scala 138:34 143:24]
  wire [8:0] _GEN_205 = state == 2'h1 ? 9'h0 : io_polyvec0_rd_addr_1; // @[Buffer.scala 138:34 143:24]
  wire [8:0] _GEN_206 = state == 2'h1 ? 9'h0 : io_polyvec0_rd_addr_2; // @[Buffer.scala 138:34 143:24]
  wire [8:0] _GEN_207 = state == 2'h1 ? 9'h0 : io_polyvec0_rd_addr_3; // @[Buffer.scala 138:34 143:24]
  wire [8:0] _GEN_208 = state == 2'h1 ? 9'h0 : io_polyvec0_rd_addr_4; // @[Buffer.scala 138:34 143:24]
  wire [8:0] _GEN_209 = state == 2'h1 ? 9'h0 : io_polyvec0_rd_addr_5; // @[Buffer.scala 138:34 143:24]
  wire [8:0] _GEN_210 = state == 2'h1 ? 9'h0 : io_polyvec0_rd_addr_6; // @[Buffer.scala 138:34 143:24]
  wire [8:0] _GEN_211 = state == 2'h1 ? 9'h0 : io_polyvec0_rd_addr_7; // @[Buffer.scala 138:34 143:24]
  wire  _GEN_220 = state == 2'h1 ? 1'h0 : io_polyvec0_wr_en_0; // @[Buffer.scala 138:34 144:24]
  wire  _GEN_221 = state == 2'h1 ? 1'h0 : io_polyvec0_wr_en_1; // @[Buffer.scala 138:34 144:24]
  wire  _GEN_222 = state == 2'h1 ? 1'h0 : io_polyvec0_wr_en_2; // @[Buffer.scala 138:34 144:24]
  wire  _GEN_223 = state == 2'h1 ? 1'h0 : io_polyvec0_wr_en_3; // @[Buffer.scala 138:34 144:24]
  wire  _GEN_224 = state == 2'h1 ? 1'h0 : io_polyvec0_wr_en_4; // @[Buffer.scala 138:34 144:24]
  wire  _GEN_225 = state == 2'h1 ? 1'h0 : io_polyvec0_wr_en_5; // @[Buffer.scala 138:34 144:24]
  wire  _GEN_226 = state == 2'h1 ? 1'h0 : io_polyvec0_wr_en_6; // @[Buffer.scala 138:34 144:24]
  wire  _GEN_227 = state == 2'h1 ? 1'h0 : io_polyvec0_wr_en_7; // @[Buffer.scala 138:34 144:24]
  wire [8:0] _GEN_228 = state == 2'h1 ? 9'h0 : io_polyvec0_wr_addr_0; // @[Buffer.scala 138:34 144:24]
  wire [8:0] _GEN_229 = state == 2'h1 ? 9'h0 : io_polyvec0_wr_addr_1; // @[Buffer.scala 138:34 144:24]
  wire [8:0] _GEN_230 = state == 2'h1 ? 9'h0 : io_polyvec0_wr_addr_2; // @[Buffer.scala 138:34 144:24]
  wire [8:0] _GEN_231 = state == 2'h1 ? 9'h0 : io_polyvec0_wr_addr_3; // @[Buffer.scala 138:34 144:24]
  wire [8:0] _GEN_232 = state == 2'h1 ? 9'h0 : io_polyvec0_wr_addr_4; // @[Buffer.scala 138:34 144:24]
  wire [8:0] _GEN_233 = state == 2'h1 ? 9'h0 : io_polyvec0_wr_addr_5; // @[Buffer.scala 138:34 144:24]
  wire [8:0] _GEN_234 = state == 2'h1 ? 9'h0 : io_polyvec0_wr_addr_6; // @[Buffer.scala 138:34 144:24]
  wire [8:0] _GEN_235 = state == 2'h1 ? 9'h0 : io_polyvec0_wr_addr_7; // @[Buffer.scala 138:34 144:24]
  wire [34:0] _GEN_236 = state == 2'h1 ? 35'h0 : io_polyvec0_wr_data_0; // @[Buffer.scala 138:34 144:24]
  wire [34:0] _GEN_237 = state == 2'h1 ? 35'h0 : io_polyvec0_wr_data_1; // @[Buffer.scala 138:34 144:24]
  wire [34:0] _GEN_238 = state == 2'h1 ? 35'h0 : io_polyvec0_wr_data_2; // @[Buffer.scala 138:34 144:24]
  wire [34:0] _GEN_239 = state == 2'h1 ? 35'h0 : io_polyvec0_wr_data_3; // @[Buffer.scala 138:34 144:24]
  wire [34:0] _GEN_240 = state == 2'h1 ? 35'h0 : io_polyvec0_wr_data_4; // @[Buffer.scala 138:34 144:24]
  wire [34:0] _GEN_241 = state == 2'h1 ? 35'h0 : io_polyvec0_wr_data_5; // @[Buffer.scala 138:34 144:24]
  wire [34:0] _GEN_242 = state == 2'h1 ? 35'h0 : io_polyvec0_wr_data_6; // @[Buffer.scala 138:34 144:24]
  wire [34:0] _GEN_243 = state == 2'h1 ? 35'h0 : io_polyvec0_wr_data_7; // @[Buffer.scala 138:34 144:24]
  poly_ram_35_9_8 u_ram_0 ( // @[Buffer.scala 128:15]
    .clock(u_ram_0_clock),
    .io_wr_en_0(u_ram_0_io_wr_en_0),
    .io_wr_en_1(u_ram_0_io_wr_en_1),
    .io_wr_en_2(u_ram_0_io_wr_en_2),
    .io_wr_en_3(u_ram_0_io_wr_en_3),
    .io_wr_en_4(u_ram_0_io_wr_en_4),
    .io_wr_en_5(u_ram_0_io_wr_en_5),
    .io_wr_en_6(u_ram_0_io_wr_en_6),
    .io_wr_en_7(u_ram_0_io_wr_en_7),
    .io_wr_addr_0(u_ram_0_io_wr_addr_0),
    .io_wr_addr_1(u_ram_0_io_wr_addr_1),
    .io_wr_addr_2(u_ram_0_io_wr_addr_2),
    .io_wr_addr_3(u_ram_0_io_wr_addr_3),
    .io_wr_addr_4(u_ram_0_io_wr_addr_4),
    .io_wr_addr_5(u_ram_0_io_wr_addr_5),
    .io_wr_addr_6(u_ram_0_io_wr_addr_6),
    .io_wr_addr_7(u_ram_0_io_wr_addr_7),
    .io_wr_data_0(u_ram_0_io_wr_data_0),
    .io_wr_data_1(u_ram_0_io_wr_data_1),
    .io_wr_data_2(u_ram_0_io_wr_data_2),
    .io_wr_data_3(u_ram_0_io_wr_data_3),
    .io_wr_data_4(u_ram_0_io_wr_data_4),
    .io_wr_data_5(u_ram_0_io_wr_data_5),
    .io_wr_data_6(u_ram_0_io_wr_data_6),
    .io_wr_data_7(u_ram_0_io_wr_data_7),
    .io_rd_addr_0(u_ram_0_io_rd_addr_0),
    .io_rd_addr_1(u_ram_0_io_rd_addr_1),
    .io_rd_addr_2(u_ram_0_io_rd_addr_2),
    .io_rd_addr_3(u_ram_0_io_rd_addr_3),
    .io_rd_addr_4(u_ram_0_io_rd_addr_4),
    .io_rd_addr_5(u_ram_0_io_rd_addr_5),
    .io_rd_addr_6(u_ram_0_io_rd_addr_6),
    .io_rd_addr_7(u_ram_0_io_rd_addr_7),
    .io_rd_data_0(u_ram_0_io_rd_data_0),
    .io_rd_data_1(u_ram_0_io_rd_data_1),
    .io_rd_data_2(u_ram_0_io_rd_data_2),
    .io_rd_data_3(u_ram_0_io_rd_data_3),
    .io_rd_data_4(u_ram_0_io_rd_data_4),
    .io_rd_data_5(u_ram_0_io_rd_data_5),
    .io_rd_data_6(u_ram_0_io_rd_data_6),
    .io_rd_data_7(u_ram_0_io_rd_data_7)
  );
  poly_ram_35_9_8 u_ram_1 ( // @[Buffer.scala 128:15]
    .clock(u_ram_1_clock),
    .io_wr_en_0(u_ram_1_io_wr_en_0),
    .io_wr_en_1(u_ram_1_io_wr_en_1),
    .io_wr_en_2(u_ram_1_io_wr_en_2),
    .io_wr_en_3(u_ram_1_io_wr_en_3),
    .io_wr_en_4(u_ram_1_io_wr_en_4),
    .io_wr_en_5(u_ram_1_io_wr_en_5),
    .io_wr_en_6(u_ram_1_io_wr_en_6),
    .io_wr_en_7(u_ram_1_io_wr_en_7),
    .io_wr_addr_0(u_ram_1_io_wr_addr_0),
    .io_wr_addr_1(u_ram_1_io_wr_addr_1),
    .io_wr_addr_2(u_ram_1_io_wr_addr_2),
    .io_wr_addr_3(u_ram_1_io_wr_addr_3),
    .io_wr_addr_4(u_ram_1_io_wr_addr_4),
    .io_wr_addr_5(u_ram_1_io_wr_addr_5),
    .io_wr_addr_6(u_ram_1_io_wr_addr_6),
    .io_wr_addr_7(u_ram_1_io_wr_addr_7),
    .io_wr_data_0(u_ram_1_io_wr_data_0),
    .io_wr_data_1(u_ram_1_io_wr_data_1),
    .io_wr_data_2(u_ram_1_io_wr_data_2),
    .io_wr_data_3(u_ram_1_io_wr_data_3),
    .io_wr_data_4(u_ram_1_io_wr_data_4),
    .io_wr_data_5(u_ram_1_io_wr_data_5),
    .io_wr_data_6(u_ram_1_io_wr_data_6),
    .io_wr_data_7(u_ram_1_io_wr_data_7),
    .io_rd_addr_0(u_ram_1_io_rd_addr_0),
    .io_rd_addr_1(u_ram_1_io_rd_addr_1),
    .io_rd_addr_2(u_ram_1_io_rd_addr_2),
    .io_rd_addr_3(u_ram_1_io_rd_addr_3),
    .io_rd_addr_4(u_ram_1_io_rd_addr_4),
    .io_rd_addr_5(u_ram_1_io_rd_addr_5),
    .io_rd_addr_6(u_ram_1_io_rd_addr_6),
    .io_rd_addr_7(u_ram_1_io_rd_addr_7),
    .io_rd_data_0(u_ram_1_io_rd_data_0),
    .io_rd_data_1(u_ram_1_io_rd_data_1),
    .io_rd_data_2(u_ram_1_io_rd_data_2),
    .io_rd_data_3(u_ram_1_io_rd_data_3),
    .io_rd_data_4(u_ram_1_io_rd_data_4),
    .io_rd_data_5(u_ram_1_io_rd_data_5),
    .io_rd_data_6(u_ram_1_io_rd_data_6),
    .io_rd_data_7(u_ram_1_io_rd_data_7)
  );
  poly_ram_35_9_8 u_ram_2 ( // @[Buffer.scala 128:15]
    .clock(u_ram_2_clock),
    .io_wr_en_0(u_ram_2_io_wr_en_0),
    .io_wr_en_1(u_ram_2_io_wr_en_1),
    .io_wr_en_2(u_ram_2_io_wr_en_2),
    .io_wr_en_3(u_ram_2_io_wr_en_3),
    .io_wr_en_4(u_ram_2_io_wr_en_4),
    .io_wr_en_5(u_ram_2_io_wr_en_5),
    .io_wr_en_6(u_ram_2_io_wr_en_6),
    .io_wr_en_7(u_ram_2_io_wr_en_7),
    .io_wr_addr_0(u_ram_2_io_wr_addr_0),
    .io_wr_addr_1(u_ram_2_io_wr_addr_1),
    .io_wr_addr_2(u_ram_2_io_wr_addr_2),
    .io_wr_addr_3(u_ram_2_io_wr_addr_3),
    .io_wr_addr_4(u_ram_2_io_wr_addr_4),
    .io_wr_addr_5(u_ram_2_io_wr_addr_5),
    .io_wr_addr_6(u_ram_2_io_wr_addr_6),
    .io_wr_addr_7(u_ram_2_io_wr_addr_7),
    .io_wr_data_0(u_ram_2_io_wr_data_0),
    .io_wr_data_1(u_ram_2_io_wr_data_1),
    .io_wr_data_2(u_ram_2_io_wr_data_2),
    .io_wr_data_3(u_ram_2_io_wr_data_3),
    .io_wr_data_4(u_ram_2_io_wr_data_4),
    .io_wr_data_5(u_ram_2_io_wr_data_5),
    .io_wr_data_6(u_ram_2_io_wr_data_6),
    .io_wr_data_7(u_ram_2_io_wr_data_7),
    .io_rd_addr_0(u_ram_2_io_rd_addr_0),
    .io_rd_addr_1(u_ram_2_io_rd_addr_1),
    .io_rd_addr_2(u_ram_2_io_rd_addr_2),
    .io_rd_addr_3(u_ram_2_io_rd_addr_3),
    .io_rd_addr_4(u_ram_2_io_rd_addr_4),
    .io_rd_addr_5(u_ram_2_io_rd_addr_5),
    .io_rd_addr_6(u_ram_2_io_rd_addr_6),
    .io_rd_addr_7(u_ram_2_io_rd_addr_7),
    .io_rd_data_0(u_ram_2_io_rd_data_0),
    .io_rd_data_1(u_ram_2_io_rd_data_1),
    .io_rd_data_2(u_ram_2_io_rd_data_2),
    .io_rd_data_3(u_ram_2_io_rd_data_3),
    .io_rd_data_4(u_ram_2_io_rd_data_4),
    .io_rd_data_5(u_ram_2_io_rd_data_5),
    .io_rd_data_6(u_ram_2_io_rd_data_6),
    .io_rd_data_7(u_ram_2_io_rd_data_7)
  );
  assign io_polyvec0_rd_data_0 = state == 2'h0 ? u_ram_0_io_rd_data_0 : _GEN_132; // @[Buffer.scala 131:27 132:24]
  assign io_polyvec0_rd_data_1 = state == 2'h0 ? u_ram_0_io_rd_data_1 : _GEN_133; // @[Buffer.scala 131:27 132:24]
  assign io_polyvec0_rd_data_2 = state == 2'h0 ? u_ram_0_io_rd_data_2 : _GEN_134; // @[Buffer.scala 131:27 132:24]
  assign io_polyvec0_rd_data_3 = state == 2'h0 ? u_ram_0_io_rd_data_3 : _GEN_135; // @[Buffer.scala 131:27 132:24]
  assign io_polyvec0_rd_data_4 = state == 2'h0 ? u_ram_0_io_rd_data_4 : _GEN_136; // @[Buffer.scala 131:27 132:24]
  assign io_polyvec0_rd_data_5 = state == 2'h0 ? u_ram_0_io_rd_data_5 : _GEN_137; // @[Buffer.scala 131:27 132:24]
  assign io_polyvec0_rd_data_6 = state == 2'h0 ? u_ram_0_io_rd_data_6 : _GEN_138; // @[Buffer.scala 131:27 132:24]
  assign io_polyvec0_rd_data_7 = state == 2'h0 ? u_ram_0_io_rd_data_7 : _GEN_139; // @[Buffer.scala 131:27 132:24]
  assign io_polyvec1_rd_data_0 = state == 2'h0 ? u_ram_1_io_rd_data_0 : _GEN_172; // @[Buffer.scala 131:27 134:24]
  assign io_polyvec1_rd_data_1 = state == 2'h0 ? u_ram_1_io_rd_data_1 : _GEN_173; // @[Buffer.scala 131:27 134:24]
  assign io_polyvec1_rd_data_2 = state == 2'h0 ? u_ram_1_io_rd_data_2 : _GEN_174; // @[Buffer.scala 131:27 134:24]
  assign io_polyvec1_rd_data_3 = state == 2'h0 ? u_ram_1_io_rd_data_3 : _GEN_175; // @[Buffer.scala 131:27 134:24]
  assign io_polyvec1_rd_data_4 = state == 2'h0 ? u_ram_1_io_rd_data_4 : _GEN_176; // @[Buffer.scala 131:27 134:24]
  assign io_polyvec1_rd_data_5 = state == 2'h0 ? u_ram_1_io_rd_data_5 : _GEN_177; // @[Buffer.scala 131:27 134:24]
  assign io_polyvec1_rd_data_6 = state == 2'h0 ? u_ram_1_io_rd_data_6 : _GEN_178; // @[Buffer.scala 131:27 134:24]
  assign io_polyvec1_rd_data_7 = state == 2'h0 ? u_ram_1_io_rd_data_7 : _GEN_179; // @[Buffer.scala 131:27 134:24]
  assign u_ram_0_clock = clock;
  assign u_ram_0_io_wr_en_0 = state == 2'h0 ? io_polyvec0_wr_en_0 : _GEN_180; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_en_1 = state == 2'h0 ? io_polyvec0_wr_en_1 : _GEN_181; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_en_2 = state == 2'h0 ? io_polyvec0_wr_en_2 : _GEN_182; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_en_3 = state == 2'h0 ? io_polyvec0_wr_en_3 : _GEN_183; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_en_4 = state == 2'h0 ? io_polyvec0_wr_en_4 : _GEN_184; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_en_5 = state == 2'h0 ? io_polyvec0_wr_en_5 : _GEN_185; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_en_6 = state == 2'h0 ? io_polyvec0_wr_en_6 : _GEN_186; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_en_7 = state == 2'h0 ? io_polyvec0_wr_en_7 : _GEN_187; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_addr_0 = state == 2'h0 ? io_polyvec0_wr_addr_0 : _GEN_188; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_addr_1 = state == 2'h0 ? io_polyvec0_wr_addr_1 : _GEN_189; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_addr_2 = state == 2'h0 ? io_polyvec0_wr_addr_2 : _GEN_190; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_addr_3 = state == 2'h0 ? io_polyvec0_wr_addr_3 : _GEN_191; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_addr_4 = state == 2'h0 ? io_polyvec0_wr_addr_4 : _GEN_192; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_addr_5 = state == 2'h0 ? io_polyvec0_wr_addr_5 : _GEN_193; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_addr_6 = state == 2'h0 ? io_polyvec0_wr_addr_6 : _GEN_194; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_addr_7 = state == 2'h0 ? io_polyvec0_wr_addr_7 : _GEN_195; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_data_0 = state == 2'h0 ? io_polyvec0_wr_data_0 : _GEN_196; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_data_1 = state == 2'h0 ? io_polyvec0_wr_data_1 : _GEN_197; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_data_2 = state == 2'h0 ? io_polyvec0_wr_data_2 : _GEN_198; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_data_3 = state == 2'h0 ? io_polyvec0_wr_data_3 : _GEN_199; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_data_4 = state == 2'h0 ? io_polyvec0_wr_data_4 : _GEN_200; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_data_5 = state == 2'h0 ? io_polyvec0_wr_data_5 : _GEN_201; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_data_6 = state == 2'h0 ? io_polyvec0_wr_data_6 : _GEN_202; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_wr_data_7 = state == 2'h0 ? io_polyvec0_wr_data_7 : _GEN_203; // @[Buffer.scala 131:27 133:24]
  assign u_ram_0_io_rd_addr_0 = state == 2'h0 ? io_polyvec0_rd_addr_0 : _GEN_164; // @[Buffer.scala 131:27 132:24]
  assign u_ram_0_io_rd_addr_1 = state == 2'h0 ? io_polyvec0_rd_addr_1 : _GEN_165; // @[Buffer.scala 131:27 132:24]
  assign u_ram_0_io_rd_addr_2 = state == 2'h0 ? io_polyvec0_rd_addr_2 : _GEN_166; // @[Buffer.scala 131:27 132:24]
  assign u_ram_0_io_rd_addr_3 = state == 2'h0 ? io_polyvec0_rd_addr_3 : _GEN_167; // @[Buffer.scala 131:27 132:24]
  assign u_ram_0_io_rd_addr_4 = state == 2'h0 ? io_polyvec0_rd_addr_4 : _GEN_168; // @[Buffer.scala 131:27 132:24]
  assign u_ram_0_io_rd_addr_5 = state == 2'h0 ? io_polyvec0_rd_addr_5 : _GEN_169; // @[Buffer.scala 131:27 132:24]
  assign u_ram_0_io_rd_addr_6 = state == 2'h0 ? io_polyvec0_rd_addr_6 : _GEN_170; // @[Buffer.scala 131:27 132:24]
  assign u_ram_0_io_rd_addr_7 = state == 2'h0 ? io_polyvec0_rd_addr_7 : _GEN_171; // @[Buffer.scala 131:27 132:24]
  assign u_ram_1_clock = clock;
  assign u_ram_1_io_wr_en_0 = state == 2'h0 ? io_polyvec1_wr_en_0 : _GEN_220; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_en_1 = state == 2'h0 ? io_polyvec1_wr_en_1 : _GEN_221; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_en_2 = state == 2'h0 ? io_polyvec1_wr_en_2 : _GEN_222; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_en_3 = state == 2'h0 ? io_polyvec1_wr_en_3 : _GEN_223; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_en_4 = state == 2'h0 ? io_polyvec1_wr_en_4 : _GEN_224; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_en_5 = state == 2'h0 ? io_polyvec1_wr_en_5 : _GEN_225; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_en_6 = state == 2'h0 ? io_polyvec1_wr_en_6 : _GEN_226; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_en_7 = state == 2'h0 ? io_polyvec1_wr_en_7 : _GEN_227; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_addr_0 = state == 2'h0 ? io_polyvec1_wr_addr_0 : _GEN_228; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_addr_1 = state == 2'h0 ? io_polyvec1_wr_addr_1 : _GEN_229; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_addr_2 = state == 2'h0 ? io_polyvec1_wr_addr_2 : _GEN_230; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_addr_3 = state == 2'h0 ? io_polyvec1_wr_addr_3 : _GEN_231; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_addr_4 = state == 2'h0 ? io_polyvec1_wr_addr_4 : _GEN_232; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_addr_5 = state == 2'h0 ? io_polyvec1_wr_addr_5 : _GEN_233; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_addr_6 = state == 2'h0 ? io_polyvec1_wr_addr_6 : _GEN_234; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_addr_7 = state == 2'h0 ? io_polyvec1_wr_addr_7 : _GEN_235; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_data_0 = state == 2'h0 ? io_polyvec1_wr_data_0 : _GEN_236; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_data_1 = state == 2'h0 ? io_polyvec1_wr_data_1 : _GEN_237; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_data_2 = state == 2'h0 ? io_polyvec1_wr_data_2 : _GEN_238; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_data_3 = state == 2'h0 ? io_polyvec1_wr_data_3 : _GEN_239; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_data_4 = state == 2'h0 ? io_polyvec1_wr_data_4 : _GEN_240; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_data_5 = state == 2'h0 ? io_polyvec1_wr_data_5 : _GEN_241; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_data_6 = state == 2'h0 ? io_polyvec1_wr_data_6 : _GEN_242; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_wr_data_7 = state == 2'h0 ? io_polyvec1_wr_data_7 : _GEN_243; // @[Buffer.scala 131:27 135:24]
  assign u_ram_1_io_rd_addr_0 = state == 2'h0 ? io_polyvec1_rd_addr_0 : _GEN_204; // @[Buffer.scala 131:27 134:24]
  assign u_ram_1_io_rd_addr_1 = state == 2'h0 ? io_polyvec1_rd_addr_1 : _GEN_205; // @[Buffer.scala 131:27 134:24]
  assign u_ram_1_io_rd_addr_2 = state == 2'h0 ? io_polyvec1_rd_addr_2 : _GEN_206; // @[Buffer.scala 131:27 134:24]
  assign u_ram_1_io_rd_addr_3 = state == 2'h0 ? io_polyvec1_rd_addr_3 : _GEN_207; // @[Buffer.scala 131:27 134:24]
  assign u_ram_1_io_rd_addr_4 = state == 2'h0 ? io_polyvec1_rd_addr_4 : _GEN_208; // @[Buffer.scala 131:27 134:24]
  assign u_ram_1_io_rd_addr_5 = state == 2'h0 ? io_polyvec1_rd_addr_5 : _GEN_209; // @[Buffer.scala 131:27 134:24]
  assign u_ram_1_io_rd_addr_6 = state == 2'h0 ? io_polyvec1_rd_addr_6 : _GEN_210; // @[Buffer.scala 131:27 134:24]
  assign u_ram_1_io_rd_addr_7 = state == 2'h0 ? io_polyvec1_rd_addr_7 : _GEN_211; // @[Buffer.scala 131:27 134:24]
  assign u_ram_2_clock = clock;
  assign u_ram_2_io_wr_en_0 = state == 2'h0 ? 1'h0 : _GEN_140; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_en_1 = state == 2'h0 ? 1'h0 : _GEN_141; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_en_2 = state == 2'h0 ? 1'h0 : _GEN_142; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_en_3 = state == 2'h0 ? 1'h0 : _GEN_143; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_en_4 = state == 2'h0 ? 1'h0 : _GEN_144; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_en_5 = state == 2'h0 ? 1'h0 : _GEN_145; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_en_6 = state == 2'h0 ? 1'h0 : _GEN_146; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_en_7 = state == 2'h0 ? 1'h0 : _GEN_147; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_addr_0 = state == 2'h0 ? 9'h0 : _GEN_148; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_addr_1 = state == 2'h0 ? 9'h0 : _GEN_149; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_addr_2 = state == 2'h0 ? 9'h0 : _GEN_150; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_addr_3 = state == 2'h0 ? 9'h0 : _GEN_151; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_addr_4 = state == 2'h0 ? 9'h0 : _GEN_152; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_addr_5 = state == 2'h0 ? 9'h0 : _GEN_153; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_addr_6 = state == 2'h0 ? 9'h0 : _GEN_154; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_addr_7 = state == 2'h0 ? 9'h0 : _GEN_155; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_data_0 = state == 2'h0 ? 35'h0 : _GEN_156; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_data_1 = state == 2'h0 ? 35'h0 : _GEN_157; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_data_2 = state == 2'h0 ? 35'h0 : _GEN_158; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_data_3 = state == 2'h0 ? 35'h0 : _GEN_159; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_data_4 = state == 2'h0 ? 35'h0 : _GEN_160; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_data_5 = state == 2'h0 ? 35'h0 : _GEN_161; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_data_6 = state == 2'h0 ? 35'h0 : _GEN_162; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_wr_data_7 = state == 2'h0 ? 35'h0 : _GEN_163; // @[Buffer.scala 131:27 137:24]
  assign u_ram_2_io_rd_addr_0 = state == 2'h0 ? 9'h0 : _GEN_124; // @[Buffer.scala 131:27 136:24]
  assign u_ram_2_io_rd_addr_1 = state == 2'h0 ? 9'h0 : _GEN_125; // @[Buffer.scala 131:27 136:24]
  assign u_ram_2_io_rd_addr_2 = state == 2'h0 ? 9'h0 : _GEN_126; // @[Buffer.scala 131:27 136:24]
  assign u_ram_2_io_rd_addr_3 = state == 2'h0 ? 9'h0 : _GEN_127; // @[Buffer.scala 131:27 136:24]
  assign u_ram_2_io_rd_addr_4 = state == 2'h0 ? 9'h0 : _GEN_128; // @[Buffer.scala 131:27 136:24]
  assign u_ram_2_io_rd_addr_5 = state == 2'h0 ? 9'h0 : _GEN_129; // @[Buffer.scala 131:27 136:24]
  assign u_ram_2_io_rd_addr_6 = state == 2'h0 ? 9'h0 : _GEN_130; // @[Buffer.scala 131:27 136:24]
  assign u_ram_2_io_rd_addr_7 = state == 2'h0 ? 9'h0 : _GEN_131; // @[Buffer.scala 131:27 136:24]
  always @(posedge clock) begin
    done_r <= io_i_done; // @[Buffer.scala 115:25]
    if (reset) begin // @[Buffer.scala 118:24]
      state <= 2'h0; // @[Buffer.scala 118:24]
    end else if (io_i_done & ~done_r) begin // @[Buffer.scala 119:33]
      if (2'h0 == state) begin // @[Buffer.scala 120:24]
        state <= 2'h1; // @[Buffer.scala 121:31]
      end else if (2'h1 == state) begin // @[Buffer.scala 120:24]
        state <= 2'h2; // @[Buffer.scala 122:31]
      end else begin
        state <= _GEN_0;
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
  input         clock,
  input         reset,
  input         io_i_intt_start,
  output        io_o_intt_done,
  input         io_i_pre_switch,
  input         io_i_mux_done,
  input  [11:0] io_i_coeff_index,
  input         io_dp1_wr_0_en,
  input  [11:0] io_dp1_wr_0_addr,
  input  [34:0] io_dp1_wr_0_data,
  input  [11:0] io_dp1_rd_0_addr,
  output [34:0] io_dp1_rd_0_data
);
  wire  u_intt_0_clock; // @[Preprocess.scala 38:48]
  wire  u_intt_0_reset; // @[Preprocess.scala 38:48]
  wire  u_intt_0_io_ntt_start; // @[Preprocess.scala 38:48]
  wire  u_intt_0_io_ntt_done; // @[Preprocess.scala 38:48]
  wire  u_intt_0_io_wr_l_en_0; // @[Preprocess.scala 38:48]
  wire  u_intt_0_io_wr_l_en_1; // @[Preprocess.scala 38:48]
  wire  u_intt_0_io_wr_l_en_2; // @[Preprocess.scala 38:48]
  wire  u_intt_0_io_wr_l_en_3; // @[Preprocess.scala 38:48]
  wire  u_intt_0_io_wr_l_en_4; // @[Preprocess.scala 38:48]
  wire  u_intt_0_io_wr_l_en_5; // @[Preprocess.scala 38:48]
  wire  u_intt_0_io_wr_l_en_6; // @[Preprocess.scala 38:48]
  wire  u_intt_0_io_wr_l_en_7; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_wr_l_addr_0; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_wr_l_addr_1; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_wr_l_addr_2; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_wr_l_addr_3; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_wr_l_addr_4; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_wr_l_addr_5; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_wr_l_addr_6; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_wr_l_addr_7; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_wr_l_data_0; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_wr_l_data_1; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_wr_l_data_2; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_wr_l_data_3; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_wr_l_data_4; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_wr_l_data_5; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_wr_l_data_6; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_wr_l_data_7; // @[Preprocess.scala 38:48]
  wire  u_intt_0_io_wr_r_en_0; // @[Preprocess.scala 38:48]
  wire  u_intt_0_io_wr_r_en_1; // @[Preprocess.scala 38:48]
  wire  u_intt_0_io_wr_r_en_2; // @[Preprocess.scala 38:48]
  wire  u_intt_0_io_wr_r_en_3; // @[Preprocess.scala 38:48]
  wire  u_intt_0_io_wr_r_en_4; // @[Preprocess.scala 38:48]
  wire  u_intt_0_io_wr_r_en_5; // @[Preprocess.scala 38:48]
  wire  u_intt_0_io_wr_r_en_6; // @[Preprocess.scala 38:48]
  wire  u_intt_0_io_wr_r_en_7; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_wr_r_addr_0; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_wr_r_addr_1; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_wr_r_addr_2; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_wr_r_addr_3; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_wr_r_addr_4; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_wr_r_addr_5; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_wr_r_addr_6; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_wr_r_addr_7; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_wr_r_data_0; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_wr_r_data_1; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_wr_r_data_2; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_wr_r_data_3; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_wr_r_data_4; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_wr_r_data_5; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_wr_r_data_6; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_wr_r_data_7; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_rd_l_addr_0; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_rd_l_addr_1; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_rd_l_addr_2; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_rd_l_addr_3; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_rd_l_addr_4; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_rd_l_addr_5; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_rd_l_addr_6; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_rd_l_addr_7; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_rd_l_data_0; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_rd_l_data_1; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_rd_l_data_2; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_rd_l_data_3; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_rd_l_data_4; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_rd_l_data_5; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_rd_l_data_6; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_rd_l_data_7; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_rd_r_addr_0; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_rd_r_addr_1; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_rd_r_addr_2; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_rd_r_addr_3; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_rd_r_addr_4; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_rd_r_addr_5; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_rd_r_addr_6; // @[Preprocess.scala 38:48]
  wire [8:0] u_intt_0_io_rd_r_addr_7; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_rd_r_data_0; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_rd_r_data_1; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_rd_r_data_2; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_rd_r_data_3; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_rd_r_data_4; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_rd_r_data_5; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_rd_r_data_6; // @[Preprocess.scala 38:48]
  wire [34:0] u_intt_0_io_rd_r_data_7; // @[Preprocess.scala 38:48]
  wire  u_intt_buf_0_clock; // @[Preprocess.scala 46:15]
  wire  u_intt_buf_0_io_wr_en_0; // @[Preprocess.scala 46:15]
  wire  u_intt_buf_0_io_wr_en_1; // @[Preprocess.scala 46:15]
  wire  u_intt_buf_0_io_wr_en_2; // @[Preprocess.scala 46:15]
  wire  u_intt_buf_0_io_wr_en_3; // @[Preprocess.scala 46:15]
  wire  u_intt_buf_0_io_wr_en_4; // @[Preprocess.scala 46:15]
  wire  u_intt_buf_0_io_wr_en_5; // @[Preprocess.scala 46:15]
  wire  u_intt_buf_0_io_wr_en_6; // @[Preprocess.scala 46:15]
  wire  u_intt_buf_0_io_wr_en_7; // @[Preprocess.scala 46:15]
  wire [8:0] u_intt_buf_0_io_wr_addr_0; // @[Preprocess.scala 46:15]
  wire [8:0] u_intt_buf_0_io_wr_addr_1; // @[Preprocess.scala 46:15]
  wire [8:0] u_intt_buf_0_io_wr_addr_2; // @[Preprocess.scala 46:15]
  wire [8:0] u_intt_buf_0_io_wr_addr_3; // @[Preprocess.scala 46:15]
  wire [8:0] u_intt_buf_0_io_wr_addr_4; // @[Preprocess.scala 46:15]
  wire [8:0] u_intt_buf_0_io_wr_addr_5; // @[Preprocess.scala 46:15]
  wire [8:0] u_intt_buf_0_io_wr_addr_6; // @[Preprocess.scala 46:15]
  wire [8:0] u_intt_buf_0_io_wr_addr_7; // @[Preprocess.scala 46:15]
  wire [34:0] u_intt_buf_0_io_wr_data_0; // @[Preprocess.scala 46:15]
  wire [34:0] u_intt_buf_0_io_wr_data_1; // @[Preprocess.scala 46:15]
  wire [34:0] u_intt_buf_0_io_wr_data_2; // @[Preprocess.scala 46:15]
  wire [34:0] u_intt_buf_0_io_wr_data_3; // @[Preprocess.scala 46:15]
  wire [34:0] u_intt_buf_0_io_wr_data_4; // @[Preprocess.scala 46:15]
  wire [34:0] u_intt_buf_0_io_wr_data_5; // @[Preprocess.scala 46:15]
  wire [34:0] u_intt_buf_0_io_wr_data_6; // @[Preprocess.scala 46:15]
  wire [34:0] u_intt_buf_0_io_wr_data_7; // @[Preprocess.scala 46:15]
  wire [8:0] u_intt_buf_0_io_rd_addr_0; // @[Preprocess.scala 46:15]
  wire [8:0] u_intt_buf_0_io_rd_addr_1; // @[Preprocess.scala 46:15]
  wire [8:0] u_intt_buf_0_io_rd_addr_2; // @[Preprocess.scala 46:15]
  wire [8:0] u_intt_buf_0_io_rd_addr_3; // @[Preprocess.scala 46:15]
  wire [8:0] u_intt_buf_0_io_rd_addr_4; // @[Preprocess.scala 46:15]
  wire [8:0] u_intt_buf_0_io_rd_addr_5; // @[Preprocess.scala 46:15]
  wire [8:0] u_intt_buf_0_io_rd_addr_6; // @[Preprocess.scala 46:15]
  wire [8:0] u_intt_buf_0_io_rd_addr_7; // @[Preprocess.scala 46:15]
  wire [34:0] u_intt_buf_0_io_rd_data_0; // @[Preprocess.scala 46:15]
  wire [34:0] u_intt_buf_0_io_rd_data_1; // @[Preprocess.scala 46:15]
  wire [34:0] u_intt_buf_0_io_rd_data_2; // @[Preprocess.scala 46:15]
  wire [34:0] u_intt_buf_0_io_rd_data_3; // @[Preprocess.scala 46:15]
  wire [34:0] u_intt_buf_0_io_rd_data_4; // @[Preprocess.scala 46:15]
  wire [34:0] u_intt_buf_0_io_rd_data_5; // @[Preprocess.scala 46:15]
  wire [34:0] u_intt_buf_0_io_rd_data_6; // @[Preprocess.scala 46:15]
  wire [34:0] u_intt_buf_0_io_rd_data_7; // @[Preprocess.scala 46:15]
  wire  u_tpp_0_clock; // @[Preprocess.scala 49:15]
  wire  u_tpp_0_reset; // @[Preprocess.scala 49:15]
  wire  u_tpp_0_io_i_done; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec0_rd_addr_0; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec0_rd_addr_1; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec0_rd_addr_2; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec0_rd_addr_3; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec0_rd_addr_4; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec0_rd_addr_5; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec0_rd_addr_6; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec0_rd_addr_7; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec0_rd_data_0; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec0_rd_data_1; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec0_rd_data_2; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec0_rd_data_3; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec0_rd_data_4; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec0_rd_data_5; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec0_rd_data_6; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec0_rd_data_7; // @[Preprocess.scala 49:15]
  wire  u_tpp_0_io_polyvec0_wr_en_0; // @[Preprocess.scala 49:15]
  wire  u_tpp_0_io_polyvec0_wr_en_1; // @[Preprocess.scala 49:15]
  wire  u_tpp_0_io_polyvec0_wr_en_2; // @[Preprocess.scala 49:15]
  wire  u_tpp_0_io_polyvec0_wr_en_3; // @[Preprocess.scala 49:15]
  wire  u_tpp_0_io_polyvec0_wr_en_4; // @[Preprocess.scala 49:15]
  wire  u_tpp_0_io_polyvec0_wr_en_5; // @[Preprocess.scala 49:15]
  wire  u_tpp_0_io_polyvec0_wr_en_6; // @[Preprocess.scala 49:15]
  wire  u_tpp_0_io_polyvec0_wr_en_7; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec0_wr_addr_0; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec0_wr_addr_1; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec0_wr_addr_2; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec0_wr_addr_3; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec0_wr_addr_4; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec0_wr_addr_5; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec0_wr_addr_6; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec0_wr_addr_7; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec0_wr_data_0; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec0_wr_data_1; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec0_wr_data_2; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec0_wr_data_3; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec0_wr_data_4; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec0_wr_data_5; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec0_wr_data_6; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec0_wr_data_7; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec1_rd_addr_0; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec1_rd_addr_1; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec1_rd_addr_2; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec1_rd_addr_3; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec1_rd_addr_4; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec1_rd_addr_5; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec1_rd_addr_6; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec1_rd_addr_7; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec1_rd_data_0; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec1_rd_data_1; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec1_rd_data_2; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec1_rd_data_3; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec1_rd_data_4; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec1_rd_data_5; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec1_rd_data_6; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec1_rd_data_7; // @[Preprocess.scala 49:15]
  wire  u_tpp_0_io_polyvec1_wr_en_0; // @[Preprocess.scala 49:15]
  wire  u_tpp_0_io_polyvec1_wr_en_1; // @[Preprocess.scala 49:15]
  wire  u_tpp_0_io_polyvec1_wr_en_2; // @[Preprocess.scala 49:15]
  wire  u_tpp_0_io_polyvec1_wr_en_3; // @[Preprocess.scala 49:15]
  wire  u_tpp_0_io_polyvec1_wr_en_4; // @[Preprocess.scala 49:15]
  wire  u_tpp_0_io_polyvec1_wr_en_5; // @[Preprocess.scala 49:15]
  wire  u_tpp_0_io_polyvec1_wr_en_6; // @[Preprocess.scala 49:15]
  wire  u_tpp_0_io_polyvec1_wr_en_7; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec1_wr_addr_0; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec1_wr_addr_1; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec1_wr_addr_2; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec1_wr_addr_3; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec1_wr_addr_4; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec1_wr_addr_5; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec1_wr_addr_6; // @[Preprocess.scala 49:15]
  wire [8:0] u_tpp_0_io_polyvec1_wr_addr_7; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec1_wr_data_0; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec1_wr_data_1; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec1_wr_data_2; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec1_wr_data_3; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec1_wr_data_4; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec1_wr_data_5; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec1_wr_data_6; // @[Preprocess.scala 49:15]
  wire [34:0] u_tpp_0_io_polyvec1_wr_data_7; // @[Preprocess.scala 49:15]
  wire  u_dp1_wr_itf_0_io_vpu_wr_en; // @[Preprocess.scala 59:15]
  wire [11:0] u_dp1_wr_itf_0_io_vpu_wr_addr; // @[Preprocess.scala 59:15]
  wire [34:0] u_dp1_wr_itf_0_io_vpu_wr_data; // @[Preprocess.scala 59:15]
  wire  u_dp1_wr_itf_0_io_buf_wr_en_0; // @[Preprocess.scala 59:15]
  wire  u_dp1_wr_itf_0_io_buf_wr_en_1; // @[Preprocess.scala 59:15]
  wire  u_dp1_wr_itf_0_io_buf_wr_en_2; // @[Preprocess.scala 59:15]
  wire  u_dp1_wr_itf_0_io_buf_wr_en_3; // @[Preprocess.scala 59:15]
  wire  u_dp1_wr_itf_0_io_buf_wr_en_4; // @[Preprocess.scala 59:15]
  wire  u_dp1_wr_itf_0_io_buf_wr_en_5; // @[Preprocess.scala 59:15]
  wire  u_dp1_wr_itf_0_io_buf_wr_en_6; // @[Preprocess.scala 59:15]
  wire  u_dp1_wr_itf_0_io_buf_wr_en_7; // @[Preprocess.scala 59:15]
  wire [8:0] u_dp1_wr_itf_0_io_buf_wr_addr_0; // @[Preprocess.scala 59:15]
  wire [8:0] u_dp1_wr_itf_0_io_buf_wr_addr_1; // @[Preprocess.scala 59:15]
  wire [8:0] u_dp1_wr_itf_0_io_buf_wr_addr_2; // @[Preprocess.scala 59:15]
  wire [8:0] u_dp1_wr_itf_0_io_buf_wr_addr_3; // @[Preprocess.scala 59:15]
  wire [8:0] u_dp1_wr_itf_0_io_buf_wr_addr_4; // @[Preprocess.scala 59:15]
  wire [8:0] u_dp1_wr_itf_0_io_buf_wr_addr_5; // @[Preprocess.scala 59:15]
  wire [8:0] u_dp1_wr_itf_0_io_buf_wr_addr_6; // @[Preprocess.scala 59:15]
  wire [8:0] u_dp1_wr_itf_0_io_buf_wr_addr_7; // @[Preprocess.scala 59:15]
  wire [34:0] u_dp1_wr_itf_0_io_buf_wr_data_0; // @[Preprocess.scala 59:15]
  wire [34:0] u_dp1_wr_itf_0_io_buf_wr_data_1; // @[Preprocess.scala 59:15]
  wire [34:0] u_dp1_wr_itf_0_io_buf_wr_data_2; // @[Preprocess.scala 59:15]
  wire [34:0] u_dp1_wr_itf_0_io_buf_wr_data_3; // @[Preprocess.scala 59:15]
  wire [34:0] u_dp1_wr_itf_0_io_buf_wr_data_4; // @[Preprocess.scala 59:15]
  wire [34:0] u_dp1_wr_itf_0_io_buf_wr_data_5; // @[Preprocess.scala 59:15]
  wire [34:0] u_dp1_wr_itf_0_io_buf_wr_data_6; // @[Preprocess.scala 59:15]
  wire [34:0] u_dp1_wr_itf_0_io_buf_wr_data_7; // @[Preprocess.scala 59:15]
  wire  u_dp1_rd_itf_0_clock; // @[Preprocess.scala 62:15]
  wire [11:0] u_dp1_rd_itf_0_io_vpu_rd_addr; // @[Preprocess.scala 62:15]
  wire [34:0] u_dp1_rd_itf_0_io_vpu_rd_data; // @[Preprocess.scala 62:15]
  wire [8:0] u_dp1_rd_itf_0_io_buf_rd_addr_0; // @[Preprocess.scala 62:15]
  wire [8:0] u_dp1_rd_itf_0_io_buf_rd_addr_1; // @[Preprocess.scala 62:15]
  wire [8:0] u_dp1_rd_itf_0_io_buf_rd_addr_2; // @[Preprocess.scala 62:15]
  wire [8:0] u_dp1_rd_itf_0_io_buf_rd_addr_3; // @[Preprocess.scala 62:15]
  wire [8:0] u_dp1_rd_itf_0_io_buf_rd_addr_4; // @[Preprocess.scala 62:15]
  wire [8:0] u_dp1_rd_itf_0_io_buf_rd_addr_5; // @[Preprocess.scala 62:15]
  wire [8:0] u_dp1_rd_itf_0_io_buf_rd_addr_6; // @[Preprocess.scala 62:15]
  wire [8:0] u_dp1_rd_itf_0_io_buf_rd_addr_7; // @[Preprocess.scala 62:15]
  wire [34:0] u_dp1_rd_itf_0_io_buf_rd_data_0; // @[Preprocess.scala 62:15]
  wire [34:0] u_dp1_rd_itf_0_io_buf_rd_data_1; // @[Preprocess.scala 62:15]
  wire [34:0] u_dp1_rd_itf_0_io_buf_rd_data_2; // @[Preprocess.scala 62:15]
  wire [34:0] u_dp1_rd_itf_0_io_buf_rd_data_3; // @[Preprocess.scala 62:15]
  wire [34:0] u_dp1_rd_itf_0_io_buf_rd_data_4; // @[Preprocess.scala 62:15]
  wire [34:0] u_dp1_rd_itf_0_io_buf_rd_data_5; // @[Preprocess.scala 62:15]
  wire [34:0] u_dp1_rd_itf_0_io_buf_rd_data_6; // @[Preprocess.scala 62:15]
  wire [34:0] u_dp1_rd_itf_0_io_buf_rd_data_7; // @[Preprocess.scala 62:15]
  intt_17314086913 u_intt_0 ( // @[Preprocess.scala 38:48]
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
    .io_rd_r_data_7(u_intt_0_io_rd_r_data_7)
  );
  poly_ram_35_9_8 u_intt_buf_0 ( // @[Preprocess.scala 46:15]
    .clock(u_intt_buf_0_clock),
    .io_wr_en_0(u_intt_buf_0_io_wr_en_0),
    .io_wr_en_1(u_intt_buf_0_io_wr_en_1),
    .io_wr_en_2(u_intt_buf_0_io_wr_en_2),
    .io_wr_en_3(u_intt_buf_0_io_wr_en_3),
    .io_wr_en_4(u_intt_buf_0_io_wr_en_4),
    .io_wr_en_5(u_intt_buf_0_io_wr_en_5),
    .io_wr_en_6(u_intt_buf_0_io_wr_en_6),
    .io_wr_en_7(u_intt_buf_0_io_wr_en_7),
    .io_wr_addr_0(u_intt_buf_0_io_wr_addr_0),
    .io_wr_addr_1(u_intt_buf_0_io_wr_addr_1),
    .io_wr_addr_2(u_intt_buf_0_io_wr_addr_2),
    .io_wr_addr_3(u_intt_buf_0_io_wr_addr_3),
    .io_wr_addr_4(u_intt_buf_0_io_wr_addr_4),
    .io_wr_addr_5(u_intt_buf_0_io_wr_addr_5),
    .io_wr_addr_6(u_intt_buf_0_io_wr_addr_6),
    .io_wr_addr_7(u_intt_buf_0_io_wr_addr_7),
    .io_wr_data_0(u_intt_buf_0_io_wr_data_0),
    .io_wr_data_1(u_intt_buf_0_io_wr_data_1),
    .io_wr_data_2(u_intt_buf_0_io_wr_data_2),
    .io_wr_data_3(u_intt_buf_0_io_wr_data_3),
    .io_wr_data_4(u_intt_buf_0_io_wr_data_4),
    .io_wr_data_5(u_intt_buf_0_io_wr_data_5),
    .io_wr_data_6(u_intt_buf_0_io_wr_data_6),
    .io_wr_data_7(u_intt_buf_0_io_wr_data_7),
    .io_rd_addr_0(u_intt_buf_0_io_rd_addr_0),
    .io_rd_addr_1(u_intt_buf_0_io_rd_addr_1),
    .io_rd_addr_2(u_intt_buf_0_io_rd_addr_2),
    .io_rd_addr_3(u_intt_buf_0_io_rd_addr_3),
    .io_rd_addr_4(u_intt_buf_0_io_rd_addr_4),
    .io_rd_addr_5(u_intt_buf_0_io_rd_addr_5),
    .io_rd_addr_6(u_intt_buf_0_io_rd_addr_6),
    .io_rd_addr_7(u_intt_buf_0_io_rd_addr_7),
    .io_rd_data_0(u_intt_buf_0_io_rd_data_0),
    .io_rd_data_1(u_intt_buf_0_io_rd_data_1),
    .io_rd_data_2(u_intt_buf_0_io_rd_data_2),
    .io_rd_data_3(u_intt_buf_0_io_rd_data_3),
    .io_rd_data_4(u_intt_buf_0_io_rd_data_4),
    .io_rd_data_5(u_intt_buf_0_io_rd_data_5),
    .io_rd_data_6(u_intt_buf_0_io_rd_data_6),
    .io_rd_data_7(u_intt_buf_0_io_rd_data_7)
  );
  triple_pp_buffer_35_512_8 u_tpp_0 ( // @[Preprocess.scala 49:15]
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
    .io_polyvec1_wr_data_7(u_tpp_0_io_polyvec1_wr_data_7)
  );
  poly_wr_interface_35_512_8 u_dp1_wr_itf_0 ( // @[Preprocess.scala 59:15]
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
  poly_rd_interface_35_512_8_1 u_dp1_rd_itf_0 ( // @[Preprocess.scala 62:15]
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
  assign io_o_intt_done = u_intt_0_io_ntt_done; // @[Preprocess.scala 115:25]
  assign io_dp1_rd_0_data = u_dp1_rd_itf_0_io_vpu_rd_data; // @[Preprocess.scala 84:33]
  assign u_intt_0_clock = clock;
  assign u_intt_0_reset = reset;
  assign u_intt_0_io_ntt_start = io_i_intt_start; // @[Preprocess.scala 113:25]
  assign u_intt_0_io_rd_l_data_0 = u_tpp_0_io_polyvec1_rd_data_0; // @[Preprocess.scala 89:33]
  assign u_intt_0_io_rd_l_data_1 = u_tpp_0_io_polyvec1_rd_data_1; // @[Preprocess.scala 89:33]
  assign u_intt_0_io_rd_l_data_2 = u_tpp_0_io_polyvec1_rd_data_2; // @[Preprocess.scala 89:33]
  assign u_intt_0_io_rd_l_data_3 = u_tpp_0_io_polyvec1_rd_data_3; // @[Preprocess.scala 89:33]
  assign u_intt_0_io_rd_l_data_4 = u_tpp_0_io_polyvec1_rd_data_4; // @[Preprocess.scala 89:33]
  assign u_intt_0_io_rd_l_data_5 = u_tpp_0_io_polyvec1_rd_data_5; // @[Preprocess.scala 89:33]
  assign u_intt_0_io_rd_l_data_6 = u_tpp_0_io_polyvec1_rd_data_6; // @[Preprocess.scala 89:33]
  assign u_intt_0_io_rd_l_data_7 = u_tpp_0_io_polyvec1_rd_data_7; // @[Preprocess.scala 89:33]
  assign u_intt_0_io_rd_r_data_0 = u_intt_buf_0_io_rd_data_0; // @[Preprocess.scala 94:33]
  assign u_intt_0_io_rd_r_data_1 = u_intt_buf_0_io_rd_data_1; // @[Preprocess.scala 94:33]
  assign u_intt_0_io_rd_r_data_2 = u_intt_buf_0_io_rd_data_2; // @[Preprocess.scala 94:33]
  assign u_intt_0_io_rd_r_data_3 = u_intt_buf_0_io_rd_data_3; // @[Preprocess.scala 94:33]
  assign u_intt_0_io_rd_r_data_4 = u_intt_buf_0_io_rd_data_4; // @[Preprocess.scala 94:33]
  assign u_intt_0_io_rd_r_data_5 = u_intt_buf_0_io_rd_data_5; // @[Preprocess.scala 94:33]
  assign u_intt_0_io_rd_r_data_6 = u_intt_buf_0_io_rd_data_6; // @[Preprocess.scala 94:33]
  assign u_intt_0_io_rd_r_data_7 = u_intt_buf_0_io_rd_data_7; // @[Preprocess.scala 94:33]
  assign u_intt_buf_0_clock = clock;
  assign u_intt_buf_0_io_wr_en_0 = u_intt_0_io_wr_r_en_0; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_en_1 = u_intt_0_io_wr_r_en_1; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_en_2 = u_intt_0_io_wr_r_en_2; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_en_3 = u_intt_0_io_wr_r_en_3; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_en_4 = u_intt_0_io_wr_r_en_4; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_en_5 = u_intt_0_io_wr_r_en_5; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_en_6 = u_intt_0_io_wr_r_en_6; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_en_7 = u_intt_0_io_wr_r_en_7; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_addr_0 = u_intt_0_io_wr_r_addr_0; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_addr_1 = u_intt_0_io_wr_r_addr_1; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_addr_2 = u_intt_0_io_wr_r_addr_2; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_addr_3 = u_intt_0_io_wr_r_addr_3; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_addr_4 = u_intt_0_io_wr_r_addr_4; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_addr_5 = u_intt_0_io_wr_r_addr_5; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_addr_6 = u_intt_0_io_wr_r_addr_6; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_addr_7 = u_intt_0_io_wr_r_addr_7; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_data_0 = u_intt_0_io_wr_r_data_0; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_data_1 = u_intt_0_io_wr_r_data_1; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_data_2 = u_intt_0_io_wr_r_data_2; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_data_3 = u_intt_0_io_wr_r_data_3; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_data_4 = u_intt_0_io_wr_r_data_4; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_data_5 = u_intt_0_io_wr_r_data_5; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_data_6 = u_intt_0_io_wr_r_data_6; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_wr_data_7 = u_intt_0_io_wr_r_data_7; // @[Preprocess.scala 93:33]
  assign u_intt_buf_0_io_rd_addr_0 = u_intt_0_io_rd_r_addr_0; // @[Preprocess.scala 94:33]
  assign u_intt_buf_0_io_rd_addr_1 = u_intt_0_io_rd_r_addr_1; // @[Preprocess.scala 94:33]
  assign u_intt_buf_0_io_rd_addr_2 = u_intt_0_io_rd_r_addr_2; // @[Preprocess.scala 94:33]
  assign u_intt_buf_0_io_rd_addr_3 = u_intt_0_io_rd_r_addr_3; // @[Preprocess.scala 94:33]
  assign u_intt_buf_0_io_rd_addr_4 = u_intt_0_io_rd_r_addr_4; // @[Preprocess.scala 94:33]
  assign u_intt_buf_0_io_rd_addr_5 = u_intt_0_io_rd_r_addr_5; // @[Preprocess.scala 94:33]
  assign u_intt_buf_0_io_rd_addr_6 = u_intt_0_io_rd_r_addr_6; // @[Preprocess.scala 94:33]
  assign u_intt_buf_0_io_rd_addr_7 = u_intt_0_io_rd_r_addr_7; // @[Preprocess.scala 94:33]
  assign u_tpp_0_clock = clock;
  assign u_tpp_0_reset = reset;
  assign u_tpp_0_io_i_done = io_i_pre_switch; // @[Preprocess.scala 124:28]
  assign u_tpp_0_io_polyvec0_rd_addr_0 = u_dp1_rd_itf_0_io_buf_rd_addr_0; // @[Preprocess.scala 87:33]
  assign u_tpp_0_io_polyvec0_rd_addr_1 = u_dp1_rd_itf_0_io_buf_rd_addr_1; // @[Preprocess.scala 87:33]
  assign u_tpp_0_io_polyvec0_rd_addr_2 = u_dp1_rd_itf_0_io_buf_rd_addr_2; // @[Preprocess.scala 87:33]
  assign u_tpp_0_io_polyvec0_rd_addr_3 = u_dp1_rd_itf_0_io_buf_rd_addr_3; // @[Preprocess.scala 87:33]
  assign u_tpp_0_io_polyvec0_rd_addr_4 = u_dp1_rd_itf_0_io_buf_rd_addr_4; // @[Preprocess.scala 87:33]
  assign u_tpp_0_io_polyvec0_rd_addr_5 = u_dp1_rd_itf_0_io_buf_rd_addr_5; // @[Preprocess.scala 87:33]
  assign u_tpp_0_io_polyvec0_rd_addr_6 = u_dp1_rd_itf_0_io_buf_rd_addr_6; // @[Preprocess.scala 87:33]
  assign u_tpp_0_io_polyvec0_rd_addr_7 = u_dp1_rd_itf_0_io_buf_rd_addr_7; // @[Preprocess.scala 87:33]
  assign u_tpp_0_io_polyvec0_wr_en_0 = u_dp1_wr_itf_0_io_buf_wr_en_0; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_en_1 = u_dp1_wr_itf_0_io_buf_wr_en_1; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_en_2 = u_dp1_wr_itf_0_io_buf_wr_en_2; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_en_3 = u_dp1_wr_itf_0_io_buf_wr_en_3; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_en_4 = u_dp1_wr_itf_0_io_buf_wr_en_4; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_en_5 = u_dp1_wr_itf_0_io_buf_wr_en_5; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_en_6 = u_dp1_wr_itf_0_io_buf_wr_en_6; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_en_7 = u_dp1_wr_itf_0_io_buf_wr_en_7; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_addr_0 = u_dp1_wr_itf_0_io_buf_wr_addr_0; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_addr_1 = u_dp1_wr_itf_0_io_buf_wr_addr_1; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_addr_2 = u_dp1_wr_itf_0_io_buf_wr_addr_2; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_addr_3 = u_dp1_wr_itf_0_io_buf_wr_addr_3; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_addr_4 = u_dp1_wr_itf_0_io_buf_wr_addr_4; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_addr_5 = u_dp1_wr_itf_0_io_buf_wr_addr_5; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_addr_6 = u_dp1_wr_itf_0_io_buf_wr_addr_6; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_addr_7 = u_dp1_wr_itf_0_io_buf_wr_addr_7; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_data_0 = u_dp1_wr_itf_0_io_buf_wr_data_0; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_data_1 = u_dp1_wr_itf_0_io_buf_wr_data_1; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_data_2 = u_dp1_wr_itf_0_io_buf_wr_data_2; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_data_3 = u_dp1_wr_itf_0_io_buf_wr_data_3; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_data_4 = u_dp1_wr_itf_0_io_buf_wr_data_4; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_data_5 = u_dp1_wr_itf_0_io_buf_wr_data_5; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_data_6 = u_dp1_wr_itf_0_io_buf_wr_data_6; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec0_wr_data_7 = u_dp1_wr_itf_0_io_buf_wr_data_7; // @[Preprocess.scala 86:33]
  assign u_tpp_0_io_polyvec1_rd_addr_0 = u_intt_0_io_rd_l_addr_0; // @[Preprocess.scala 89:33]
  assign u_tpp_0_io_polyvec1_rd_addr_1 = u_intt_0_io_rd_l_addr_1; // @[Preprocess.scala 89:33]
  assign u_tpp_0_io_polyvec1_rd_addr_2 = u_intt_0_io_rd_l_addr_2; // @[Preprocess.scala 89:33]
  assign u_tpp_0_io_polyvec1_rd_addr_3 = u_intt_0_io_rd_l_addr_3; // @[Preprocess.scala 89:33]
  assign u_tpp_0_io_polyvec1_rd_addr_4 = u_intt_0_io_rd_l_addr_4; // @[Preprocess.scala 89:33]
  assign u_tpp_0_io_polyvec1_rd_addr_5 = u_intt_0_io_rd_l_addr_5; // @[Preprocess.scala 89:33]
  assign u_tpp_0_io_polyvec1_rd_addr_6 = u_intt_0_io_rd_l_addr_6; // @[Preprocess.scala 89:33]
  assign u_tpp_0_io_polyvec1_rd_addr_7 = u_intt_0_io_rd_l_addr_7; // @[Preprocess.scala 89:33]
  assign u_tpp_0_io_polyvec1_wr_en_0 = u_intt_0_io_wr_l_en_0; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_en_1 = u_intt_0_io_wr_l_en_1; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_en_2 = u_intt_0_io_wr_l_en_2; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_en_3 = u_intt_0_io_wr_l_en_3; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_en_4 = u_intt_0_io_wr_l_en_4; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_en_5 = u_intt_0_io_wr_l_en_5; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_en_6 = u_intt_0_io_wr_l_en_6; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_en_7 = u_intt_0_io_wr_l_en_7; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_addr_0 = u_intt_0_io_wr_l_addr_0; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_addr_1 = u_intt_0_io_wr_l_addr_1; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_addr_2 = u_intt_0_io_wr_l_addr_2; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_addr_3 = u_intt_0_io_wr_l_addr_3; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_addr_4 = u_intt_0_io_wr_l_addr_4; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_addr_5 = u_intt_0_io_wr_l_addr_5; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_addr_6 = u_intt_0_io_wr_l_addr_6; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_addr_7 = u_intt_0_io_wr_l_addr_7; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_data_0 = u_intt_0_io_wr_l_data_0; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_data_1 = u_intt_0_io_wr_l_data_1; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_data_2 = u_intt_0_io_wr_l_data_2; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_data_3 = u_intt_0_io_wr_l_data_3; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_data_4 = u_intt_0_io_wr_l_data_4; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_data_5 = u_intt_0_io_wr_l_data_5; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_data_6 = u_intt_0_io_wr_l_data_6; // @[Preprocess.scala 88:33]
  assign u_tpp_0_io_polyvec1_wr_data_7 = u_intt_0_io_wr_l_data_7; // @[Preprocess.scala 88:33]
  assign u_dp1_wr_itf_0_io_vpu_wr_en = io_dp1_wr_0_en; // @[Preprocess.scala 83:33]
  assign u_dp1_wr_itf_0_io_vpu_wr_addr = io_dp1_wr_0_addr; // @[Preprocess.scala 83:33]
  assign u_dp1_wr_itf_0_io_vpu_wr_data = io_dp1_wr_0_data; // @[Preprocess.scala 83:33]
  assign u_dp1_rd_itf_0_clock = clock;
  assign u_dp1_rd_itf_0_io_vpu_rd_addr = io_dp1_rd_0_addr; // @[Preprocess.scala 84:33]
  assign u_dp1_rd_itf_0_io_buf_rd_data_0 = u_tpp_0_io_polyvec0_rd_data_0; // @[Preprocess.scala 87:33]
  assign u_dp1_rd_itf_0_io_buf_rd_data_1 = u_tpp_0_io_polyvec0_rd_data_1; // @[Preprocess.scala 87:33]
  assign u_dp1_rd_itf_0_io_buf_rd_data_2 = u_tpp_0_io_polyvec0_rd_data_2; // @[Preprocess.scala 87:33]
  assign u_dp1_rd_itf_0_io_buf_rd_data_3 = u_tpp_0_io_polyvec0_rd_data_3; // @[Preprocess.scala 87:33]
  assign u_dp1_rd_itf_0_io_buf_rd_data_4 = u_tpp_0_io_polyvec0_rd_data_4; // @[Preprocess.scala 87:33]
  assign u_dp1_rd_itf_0_io_buf_rd_data_5 = u_tpp_0_io_polyvec0_rd_data_5; // @[Preprocess.scala 87:33]
  assign u_dp1_rd_itf_0_io_buf_rd_data_6 = u_tpp_0_io_polyvec0_rd_data_6; // @[Preprocess.scala 87:33]
  assign u_dp1_rd_itf_0_io_buf_rd_data_7 = u_tpp_0_io_polyvec0_rd_data_7; // @[Preprocess.scala 87:33]
endmodule
