
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



##############HDFS
hadoop fs -rmr /user/hduser0401/sample/test02
hadoop fs -ls /user/hduser0401/sample/test02

##hdfs don't need the queue 
hadoop jar FileCopyWithProgress.jar \
./quangle.txt \
/user/hduser0401/sample/test02/quangle.txt

hadoop dfs -ls /user/hduser0401/sample/test02


hadoop dfs -lsr /user/hduser0401/sample/test01 /user/hduser0401/sample/test02
hadoop jar ListStatus.jar /user/hduser0401/sample/test01 /user/hduser0401/sample/test02 


hadoop jar ListStatus.jar /user/hduser0401/sample/test03



