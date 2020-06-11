package internet_user_churn.extract

import core.SparkApplication
import org.joda.time.DateTime

/**
  * Created by hungdv on 10/04/2017.
  */
class LoadExtractJob(config:LoadJobConfig, date: DateTime) extends SparkApplication{

  override def sparkConfig: Map[String, String] = config.sparkConfig
  def outputRoot                                = config.outputRootFolder

  def start(): Unit ={
    withSparkSession{(ssc) =>
      val loadExtracter = new LoadExtract(ssc,date,config.inputRootFolder,config.outputRootFolder)
      loadExtracter.loadExtract()
    }
  }

}
//FIXME add prameter parsing -t today or -a adhoc with specific datetime
object LoadExtractJob{
  def main(args: Array[String]): Unit = {
    val config = LoadJobConfig()
    val loadExtractJob = new LoadExtractJob(config,DateTime.now().minusDays(2))
    loadExtractJob.start()
  }
}

