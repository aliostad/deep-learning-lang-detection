#!/bin/sh
ls
ls -la test/sample_input
python3.4 test/exercise_1_tester.py "build/exercise_1.exe 5" "test/sample_input/test0" "test/sample_output/wzor0"
python3.4 test/exercise_1_tester.py "build/exercise_1.exe 5" "test/sample_input/test1" "test/sample_output/wzor1"
python3.4 test/exercise_1_tester.py "build/exercise_1.exe 0" "test/sample_input/test0" "test/sample_output/wzor0"
python3.4 test/exercise_1_tester.py "build/exercise_1.exe 0" "test/sample_input/test1" "test/sample_output/wzor1"
python3.4 test/exercise_1_tester.py "build/exercise_1.exe 9999" "test/sample_input/test2" "test/sample_output/wzor2"
python3.4 test/exercise_1_tester.py "build/exercise_1.exe 9999" "test/sample_input/test3" "test/sample_output/wzor3"
python3.4 test/exercise_1_tester.py "build/exercise_1.exe 9999" "test/sample_input/test4" "test/sample_output/wzor4"
python3.4 test/exercise_1_tester.py "build/exercise_1.exe 9999" "test/sample_input/test5" "test/sample_output/wzor5"
python3.4 test/exercise_1_tester.py "build/exercise_1.exe 0" "test/sample_input/test6" "test/sample_output/wzor6"
python3.4 test/exercise_1_tester.py "build/exercise_1.exe 2" "test/sample_input/test7" "test/sample_output/wzor7"
python3.4 test/exercise_1_tester.py "build/exercise_1.exe 1" "test/sample_input/test8" "test/sample_output/wzor8"
python3.4 test/exercise_1_tester.py "build/exercise_1.exe 6" "test/sample_input/test9" "test/sample_output/wzor9"
python3.4 test/exercise_1_tester.py "build/exercise_1.exe 8" "test/sample_input/test10" "test/sample_output/wzor10"
