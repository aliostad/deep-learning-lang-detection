#! /bin/bash

file_names=(sample_adequate_1 sample_adequate_2 sample_adequate_3 sample_poor_1 sample_poor_2)
for d in ${file_names[@]}; do
	# open-ocr docker
	bash open_ocr.sh http://192.168.59.103:$HTTP_PORT/ocr-file-upload sample_png/straight/$d/$d-20.png >> sample_output/$d-straight-open_ocr.txt
	bash open_ocr.sh http://192.168.59.103:$HTTP_PORT/ocr-file-upload sample_png/pre_1/$d/$d-20.png >> sample_output/$d-pre_1-open_ocr.txt
	bash open_ocr.sh http://192.168.59.103:$HTTP_PORT/ocr-file-upload sample_png/pre_2/$d/$d-20.png >> sample_output/$d-pre_2-open_ocr.txt

	# okflabs tika/tesseract
	curl -T sample_png/straight/$d/$d-20.png http://192.168.59.103:9998/tika >> sample_output/$d-straight-okf.txt
	curl -T sample_png/pre_1/$d/$d-20.png http://192.168.59.103:9998/tika >> sample_output/$d-pre_1-okf.txt
	curl -T sample_png/pre_2/$d/$d-20.png http://192.168.59.103:9998/tika >> sample_output/$d-pre_2-okf.txt

	#abbyy
	python ABBYY/process.py sample_abbyy/$d.pdf sample_output/$d-abbyy.txt -txt
	python ABBYY/process.py sample_abbyy/$d.pdf sample_output/$d-abbyy.docx -docx
	python ABBYY/process.py sample_abbyy/$d.pdf sample_output/$d-abbyy.xml -xml

done