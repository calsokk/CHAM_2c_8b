parameter DP_PP_COE_WIDTH = 39;
parameter PP_PP_COE_WIDTH = 39;
parameter RB_PP_COE_WIDTH = 35;
int fp_r0;
int fp_r1;
int flag; // $fscanf
// -------------------------------------
// dotproduct Ping-pong buffer init
// -------------------------------------
int _dp_idx;
logic [DP_PP_COE_WIDTH-1:0] _dp_temp0 [0:3*4096-1];
logic [DP_PP_COE_WIDTH-1:0] _dp_temp1 [0:3*4096-1];
    // --------------------------------------------
    // init dotprodct Ping-pong buffer tri_pp
    // --------------------------------------------

    task initialize_dp_tri_pp0_buf0_as_input(string filename);
        fp_r0 = $fopen(filename, "r");
        if (fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
        for (_dp_idx = 0; _dp_idx < 16384; _dp_idx = _dp_idx + 1) begin
            flag = $fscanf(fp_r0, "%h", _dp_temp0[_dp_idx]);
        end

    endtask

    task initialize_dp_tri_pp0_buf1_as_input(string filename);
        fp_r0 = $fopen(filename, "r");
        if (fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
        for (_dp_idx = 0; _dp_idx < 16384; _dp_idx = _dp_idx + 1) begin
            flag = $fscanf(fp_r0, "%h", _dp_temp0[_dp_idx]);
        end

    endtask

    task initialize_dp_tri_pp0_buf2_as_input(string filename);
        fp_r0 = $fopen(filename, "r");
        if (fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
        for (_dp_idx = 0; _dp_idx < 16384; _dp_idx = _dp_idx + 1) begin
            flag = $fscanf(fp_r0, "%h", _dp_temp0[_dp_idx]);
        end

    endtask

// -------------------------------------
// dotproduct Ping-pong buffer check
// -------------------------------------
logic [DP_PP_COE_WIDTH-1:0] _dp_model_data [0:16383];

    // -------------------------------------
    // check dotproduct Ping-pong buffer tri_pp
    // -------------------------------------

    task check_dp_tri_pp0_buf0_as_output(string filename);
        fp_r0 = $fopen(filename, "r");
        if (fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
        for (_dp_idx = 0; _dp_idx < 16384; _dp_idx = _dp_idx + 1) begin
            flag = $fscanf(fp_r0, "%h", _dp_model_data[_dp_idx]);
        end

    endtask

    task check_dp_tri_pp0_buf1_as_output(string filename);
        fp_r0 = $fopen(filename, "r");
        if (fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
        for (_dp_idx = 0; _dp_idx < 16384; _dp_idx = _dp_idx + 1) begin
            flag = $fscanf(fp_r0, "%h", _dp_model_data[_dp_idx]);
        end

    endtask

    task check_dp_tri_pp0_buf2_as_output(string filename);
        fp_r0 = $fopen(filename, "r");
        if (fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
        for (_dp_idx = 0; _dp_idx < 16384; _dp_idx = _dp_idx + 1) begin
            flag = $fscanf(fp_r0, "%h", _dp_model_data[_dp_idx]);
        end

    endtask

// -------------------------------------
// dotproduct ciphertext uram init
// -------------------------------------
int _ct_idx;
int _ct_split_idx;

logic [DP_PP_COE_WIDTH-1:0] _ct_temp [6*4096-1:0];

    task initialize_dp_ctxt_uram(string filename, int n_split);
        fp_r0 = $fopen(filename, "r");
        if (fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end

    endtask

// -------------------------------------
// preprocess Ping-pong buffer init
// -------------------------------------
int _pp_idx;
logic [PP_PP_COE_WIDTH-1:0] _pp_tpp_temp0 [0:6*4096-1];
logic [PP_PP_COE_WIDTH-1:0] _pp_tpp_temp1 [0:6*4096-1];
logic [PP_PP_COE_WIDTH-1:0] _pp_dpp_temp0 [0:4*4096-1];
logic [PP_PP_COE_WIDTH-1:0] _pp_dpp_temp1 [0:4*4096-1];

    // --------------------------------------------
    // init preprocess Ping-pong buffer tpp
    // --------------------------------------------

    task initialize_pp0_tpp_buf0_as_input(string filename);
        fp_r0 = $fopen(filename, "r");
        if (fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
        for (_pp_idx = 0; _pp_idx < 4096; _pp_idx = _pp_idx + 1) begin
            flag = $fscanf(fp_r0, "%h", _pp_tpp_temp0[_pp_idx]);
        end

        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_0.u_ram.genblk1[0].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 0*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_0.u_ram.genblk1[1].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 1*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_0.u_ram.genblk1[2].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 2*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_0.u_ram.genblk1[3].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 3*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_0.u_ram.genblk1[4].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 4*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_0.u_ram.genblk1[5].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 5*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_0.u_ram.genblk1[6].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 6*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_0.u_ram.genblk1[7].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 7*512 + _pp_idx];
        end
    endtask

    task initialize_pp0_tpp_buf1_as_input(string filename);
        fp_r0 = $fopen(filename, "r");
        if (fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
        for (_pp_idx = 0; _pp_idx < 4096; _pp_idx = _pp_idx + 1) begin
            flag = $fscanf(fp_r0, "%h", _pp_tpp_temp0[_pp_idx]);
        end

        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_1.u_ram.genblk1[0].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 0*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_1.u_ram.genblk1[1].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 1*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_1.u_ram.genblk1[2].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 2*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_1.u_ram.genblk1[3].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 3*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_1.u_ram.genblk1[4].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 4*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_1.u_ram.genblk1[5].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 5*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_1.u_ram.genblk1[6].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 6*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_1.u_ram.genblk1[7].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 7*512 + _pp_idx];
        end
    endtask

    task initialize_pp0_tpp_buf2_as_input(string filename);
        fp_r0 = $fopen(filename, "r");
        if (fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
        for (_pp_idx = 0; _pp_idx < 4096; _pp_idx = _pp_idx + 1) begin
            flag = $fscanf(fp_r0, "%h", _pp_tpp_temp0[_pp_idx]);
        end

        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_2.u_ram.genblk1[0].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 0*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_2.u_ram.genblk1[1].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 1*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_2.u_ram.genblk1[2].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 2*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_2.u_ram.genblk1[3].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 3*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_2.u_ram.genblk1[4].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 4*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_2.u_ram.genblk1[5].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 5*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_2.u_ram.genblk1[6].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 6*512 + _pp_idx];
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
        tb_top.tppBank_2.u_ram.genblk1[7].base_bank.mem_bank[_pp_idx]
            = _pp_tpp_temp0[0*4096 + 7*512 + _pp_idx];
        end
    endtask

    // --------------------------------------------
    // init preprocess Ping-pong buffer dpp
    // --------------------------------------------

    task initialize_pp0_dpp_buf0_as_input(string filename);
        fp_r0 = $fopen(filename, "r");
        if (fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
        for (_pp_idx = 0; _pp_idx < 0; _pp_idx = _pp_idx + 1) begin
            flag = $fscanf(fp_r0, "%h", _pp_dpp_temp0[_pp_idx]);
        end

    endtask

    task initialize_pp0_dpp_buf1_as_input(string filename);
        fp_r0 = $fopen(filename, "r");
        if (fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
        for (_pp_idx = 0; _pp_idx < 0; _pp_idx = _pp_idx + 1) begin
            flag = $fscanf(fp_r0, "%h", _pp_dpp_temp0[_pp_idx]);
        end

    endtask

// -------------------------------------
// preprocess Ping-pong buffer check
// -------------------------------------
logic [PP_PP_COE_WIDTH-1:0] _pp_tpp_model_data [0:6*4096-1];
logic [PP_PP_COE_WIDTH-1:0] _pp_dpp_model_data [0:4*4096-1];

    // -------------------------------------
    // check preprocess Ping-pong buffer tpp
    // -------------------------------------
    task check_pp0_tpp_buf0_as_output(string filename);
        fp_r0 = $fopen(filename, "r");
        if (fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
        for (_pp_idx = 0; _pp_idx < 4096; _pp_idx = _pp_idx + 1) begin
            flag = $fscanf(fp_r0, "%h", _pp_tpp_model_data[_pp_idx]);
        end

        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_0.u_ram.genblk1[0].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 0*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_0.u_ram.genblk1[0].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_0.u_ram.genblk1[0].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 0*512 + _pp_idx]
                );
                $display("tb_top.tppBank_0.u_ram.genblk1[0].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_0.u_ram.genblk1[0].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 0*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_0.u_ram.genblk1[1].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 1*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_0.u_ram.genblk1[1].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_0.u_ram.genblk1[1].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 1*512 + _pp_idx]
                );
                $display("tb_top.tppBank_0.u_ram.genblk1[1].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_0.u_ram.genblk1[1].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 1*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_0.u_ram.genblk1[2].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 2*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_0.u_ram.genblk1[2].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_0.u_ram.genblk1[2].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 2*512 + _pp_idx]
                );
                $display("tb_top.tppBank_0.u_ram.genblk1[2].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_0.u_ram.genblk1[2].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 2*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_0.u_ram.genblk1[3].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 3*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_0.u_ram.genblk1[3].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_0.u_ram.genblk1[3].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 3*512 + _pp_idx]
                );
                $display("tb_top.tppBank_0.u_ram.genblk1[3].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_0.u_ram.genblk1[3].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 3*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_0.u_ram.genblk1[4].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 4*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_0.u_ram.genblk1[4].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_0.u_ram.genblk1[4].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 4*512 + _pp_idx]
                );
                $display("tb_top.tppBank_0.u_ram.genblk1[4].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_0.u_ram.genblk1[4].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 4*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_0.u_ram.genblk1[5].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 5*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_0.u_ram.genblk1[5].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_0.u_ram.genblk1[5].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 5*512 + _pp_idx]
                );
                $display("tb_top.tppBank_0.u_ram.genblk1[5].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_0.u_ram.genblk1[5].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 5*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_0.u_ram.genblk1[6].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 6*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_0.u_ram.genblk1[6].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_0.u_ram.genblk1[6].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 6*512 + _pp_idx]
                );
                $display("tb_top.tppBank_0.u_ram.genblk1[6].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_0.u_ram.genblk1[6].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 6*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_0.u_ram.genblk1[7].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 7*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_0.u_ram.genblk1[7].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_0.u_ram.genblk1[7].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 7*512 + _pp_idx]
                );
                $display("tb_top.tppBank_0.u_ram.genblk1[7].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_0.u_ram.genblk1[7].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 7*512 + _pp_idx]
                );
                $finish;
            end
        end
    endtask

    task check_pp0_tpp_buf1_as_output(string filename);
        fp_r0 = $fopen(filename, "r");
        if (fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
        for (_pp_idx = 0; _pp_idx < 4096; _pp_idx = _pp_idx + 1) begin
            flag = $fscanf(fp_r0, "%h", _pp_tpp_model_data[_pp_idx]);
        end

        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_1.u_ram.genblk1[0].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 0*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_1.u_ram.genblk1[0].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_1.u_ram.genblk1[0].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 0*512 + _pp_idx]
                );
                $display("tb_top.tppBank_1.u_ram.genblk1[0].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_1.u_ram.genblk1[0].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 0*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_1.u_ram.genblk1[1].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 1*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_1.u_ram.genblk1[1].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_1.u_ram.genblk1[1].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 1*512 + _pp_idx]
                );
                $display("tb_top.tppBank_1.u_ram.genblk1[1].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_1.u_ram.genblk1[1].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 1*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_1.u_ram.genblk1[2].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 2*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_1.u_ram.genblk1[2].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_1.u_ram.genblk1[2].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 2*512 + _pp_idx]
                );
                $display("tb_top.tppBank_1.u_ram.genblk1[2].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_1.u_ram.genblk1[2].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 2*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_1.u_ram.genblk1[3].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 3*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_1.u_ram.genblk1[3].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_1.u_ram.genblk1[3].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 3*512 + _pp_idx]
                );
                $display("tb_top.tppBank_1.u_ram.genblk1[3].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_1.u_ram.genblk1[3].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 3*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_1.u_ram.genblk1[4].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 4*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_1.u_ram.genblk1[4].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_1.u_ram.genblk1[4].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 4*512 + _pp_idx]
                );
                $display("tb_top.tppBank_1.u_ram.genblk1[4].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_1.u_ram.genblk1[4].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 4*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_1.u_ram.genblk1[5].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 5*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_1.u_ram.genblk1[5].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_1.u_ram.genblk1[5].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 5*512 + _pp_idx]
                );
                $display("tb_top.tppBank_1.u_ram.genblk1[5].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_1.u_ram.genblk1[5].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 5*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_1.u_ram.genblk1[6].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 6*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_1.u_ram.genblk1[6].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_1.u_ram.genblk1[6].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 6*512 + _pp_idx]
                );
                $display("tb_top.tppBank_1.u_ram.genblk1[6].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_1.u_ram.genblk1[6].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 6*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_1.u_ram.genblk1[7].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 7*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_1.u_ram.genblk1[7].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_1.u_ram.genblk1[7].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 7*512 + _pp_idx]
                );
                $display("tb_top.tppBank_1.u_ram.genblk1[7].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_1.u_ram.genblk1[7].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 7*512 + _pp_idx]
                );
                $finish;
            end
        end
    endtask

    task check_pp0_tpp_buf2_as_output(string filename);
        fp_r0 = $fopen(filename, "r");
        if (fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
        for (_pp_idx = 0; _pp_idx < 4096; _pp_idx = _pp_idx + 1) begin
            flag = $fscanf(fp_r0, "%h", _pp_tpp_model_data[_pp_idx]);
        end

        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_2.u_ram.genblk1[0].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 0*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_2.u_ram.genblk1[0].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_2.u_ram.genblk1[0].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 0*512 + _pp_idx]
                );
                $display("tb_top.tppBank_2.u_ram.genblk1[0].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_2.u_ram.genblk1[0].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 0*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_2.u_ram.genblk1[1].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 1*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_2.u_ram.genblk1[1].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_2.u_ram.genblk1[1].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 1*512 + _pp_idx]
                );
                $display("tb_top.tppBank_2.u_ram.genblk1[1].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_2.u_ram.genblk1[1].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 1*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_2.u_ram.genblk1[2].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 2*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_2.u_ram.genblk1[2].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_2.u_ram.genblk1[2].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 2*512 + _pp_idx]
                );
                $display("tb_top.tppBank_2.u_ram.genblk1[2].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_2.u_ram.genblk1[2].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 2*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_2.u_ram.genblk1[3].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 3*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_2.u_ram.genblk1[3].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_2.u_ram.genblk1[3].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 3*512 + _pp_idx]
                );
                $display("tb_top.tppBank_2.u_ram.genblk1[3].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_2.u_ram.genblk1[3].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 3*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_2.u_ram.genblk1[4].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 4*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_2.u_ram.genblk1[4].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_2.u_ram.genblk1[4].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 4*512 + _pp_idx]
                );
                $display("tb_top.tppBank_2.u_ram.genblk1[4].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_2.u_ram.genblk1[4].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 4*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_2.u_ram.genblk1[5].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 5*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_2.u_ram.genblk1[5].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_2.u_ram.genblk1[5].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 5*512 + _pp_idx]
                );
                $display("tb_top.tppBank_2.u_ram.genblk1[5].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_2.u_ram.genblk1[5].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 5*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_2.u_ram.genblk1[6].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 6*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_2.u_ram.genblk1[6].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_2.u_ram.genblk1[6].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 6*512 + _pp_idx]
                );
                $display("tb_top.tppBank_2.u_ram.genblk1[6].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_2.u_ram.genblk1[6].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 6*512 + _pp_idx]
                );
                $finish;
            end
        end
        for (_pp_idx = 0; _pp_idx < 512; _pp_idx = _pp_idx + 1) begin
            if (tb_top.tppBank_2.u_ram.genblk1[7].base_bank.mem_bank[_pp_idx] ===
                _pp_tpp_model_data[0*4096 + 7*512 + _pp_idx]) begin
            end
            else begin
                $display("tb_top.tppBank_2.u_ram.genblk1[7].base_bank.mem_bank[%d] out value %d wrong! Correct value should be %d !\n",
                         _pp_idx,
                         tb_top.tppBank_2.u_ram.genblk1[7].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 7*512 + _pp_idx]
                );
                $display("tb_top.tppBank_2.u_ram.genblk1[7].base_bank.mem_bank[%d] out value %h wrong! Correct value should be %h !\n",
                         _pp_idx,
                         tb_top.tppBank_2.u_ram.genblk1[7].base_bank.mem_bank[_pp_idx],
                         _pp_tpp_model_data[0*4096 + 7*512 + _pp_idx]
                );
                $finish;
            end
        end
    endtask

    // -------------------------------------
    // check preprocess Ping-pong buffer dpp
    // -------------------------------------
    task check_pp0_dpp_buf0_as_output(string filename);
        fp_r0 = $fopen(filename, "r");
        if (fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
        for (_pp_idx = 0; _pp_idx < 0; _pp_idx = _pp_idx + 1) begin
            flag = $fscanf(fp_r0, "%h", _pp_dpp_model_data[_pp_idx]);
        end

    endtask

    task check_pp0_dpp_buf1_as_output(string filename);
        fp_r0 = $fopen(filename, "r");
        if (fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
        for (_pp_idx = 0; _pp_idx < 0; _pp_idx = _pp_idx + 1) begin
            flag = $fscanf(fp_r0, "%h", _pp_dpp_model_data[_pp_idx]);
        end

    endtask

// ----------------------------------------
// reduce_trace buffer initialize and check
// ----------------------------------------
logic [COE_WIDTH-1:0] temp2;

    // -------------------------------------
    // reduce_trace Ping-pong buffer 1
    // -------------------------------------
    task initialize_rt_pp1_buf0_as_input(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask

    task initialize_rt_pp1_buf0_as_output(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask



    task initialize_rt_pp1_buf1_as_input(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask

    task initialize_rt_pp1_buf1_as_output(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask



    task initialize_rt_pp1_buf2_as_input(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask

    task initialize_rt_pp1_buf2_as_output(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask



    // -------------------------------------
    // reduce_trace Ping-pong buffer 2
    // -------------------------------------
    task initialize_rt_pp2_buf0_as_input(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask

    task initialize_rt_pp2_buf0_as_output(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask



    task initialize_rt_pp2_buf1_as_input(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask

    task initialize_rt_pp2_buf1_as_output(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask



    task initialize_rt_pp2_buf2_as_input(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask

    task initialize_rt_pp2_buf2_as_output(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask



    // -------------------------------------
    // reduce_trace Ping-pong buffer 3
    // -------------------------------------
    task initialize_rt_pp3_buf0_as_input(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask

    task initialize_rt_pp3_buf0_as_output(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask



    task initialize_rt_pp3_buf1_as_input(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask

    task initialize_rt_pp3_buf1_as_output(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask



    task initialize_rt_pp3_buf2_as_input(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask

    task initialize_rt_pp3_buf2_as_output(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask



    task initialize_rt_pp3_buf3_as_input(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask

    task initialize_rt_pp3_buf3_as_output(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask



    task initialize_rt_pp3_buf4_as_input(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask

    task initialize_rt_pp3_buf4_as_output(string filename);
        fd = $fopen(filename, "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end
    endtask



    // -------------------------------------
    // Reduce buffer init for stage 8 test
    // -------------------------------------
    logic [RB_PP_COE_WIDTH-1:0] _rb_temp;
    task initialize_reduce_buffer(string filename);
        fp_r0 = $fopen(filename, "r");
        if(fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end


    endtask
    // -------------------------------------
    // Reduce buffer check
    // -------------------------------------
    task check_reduce_buffer(string filename);
        fp_r0 = $fopen(filename, "r");
        if(fp_r0 == 0) begin
            $display("ERROR!!! Cannot find file %s \n", filename);
            $finish;
        end


    endtask
    // -------------------------------------
    // KSK URAM check
    // -------------------------------------
    task check_ksk_uram;
        fd = $fopen("uram_k0.mem", "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file uram_k0.mem ! \n");
            $finish;
        end
        fd = $fopen("uram_k1.mem", "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file uram_k1.mem ! \n");
            $finish;
        end
        fd = $fopen("uram_k2.mem", "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file uram_k2.mem ! \n");
            $finish;
        end
        fd = $fopen("uram_k3.mem", "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file uram_k3.mem ! \n");
            $finish;
        end
        fd = $fopen("uram_k4.mem", "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file uram_k4.mem ! \n");
            $finish;
        end
        fd = $fopen("uram_k5.mem", "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file uram_k5.mem ! \n");
            $finish;
        end
        fd = $fopen("uram_k6.mem", "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file uram_k6.mem ! \n");
            $finish;
        end
        fd = $fopen("uram_k7.mem", "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file uram_k7.mem ! \n");
            $finish;
        end
        fd = $fopen("uram_k8.mem", "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file uram_k8.mem ! \n");
            $finish;
        end
        fd = $fopen("uram_k9.mem", "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file uram_k9.mem ! \n");
            $finish;
        end
        fd = $fopen("uram_k10.mem", "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file uram_k10.mem ! \n");
            $finish;
        end
        fd = $fopen("uram_k11.mem", "r");
        if(fd == 0) begin
            $display("ERROR!!! Cannot find file uram_k11.mem ! \n");
            $finish;
        end
    endtask



