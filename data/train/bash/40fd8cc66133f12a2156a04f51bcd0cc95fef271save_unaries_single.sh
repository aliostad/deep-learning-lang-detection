#! /usr/bin/env bash
#./save_unaries ~/src/PMC/ParametricMaxflow/Data/data_GT/227092.jpg ~/src/PMC/ParametricMaxflow/Data/boundary_GT_lasso/227092.bmp 227092_0

#run with: cat Train.txt| parallel "./save_unaries_single.sh {}"

img_dir=~/Downloads/data_GT/
lasso_dir=~/Downloads/boundary_GT_lasso/
save_dir=unary/

filename=$1
name="${filename%.*}"
img_file=$img_dir$filename
lass_file=$lasso_dir$name'.bmp'
save_file=$save_dir$name'_0.unary'
input_name=$save_dir$name'_0'
if [ ! -f $save_file  ];
then
       echo "File $save_file does not exist."
       ./save_unaries $img_file $lass_file $input_name
fi
