.PHONY: partial_sim full_sim clean

top_tb/tast.sv:
	python3 top_tb/utils/gen_bus.py

partial_sim: top_tb/tast.sv
	python3 top_tb/utils/prepare_ksk_uram.py test_row
	python3 top_tb/utils/prepare_vec_uram.py test_row
	python3 top_tb/utils/tb_top.py test_row
	vivado -source scripts/run_partial_sim.tcl -nojournal -nolog

full_sim: top_tb/tast.sv
	python3 top_tb/utils/prepare_ksk_uram.py test_full_4x4096
	python3 top_tb/utils/prepare_vec_uram.py test_full_4x4096
	python3 top_tb/utils/tb_top.py test_full_4x4096
	vivado -source scripts/run_full_sim.tcl -nojournal -nolog

clean:
	-rm -rf mvp_sim_prj
