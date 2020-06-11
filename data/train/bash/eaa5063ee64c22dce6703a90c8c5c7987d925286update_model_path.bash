#!/bin/bash
#Script for helping gazebo find ROS packages
#To use, add the packages you want to find to the array below and source the script
declare -a packages=( \
'lwr_description' \
'lwr_robot' \
'robotiq_s_model_visualization' \
'soft_hand_description' \
)
model_path="$GAZEBO_MODEL_PATH"
for package in "${packages[@]}"; do
    package_path="$(rospack find $package)"
    package_path=$(echo ${package_path%/*})
    case ":$model_path:" in
      *":$package_path:"*) :;;
      *) model_path="$package_path:$model_path";;
    esac
done
export GAZEBO_MODEL_PATH=$model_path
