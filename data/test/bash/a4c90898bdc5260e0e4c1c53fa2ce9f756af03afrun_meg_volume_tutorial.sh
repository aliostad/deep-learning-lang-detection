#!/usr/bin/env bash

if [ $# -ne 1 ] ; then
    echo "Usage: $0 <sample data directory>"
    exit 1
fi

MNE_sample=$1

cd ${MNE_sample}/subjects && export SUBJECTS_DIR=`pwd`
cd -
cd ${MNE_sample}/MEG/sample && export MEG_DIR=`pwd`
cd -

export SUBJECT=sample

mne_volume_source_space --bem $SUBJECTS_DIR/$SUBJECT/bem/sample-5120-bem.fif \
    --grid 7 --mri $SUBJECTS_DIR/$SUBJECT/mri/T1.mgz \
    --src $SUBJECTS_DIR/$SUBJECT/bem/volume-7mm-src.fif

# Prepare for forward computation
mne_setup_forward_model --homog --surf \
        --src $SUBJECTS_DIR/$SUBJECT/bem/volume-7mm-src.fif

cd $MEG_DIR

###############################################################################
# Compute forward solution a.k.a. lead field

# for MEG only
mne_do_forward_solution --mindist 5 \
        --src $SUBJECTS_DIR/$SUBJECT/bem/volume-7mm-src.fif \
        --meas sample_audvis_raw.fif --bem sample-5120 --megonly --overwrite \
        --fwd sample_audvis-meg-vol-7-fwd.fif

# Make a sensitivity map
mne_sensitivity_map --fwd sample_audvis-meg-vol-7-fwd.fif \
    --map 1 --w sample_audvis-grad-vol-7-fwd-sensmap

###############################################################################
# Compute MNE inverse operators
#
# Note: The MEG/EEG forward solution could be used for all
#
mne_do_inverse_operator --fwd sample_audvis-meg-vol-7-fwd.fif --depth --meg

# # Produce stc files
#
# mne_make_movie --inv sample_audvis-${mod}-oct-6-${mod}-inv.fif \
#     --meas sample_audvis-ave.fif \
#     --tmin 0 --tmax 250 --tstep 10 --spm \
#     --smooth 5 --bmin -100 --bmax 0 --stc sample_audvis-${mod}

# mne_volume_data2mri --src sample_audvis-meg-vol-7-fwd.fif --stc mne_dSPM_inverse-vol.stc --out mne_dSPM_vol_inverse.mgz

exit 0
