create_project mvp_sim_prj mvp_sim_prj -part xcvu9p-flgb2104-2L-e

import_files -norecurse {../include/addx_defines.vh ../include/mux_defines.vh ../include/dp_defines.vh ../include/monox_defines.vh ../include/ntt_intt_defines.vh ../include/common_defines.vh ../include/vpu3_defines.vh ../include/vpu4_defines.vh ../include/vpu2_defines.vh}

add_files -norecurse -scan_for_includes {../src/intt/gs_butterfly.v ../src/vpu3/vpu3_top.v ../src/preprocess/preprocess_top_chisel.v ../src/axi/out_output_transposer.v ../src/ntt_intt_common/ntt_pe_swap.v ../src/axi/counter.sv ../src/DP/madd_top.v ../src/reducebuffer/uram_polyvec.v ../src/axi/axi_axis2bram.v ../src/ntt_intt_common/addred.v ../src/reduce_trace/stg3_sub.sv ../src/mux/mux_seq.v ../src/common/modsubred.v ../src/sys_integration/mux_monox_seq.v ../src/intt/intt_core.v ../src/intt/intt_cu.v ../src/vpu2/vpu2_top.v ../src/DP/dp_tripple_pp_buffer.v ../src/DP/madd.v ../src/axi/data_trimmer.v ../src/ntt_intt_common/single_port_rom.v ../src/ntt_intt_common/barrett.v ../src/reduce_trace/pp_buffer.sv ../src/DP/dp_core.v ../src/axi/ksk_buffer.v ../src/axi/ksk_addr_gen.v ../src/ntt_intt_common/subred.v ../src/vpu3/vpu3_datapath.v ../src/ntt_intt_common/mulred.v ../src/DP/dp_ctxt_polyvec.v ../src/ntt_intt_common/mult.v ../src/reduce_trace/pp_buffer_x4.sv ../src/monox/cross_aggressive_seq.v ../src/reduce_trace/reduce_trace.sv ../src/common/modmul.v ../src/monox/monox_aggressive_seq.v ../src/preprocess/polyvec_ram.v ../src/monox/shuffle_seq.v ../src/mvp.v ../src/axi/axi_bram2axis.v ../src/mvp_top.v ../src/sys_integration/vpu_addx_seq.v ../src/axi/axi_data_rd_top.v ../src/reduce_trace/poly_ram.sv ../src/axi/inst_axi_top.v ../src/addx/cross_aggressive_last_seq.sv ../src/ntt_intt_common/tf_rom_wrapper.v ../src/preprocess/preprocess_top.v ../src/DP/dp_uram_polyvec.v ../src/mvp_axil.v ../src/axi/axi_axi2bram.v ../src/axi/axi_write_master.sv ../src/axi/pre_buffer.v ../src/control.v ../src/DP/dp_top.v ../src/vpu2/vpu2_datapath.v ../src/ntt/ct_butterfly.v ../src/common/modadd.v ../src/axi/pre_input_transposer.v ../src/sys_integration/vpu_addx_mux_monox_seq.v ../src/axi/axi_data_wr_top.v ../src/axi/axi_bram2axi.v ../src/preprocess/poly_ram.v ../src/common/modsub.v ../src/reducebuffer/sp_uram.v ../src/DP/modmuladd.v ../src/ntt/ntt_core.v ../src/reducebuffer/reduce_buffer.sv ../src/axi/axi_demo_top.v ../src/ntt/ntt_cu.v ../src/axi/axi_read_master.sv ../src/intt/halfred.v ../src/preprocess/simple_dual_ram.v}

add_files -norecurse -scan_for_includes {../src/ntt/ntt_rom_39q/ntt_rom_39q_tf3.mem ../src/intt/intt_rom_35q0/intt_rom_35q0_tf2.mem ../src/intt/intt_rom_35q0/intt_rom_35q0_tf0.mem ../src/intt/intt_rom_39q/intt_rom_39q_tf3.mem ../src/ntt/ntt_rom_39q/ntt_rom_39q_tf1.mem ../src/intt/intt_rom_35q1/intt_rom_35q1_tf0.mem ../src/ntt/ntt_rom_35q1/ntt_rom_35q1_tf0.mem ../src/ntt/ntt_rom_35q1/ntt_rom_35q1_tf2.mem ../src/intt/intt_rom_35q1/intt_rom_35q1_tf2.mem ../src/intt/intt_rom_39q/intt_rom_39q_tf0.mem ../src/ntt/ntt_rom_35q0/ntt_rom_35q0_tf2.mem ../src/ntt/ntt_rom_35q1/ntt_rom_35q1_tf3.mem ../src/ntt/ntt_rom_39q/ntt_rom_39q_tf2.mem ../src/intt/intt_rom_35q0/intt_rom_35q0_tf1.mem ../src/ntt/ntt_rom_35q1/ntt_rom_35q1_tf1.mem ../src/ntt/ntt_rom_35q0/ntt_rom_35q0_tf0.mem ../src/ntt/ntt_rom_39q/ntt_rom_39q_tf0.mem ../src/intt/intt_rom_39q/intt_rom_39q_tf2.mem ../src/intt/intt_rom_35q0/intt_rom_35q0_tf3.mem ../src/ntt/ntt_rom_35q0/ntt_rom_35q0_tf1.mem ../src/intt/intt_rom_39q/intt_rom_39q_tf1.mem ../src/intt/intt_rom_35q1/intt_rom_35q1_tf1.mem ../src/ntt/ntt_rom_35q0/ntt_rom_35q0_tf3.mem ../src/intt/intt_rom_35q1/intt_rom_35q1_tf3.mem}

import_files -force -norecurse
set_property top mvp [current_fileset]
update_compile_order -fileset sources_1

set_property SOURCE_SET sources_1 [get_filesets sim_1]

add_files -fileset sim_1 -norecurse -scan_for_includes {top_tb/tb_axi_bram.v top_tb/current_tb_top.sv top_tb/ram_model.sv xsim/glbl.v top_tb/testcase.sv top_tb/monitor.sv top_tb/control_tb.sv top_tb/task.sv top_tb/fifo_fwft.v}

import_files -fileset sim_1 -norecurse {top_tb/tb_axi_bram.v top_tb/current_tb_top.sv top_tb/ram_model.sv xsim/glbl.v top_tb/testcase.sv top_tb/monitor.sv top_tb/control_tb.sv top_tb/task.sv top_tb/fifo_fwft.v}

add_files -fileset sim_1 -norecurse -scan_for_includes {xsim/uram_k0.mem xsim/uram_k10.mem xsim/uram_k2.mem xsim/uram_k6.mem xsim/uram_k8.mem xsim/uram_k9.mem xsim/uram_k11.mem xsim/uram_k4.mem xsim/uram_k1.mem xsim/uram_k7.mem xsim/uram_k5.mem xsim/uram_vec.mem xsim/uram_k3.mem}

import_files -fileset sim_1 -norecurse {xsim/uram_k0.mem xsim/uram_k10.mem xsim/uram_k2.mem xsim/uram_k6.mem xsim/uram_k8.mem xsim/uram_k9.mem xsim/uram_k11.mem xsim/uram_k4.mem xsim/uram_k1.mem xsim/uram_k7.mem xsim/uram_k5.mem xsim/uram_vec.mem xsim/uram_k3.mem}

set_property top tb_top [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
update_compile_order -fileset sim_1
