#! /bin/sh

echo 'Constellations'
python load_constellations.py > /dev/null 2>&1
echo 'Object Types'
python load_obj_types.py > /dev/null 2>&1
echo 'wikipedia stars'
python load_w_stars.py > /dev/null 2>&1
echo 'HIP stars'
python load_hip_stars.py > /dev/null 2>&1
echo 'Tycho-2 stars'
python load_tyc_stars.py > /dev/null 2>&1
echo 'UCAC4 stars'
python load_ucac_stars.py > /dev/null 2>&1

echo 'NGC/IC objects'
python load_ngcic.py > /dev/null 2>&1
echo 'Other DSOs'
python load_other_dsos.py > /dev/null 2>&1
echo 'Done.'
