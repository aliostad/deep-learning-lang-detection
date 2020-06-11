echo "running problem scripts"
python problem1.py sample_data_problem_1.txt > out1.txt
python problem2.py sample_data_problem_2.txt > out2.txt
python problem3.py sample_data_problem_3_1.txt sample_data_problem_3_2.txt > out3.txt
python problem4.py sample_data_problem_4.txt > out4.txt
python problem5.py sample_data_problem_5.txt > out5.txt
python problem6.py sample_data_problem_6.txt > out6.txt
python problem7.py sample_data_problem_7.txt > out7.txt
python problem8.py sample_data_problem_8.txt > out8.txt
echo "comparing output files"
diff out1.txt sample_output_problem_1.txt
diff out2.txt sample_output_problem_2.txt
diff out3.txt sample_output_problem_3.txt
diff out4.txt sample_output_problem_4.txt
diff out5.txt sample_output_problem_5.txt
diff out6.txt sample_output_problem_6.txt
diff out7.txt sample_output_problem_7.txt
diff out8.txt sample_output_problem_8.txt

