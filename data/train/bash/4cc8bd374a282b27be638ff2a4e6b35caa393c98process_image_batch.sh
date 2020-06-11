#!/bin/bash

# 图片处理可执行程序
# process_image="/opt/opencv-procfess-image/process_image"
process_image="./process_image"

# 处理目录
from=$(realpath ${1:-"from"})
# 目标目录
to=$(realpath ${2:-"to"})
# Gamma 值
gamma=${3:-1}

if [ ! -x "${process_image}" ]; then
  echo "$process_image not found."
  exit 1
fi

if [ ! -d "${from}" ]; then
  echo "$from not found."
  exit 1
fi

if [ ! -d "${to}" ]; then
  echo "$to not found."
  exit 1
fi

for file in `find $from -type f -name "*.jpg" -depth 1`
do
  echo "Process image: $file"
  $process_image "${file}" "${to}/$(basename $file)" "$gamma" >/dev/null 2>&1
done

exit 0
