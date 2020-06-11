package gafis.internal.elasticsearch

import java.util.concurrent._

import gafis.service.elasticsearch.InputDataService
import org.gafis.service.elasticsearch.{DataAccessService, ManageIndexService}
import org.gafis.utils.{Constant, JsonUtil}

/**
  * Created by yuchen on 2017/9/6.
  */
class InputDataServiceImpl(dataAccessService: DataAccessService,manageIndexService: ManageIndexService) extends InputDataService{


  object futureController{
    val executors = Executors.newFixedThreadPool(Math.min(Runtime.getRuntime.availableProcessors, 100))
  }

  override def inputDataToIndex(indexName:String,sql: String,uuid:String): Unit = {
    val executors = futureController.executors
    try{
      val listResult = dataAccessService.queryGafisPersonForInputDataToIndex(sql)

      val futureTask  = new FutureTask[Int](new Callable[Int] {
        override def call(): Int = {

          listResult.foreach{
            t =>
              manageIndexService.putDataToIndex(indexName,t.get("ID").get.toString,JsonUtil.mapToJSONStr(t))
              dataAccessService.updateSooResourceSeq(t.get("SEQ").get.toString.toLong,uuid)
          }
          Constant.FUTURE_COMPLETED
        }
      })
      executors.submit(futureTask)
      futureTask.get
    }finally {
      if(!executors.isShutdown) executors.shutdown
    }
  }

  override def initSooResource(indexName: String,sql:String): String = {
    dataAccessService.initSooResource(indexName,sql)
  }
}
