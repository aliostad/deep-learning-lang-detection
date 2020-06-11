package models.agents

import akka.actor.Actor
import models.agents.AgentsMsg.{HeapDump, UploadToS3}
import scala.sys.process._
import play.api.Logger

class HeapDumpGenerator extends Actor {

  private val jmapCmd = "jmap -dump:live,format=b,file="
  private val lcpProcessName = Constants.LCP_PROCESS_NAME

  def receive = {
    case HeapDump(source:String, eventId:String) =>
      source.toUpperCase match {
        case "LCP" =>
          generateHeapDump("lcp", lcpProcessName, eventId)

        case _ =>
          Logger.warn("Unrecognized message in HeapDumpGenerator actor")

      }

  }


  def generateHeapDump(source:String, processName:String, eventId:String) = {
    try {
      val pidList = ShellCmd.getPIDByProcessName(processName)

      for(p <- pidList) {
        Logger.info(s"generating heap dump for process-id $p")

        val heapDumpDir = Constants.monitorLogsPath + eventId + "/heapdumps/" + Constants.NODE_IP + "/"
        val dumpFilePath = heapDumpDir + s"${source}_$p.hprof"

        if(ShellCmd.createDir(heapDumpDir)) {
          val dumpS3Path = Constants.S3_BASE_PATH + eventId + "/heapdumps/" + Constants.NODE_IP + s"/${source}_$p.hprof"
          val status = s"$jmapCmd$dumpFilePath $p".!
          if(status == 0) {
            val s3Actor = ActorSupervisor.get("S3UPLOADER")
            Logger.info(s"Generated heap dump for $p. Now uploading it to s3")
            s3Actor ! UploadToS3(isDir = false, dumpFilePath, dumpS3Path)
          } else {
            Logger.info(s"Failed to generate heap dump for pid=$p")
          }
        } else {
          Logger.info(s"Error while create dir. $heapDumpDir")
        }
      }

    } catch {
      case ex:Exception =>
        println("Exception while getting lcp process id to generate heap dump")
    }
  }

}
