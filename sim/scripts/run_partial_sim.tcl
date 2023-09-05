source scripts/create_prj.tcl

set_property verilog_define {PARTIAL_TEST INIT_KSK SIMULATION} [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value {} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.xsim.more_options} -value {-testplusarg TESTNAME=test_row} -objects [get_filesets sim_1]

launch_simulation
run all
