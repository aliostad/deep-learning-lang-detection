#! /bin/bash

prefix="sample_pdf/"
png_prefix="sample_png/"
pdf_suffix=".pdf"
png_suffix=".png"
mkdir sample_png/straight
mkdir sample_png/pre_1
mkdir sample_png/pre_2

for d in sample_pdf/* ; do
	pdf_name=${d#$prefix}
	file_name=${pdf_name%$pdf_suffix}
	mkdir sample_png/straight/${file_name}
	mkdir sample_png/pre_1/${file_name}
	mkdir sample_png/pre_2/${file_name}

	# convert to png
	convert $d sample_png/straight/${file_name}/${file_name}.png
	convert -transparent white -fuzz 10% $d sample_png/pre_1/${file_name}/${file_name}.png
	convert -verbose -density 150 -trim $d -quality 100 -sharpen 0x1.0 sample_png/pre_2/${file_name}/${file_name}.png
    
done


