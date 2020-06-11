package tools.redis.load

import java.util.concurrent.FutureTask

import org.slf4j.LoggerFactory

/**
 * Created by tsingfu on 15/6/11.
 */
class LoadStatusUpdateThread(loadStatus: LoadStatus,
                           taskMap: scala.collection.mutable.HashMap[Long, FutureTask[FutureTaskResult]])
        extends Runnable{

  val logger = LoggerFactory.getLogger(this.getClass)

  override def run(): Unit = {
    logger.info("loadStatus.loadFinished = " + loadStatus.loadFinished)

    while (!loadStatus.loadFinished){
      logger.debug("= = " * 10)
      if(taskMap.size == 0){
        logger.debug("update progress info , found taskMap.size = " + taskMap.size+", retry after sleep 1 s ...")
        Thread.sleep(1000)
      } else {
        logger.debug("update progress info , found taskMap.size = " + taskMap.size)
        for(id<-taskMap.keySet){
          val task = taskMap(id)
          if(task.isDone){

            loadStatus.numProcessed += task.get().numProcessed
            loadStatus.numBatchesProcessed += 1

            taskMap.remove(id)
          }
        }
        Thread.sleep(1000)
        logger.debug("loadStatus.loadFinished = " + loadStatus.loadFinished +", taskMap.size = " + taskMap.size)
      }
    }
    logger.info("loadStatus.loadFinished = " + loadStatus.loadFinished +", taskMap.size = " + taskMap.size)

    for(id<-taskMap.keySet) {
      val task = taskMap(id)
      if (task.isDone) {

        loadStatus.numProcessed += task.get().numProcessed
        loadStatus.numBatchesProcessed += 1

        taskMap.remove(id)
      }
    }
  }
}
