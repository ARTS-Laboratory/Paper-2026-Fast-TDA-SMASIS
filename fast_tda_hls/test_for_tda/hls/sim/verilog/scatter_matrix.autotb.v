// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2024.1 (64-bit)
// Tool Version Limit: 2024.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
 `timescale 1ns/1ps


`define AUTOTB_DUT      scatter_matrix
`define AUTOTB_DUT_INST AESL_inst_scatter_matrix
`define AUTOTB_TOP      apatb_scatter_matrix_top
`define AUTOTB_LAT_RESULT_FILE "scatter_matrix.result.lat.rb"
`define AUTOTB_PER_RESULT_TRANS_FILE "scatter_matrix.performance.result.transaction.xml"
`define AUTOTB_TOP_INST AESL_inst_apatb_scatter_matrix_top
`define AUTOTB_MAX_ALLOW_LATENCY  15000000
`define AUTOTB_CLOCK_PERIOD_DIV2 2.50

`define AESL_DEPTH_accel 1
`define AESL_DEPTH_S_tilde_0 1
`define AESL_DEPTH_S_tilde_1 1
`define AESL_DEPTH_S_tilde_2 1
`define AESL_DEPTH_S_tilde_3 1
`define AESL_DEPTH_S_tilde_4 1
`define AESL_DEPTH_S_tilde_5 1
`define AESL_DEPTH_S_tilde_6 1
`define AESL_DEPTH_S_tilde_7 1
`define AESL_DEPTH_S_tilde_8 1
`define AUTOTB_TVIN_accel  "../tv/cdatafile/c.scatter_matrix.autotvin_accel.dat"
`define AUTOTB_TVIN_accel_out_wrapc  "../tv/rtldatafile/rtl.scatter_matrix.autotvin_accel.dat"
`define AUTOTB_TVOUT_S_tilde_0  "../tv/cdatafile/c.scatter_matrix.autotvout_S_tilde_0.dat"
`define AUTOTB_TVOUT_S_tilde_1  "../tv/cdatafile/c.scatter_matrix.autotvout_S_tilde_1.dat"
`define AUTOTB_TVOUT_S_tilde_2  "../tv/cdatafile/c.scatter_matrix.autotvout_S_tilde_2.dat"
`define AUTOTB_TVOUT_S_tilde_3  "../tv/cdatafile/c.scatter_matrix.autotvout_S_tilde_3.dat"
`define AUTOTB_TVOUT_S_tilde_4  "../tv/cdatafile/c.scatter_matrix.autotvout_S_tilde_4.dat"
`define AUTOTB_TVOUT_S_tilde_5  "../tv/cdatafile/c.scatter_matrix.autotvout_S_tilde_5.dat"
`define AUTOTB_TVOUT_S_tilde_6  "../tv/cdatafile/c.scatter_matrix.autotvout_S_tilde_6.dat"
`define AUTOTB_TVOUT_S_tilde_7  "../tv/cdatafile/c.scatter_matrix.autotvout_S_tilde_7.dat"
`define AUTOTB_TVOUT_S_tilde_8  "../tv/cdatafile/c.scatter_matrix.autotvout_S_tilde_8.dat"
`define AUTOTB_TVOUT_S_tilde_0_out_wrapc  "../tv/rtldatafile/rtl.scatter_matrix.autotvout_S_tilde_0.dat"
`define AUTOTB_TVOUT_S_tilde_1_out_wrapc  "../tv/rtldatafile/rtl.scatter_matrix.autotvout_S_tilde_1.dat"
`define AUTOTB_TVOUT_S_tilde_2_out_wrapc  "../tv/rtldatafile/rtl.scatter_matrix.autotvout_S_tilde_2.dat"
`define AUTOTB_TVOUT_S_tilde_3_out_wrapc  "../tv/rtldatafile/rtl.scatter_matrix.autotvout_S_tilde_3.dat"
`define AUTOTB_TVOUT_S_tilde_4_out_wrapc  "../tv/rtldatafile/rtl.scatter_matrix.autotvout_S_tilde_4.dat"
`define AUTOTB_TVOUT_S_tilde_5_out_wrapc  "../tv/rtldatafile/rtl.scatter_matrix.autotvout_S_tilde_5.dat"
`define AUTOTB_TVOUT_S_tilde_6_out_wrapc  "../tv/rtldatafile/rtl.scatter_matrix.autotvout_S_tilde_6.dat"
`define AUTOTB_TVOUT_S_tilde_7_out_wrapc  "../tv/rtldatafile/rtl.scatter_matrix.autotvout_S_tilde_7.dat"
`define AUTOTB_TVOUT_S_tilde_8_out_wrapc  "../tv/rtldatafile/rtl.scatter_matrix.autotvout_S_tilde_8.dat"
module `AUTOTB_TOP;

parameter AUTOTB_TRANSACTION_NUM = 80000;
parameter PROGRESS_TIMEOUT = 10000000;
parameter LATENCY_ESTIMATION = 870;
parameter LENGTH_S_tilde_0 = 1;
parameter LENGTH_S_tilde_1 = 1;
parameter LENGTH_S_tilde_2 = 1;
parameter LENGTH_S_tilde_3 = 1;
parameter LENGTH_S_tilde_4 = 1;
parameter LENGTH_S_tilde_5 = 1;
parameter LENGTH_S_tilde_6 = 1;
parameter LENGTH_S_tilde_7 = 1;
parameter LENGTH_S_tilde_8 = 1;
parameter LENGTH_accel = 1;

task read_token;
    input integer fp;
    output reg [191 : 0] token;
    integer ret;
    begin
        token = "";
        ret = 0;
        ret = $fscanf(fp,"%s",token);
    end
endtask

reg AESL_clock;
reg rst;
reg dut_rst;
reg start;
reg ce;
reg tb_continue;
wire AESL_start;
wire AESL_reset;
wire AESL_ce;
wire AESL_ready;
wire AESL_idle;
wire AESL_continue;
wire AESL_done;
reg AESL_done_delay = 0;
reg AESL_done_delay2 = 0;
reg AESL_ready_delay = 0;
wire ready;
wire ready_wire;
wire [3 : 0] control_AWADDR;
wire  control_AWVALID;
wire  control_AWREADY;
wire  control_WVALID;
wire  control_WREADY;
wire [31 : 0] control_WDATA;
wire [3 : 0] control_WSTRB;
wire [3 : 0] control_ARADDR;
wire  control_ARVALID;
wire  control_ARREADY;
wire  control_RVALID;
wire  control_RREADY;
wire [31 : 0] control_RDATA;
wire [1 : 0] control_RRESP;
wire  control_BVALID;
wire  control_BREADY;
wire [1 : 0] control_BRESP;
wire  control_INTERRUPT;
wire [15 : 0] accel_TDATA;
wire  accel_TVALID;
wire  accel_TREADY;
wire [31 : 0] S_tilde_0;
wire  S_tilde_0_ap_vld;
wire [31 : 0] S_tilde_1;
wire  S_tilde_1_ap_vld;
wire [31 : 0] S_tilde_2;
wire  S_tilde_2_ap_vld;
wire [31 : 0] S_tilde_3;
wire  S_tilde_3_ap_vld;
wire [31 : 0] S_tilde_4;
wire  S_tilde_4_ap_vld;
wire [31 : 0] S_tilde_5;
wire  S_tilde_5_ap_vld;
wire [31 : 0] S_tilde_6;
wire  S_tilde_6_ap_vld;
wire [31 : 0] S_tilde_7;
wire  S_tilde_7_ap_vld;
wire [31 : 0] S_tilde_8;
wire  S_tilde_8_ap_vld;
integer done_cnt = 0;
integer AESL_ready_cnt = 0;
integer ready_cnt = 0;
reg ready_initial;
reg ready_initial_n;
reg ready_last_n;
reg ready_delay_last_n;
reg done_delay_last_n;
reg interface_done = 0;
wire AESL_slave_start;
reg AESL_slave_start_lock = 0;
wire AESL_slave_write_start_in;
wire AESL_slave_write_start_finish;
reg AESL_slave_ready;
wire AESL_slave_output_done;
wire AESL_slave_done;
reg ready_rise = 0;
reg start_rise = 0;
reg slave_start_status = 0;
reg slave_done_status = 0;
reg ap_done_lock = 0;


wire ap_clk;
wire ap_rst_n;
wire ap_rst_n_n;

`AUTOTB_DUT `AUTOTB_DUT_INST(
    .s_axi_control_AWADDR(control_AWADDR),
    .s_axi_control_AWVALID(control_AWVALID),
    .s_axi_control_AWREADY(control_AWREADY),
    .s_axi_control_WVALID(control_WVALID),
    .s_axi_control_WREADY(control_WREADY),
    .s_axi_control_WDATA(control_WDATA),
    .s_axi_control_WSTRB(control_WSTRB),
    .s_axi_control_ARADDR(control_ARADDR),
    .s_axi_control_ARVALID(control_ARVALID),
    .s_axi_control_ARREADY(control_ARREADY),
    .s_axi_control_RVALID(control_RVALID),
    .s_axi_control_RREADY(control_RREADY),
    .s_axi_control_RDATA(control_RDATA),
    .s_axi_control_RRESP(control_RRESP),
    .s_axi_control_BVALID(control_BVALID),
    .s_axi_control_BREADY(control_BREADY),
    .s_axi_control_BRESP(control_BRESP),
    .interrupt(control_INTERRUPT),
    .ap_clk(ap_clk),
    .ap_rst_n(ap_rst_n),
    .accel_TDATA(accel_TDATA),
    .accel_TVALID(accel_TVALID),
    .accel_TREADY(accel_TREADY),
    .S_tilde_0(S_tilde_0),
    .S_tilde_0_ap_vld(S_tilde_0_ap_vld),
    .S_tilde_1(S_tilde_1),
    .S_tilde_1_ap_vld(S_tilde_1_ap_vld),
    .S_tilde_2(S_tilde_2),
    .S_tilde_2_ap_vld(S_tilde_2_ap_vld),
    .S_tilde_3(S_tilde_3),
    .S_tilde_3_ap_vld(S_tilde_3_ap_vld),
    .S_tilde_4(S_tilde_4),
    .S_tilde_4_ap_vld(S_tilde_4_ap_vld),
    .S_tilde_5(S_tilde_5),
    .S_tilde_5_ap_vld(S_tilde_5_ap_vld),
    .S_tilde_6(S_tilde_6),
    .S_tilde_6_ap_vld(S_tilde_6_ap_vld),
    .S_tilde_7(S_tilde_7),
    .S_tilde_7_ap_vld(S_tilde_7_ap_vld),
    .S_tilde_8(S_tilde_8),
    .S_tilde_8_ap_vld(S_tilde_8_ap_vld));

// Assignment for control signal
assign ap_clk = AESL_clock;
assign ap_rst_n = dut_rst;
assign ap_rst_n_n = ~dut_rst;
assign AESL_reset = rst;
assign AESL_start = start;
assign AESL_ce = ce;
assign AESL_continue = tb_continue;
  assign AESL_slave_write_start_in = slave_start_status ;
  assign AESL_slave_start = AESL_slave_write_start_finish;
  assign AESL_done = slave_done_status ;

always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
    begin
        slave_start_status <= 1;
    end
    else begin
        if (AESL_start == 1 ) begin
            start_rise = 1;
        end
        if (start_rise == 1 && AESL_done == 1 ) begin
            slave_start_status <= 1;
        end
        if (AESL_slave_write_start_in == 1 && AESL_done == 0) begin 
            slave_start_status <= 0;
            start_rise = 0;
        end
    end
end

always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
    begin
        AESL_slave_ready <= 0;
        ready_rise = 0;
    end
    else begin
        if (AESL_ready == 1 ) begin
            ready_rise = 1;
        end
        if (ready_rise == 1 && AESL_done_delay == 1 ) begin
            AESL_slave_ready <= 1;
        end
        if (AESL_slave_ready == 1) begin 
            AESL_slave_ready <= 0;
            ready_rise = 0;
        end
    end
end

always @ (posedge AESL_clock)
begin
    if (AESL_done == 1) begin
        slave_done_status <= 0;
    end
    else if (AESL_slave_output_done == 1 ) begin
        slave_done_status <= 1;
    end
end

reg AESL_REG_S_tilde_0_ap_vld = 0;
// The signal of port S_tilde_0
reg [31: 0] AESL_REG_S_tilde_0 = 0;
always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
        AESL_REG_S_tilde_0 = 0; 
    else if(S_tilde_0_ap_vld) begin
        AESL_REG_S_tilde_0 <= S_tilde_0;
        AESL_REG_S_tilde_0_ap_vld <= 1;
    end
end 

initial begin : write_file_process_S_tilde_0
    integer fp;
    integer fp_size;
    integer err;
    integer ret;
    integer i;
    integer hls_stream_size;
    integer proc_rand;
    integer S_tilde_0_count;
    reg [191:0] token;
    integer transaction_idx;
    reg [8 * 5:1] str;
    wait(AESL_reset === 1);
    fp = $fopen(`AUTOTB_TVOUT_S_tilde_0_out_wrapc,"w");
    if(fp == 0) begin       // Failed to open file
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_S_tilde_0_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    transaction_idx = 0;
    while (transaction_idx != AUTOTB_TRANSACTION_NUM) begin
        @(posedge AESL_clock);
          while(AESL_done !== 1) begin
              @(posedge AESL_clock);
          end
        # 0.4;
        $fdisplay(fp,"[[transaction]] %d", transaction_idx);
        if(AESL_REG_S_tilde_0_ap_vld)  begin
          $fdisplay(fp,"0x%x", AESL_REG_S_tilde_0);
        AESL_REG_S_tilde_0_ap_vld = 0;
        end
    transaction_idx = transaction_idx + 1;
      $fdisplay(fp,"[[/transaction]]");
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
end


reg AESL_REG_S_tilde_1_ap_vld = 0;
// The signal of port S_tilde_1
reg [31: 0] AESL_REG_S_tilde_1 = 0;
always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
        AESL_REG_S_tilde_1 = 0; 
    else if(S_tilde_1_ap_vld) begin
        AESL_REG_S_tilde_1 <= S_tilde_1;
        AESL_REG_S_tilde_1_ap_vld <= 1;
    end
end 

initial begin : write_file_process_S_tilde_1
    integer fp;
    integer fp_size;
    integer err;
    integer ret;
    integer i;
    integer hls_stream_size;
    integer proc_rand;
    integer S_tilde_1_count;
    reg [191:0] token;
    integer transaction_idx;
    reg [8 * 5:1] str;
    wait(AESL_reset === 1);
    fp = $fopen(`AUTOTB_TVOUT_S_tilde_1_out_wrapc,"w");
    if(fp == 0) begin       // Failed to open file
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_S_tilde_1_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    transaction_idx = 0;
    while (transaction_idx != AUTOTB_TRANSACTION_NUM) begin
        @(posedge AESL_clock);
          while(AESL_done !== 1) begin
              @(posedge AESL_clock);
          end
        # 0.4;
        $fdisplay(fp,"[[transaction]] %d", transaction_idx);
        if(AESL_REG_S_tilde_1_ap_vld)  begin
          $fdisplay(fp,"0x%x", AESL_REG_S_tilde_1);
        AESL_REG_S_tilde_1_ap_vld = 0;
        end
    transaction_idx = transaction_idx + 1;
      $fdisplay(fp,"[[/transaction]]");
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
end


reg AESL_REG_S_tilde_2_ap_vld = 0;
// The signal of port S_tilde_2
reg [31: 0] AESL_REG_S_tilde_2 = 0;
always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
        AESL_REG_S_tilde_2 = 0; 
    else if(S_tilde_2_ap_vld) begin
        AESL_REG_S_tilde_2 <= S_tilde_2;
        AESL_REG_S_tilde_2_ap_vld <= 1;
    end
end 

initial begin : write_file_process_S_tilde_2
    integer fp;
    integer fp_size;
    integer err;
    integer ret;
    integer i;
    integer hls_stream_size;
    integer proc_rand;
    integer S_tilde_2_count;
    reg [191:0] token;
    integer transaction_idx;
    reg [8 * 5:1] str;
    wait(AESL_reset === 1);
    fp = $fopen(`AUTOTB_TVOUT_S_tilde_2_out_wrapc,"w");
    if(fp == 0) begin       // Failed to open file
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_S_tilde_2_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    transaction_idx = 0;
    while (transaction_idx != AUTOTB_TRANSACTION_NUM) begin
        @(posedge AESL_clock);
          while(AESL_done !== 1) begin
              @(posedge AESL_clock);
          end
        # 0.4;
        $fdisplay(fp,"[[transaction]] %d", transaction_idx);
        if(AESL_REG_S_tilde_2_ap_vld)  begin
          $fdisplay(fp,"0x%x", AESL_REG_S_tilde_2);
        AESL_REG_S_tilde_2_ap_vld = 0;
        end
    transaction_idx = transaction_idx + 1;
      $fdisplay(fp,"[[/transaction]]");
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
end


reg AESL_REG_S_tilde_3_ap_vld = 0;
// The signal of port S_tilde_3
reg [31: 0] AESL_REG_S_tilde_3 = 0;
always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
        AESL_REG_S_tilde_3 = 0; 
    else if(S_tilde_3_ap_vld) begin
        AESL_REG_S_tilde_3 <= S_tilde_3;
        AESL_REG_S_tilde_3_ap_vld <= 1;
    end
end 

initial begin : write_file_process_S_tilde_3
    integer fp;
    integer fp_size;
    integer err;
    integer ret;
    integer i;
    integer hls_stream_size;
    integer proc_rand;
    integer S_tilde_3_count;
    reg [191:0] token;
    integer transaction_idx;
    reg [8 * 5:1] str;
    wait(AESL_reset === 1);
    fp = $fopen(`AUTOTB_TVOUT_S_tilde_3_out_wrapc,"w");
    if(fp == 0) begin       // Failed to open file
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_S_tilde_3_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    transaction_idx = 0;
    while (transaction_idx != AUTOTB_TRANSACTION_NUM) begin
        @(posedge AESL_clock);
          while(AESL_done !== 1) begin
              @(posedge AESL_clock);
          end
        # 0.4;
        $fdisplay(fp,"[[transaction]] %d", transaction_idx);
        if(AESL_REG_S_tilde_3_ap_vld)  begin
          $fdisplay(fp,"0x%x", AESL_REG_S_tilde_3);
        AESL_REG_S_tilde_3_ap_vld = 0;
        end
    transaction_idx = transaction_idx + 1;
      $fdisplay(fp,"[[/transaction]]");
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
end


reg AESL_REG_S_tilde_4_ap_vld = 0;
// The signal of port S_tilde_4
reg [31: 0] AESL_REG_S_tilde_4 = 0;
always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
        AESL_REG_S_tilde_4 = 0; 
    else if(S_tilde_4_ap_vld) begin
        AESL_REG_S_tilde_4 <= S_tilde_4;
        AESL_REG_S_tilde_4_ap_vld <= 1;
    end
end 

initial begin : write_file_process_S_tilde_4
    integer fp;
    integer fp_size;
    integer err;
    integer ret;
    integer i;
    integer hls_stream_size;
    integer proc_rand;
    integer S_tilde_4_count;
    reg [191:0] token;
    integer transaction_idx;
    reg [8 * 5:1] str;
    wait(AESL_reset === 1);
    fp = $fopen(`AUTOTB_TVOUT_S_tilde_4_out_wrapc,"w");
    if(fp == 0) begin       // Failed to open file
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_S_tilde_4_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    transaction_idx = 0;
    while (transaction_idx != AUTOTB_TRANSACTION_NUM) begin
        @(posedge AESL_clock);
          while(AESL_done !== 1) begin
              @(posedge AESL_clock);
          end
        # 0.4;
        $fdisplay(fp,"[[transaction]] %d", transaction_idx);
        if(AESL_REG_S_tilde_4_ap_vld)  begin
          $fdisplay(fp,"0x%x", AESL_REG_S_tilde_4);
        AESL_REG_S_tilde_4_ap_vld = 0;
        end
    transaction_idx = transaction_idx + 1;
      $fdisplay(fp,"[[/transaction]]");
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
end


reg AESL_REG_S_tilde_5_ap_vld = 0;
// The signal of port S_tilde_5
reg [31: 0] AESL_REG_S_tilde_5 = 0;
always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
        AESL_REG_S_tilde_5 = 0; 
    else if(S_tilde_5_ap_vld) begin
        AESL_REG_S_tilde_5 <= S_tilde_5;
        AESL_REG_S_tilde_5_ap_vld <= 1;
    end
end 

initial begin : write_file_process_S_tilde_5
    integer fp;
    integer fp_size;
    integer err;
    integer ret;
    integer i;
    integer hls_stream_size;
    integer proc_rand;
    integer S_tilde_5_count;
    reg [191:0] token;
    integer transaction_idx;
    reg [8 * 5:1] str;
    wait(AESL_reset === 1);
    fp = $fopen(`AUTOTB_TVOUT_S_tilde_5_out_wrapc,"w");
    if(fp == 0) begin       // Failed to open file
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_S_tilde_5_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    transaction_idx = 0;
    while (transaction_idx != AUTOTB_TRANSACTION_NUM) begin
        @(posedge AESL_clock);
          while(AESL_done !== 1) begin
              @(posedge AESL_clock);
          end
        # 0.4;
        $fdisplay(fp,"[[transaction]] %d", transaction_idx);
        if(AESL_REG_S_tilde_5_ap_vld)  begin
          $fdisplay(fp,"0x%x", AESL_REG_S_tilde_5);
        AESL_REG_S_tilde_5_ap_vld = 0;
        end
    transaction_idx = transaction_idx + 1;
      $fdisplay(fp,"[[/transaction]]");
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
end


reg AESL_REG_S_tilde_6_ap_vld = 0;
// The signal of port S_tilde_6
reg [31: 0] AESL_REG_S_tilde_6 = 0;
always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
        AESL_REG_S_tilde_6 = 0; 
    else if(S_tilde_6_ap_vld) begin
        AESL_REG_S_tilde_6 <= S_tilde_6;
        AESL_REG_S_tilde_6_ap_vld <= 1;
    end
end 

initial begin : write_file_process_S_tilde_6
    integer fp;
    integer fp_size;
    integer err;
    integer ret;
    integer i;
    integer hls_stream_size;
    integer proc_rand;
    integer S_tilde_6_count;
    reg [191:0] token;
    integer transaction_idx;
    reg [8 * 5:1] str;
    wait(AESL_reset === 1);
    fp = $fopen(`AUTOTB_TVOUT_S_tilde_6_out_wrapc,"w");
    if(fp == 0) begin       // Failed to open file
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_S_tilde_6_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    transaction_idx = 0;
    while (transaction_idx != AUTOTB_TRANSACTION_NUM) begin
        @(posedge AESL_clock);
          while(AESL_done !== 1) begin
              @(posedge AESL_clock);
          end
        # 0.4;
        $fdisplay(fp,"[[transaction]] %d", transaction_idx);
        if(AESL_REG_S_tilde_6_ap_vld)  begin
          $fdisplay(fp,"0x%x", AESL_REG_S_tilde_6);
        AESL_REG_S_tilde_6_ap_vld = 0;
        end
    transaction_idx = transaction_idx + 1;
      $fdisplay(fp,"[[/transaction]]");
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
end


reg AESL_REG_S_tilde_7_ap_vld = 0;
// The signal of port S_tilde_7
reg [31: 0] AESL_REG_S_tilde_7 = 0;
always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
        AESL_REG_S_tilde_7 = 0; 
    else if(S_tilde_7_ap_vld) begin
        AESL_REG_S_tilde_7 <= S_tilde_7;
        AESL_REG_S_tilde_7_ap_vld <= 1;
    end
end 

initial begin : write_file_process_S_tilde_7
    integer fp;
    integer fp_size;
    integer err;
    integer ret;
    integer i;
    integer hls_stream_size;
    integer proc_rand;
    integer S_tilde_7_count;
    reg [191:0] token;
    integer transaction_idx;
    reg [8 * 5:1] str;
    wait(AESL_reset === 1);
    fp = $fopen(`AUTOTB_TVOUT_S_tilde_7_out_wrapc,"w");
    if(fp == 0) begin       // Failed to open file
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_S_tilde_7_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    transaction_idx = 0;
    while (transaction_idx != AUTOTB_TRANSACTION_NUM) begin
        @(posedge AESL_clock);
          while(AESL_done !== 1) begin
              @(posedge AESL_clock);
          end
        # 0.4;
        $fdisplay(fp,"[[transaction]] %d", transaction_idx);
        if(AESL_REG_S_tilde_7_ap_vld)  begin
          $fdisplay(fp,"0x%x", AESL_REG_S_tilde_7);
        AESL_REG_S_tilde_7_ap_vld = 0;
        end
    transaction_idx = transaction_idx + 1;
      $fdisplay(fp,"[[/transaction]]");
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
end


reg AESL_REG_S_tilde_8_ap_vld = 0;
// The signal of port S_tilde_8
reg [31: 0] AESL_REG_S_tilde_8 = 0;
always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
        AESL_REG_S_tilde_8 = 0; 
    else if(S_tilde_8_ap_vld) begin
        AESL_REG_S_tilde_8 <= S_tilde_8;
        AESL_REG_S_tilde_8_ap_vld <= 1;
    end
end 

initial begin : write_file_process_S_tilde_8
    integer fp;
    integer fp_size;
    integer err;
    integer ret;
    integer i;
    integer hls_stream_size;
    integer proc_rand;
    integer S_tilde_8_count;
    reg [191:0] token;
    integer transaction_idx;
    reg [8 * 5:1] str;
    wait(AESL_reset === 1);
    fp = $fopen(`AUTOTB_TVOUT_S_tilde_8_out_wrapc,"w");
    if(fp == 0) begin       // Failed to open file
        $display("Failed to open file \"%s\"!", `AUTOTB_TVOUT_S_tilde_8_out_wrapc);
        $display("ERROR: Simulation using HLS TB failed.");
        $finish;
    end
    $fdisplay(fp,"[[[runtime]]]");
    transaction_idx = 0;
    while (transaction_idx != AUTOTB_TRANSACTION_NUM) begin
        @(posedge AESL_clock);
          while(AESL_done !== 1) begin
              @(posedge AESL_clock);
          end
        # 0.4;
        $fdisplay(fp,"[[transaction]] %d", transaction_idx);
        if(AESL_REG_S_tilde_8_ap_vld)  begin
          $fdisplay(fp,"0x%x", AESL_REG_S_tilde_8);
        AESL_REG_S_tilde_8_ap_vld = 0;
        end
    transaction_idx = transaction_idx + 1;
      $fdisplay(fp,"[[/transaction]]");
    end
    $fdisplay(fp,"[[[/runtime]]]");
    $fclose(fp);
end


reg [31:0] ap_c_n_tvin_trans_num_accel;

reg accel_ready_reg; // for self-sync

wire accel_ready;
wire accel_done;
wire [31:0] accel_transaction;
wire axi_s_accel_TVALID;
wire axi_s_accel_TREADY;

AESL_axi_s_accel AESL_AXI_S_accel(
    .clk(AESL_clock),
    .reset(AESL_reset),
    .TRAN_accel_TDATA(accel_TDATA),
    .TRAN_accel_TVALID(axi_s_accel_TVALID),
    .TRAN_accel_TREADY(axi_s_accel_TREADY),
    .ready(accel_ready),
    .done(accel_done),
    .transaction(accel_transaction));

assign accel_ready = accel_ready_reg | ready_initial;
assign accel_done = 0;

assign accel_TVALID = axi_s_accel_TVALID;

assign axi_s_accel_TREADY = accel_TREADY;

AESL_axi_slave_control AESL_AXI_SLAVE_control(
    .clk   (AESL_clock),
    .reset (AESL_reset),
    .TRAN_s_axi_control_AWADDR (control_AWADDR),
    .TRAN_s_axi_control_AWVALID (control_AWVALID),
    .TRAN_s_axi_control_AWREADY (control_AWREADY),
    .TRAN_s_axi_control_WVALID (control_WVALID),
    .TRAN_s_axi_control_WREADY (control_WREADY),
    .TRAN_s_axi_control_WDATA (control_WDATA),
    .TRAN_s_axi_control_WSTRB (control_WSTRB),
    .TRAN_s_axi_control_ARADDR (control_ARADDR),
    .TRAN_s_axi_control_ARVALID (control_ARVALID),
    .TRAN_s_axi_control_ARREADY (control_ARREADY),
    .TRAN_s_axi_control_RVALID (control_RVALID),
    .TRAN_s_axi_control_RREADY (control_RREADY),
    .TRAN_s_axi_control_RDATA (control_RDATA),
    .TRAN_s_axi_control_RRESP (control_RRESP),
    .TRAN_s_axi_control_BVALID (control_BVALID),
    .TRAN_s_axi_control_BREADY (control_BREADY),
    .TRAN_s_axi_control_BRESP (control_BRESP),
    .TRAN_control_interrupt (control_INTERRUPT),
    .TRAN_control_ready_out (AESL_ready),
    .TRAN_control_ready_in (AESL_slave_ready),
    .TRAN_control_done_out (AESL_slave_output_done),
    .TRAN_control_idle_out (AESL_idle),
    .TRAN_control_write_start_in     (AESL_slave_write_start_in),
    .TRAN_control_write_start_finish (AESL_slave_write_start_finish),
    .TRAN_control_transaction_done_in (AESL_done_delay),
    .TRAN_control_start_in  (AESL_slave_start)
);

initial begin : generate_AESL_ready_cnt_proc
    AESL_ready_cnt = 0;
    wait(AESL_reset === 1);
    while(AESL_ready_cnt != AUTOTB_TRANSACTION_NUM) begin
        while(AESL_ready !== 1) begin
            @(posedge AESL_clock);
            # 0.4;
        end
        @(negedge AESL_clock);
        AESL_ready_cnt = AESL_ready_cnt + 1;
        @(posedge AESL_clock);
        # 0.4;
    end
end

    event next_trigger_ready_cnt;
    
    initial begin : gen_ready_cnt
        ready_cnt = 0;
        wait (AESL_reset === 1);
        forever begin
            @ (posedge AESL_clock);
            if (ready == 1) begin
                if (ready_cnt < AUTOTB_TRANSACTION_NUM) begin
                    ready_cnt = ready_cnt + 1;
                end
            end
            -> next_trigger_ready_cnt;
        end
    end
    
    wire all_finish = (done_cnt == AUTOTB_TRANSACTION_NUM);
    
    // done_cnt
    always @ (posedge AESL_clock) begin
        if (~AESL_reset) begin
            done_cnt <= 0;
        end else begin
            if (AESL_done == 1) begin
                if (done_cnt < AUTOTB_TRANSACTION_NUM) begin
                    done_cnt <= done_cnt + 1;
                end
            end
        end
    end
    
    initial begin : finish_simulation
        wait (all_finish == 1);
        // last transaction is saved at negedge right after last done
        repeat(6) @ (posedge AESL_clock);
        $finish;
    end
    
initial begin
    AESL_clock = 0;
    forever #`AUTOTB_CLOCK_PERIOD_DIV2 AESL_clock = ~AESL_clock;
end


reg end_accel;
reg [31:0] size_accel;
reg [31:0] size_accel_backup;
reg end_S_tilde_0;
reg [31:0] size_S_tilde_0;
reg [31:0] size_S_tilde_0_backup;
reg end_S_tilde_1;
reg [31:0] size_S_tilde_1;
reg [31:0] size_S_tilde_1_backup;
reg end_S_tilde_2;
reg [31:0] size_S_tilde_2;
reg [31:0] size_S_tilde_2_backup;
reg end_S_tilde_3;
reg [31:0] size_S_tilde_3;
reg [31:0] size_S_tilde_3_backup;
reg end_S_tilde_4;
reg [31:0] size_S_tilde_4;
reg [31:0] size_S_tilde_4_backup;
reg end_S_tilde_5;
reg [31:0] size_S_tilde_5;
reg [31:0] size_S_tilde_5_backup;
reg end_S_tilde_6;
reg [31:0] size_S_tilde_6;
reg [31:0] size_S_tilde_6_backup;
reg end_S_tilde_7;
reg [31:0] size_S_tilde_7;
reg [31:0] size_S_tilde_7_backup;
reg end_S_tilde_8;
reg [31:0] size_S_tilde_8;
reg [31:0] size_S_tilde_8_backup;

initial begin : initial_process
    integer proc_rand;
    rst = 0;
    # 100;
    repeat(0+3) @ (posedge AESL_clock);
    # 0.1;
    rst = 1;
end
initial begin : initial_process_for_dut_rst
    integer proc_rand;
    dut_rst = 0;
    # 100;
    repeat(3) @ (posedge AESL_clock);
    # 0.1;
    dut_rst = 1;
end
initial begin : start_process
    integer proc_rand;
    reg [31:0] start_cnt;
    ce = 1;
    start = 0;
    start_cnt = 0;
    wait (AESL_reset === 1);
    @ (posedge AESL_clock);
    #0 start = 1;
    start_cnt = start_cnt + 1;
    forever begin
        if (start_cnt >= AUTOTB_TRANSACTION_NUM + 1) begin
            #0 start = 0;
        end
        @ (posedge AESL_clock);
        if (AESL_ready) begin
            start_cnt = start_cnt + 1;
        end
    end
end

always @(AESL_done)
begin
    tb_continue = AESL_done;
end

initial begin : ready_initial_process
    ready_initial = 0;
    wait (AESL_start === 1);
    ready_initial = 1;
    @(posedge AESL_clock);
    ready_initial = 0;
end

always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
      AESL_ready_delay = 0;
  else
      AESL_ready_delay = AESL_ready;
end
initial begin : ready_last_n_process
  ready_last_n = 1;
  wait(ready_cnt == AUTOTB_TRANSACTION_NUM)
  @(posedge AESL_clock);
  ready_last_n <= 0;
end

always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
      ready_delay_last_n = 0;
  else
      ready_delay_last_n <= ready_last_n;
end
assign ready = (ready_initial | AESL_ready_delay);
assign ready_wire = ready_initial | AESL_ready_delay;
initial begin : done_delay_last_n_process
  done_delay_last_n = 1;
  while(done_cnt < AUTOTB_TRANSACTION_NUM)
      @(posedge AESL_clock);
  # 0.1;
  done_delay_last_n = 0;
end

always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
  begin
      AESL_done_delay <= 0;
      AESL_done_delay2 <= 0;
  end
  else begin
      AESL_done_delay <= AESL_done & done_delay_last_n;
      AESL_done_delay2 <= AESL_done_delay;
  end
end
always @(posedge AESL_clock)
begin
    if(AESL_reset === 0)
      interface_done = 0;
  else begin
      # 0.01;
      if(ready === 1 && ready_cnt > 0 && ready_cnt < AUTOTB_TRANSACTION_NUM)
          interface_done = 1;
      else if(AESL_done_delay === 1 && done_cnt == AUTOTB_TRANSACTION_NUM)
          interface_done = 1;
      else
          interface_done = 0;
  end
end
    
    initial begin : proc_gen_axis_internal_ready_accel
        accel_ready_reg = 0;
        @ (posedge ready_initial);
        forever begin
            @ (ap_c_n_tvin_trans_num_accel or accel_transaction);
            if (ap_c_n_tvin_trans_num_accel > accel_transaction) begin
                accel_ready_reg = 1;
            end else begin
                accel_ready_reg = 0;
            end
        end
    end
    
    `define STREAM_SIZE_IN_accel "../tv/stream_size/stream_size_in_accel.dat"
    
    initial begin : gen_ap_c_n_tvin_trans_num_accel
        integer fp_accel;
        reg [127:0] token_accel;
        integer ret;
        
        ap_c_n_tvin_trans_num_accel = 0;
        end_accel = 0;
        wait (AESL_reset === 1);
        
        fp_accel = $fopen(`STREAM_SIZE_IN_accel, "r");
        if(fp_accel == 0) begin
            $display("Failed to open file \"%s\"!", `STREAM_SIZE_IN_accel);
            $finish;
        end
        read_token(fp_accel, token_accel); // should be [[[runtime]]]
        if (token_accel != "[[[runtime]]]") begin
            $display("ERROR: token_accel != \"[[[runtime]]]\"");
            $finish;
        end
        size_accel = 0;
        size_accel_backup = 0;
        while (size_accel == 0 && end_accel == 0) begin
            ap_c_n_tvin_trans_num_accel = ap_c_n_tvin_trans_num_accel + 1;
            read_token(fp_accel, token_accel); // should be [[transaction]] or [[[/runtime]]]
            if (token_accel == "[[transaction]]") begin
                read_token(fp_accel, token_accel); // should be transaction number
                read_token(fp_accel, token_accel); // should be size for hls::stream
                ret = $sscanf(token_accel, "%d", size_accel);
                if (size_accel > 0) begin
                    size_accel_backup = size_accel;
                end
                read_token(fp_accel, token_accel); // should be [[/transaction]]
            end else if (token_accel == "[[[/runtime]]]") begin
                $fclose(fp_accel);
                end_accel = 1;
            end else begin
                $display("ERROR: unknown token_accel");
                $finish;
            end
        end
        forever begin
            @ (posedge AESL_clock);
            if (end_accel == 0) begin
                if ((accel_TREADY & accel_TVALID) == 1) begin
                    if (size_accel > 0) begin
                        size_accel = size_accel - 1;
                        while (size_accel == 0 && end_accel == 0) begin
                            ap_c_n_tvin_trans_num_accel = ap_c_n_tvin_trans_num_accel + 1;
                            read_token(fp_accel, token_accel); // should be [[transaction]] or [[[/runtime]]]
                            if (token_accel == "[[transaction]]") begin
                                read_token(fp_accel, token_accel); // should be transaction number
                                read_token(fp_accel, token_accel); // should be size for hls::stream
                                ret = $sscanf(token_accel, "%d", size_accel);
                                if (size_accel > 0) begin
                                    size_accel_backup = size_accel;
                                end
                                read_token(fp_accel, token_accel); // should be [[/transaction]]
                            end else if (token_accel == "[[[/runtime]]]") begin
                                size_accel = size_accel_backup;
                                $fclose(fp_accel);
                                end_accel = 1;
                            end else begin
                                $display("ERROR: unknown token_accel");
                                $finish;
                            end
                        end
                    end
                end
            end else begin
                if ((accel_TREADY & accel_TVALID) == 1) begin
                    if (size_accel > 0) begin
                        size_accel = size_accel - 1;
                        if (size_accel == 0) begin
                            ap_c_n_tvin_trans_num_accel = ap_c_n_tvin_trans_num_accel + 1;
                            size_accel = size_accel_backup;
                        end
                    end
                end
            end
        end
    end
    
task write_binary;
    input integer fp;
    input reg[64-1:0] in;
    input integer in_bw;
    reg [63:0] tmp_long;
    reg[64-1:0] local_in;
    integer char_num;
    integer long_num;
    integer i;
    integer j;
    begin
        long_num = (in_bw + 63) / 64;
        char_num = ((in_bw - 1) % 64 + 7) / 8;
        for(i=long_num;i>0;i=i-1) begin
             local_in = in;
             tmp_long = local_in >> ((i-1)*64);
             for(j=0;j<64;j=j+1)
                 if (tmp_long[j] === 1'bx)
                     tmp_long[j] = 1'b0;
             if (i == long_num) begin
                 case(char_num)
                     1: $fwrite(fp,"%c",tmp_long[7:0]);
                     2: $fwrite(fp,"%c%c",tmp_long[15:8],tmp_long[7:0]);
                     3: $fwrite(fp,"%c%c%c",tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     4: $fwrite(fp,"%c%c%c%c",tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     5: $fwrite(fp,"%c%c%c%c%c",tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     6: $fwrite(fp,"%c%c%c%c%c%c",tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     7: $fwrite(fp,"%c%c%c%c%c%c%c",tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     8: $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
                     default: ;
                 endcase
             end
             else begin
                 $fwrite(fp,"%c%c%c%c%c%c%c%c",tmp_long[63:56],tmp_long[55:48],tmp_long[47:40],tmp_long[39:32],tmp_long[31:24],tmp_long[23:16],tmp_long[15:8],tmp_long[7:0]);
             end
        end
    end
endtask;

////////////////////////////////////////////
// progress and performance
////////////////////////////////////////////

task wait_start();
    while (~AESL_start) begin
        @ (posedge AESL_clock);
    end
endtask

reg [31:0] clk_cnt = 0;
reg AESL_ready_p1;
reg AESL_start_p1;

always @ (posedge AESL_clock) begin
    if (AESL_reset == 0) begin
        clk_cnt <= 32'h0;
        AESL_ready_p1 <= 1'b0;
        AESL_start_p1 <= 1'b0;
    end
    else begin
        clk_cnt <= clk_cnt + 1;
        AESL_ready_p1 <= AESL_ready;
        AESL_start_p1 <= AESL_start;
    end
end

reg [31:0] start_timestamp [0:AUTOTB_TRANSACTION_NUM - 1];
reg [31:0] start_cnt;
reg [31:0] ready_timestamp [0:AUTOTB_TRANSACTION_NUM - 1];
reg [31:0] ap_ready_cnt;
reg [31:0] finish_timestamp [0:AUTOTB_TRANSACTION_NUM - 1];
reg [31:0] finish_cnt;
reg [31:0] lat_total;
event report_progress;

always @(posedge AESL_clock)
begin
    if (finish_cnt == AUTOTB_TRANSACTION_NUM - 1 && AESL_done == 1'b1)
        lat_total = clk_cnt - start_timestamp[0];
end

initial begin
    start_cnt = 0;
    finish_cnt = 0;
    ap_ready_cnt = 0;
    wait (AESL_reset == 1);
    wait_start();
    start_timestamp[start_cnt] = clk_cnt;
    start_cnt = start_cnt + 1;
    if (AESL_done) begin
        finish_timestamp[finish_cnt] = clk_cnt;
        finish_cnt = finish_cnt + 1;
    end
    -> report_progress;
    forever begin
        @ (posedge AESL_clock);
        if (start_cnt < AUTOTB_TRANSACTION_NUM) begin
            if ((AESL_start && AESL_ready_p1)||(AESL_start && ~AESL_start_p1)) begin
                start_timestamp[start_cnt] = clk_cnt;
                start_cnt = start_cnt + 1;
            end
        end
        if (ap_ready_cnt < AUTOTB_TRANSACTION_NUM) begin
            if (AESL_start_p1 && AESL_ready_p1) begin
                ready_timestamp[ap_ready_cnt] = clk_cnt;
                ap_ready_cnt = ap_ready_cnt + 1;
            end
        end
        if (finish_cnt < AUTOTB_TRANSACTION_NUM) begin
            if (AESL_done) begin
                finish_timestamp[finish_cnt] = clk_cnt;
                finish_cnt = finish_cnt + 1;
            end
        end
        -> report_progress;
    end
end

reg [31:0] progress_timeout;

initial begin : simulation_progress
    real intra_progress;
    wait (AESL_reset == 1);
    progress_timeout = PROGRESS_TIMEOUT;
    $display("////////////////////////////////////////////////////////////////////////////////////");
    $display("// Inter-Transaction Progress: Completed Transaction / Total Transaction");
    $display("// Intra-Transaction Progress: Measured Latency / Latency Estimation * 100%%");
    $display("//");
    $display("// RTL Simulation : \"Inter-Transaction Progress\" [\"Intra-Transaction Progress\"] @ \"Simulation Time\"");
    $display("////////////////////////////////////////////////////////////////////////////////////");
    print_progress();
    while (finish_cnt < AUTOTB_TRANSACTION_NUM) begin
        @ (report_progress);
        if (finish_cnt < AUTOTB_TRANSACTION_NUM) begin
            if (AESL_done) begin
                print_progress();
                progress_timeout = PROGRESS_TIMEOUT;
            end else begin
                if (progress_timeout == 0) begin
                    print_progress();
                    progress_timeout = PROGRESS_TIMEOUT;
                end else begin
                    progress_timeout = progress_timeout - 1;
                end
            end
        end
        // non-dataflow design && latency is predictable && no AXI master/slave interface
        get_intra_progress(intra_progress);
        if (intra_progress > 1000) begin
            $display("// RTL Simulation : transaction %0d run-time latency is greater than %0f time(s) of the prediction @ \"%0t\"", start_cnt, intra_progress, $time);
            $display("////////////////////////////////////////////////////////////////////////////////////");
            $finish;
        end
    end
    print_progress();
    $display("////////////////////////////////////////////////////////////////////////////////////");
    calculate_performance();
end

task get_intra_progress(output real intra_progress);
    begin
        if (start_cnt > finish_cnt) begin
            intra_progress = clk_cnt - start_timestamp[finish_cnt];
        end else if(finish_cnt > 0) begin
            intra_progress = LATENCY_ESTIMATION;
        end else begin
            intra_progress = 0;
        end
        intra_progress = intra_progress / LATENCY_ESTIMATION;
    end
endtask

task print_progress();
    real intra_progress;
    begin
        if (LATENCY_ESTIMATION > 0) begin
            get_intra_progress(intra_progress);
            $display("// RTL Simulation : %0d / %0d [%2.2f%%] @ \"%0t\"", finish_cnt, AUTOTB_TRANSACTION_NUM, intra_progress * 100, $time);
        end else begin
            $display("// RTL Simulation : %0d / %0d [n/a] @ \"%0t\"", finish_cnt, AUTOTB_TRANSACTION_NUM, $time);
        end
    end
endtask

task calculate_performance();
    integer i;
    integer fp;
    reg [31:0] latency [0:AUTOTB_TRANSACTION_NUM - 1];
    reg [31:0] latency_min;
    reg [31:0] latency_max;
    reg [31:0] latency_total;
    reg [31:0] latency_average;
    reg [31:0] interval [0:AUTOTB_TRANSACTION_NUM - 2];
    reg [31:0] interval_min;
    reg [31:0] interval_max;
    reg [31:0] interval_total;
    reg [31:0] interval_average;
    reg [31:0] total_execute_time;
    begin
        latency_min = -1;
        latency_max = 0;
        latency_total = 0;
        interval_min = -1;
        interval_max = 0;
        interval_total = 0;
        total_execute_time = lat_total;

        for (i = 0; i < AUTOTB_TRANSACTION_NUM; i = i + 1) begin
            // calculate latency
            latency[i] = finish_timestamp[i] - start_timestamp[i];
            if (latency[i] > latency_max) latency_max = latency[i];
            if (latency[i] < latency_min) latency_min = latency[i];
            latency_total = latency_total + latency[i];
            // calculate interval
            if (AUTOTB_TRANSACTION_NUM == 1) begin
                interval[i] = 0;
                interval_max = 0;
                interval_min = 0;
                interval_total = 0;
            end else if (i < AUTOTB_TRANSACTION_NUM - 1) begin
                interval[i] = start_timestamp[i + 1] - start_timestamp[i];
                if (interval[i] > interval_max) interval_max = interval[i];
                if (interval[i] < interval_min) interval_min = interval[i];
                interval_total = interval_total + interval[i];
            end
        end

        latency_average = latency_total / AUTOTB_TRANSACTION_NUM;
        if (AUTOTB_TRANSACTION_NUM == 1) begin
            interval_average = 0;
        end else begin
            interval_average = interval_total / (AUTOTB_TRANSACTION_NUM - 1);
        end

        fp = $fopen(`AUTOTB_LAT_RESULT_FILE, "w");

        $fdisplay(fp, "$MAX_LATENCY = \"%0d\"", latency_max);
        $fdisplay(fp, "$MIN_LATENCY = \"%0d\"", latency_min);
        $fdisplay(fp, "$AVER_LATENCY = \"%0d\"", latency_average);
        $fdisplay(fp, "$MAX_THROUGHPUT = \"%0d\"", interval_max);
        $fdisplay(fp, "$MIN_THROUGHPUT = \"%0d\"", interval_min);
        $fdisplay(fp, "$AVER_THROUGHPUT = \"%0d\"", interval_average);
        $fdisplay(fp, "$TOTAL_EXECUTE_TIME = \"%0d\"", total_execute_time);

        $fclose(fp);

        fp = $fopen(`AUTOTB_PER_RESULT_TRANS_FILE, "w");

        $fdisplay(fp, "%20s%16s%16s", "", "latency", "interval");
        if (AUTOTB_TRANSACTION_NUM == 1) begin
            i = 0;
            $fdisplay(fp, "transaction%8d:%16d%16d", i, latency[i], interval[i]);
        end else begin
            for (i = 0; i < AUTOTB_TRANSACTION_NUM; i = i + 1) begin
                if (i < AUTOTB_TRANSACTION_NUM - 1) begin
                    $fdisplay(fp, "transaction%8d:%16d%16d", i, latency[i], interval[i]);
                end else begin
                    $fdisplay(fp, "transaction%8d:%16d               x", i, latency[i]);
                end
            end
        end

        $fclose(fp);
    end
endtask


////////////////////////////////////////////
// Dependence Check
////////////////////////////////////////////

`ifndef POST_SYN

`endif

AESL_deadlock_kernel_monitor_top kernel_monitor_top(
    .kernel_monitor_reset(~AESL_reset),
    .kernel_monitor_clock(AESL_clock));

///////////////////////////////////////////////////////
// dataflow status monitor
///////////////////////////////////////////////////////
dataflow_monitor U_dataflow_monitor(
    .clock(AESL_clock),
    .reset(~rst),
    .finish(all_finish));

`include "fifo_para.vh"

endmodule
