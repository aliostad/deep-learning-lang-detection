javac TreeParser.java
java TreeParser < data/sample_input1.txt > data/sample_progOutput1.txt
cmp data/sample_progOutput1.txt data/sample_output1.txt

java TreeParser < data/sample_input2.txt > data/sample_progOutput2.txt
cmp data/sample_progOutput2.txt data/sample_output2.txt

if cmp -s data/sample_progOutput1.txt data/sample_output1.txt
then
   echo "Sanity Test"1" Passed!"
else
   echo "Output Differs"
   echo "run vimdiff data/sample_progOutput.txt data/sample_output.txt"
fi

if cmp -s data/sample_progOutput1.txt data/sample_output1.txt
	then
   echo "Sanity Test"2" Passed!"
else
   echo "Output Differs"
   echo "run vimdiff data/sample_progOutput.txt data/sample_output.txt"
fi
