rm err.log
set -e
#python step2_model_data_preprocessing/step2a_data_concat_daily_files.py 2>> err.log
python step2_model_data_preprocessing/step2b_model_data_split_downsample.py 2>> err.log
python step3_model_data_prep_signal_tmx/step3a_model_data_rc_tmxrc_ind_creation_main.py 2>> err.log
python step3_model_data_prep_signal_tmx/step3b_model_data_feature_creation_main.py 2>> err.log
python step3_model_data_prep_signal_tmx/step3c_support_impute_woe_mapping_calculation.py 2>> err.log
python step3_model_data_prep_signal_tmx/step3c_model_data_impute_woe_assigin_main.py 2>> err.log
python step4_model_train/step4_model_train_signal_tmx_v2.py 2>> err.log