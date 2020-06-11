# Get difference volumes. csh script

ID="29"
BASE=/home/student/jpringle/.secret/NIH
OD=freesurfer_output
TEST=frs
TEST_FULL=freesurfer

cd ${BASE}/${ID}

#3dcalc -a all+orig'[t1]' -expr "a" -prefix t1_avg_s+orig

3dcalc -a ${TEST}_seg+orig -b t1_avg_s+orig -expr "step(a)*b" -prefix ${OD}/t1_ss_${TEST}
3dcalc -a ${TEST}_seg+orig -b ${OD}/mlr_${ID}_full_c+orig -expr "step(abs(a-b))" -prefix ${OD}/full_diff
3dcalc -a ${TEST}_seg+orig -b ${OD}/mlr_${ID}_spline_c+orig -expr "step(abs(a-b))" -prefix ${OD}/spline_diff
3dcalc -a ${TEST}_seg+orig -b ${OD}/${TEST_FULL}_knn_${ID}+orig -expr "step(abs(a-b))" -prefix ${OD}/knn_diff

cp ${TEST}_seg+orig* ${OD}

cd ${OD}

# Now take pictures
PICS="pics"
PIC_DIR=${PICS}
mkdir ${PIC_DIR}

# For subject 04
a1s1="6514051"
a2c1="6707874"

# For subject 13
a1s1="6249875"
a2c1="6576528"

# For subject 27
a1s1="6248861"
a2c1="6052262"

# For subject 29
a1s1="6446758"
a2c1="4543904"

afni -com 'OPEN_WINDOW A.axialimage'                                            \
     -com 'OPEN_WINDOW A.sagittalimage'                                         \
     -com 'OPEN_WINDOW A.coronalimage'                                          \
     -com 'SET_XHAIRS A.OFF'                                                    \
     -com "SWITCH_UNDERLAY t1_ss_${TEST}+orig"                                      \
     -com "SEE_OVERLAY A.-"                                                     \
     -com "SET_INDEX A ${a1s1}"                                                 \
     -com "SAVE_JPEG A.axialimage ${PIC_DIR}/a1_truth.jpg blowup=2"             \
     -com "SAVE_JPEG A.sagittalimage ${PIC_DIR}/s1_truth.jpg blowup=2"          \
     -com "SWITCH_OVERLAY ${TEST}_seg+orig"                                         \
     -com 'SEE_OVERLAY A.+'                                                     \
     -com "SAVE_JPEG A.axialimage ${PIC_DIR}/a1_${TEST}.jpg blowup=2"               \
     -com "SAVE_JPEG A.sagittalimage ${PIC_DIR}/s1_${TEST}.jpg blowup=2"            \
     -com "SWITCH_OVERLAY mlr_${ID}_full_c+orig"                                \
     -com "SAVE_JPEG A.axialimage ${PIC_DIR}/a1_mlr_full.jpg blowup=2"          \
     -com "SAVE_JPEG A.sagittalimage ${PIC_DIR}/s1_mlr_full.jpg blowup=2"       \
     -com "SWITCH_OVERLAY mlr_${ID}_spline_c+orig"                              \
     -com "SAVE_JPEG A.axialimage ${PIC_DIR}/a1_mlr_spline.jpg blowup=2"        \
     -com "SAVE_JPEG A.sagittalimage ${PIC_DIR}/s1_mlr_spline.jpg blowup=2"     \
     -com "SWITCH_OVERLAY ${TEST_FULL}_knn_${ID}+orig"                                   \
     -com "SAVE_JPEG A.axialimage ${PIC_DIR}/a1_knn.jpg blowup=2"               \
     -com "SAVE_JPEG A.sagittalimage ${PIC_DIR}/s1_knn.jpg blowup=2"            \
     -com "SWITCH_UNDERLAY full_diff+orig"                                      \
     -com 'SEE_OVERLAY A.-'                                                     \
     -com "SAVE_JPEG A.axialimage ${PIC_DIR}/a1_mlr_full_diff.jpg blowup=2"     \
     -com "SAVE_JPEG A.sagittalimage ${PIC_DIR}/s1_mlr_full_diff.jpg blowup=2"  \
     -com "SWITCH_UNDERLAY spline_diff+orig"                                    \
     -com "SAVE_JPEG A.axialimage ${PIC_DIR}/a1_mlr_spline_diff.jpg blowup=2"   \
     -com "SAVE_JPEG A.sagittalimage ${PIC_DIR}/s1_mlr_spline_diff.jpg blowup=2"\
     -com "SWITCH_UNDERLAY knn_diff+orig"                                       \
     -com "SAVE_JPEG A.axialimage ${PIC_DIR}/a1_knn_diff.jpg blowup=2"          \
     -com "SAVE_JPEG A.sagittalimage ${PIC_DIR}/s1_knn_diff.jpg blowup=2"       \
     -com "SWITCH_UNDERLAY t1_ss_${TEST}+orig"                                  \
     -com "SET_INDEX A ${a2c1}"                                                 \
     -com "SAVE_JPEG A.axialimage ${PIC_DIR}/a2_truth.jpg blowup=2"             \
     -com "SAVE_JPEG A.coronalimage ${PIC_DIR}/c1_truth.jpg blowup=2"           \
     -com "SWITCH_OVERLAY ${TEST}_seg+orig"                                     \
     -com 'SEE_OVERLAY A.+'                                                     \
     -com "SAVE_JPEG A.axialimage ${PIC_DIR}/a2_${TEST}.jpg blowup=2"               \
     -com "SAVE_JPEG A.coronalimage ${PIC_DIR}/c1_${TEST}.jpg blowup=2"             \
     -com "SWITCH_OVERLAY mlr_${ID}_full_c+orig"                                \
     -com "SAVE_JPEG A.axialimage ${PIC_DIR}/a2_mlr_full.jpg blowup=2"          \
     -com "SAVE_JPEG A.coronalimage ${PIC_DIR}/c1_mlr_full.jpg blowup=2"        \
     -com "SWITCH_OVERLAY mlr_${ID}_spline_c+orig"                              \
     -com "SAVE_JPEG A.axialimage ${PIC_DIR}/a2_mlr_spline.jpg blowup=2"        \
     -com "SAVE_JPEG A.coronalimage ${PIC_DIR}/c1_mlr_spline.jpg blowup=2"      \
     -com "SWITCH_OVERLAY ${TEST_FULL}_knn_${ID}+orig"                          \
     -com "SAVE_JPEG A.axialimage ${PIC_DIR}/a2_knn.jpg blowup=2"               \
     -com "SAVE_JPEG A.coronalimage ${PIC_DIR}/c1_knn.jpg blowup=2"             \
     -com "SWITCH_UNDERLAY full_diff+orig"                                      \
     -com 'SEE_OVERLAY A.-'                                                     \
     -com "SAVE_JPEG A.axialimage ${PIC_DIR}/a2_mlr_full_diff.jpg blowup=2"     \
     -com "SAVE_JPEG A.coronalimage ${PIC_DIR}/c1_mlr_full_diff.jpg blowup=2"   \
     -com "SWITCH_UNDERLAY spline_diff+orig"                                    \
     -com "SAVE_JPEG A.axialimage ${PIC_DIR}/a2_mlr_spline_diff.jpg blowup=2"   \
     -com "SAVE_JPEG A.coronalimage ${PIC_DIR}/c1_mlr_spline_diff.jpg blowup=2" \
     -com "SWITCH_UNDERLAY knn_diff+orig"                                       \
     -com "SAVE_JPEG A.axialimage ${PIC_DIR}/a2_knn_diff.jpg blowup=2"          \
     -com "SAVE_JPEG A.coronalimage ${PIC_DIR}/c1_knn_diff.jpg blowup=2"       \
     -com 'QUIT'