set SynModuleInfo {
  {SRCNAME {addsub<0, 0, ap_fixed<43, 4, 5, 3, 0>, ap_fixed<43, 4, 5, 3, 0>, ap_uint<1> >} MODELNAME addsub_0_0_ap_fixed_43_4_5_3_0_ap_fixed_43_4_5_3_0_ap_uint_1_s RTLNAME scatter_matrix_addsub_0_0_ap_fixed_43_4_5_3_0_ap_fixed_43_4_5_3_0_ap_uint_1_s}
  {SRCNAME {addsub<0, 0, ap_fixed<43, 4, 5, 3, 0>, ap_fixed<43, 4, 5, 3, 0>, bool>} MODELNAME addsub_0_0_ap_fixed_43_4_5_3_0_ap_fixed_43_4_5_3_0_bool_s RTLNAME scatter_matrix_addsub_0_0_ap_fixed_43_4_5_3_0_ap_fixed_43_4_5_3_0_bool_s}
  {SRCNAME {addsub<0, 0, ap_fixed<40, 1, 5, 3, 0>, ap_fixed<40, 1, 0, 3, 0>, ap_uint<1> >} MODELNAME addsub_0_0_ap_fixed_40_1_5_3_0_ap_fixed_40_1_0_3_0_ap_uint_1_s RTLNAME scatter_matrix_addsub_0_0_ap_fixed_40_1_5_3_0_ap_fixed_40_1_0_3_0_ap_uint_1_s}
  {SRCNAME atan2_generic<float> MODELNAME atan2_generic_float_s RTLNAME scatter_matrix_atan2_generic_float_s
    SUBMODULES {
      {MODELNAME scatter_matrix_fdiv_32ns_32ns_32_10_no_dsp_0 RTLNAME scatter_matrix_fdiv_32ns_32ns_32_10_no_dsp_0 BINDTYPE op TYPE fdiv IMPL fabric LATENCY 9 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME atan2_cordic<float> MODELNAME atan2_cordic_float_s RTLNAME scatter_matrix_atan2_cordic_float_s
    SUBMODULES {
      {MODELNAME scatter_matrix_fsub_32ns_32ns_32_5_full_dsp_1 RTLNAME scatter_matrix_fsub_32ns_32ns_32_5_full_dsp_1 BINDTYPE op TYPE fsub IMPL fulldsp LATENCY 4 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_fcmp_32ns_32ns_1_2_no_dsp_1 RTLNAME scatter_matrix_fcmp_32ns_32ns_1_2_no_dsp_1 BINDTYPE op TYPE fcmp IMPL auto LATENCY 1 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME sin_or_cos<float> MODELNAME sin_or_cos_float_s RTLNAME scatter_matrix_sin_or_cos_float_s
    SUBMODULES {
      {MODELNAME scatter_matrix_mul_23s_22ns_45_1_1 RTLNAME scatter_matrix_mul_23s_22ns_45_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_mul_30s_29ns_58_1_1 RTLNAME scatter_matrix_mul_30s_29ns_58_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_mul_80s_24ns_80_2_1 RTLNAME scatter_matrix_mul_80s_24ns_80_2_1 BINDTYPE op TYPE mul IMPL auto LATENCY 1 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_sparsemux_17_3_1_1_1 RTLNAME scatter_matrix_sparsemux_17_3_1_1_1 BINDTYPE op TYPE sparsemux IMPL auto}
      {MODELNAME scatter_matrix_sparsemux_33_4_1_1_1 RTLNAME scatter_matrix_sparsemux_33_4_1_1_1 BINDTYPE op TYPE sparsemux IMPL auto}
      {MODELNAME scatter_matrix_mul_15ns_15ns_30_1_1 RTLNAME scatter_matrix_mul_15ns_15ns_30_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_mul_15ns_15s_30_1_1 RTLNAME scatter_matrix_mul_15ns_15s_30_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_sin_or_cos_float_s_ref_4oPi_table_100_ROM_1P_LUTRAM_1R RTLNAME scatter_matrix_sin_or_cos_float_s_ref_4oPi_table_100_ROM_1P_LUTRAM_1R BINDTYPE storage TYPE rom_1p IMPL lutram LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_sin_or_cos_float_s_second_order_float_sin_cos_K0_ROM_1P_LUTRAM_1R RTLNAME scatter_matrix_sin_or_cos_float_s_second_order_float_sin_cos_K0_ROM_1P_LUTRAM_1R BINDTYPE storage TYPE rom_1p IMPL lutram LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_sin_or_cos_float_s_second_order_float_sin_cos_K1_ROM_1P_LUTRAM_1R RTLNAME scatter_matrix_sin_or_cos_float_s_second_order_float_sin_cos_K1_ROM_1P_LUTRAM_1R BINDTYPE storage TYPE rom_1p IMPL lutram LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_sin_or_cos_float_s_second_order_float_sin_cos_K2_ROM_1P_LUTRAM_1R RTLNAME scatter_matrix_sin_or_cos_float_s_second_order_float_sin_cos_K2_ROM_1P_LUTRAM_1R BINDTYPE storage TYPE rom_1p IMPL lutram LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME jacobi_eigen_3x3 MODELNAME jacobi_eigen_3x3 RTLNAME scatter_matrix_jacobi_eigen_3x3
    SUBMODULES {
      {MODELNAME scatter_matrix_fsub_32ns_32ns_32_5_full_dsp_0 RTLNAME scatter_matrix_fsub_32ns_32ns_32_5_full_dsp_0 BINDTYPE op TYPE fsub IMPL fulldsp LATENCY 4 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_fadd_32ns_32ns_32_5_full_dsp_0 RTLNAME scatter_matrix_fadd_32ns_32ns_32_5_full_dsp_0 BINDTYPE op TYPE fadd IMPL fulldsp LATENCY 4 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_faddfsub_32ns_32ns_32_5_full_dsp_0 RTLNAME scatter_matrix_faddfsub_32ns_32ns_32_5_full_dsp_0 BINDTYPE op TYPE fsub IMPL fulldsp LATENCY 4 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_fmul_32ns_32ns_32_4_max_dsp_0 RTLNAME scatter_matrix_fmul_32ns_32ns_32_4_max_dsp_0 BINDTYPE op TYPE fmul IMPL maxdsp LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_fcmp_32ns_32ns_1_2_no_dsp_0 RTLNAME scatter_matrix_fcmp_32ns_32ns_1_2_no_dsp_0 BINDTYPE op TYPE fcmp IMPL auto LATENCY 1 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME scatter_matrix MODELNAME scatter_matrix RTLNAME scatter_matrix IS_TOP 1
    SUBMODULES {
      {MODELNAME scatter_matrix_fadd_32ns_32ns_32_4_no_dsp_1 RTLNAME scatter_matrix_fadd_32ns_32ns_32_4_no_dsp_1 BINDTYPE op TYPE fadd IMPL fabric LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_faddfsub_32ns_32ns_32_5_full_dsp_1 RTLNAME scatter_matrix_faddfsub_32ns_32ns_32_5_full_dsp_1 BINDTYPE op TYPE fsub IMPL fulldsp LATENCY 4 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_fadd_32ns_32ns_32_5_full_dsp_1 RTLNAME scatter_matrix_fadd_32ns_32ns_32_5_full_dsp_1 BINDTYPE op TYPE fadd IMPL fulldsp LATENCY 4 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_fmul_32ns_32ns_32_4_max_dsp_1 RTLNAME scatter_matrix_fmul_32ns_32ns_32_4_max_dsp_1 BINDTYPE op TYPE fmul IMPL maxdsp LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_sitofp_32s_32_3_no_dsp_1 RTLNAME scatter_matrix_sitofp_32s_32_3_no_dsp_1 BINDTYPE op TYPE sitofp IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_fsqrt_32ns_32ns_32_9_no_dsp_1 RTLNAME scatter_matrix_fsqrt_32ns_32ns_32_9_no_dsp_1 BINDTYPE op TYPE fsqrt IMPL fabric LATENCY 8 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_srem_9ns_8ns_8_13_1 RTLNAME scatter_matrix_srem_9ns_8ns_8_13_1 BINDTYPE op TYPE srem IMPL auto LATENCY 12 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_accel_buffer_RAM_AUTO_1R1W RTLNAME scatter_matrix_accel_buffer_RAM_AUTO_1R1W BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME scatter_matrix_frp_fifoout RTLNAME scatter_matrix_frp_fifoout BINDTYPE interface TYPE internal_frp_fifoout}
      {MODELNAME scatter_matrix_control_s_axi RTLNAME scatter_matrix_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
      {MODELNAME scatter_matrix_frp_pipeline_valid RTLNAME scatter_matrix_frp_pipeline_valid BINDTYPE interface TYPE internal_frp_validbits INSTNAME scatter_matrix_frp_pipeline_valid_U}
      {MODELNAME scatter_matrix_regslice_both RTLNAME scatter_matrix_regslice_both BINDTYPE interface TYPE adapter IMPL reg_slice}
    }
  }
}
