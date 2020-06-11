package workflow.model

import org.apache.spark.SparkContext
import org.apache.spark.rdd.RDD
import org.apache.spark.mllib.linalg.{Vectors,Vector}
import org.apache.spark.mllib.regression.LabeledPoint

import scala.reflect.ClassTag
import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.HashMap

import java.io.{PrintWriter,OutputStreamWriter,FileOutputStream,IOException}
import scala.io.Source

import workflow.mathanalysis.util
import workflow.dataset.{DataSet,LabeledData,VectorData}
import workflow.mathanalysis.DataManage





trait DataLearning extends ModelPredict with SaveLoadModel{
  
  /**
   * 运行模型接口
   * */
  def runModel(data:DataSet) 

}


