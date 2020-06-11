package datapreprocessing

import datapreprocessing.cleancolumn.{CleanColumnManage,CleanColumn}
import datapreprocessing.cleanvalue.CleanValueManage
import datapreprocessing.datatrainsformation.TransformerManage
import datapreprocessing.columnselection.ColumnSelectionManage
import scala.collection.mutable.HashMap
import org.apache.spark.rdd.RDD
import org.apache.spark.mllib.linalg.{Vector,Vectors}
import scala.reflect.ClassTag


/**
 * 数据预处理管理类。
 * 使用params中的参数，做数据预处理。
 * @author Administrator 吴雨凯
 * 
 * */
class DataDeal(params:HashMap[String,String]) {
  
  
  
  private var cleanColumn:CleanColumnManage         = null
  private var cleanValue:CleanValueManage           = null
  private var valueTransformation:TransformerManage = null
  private var columnSelection:ColumnSelectionManage = null
  private var model:DataPreprocessingModel          = null
  
  require(params != null && !params.isEmpty,"参数列表为空")
  
  private def createDealStep(){
    val cc = params.get("clean.column").get.toBoolean
    if(cc) cleanColumn = new CleanColumnManage(params)
    val cv = params.get("clean.value").get.toBoolean 
    if(cv) cleanValue = new CleanValueManage(params)
    val vt = params.get("transform.value").get.toBoolean
    if(vt) valueTransformation = new TransformerManage(params)
    val cs = params.get("column.selection").get.toBoolean
    if(cs) columnSelection = new ColumnSelectionManage(params)
    
  }
  
  def cleanData(analysis:RDD[Array[String]]):RDD[Array[String]] = {
    analysis.cache
    val statistics = analysisReady(analysis)
    val count = statistics.count
    if(count == 0) {
      throw new Exception("输入数据量为0,请重新选择数据源作为输入数据")
    } else{
      println("预处理数据为:" + count + "条")
    }
    createDealStep()
    var dataSet = analysis
    var colNum = params.get("column.num").get.toInt
    var stayCol = (0 until colNum).toArray
    if(cleanColumn != null) {
      println("开始字段清洗:  ")
      val colTemp = cleanColumn.runClean(statistics, dataSet)
      stayCol = for(id <- stayCol if colTemp.contains(id)) yield id
      if(stayCol.length < 2 || dataSet.count == 0) {
        throw new Exception("字段清洗阈值设置过高,过滤后字段为:"+ stayCol.mkString("[",",","]") + ",字段数不足2列,或记录数为0,无法进行下一步操作，建议重新选择值清洗参数！")
      }

      println("字段清洗结果为:" + stayCol.mkString("[",",","]"))
      println("字段清洗结束:")
    }
    if(cleanValue != null) {
      println("数值清洗开始")
      println("清洗前记录数为: " + dataSet.count)
      dataSet = cleanValue.runCleanValue(analysis, statistics)
      println("数据清洗结束,记录数为:" + dataSet.count)
    }
    if(valueTransformation != null) {
      println("数据变换开始:")
      dataSet = valueTransformation.runTransform(analysis, statistics)
      println("数据变换结束:")
    }
    if(columnSelection != null) {
      println("字段选择开始")
      println("字段选择开始记录条数为" + dataSet.count)
      val colTemp = columnSelection.runSelection(dataSet)
      stayCol = for(id <- stayCol if colTemp.contains(id)) yield id
      println("字段选择结果:"+ colTemp.mkString("[",",","]"))
      println("字段选择结束")
    }
    println("最终结果: ")
    println("选择的字段ID为:" + stayCol.mkString("[",",","]"))
    println("数据清洗结束")
    if(stayCol.isEmpty){
      throw new Exception("最终确认字段为空，建议重新设置参数！")
    }
    model = new DataPreprocessingModel(stayCol,valueTransformation)
    util.columnFilterArray(dataSet, stayCol)
  }
  
  def createModel(): DataPreprocessingModel = {
    require(model != null , "请先训练 ，  再获得模型！")
    model
  }
  
  
  /**
   * 初步分析数据 ，得到数据集相关参数，为之后的数据预处理做准备
   * 1、得到数据基础信息
   * 2、得到数据基础统计数据
   * */
  private def analysisReady(dataSet:RDD[Array[String]]):preAnalysis = {
    val statistic = dataSet.aggregate(new preAnalysis)(
        (agg,value) => agg.add(value), 
        (agg1,agg2) => agg1.merge(agg2))
    val dataColumn = statistic.columnNum
    params("column.num") = dataColumn.toString
    //自助判断是分类字段还是连续字段
    val userIndicateCateCol = util.arrFromParamsInt(params, "catecategorical.col").map(_.toInt)
    val uniqueValue = statistic.uniqueNumCount
    val catecategoricalCol = for(i <-  0 until dataColumn if uniqueValue(i) < 10) yield i
    
    println("用户指定的分类字段为:" + userIndicateCateCol.mkString(","))
    println("计算得到的分类字段为:" + catecategoricalCol.mkString(","))
    val newCateCol = (userIndicateCateCol ++ catecategoricalCol).distinct.mkString(",")
    params("catecategorical.col") = newCateCol
    println("得到分类字段为:" + newCateCol)
    statistic
  }

}

object DataDeal {
  
  implicit def javaHashMapToScalaHashMap(jhm:java.util.HashMap[String,String]):HashMap[String,String] = {
    val params = new HashMap[String,String]()
    jhm.toArray.foreach{
      case(key,value) => params(key) = value
    }
    params
  } 
  
}
