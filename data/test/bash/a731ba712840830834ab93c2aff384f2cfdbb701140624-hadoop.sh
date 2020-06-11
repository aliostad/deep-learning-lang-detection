hadoop fs -rm /user/hduser0401/sample/sample01/*

hadoop fs -ls /user/hduser0401/sample/sample01/
hadoop fs -ls /user/hduser0401/sample/test01

hadoop fs -cat /user/hduser0401/sample/sample01/file1.txt
hadoop fs -cat /user/hduser0401/sample/sample01/file2.txt

hadoop fs -copyFromLocal ./file1.txt /user/hduser0401/sample/sample01/file1.txt
hadoop fs -copyFromLocal ./file2.txt /user/hduser0401/sample/sample01/file2.txt



hadoop fs -rmr /user/hduser0401/sample/test01

hadoop queue -showacls

hadoop jar AggregateWordCount.jar \
 -D mapred.job.queue.name=queue02 \
 /user/hduser0401/sample/sample01 \
 /user/hduser0401/sample/test01 \
 1 \
 textinputformat

hadoop jar AggregateWordCount.jar \
 -D mapred.job.queue.name=queue02 \
 /user/hduser0401/sample/sample01 \
 /user/hduser0401/sample/test01 \
 10 


hadoop fs -cat /user/hduser0401/sample/test01/part-00000

