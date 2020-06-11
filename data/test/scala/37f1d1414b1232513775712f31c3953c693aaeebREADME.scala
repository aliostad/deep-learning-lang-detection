/**
 * 执行分析任务
 */

// 进入 README.scala 所在目录进行 spark-shell
/*
# linux shell 中的命令
# 进入工程文件下的spark-shell源代码目录
cd ..../ideaProjects/DataMining-of-StationGrid-2014/src/main/spark-shell

export MASTER=local
#SPARK_EXECUTOR_MEMORY=4G SPARK_DRIVER_MEMORY=4G spark-shell
SPARK_DRIVER_MEMORY=3G spark-shell

*/
// ----------------------------------------------------------------------------
// 公共脚本
// 1. 加载数据
:load datamapping-and-caseclass.scala
:load transform-convertTableRow2TableObject.scala
:load loaddata-from-parquet.scala

// ----------------------------------------------------------------------------
// 执行任务 task1-finding-best-k
//// 1. 加载数据
//:load datamapping-and-caseclass.scala
//:load transform-convertTableRow2TableObject.scala
//:load loaddata-from-parquet.scala
// 2. 数据预处理
:load transform-convert2percent.scala
:load task1-finding-best-k/preprocessing.scala
// 3. 执行任务
:load task1-finding-best-k/tryKMeansSmart-v3.scala
:load task1-finding-best-k/ComputeClusterCount.scala
:load task1-finding-best-k/execute-try-kmeans.scala

// ----------------------------------------------------------------------------
// 执行任务 task2-clustering-and-classifying
//// 1. 加载数据
//:load datamapping-and-caseclass.scala
//:load transform-convertTableRow2TableObject.scala
//:load loaddata-from-parquet.scala
// 2. 数据预处理
:load transform-convert2percent.scala
:load task2-clustering-and-classifying/preprocessing.scala

// 3. 加载公共函数
:load task1-finding-best-k/tryKMeansSmart-v3.scala
:load task1-finding-best-k/ComputeClusterCount.scala

// ============ type1
:load task2-clustering-and-classifying/transform-features2vector.scala
:load task2-clustering-and-classifying/type1-all-are-continuous/clusteringData.scala
:load task2-clustering-and-classifying/type1-all-are-continuous/classifyingData-type1-all-are-continuous.scala

// ============ type2-v1
// 利用Clustering 来给数据打标签 (使用了type1的实现)
:load task2-clustering-and-classifying/transform-features2vector.scala
:load task2-clustering-and-classifying/type1-all-are-continuous/clusteringData.scala
// 执行决策树
:load task2-clustering-and-classifying/type2-setting-categorical-v1/classifyingData-type2-setting-categorical.scala

// ============ type2-v2
// 封装函数
:load task2-clustering-and-classifying/type2-setting-categorical-v2/v2-functions.scala
// 封装执行过程的函数 以及执行
:load task2-clustering-and-classifying/type2-setting-categorical-v2/v2-executor.scala

// ----------------------------------------------------------------------------

