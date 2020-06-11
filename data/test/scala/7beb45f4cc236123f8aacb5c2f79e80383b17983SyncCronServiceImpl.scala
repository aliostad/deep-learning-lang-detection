package gafis.internal.elasticsearch.sync


import gafis.internal.ExceptionUtil
import gafis.service.elasticsearch.sync.SyncCronService
import org.apache.tapestry5.ioc.annotations.PostInjection
import org.apache.tapestry5.ioc.services.cron.{CronSchedule, PeriodicExecutor}
import org.gafis.service.elasticsearch.{DataAccessService, ManageIndexService}
import org.gafis.utils.{Constant, JsonUtil}
import stark.utils.services.LoggerSupport

/**
  * Created by yuchen 2017/09/04
  */
class SyncCronServiceImpl(manageIndexService:ManageIndexService
                          ,dataAccessService:DataAccessService) extends SyncCronService with LoggerSupport{

  final val SYNC_BATCH_SIZE = 10

  /**
    * 定时器，同步数据
    *
    * @param periodicExecutor
    * @param syncCronService
    */
  @PostInjection
  def startUp(periodicExecutor: PeriodicExecutor, syncCronService: SyncCronService): Unit = {
    if(Constant.webConfig.get.sync.sync_cron != null){
      periodicExecutor.addJob(new CronSchedule(Constant.webConfig.get.sync.sync_cron), "sync-cron", new Runnable {
        override def run(): Unit = {
          info("begin sync-cron")
          try{
            syncCronService.doWork
          }catch{
            case e:Exception =>
              error(ExceptionUtil.getStackTraceInfo(e))
          }
          info("end sync-cron")
        }
      })
    }
  }

  /**
    * 定时任务调用方法
    */
  override def doWork(): Unit = {
    var currentSeq = 0L
    dataAccessService.querySourcesList.foreach{
      t =>
        currentSeq = t.get("SEQ").get.toString.toLong
        syncData(t.get("SQL").get.toString
                ,currentSeq
                ,t.get("NAME").get.toString
                ,t.get("UUID").get.toString)
    }
  }

  private def syncData(sql:String,currentSeq:Long,indexName:String,uuid:String): Unit ={
    val sqlStr = sql.split(";")
    if(currentSeq < dataAccessService.queryMaxSeq(sqlStr(1))){
      val listHashMap = dataAccessService.queryGafisPerson(sqlStr(0),currentSeq + 1,SYNC_BATCH_SIZE)
      listHashMap.foreach{
        t =>
          manageIndexService.updateDataToIndex(indexName,t.get("id").get.toString,JsonUtil.mapToJSONStr(t))
          dataAccessService.updateSooResourceSeq(t.get("SEQ").get.toString.toLong,uuid)
      }
    }
  }
}
