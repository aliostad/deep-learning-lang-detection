default[:hadoop_manage][:service][:services] = [ ]
default[:hadoop_manage][:service][:action] = "start"

default[:hadoop_manage][:mapreduce][:job_local_path] = "/tmp/jobs"
default[:hadoop_manage][:mapreduce][:job_url] = ""
default[:hadoop_manage][:mapreduce][:job_parameters] = ""

default[:hadoop_manage][:hdfs][:manage][:dirs] = ""
default[:hadoop_manage][:hdfs][:manage][:owner] = "hdfs"
default[:hadoop_manage][:hdfs][:manage][:action] = "create"

default[:hadoop_manage][:hdfs][:transfer][:source] = ""
default[:hadoop_manage][:hdfs][:transfer][:destination] = ""
default[:hadoop_manage][:hdfs][:transfer][:action] = "put"
 
