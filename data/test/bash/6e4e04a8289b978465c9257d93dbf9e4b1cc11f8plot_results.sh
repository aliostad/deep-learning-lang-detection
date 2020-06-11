#!/bin/sh

VMIN=-0.03
VMAX=0.005
INTERPOLATION=bicubic

save_img() {
  ./mhamplv.py ${1} -p ${VMIN} -q ${VMAX} \
    --cmap gray_r --interpolation ${INTERPOLATION} \
    -o ../../../doc/images/inclusion_${2}.png
  ./mhamplv.py ${1} -p ${VMIN} -q ${VMAX} \
    --cmap gray_r --interpolation ${INTERPOLATION} \
    -o ../../../doc/images/inclusion_${2}.eps
}

save_img parabolic_Version_d74a851_StrainComponent0.mha parabolic
save_img amoeba_Version_a46df20_StrainComponent0.mha amoeba
save_img cosine_Version_d74a851_StrainComponent0.mha cosine
save_img no_interp_Version_d74a851_StrainComponent0.mha no_interp
