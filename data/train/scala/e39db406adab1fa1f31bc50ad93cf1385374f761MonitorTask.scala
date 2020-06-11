package tools.redis.load

import java.text.SimpleDateFormat
import java.util.{Date, TimerTask}

/**
 * Created by tsingfu on 15/6/11.
 */
class MonitorTask(loadStatus: LoadStatus, reportIntervalSeconds: Long) extends TimerTask{

  val sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")

  override def run(): Unit = {
    val runningTimeMs = System.currentTimeMillis() - loadStatus.startTimeMs
    val loadSpeedPerSec = loadStatus.numProcessed * 1.0 / runningTimeMs * 1000
    val loadSpeedPerSecLastMonitored = (loadStatus.numScanned - loadStatus.numProcessedlastMonitored) * 1.0 / reportIntervalSeconds / 1000
    loadStatus.numProcessedlastMonitored = loadStatus.numProcessed

    println(sdf.format(new Date()) + " [INFO] loadding statistics:  numTotal = "+loadStatus.numTotal+
            ", numScanned = " + loadStatus.numScanned +", numBatches = "+loadStatus.numBatches +
            ", numProcessed = " + loadStatus.numProcessed + ", numProcessedBatches = "+loadStatus.numBatchesProcessed+
            ", runningTime = " + runningTimeMs +" ms <=> " + runningTimeMs / 1000.0  +" s <=> " + runningTimeMs / 1000.0 / 60 +" min" +
            ", loadSpeed = " + loadSpeedPerSec +" records/s => " + (loadSpeedPerSec * 60) + " records/min <=> " + (loadSpeedPerSec * 60 * 60) +" records/h" +
            ", loadSpeedLastMonitored = " + loadSpeedPerSecLastMonitored +" records/s <=> " + loadSpeedPerSecLastMonitored * 60 +" records/min  " +
            "<=> " + (loadSpeedPerSecLastMonitored * 60 * 60) +" records/h" +
            ", loadProgress percent of numProcessed = " + loadStatus.numProcessed * 1.0 / loadStatus.numTotal * 100 +"%" +
            ", loadProgress percent of numBatchesProcessed = " + loadStatus.numBatchesProcessed * 1.0 / loadStatus.numBatches * 100 +"%" )
  }
}
