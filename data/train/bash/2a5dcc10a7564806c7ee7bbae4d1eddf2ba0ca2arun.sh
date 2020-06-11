#!/usr/pkg/bin/tcsh

mkdir test_sample
mkdir training_sample

foreach i (1 2 3 4 5)
	mkdir test_sample/face_sample_0${i}
	mkdir test_sample/non_face_0${i}
	mkdir training_sample/non_face_0${i}
	mkdir training_sample/face_sample_0${i}
end

foreach i (0 1 2 3 4)
	cp $1/face/cmu_0${i}* test_sample/face_sample_0`expr ${i} + 1`
	cp $1/non-face/cmu_0${i}* test_sample/non_face_0`expr ${i} + 1`
	cp $2/face/face00${i}* training_sample/face_sample_0`expr ${i} + 1`
	cp $2/non-face/B1_00${i}* training_sample/non_face_0`expr ${i} + 1`
end

cp $2/face/face02429.pgm training_sample/face_sample_01/
cp $2/non-face/GULF_9.pgm training_sample/non_face_01/B1_00000.pgm


if -e result/tp_fp.csv then
	rm result/tp_fp.csv
endif

foreach i (1 2 3 4 5)
	python ./src/classifier_1/feature_extraction.py training_sample/face_sample_0${i}/ training
	python ./src/classifier_1/feature_extraction.py training_sample/non_face_0${i}/ training
	python ./src/classifier_1/feature_extraction.py test_sample/face_sample_0${i}/ testing
	python ./src/classifier_1/feature_extraction.py test_sample/non_face_0${i}/ testing
	python ./src/classifier_1/cal_mean_and_var.py result/classifier_1/training/ face_sample_0${i}_dataset.csv
	python ./src/classifier_1/cal_mean_and_var.py result/classifier_1/training/ non_face_0${i}_dataset.csv
end

foreach i (1 2 3 4 5)
	foreach j (1 2 3 4 5)
	python src/classifier_1/naive_bayes.py result/classifier_1/testing/face_sample_0${j}_dataset.csv result/classifier_1/testing/non_face_0${j}_dataset.csv result/classifier_1/training/mean_face_sample_0${i}_dataset.csv result/classifier_1/training/mean_non_face_0${i}_dataset.csv
	end
end


foreach i (1 2 3 4 5)
	python ./src/classifier_2/feature_extraction.py training_sample/face_sample_0${i}/ training
	python ./src/classifier_2/feature_extraction.py training_sample/non_face_0${i}/ training
	python ./src/classifier_2/feature_extraction.py test_sample/face_sample_0${i}/ testing
	python ./src/classifier_2/feature_extraction.py test_sample/non_face_0${i}/ testing
	python ./src/classifier_2/cal_mean_and_var.py result/classifier_2/training/ face_sample_0${i}_dataset.csv
	python ./src/classifier_2/cal_mean_and_var.py result/classifier_2/training/ non_face_0${i}_dataset.csv
end

foreach i (1 2 3 4 5)
	foreach j (1 2 3 4 5)
	python src/classifier_2/naive_bayes.py result/classifier_2/testing/face_sample_0${j}_dataset.csv result/classifier_2/testing/non_face_0${j}_dataset.csv result/classifier_2/training/mean_face_sample_0${i}_dataset.csv result/classifier_2/training/mean_non_face_0${i}_dataset.csv
	end
end



Rscript src/roc.r
#mv Rplots.pdf result/
rm result/roc.png
