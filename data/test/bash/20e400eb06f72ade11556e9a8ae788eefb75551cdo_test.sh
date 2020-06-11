#!/bin/sh

for i in \
	00_constructor_sample 01_opeEqu_sample    02_opeEqu_sample \
	03_opePlus_sample     04_opeSubst_sample  05_opeMulti_sample \
	06_opeDivid_sample    07_opeComp_sample   071_opeNotComp_sample \
	08_size_type_sample   09_bytes_sample     10_dim_length_sample \
	11_length_sample      12_byte_length_sample 13_col_length_sample \
	14_row_length_sample  15_layer_length_sample 16_assign_default_sample \
	17_default_value_sample 18_init_sample    19_auto_resize_sample \
	20_rounding_sample    21_dvalue_sample    22_lvalue_sample \
	23_assign_sample      24_f_sample         25_f_cs_sample \
	26_put_sample         27_swap_sample      28_move_sample \
	29_cpy_sample         30_insert_sample    31_crop_sample \
	32_erase_sample       33_resize_sample    34_resizeby_sample \
	35_increase_dim_sample 36_decrease_dim_sample 37_swapObj_sample \
	38_ceil_sample        39_floor_sample     40_round_sample \
	41_trunc_sample       42_abs_sample       43_convert_sample \
	44_copy_sample        45_copy_sample      46_cut_sample \
	48_clean_sample       49_fill_sample \
	50_add_sample         51_multiply_sample  52_paste_sample \
	53_add_sample         54_subtract_sample  55_multiply_sample \
	56_divide_sample      57_compare_sample   58_register_extptr_sample \
	59_getdata_sample     60_putdata_sample   61_carray_sample \
	63_scan_cols_sample   64_flip_sample      65_reallocate_sample \
	66_trim_sample        67_flip_cols_sample 68_resize_sample \
	69_transpose_sample   70_rotate_sample    71_array_ptr_2d_sample \
	72_move_to_sample     73_math_sample      74_complex_sample \
	75_complex_cproj_sample 76_statistics_sample \
        77_pastef_sample      78_flipf_sample     79_transposef_sample \
	80_transpose_xyz2zxy_sample 81_transposef_xyz2zxy_sample \
	82_scan_f_sample \
	; do 
  echo $i
  ./$i
  echo ""
done

./62_reverse_endian_sample 2> /dev/null
md5sum 62_binary.dat
