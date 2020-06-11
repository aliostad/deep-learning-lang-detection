package datapreprocessing

import datapreprocessing.datatrainsformation.TransformerManage
import org.apache.spark.rdd.RDD
import scala.collection.mutable.HashMap


 class DataPreprocessingModel(
       val columnSelection:Array[Int],
       val transformer    :TransformerManage
       ){
  
  def predict(dataSet:RDD[Array[String]]):RDD[Array[String]] = {
    var data = dataSet
    
    if(transformer != null){
        val statistics  = dataSet.aggregate(new preAnalysis)(
            (agg,value) => agg.add(value), 
            (agg1,agg2) => agg1.merge(agg2))
    	data = transformer.runTransform(data, statistics)      
    }
    if(!columnSelection.isEmpty){
    	data = util.columnFilterArray(data,columnSelection)      
    }
    data
  } 

}

object DataPreprocessingModel {
  
  def createModel(cs:Array[Int],params:HashMap[String,String]):DataPreprocessingModel = {
    new DataPreprocessingModel(cs,new TransformerManage(params))    
  }
  
  def modeToString(model:DataPreprocessingModel,params:HashMap[String,String]):String = {
    val col = model.columnSelection.mkString(",")
    val keyAndValue = for((key,value) <- params if key.startsWith("transform")) yield{
      (key,value)
    }
    val paramsStr = keyAndValue.map{
      case(key,value) => 
        key + ":" + value
    }.mkString("@")
    col + "%" + paramsStr
  }
  
  def createModel(modelStr:String):DataPreprocessingModel = {    
    require(modelStr.toArray.contains('%'),"模型字符串不符合规范。")
    val (col,paramsStr) = {
      val temp = modelStr.split("%")
      (temp(0),temp(1))
    }
    val column = col.split(",").map(_.toInt)
    val params = new HashMap[String,String]()
    paramsStr.split("@").foreach(
        value =>{
          val tempStr = value.split(":")
          params(tempStr(0)) = tempStr(1)
        })
    new DataPreprocessingModel(column,new TransformerManage(params))    
  }  
}
