package fr.limsi.iles.cpm.process

import java.io.File
import java.nio.charset.Charset
import java.util.UUID
import java.util.concurrent.Executors

import com.typesafe.scalalogging.LazyLogging

import fr.limsi.iles.cpm.server.Server
import fr.limsi.iles.cpm.utils.ConfManager
import org.zeromq.ZMQ

import scala.collection.mutable
import scala.sys.process.{Process}


object ProcessCMDMessage{
  implicit def fromString(message:String):ProcessCMDMessage={
    val frames = getFrames(message)
    new ProcessCMDMessage(UUID.fromString(frames("ID")),
      frames("NS"),
      frames("PORT"),
      frames("CMD"),
      frames.get("IMAGE"),
      new File(frames("DEF")),
      new File(frames("RUN")),
      frames("OPT"),
      frames("UNIQ").toBoolean,
      frames("STATUS"),
      frames("NTHREADS").toInt
    )
  }

  protected def getFrames(rawmessage:String) : Map[String,String] = {
    val matches = """==(?s)([A-Z]+)==(.*?)==END_\1==""".r.findAllMatchIn(rawmessage)
    matches.foldLeft(Map[String,String]())((map,matchelt)=>{
      map + (matchelt.group(1) -> matchelt.group(2))
    })
  }
}

class ProcessCMDMessage(val id:UUID,val namespace:String,val processPort:String,val cmd:String,val dockerimagename:Option[String],val deffolder:File,val runfolder:File,val dockeropts:String,val unique:Boolean,val status:String,val nthreads:Int){
  var process : Option[Process] = None
  def format():String={
    val dockimg = if(dockerimagename.isDefined){
      "==IMAGE=="+dockerimagename.get+"==END_IMAGE=="
    }else{
      ""
    }
    "==ID=="+id.toString+"==END_ID=="+
    "==NS=="+namespace+"==END_NS=="+
      "==PORT=="+processPort+"==END_PORT=="+
      "==CMD=="+cmd+"==END_CMD=="+
      dockimg+
      "==DEF=="+deffolder.getCanonicalPath+"==END_DEF=="+
      "==RUN=="+runfolder.getCanonicalPath+"==END_RUN=="+
      "==OPT=="+dockeropts+"==END_OPT=="+
      "==UNIQ=="+String.valueOf(unique)+"==END_UNIQ=="+
      "==NTHREADS=="+String.valueOf(nthreads)+"==END_NTHREADS=="
  }

  val message = format()

  def send(): Unit ={
    val socketsend = Server.context.socket(ZMQ.PUSH)
    socketsend.connect("inproc://processmanager")
    socketsend.send("==STATUS==STARTED==END_STATUS=="+message)
    socketsend.close()
  }

  def end():Unit={
    val socketexit = Server.context.socket(ZMQ.PUSH)
    socketexit.connect("inproc://processmanager")
    socketexit.send("==STATUS==ENDED==END_STATUS=="+message)
    socketexit.close()
  }

}


class ExecutableProcessCMDMessage(processcmdmessage:ProcessCMDMessage) extends LazyLogging{
  def execute()={
    ProcessManager.runningProcess += processcmdmessage.nthreads
    // if non docker , create new thread else run docker
    var process :Process = null
    val containername = if(processcmdmessage.dockerimagename.isDefined){
      val containerName = DockerManager.serviceExec(
        processcmdmessage.id,
        processcmdmessage.namespace,
        "localhost",
        processcmdmessage.processPort,
        processcmdmessage.cmd,
        processcmdmessage.deffolder,
        processcmdmessage.dockerimagename.get,
        processcmdmessage.runfolder,
        processcmdmessage.dockeropts,
        processcmdmessage.unique)

      Some(containerName)
    }else{
      val absolutecmd = processcmdmessage.cmd.replace("\n"," ").replaceAll("^\\./",processcmdmessage.deffolder.getCanonicalPath+"/")
      val cmdtolaunch = "python "+ConfManager.get("cpm_home_dir")+"/"+ConfManager.get("process_shell_bin")+" false "+
        processcmdmessage.id.toString+" "+processcmdmessage.namespace+" "+processcmdmessage.processPort+" "+processcmdmessage.runfolder.getCanonicalPath+" "+absolutecmd+""

      process = Process(cmdtolaunch,processcmdmessage.runfolder).run()

      ProcessManager.nonDockerExecutorsService.execute(new Runnable {
        override def run(): Unit = {


          processcmdmessage.process = Some(process)
          process.exitValue()

        }
      })

      None

    }

    logger.debug("Waiting for lock containerMap")
    ProcessManager.containersmap.synchronized{
      logger.debug("Acquired lock containerMap")
      if(containername.isDefined) {
        ProcessManager.containersmap += (processcmdmessage.id.toString -> ProcessContainerDocker(containername.get,processcmdmessage.dockerimagename))
      }else{
        ProcessManager.containersmap += (processcmdmessage.id.toString -> ProcessContainerHostWrap(process))
      }

      logger.debug("Released lock containerMap")
    }

  }

}

sealed class ProcessContainer
case class ProcessContainerDocker(uid:String,imagename :Option[String]) extends ProcessContainer
case class ProcessContainerHostWrap(process:Process) extends ProcessContainer

/**
 * Created by buiquang on 4/7/16.
 */
object ProcessManager extends Thread with LazyLogging {

  val maxProcess : Int = Integer.valueOf(ConfManager.get("maxproc").toString)
  var processQueue :mutable.Queue[ProcessCMDMessage] = mutable.Queue[ProcessCMDMessage]()
  var runningProcess = 0
  val nonDockerExecutorsService = Executors.newFixedThreadPool(maxProcess)
  var containersmap = mutable.Map[String,ProcessContainer]()
  var abstractProcessQueue:mutable.Queue[AbstractProcess] = mutable.Queue[AbstractProcess]()
  var masterProcessQueue:mutable.Queue[MasterProcessShell] = mutable.Queue[MasterProcessShell]()
  var runningProcessGrid = mutable.ArrayBuffer[ProcessCMDMessage]()

  def getLoad():String={
    runningProcess.toString+"/"+maxProcess.toString
  }

  def addMasterToQueue(process:MasterProcessShell):Boolean={
    ProcessManager.processQueue.synchronized{
      logger.debug("Acquired lock processQueue")
      if (runningProcess<=maxProcess){
        process.run()
        true
      }else{
        masterProcessQueue.enqueue(process)
        false
      }
    }
  }

  def addToQueue(process:AbstractProcess):Boolean={
    logger.debug("Waiting for lock processQueue")
    ProcessManager.processQueue.synchronized{
      logger.debug("Acquired lock processQueue")
      if (runningProcess<=maxProcess){
        process.run()
        true
      }else{
        abstractProcessQueue.enqueue(process)
        false
      }
    }
  }

  def debugPrint():String={
    containersmap.synchronized {
      runningProcess.toString + "\n" +
        containersmap.foldLeft("")((agg,el)=>{
          val proc = ProcessRunManager.getProcess(UUID.fromString(el._1))
          agg + proc.moduleval.moduledef.name +" : "+el._1 + "\n"
        })
    }
  }

  // remove also queued process
  def kill(pid:String):Unit={

    ProcessManager.containersmap.synchronized{
      val p = ProcessManager.containersmap.find((el)=>pid==el._1)
      if(p.isDefined){
        p.get._2 match {
          case ProcessContainerDocker(uid,imagename)=>{
            DockerManager.updateServiceStatus(Some(uid),imagename,false)
          }
          case ProcessContainerHostWrap(process)=>{
            process.destroy()
          }
        }
      }
    }
  }


  override def run()={

    // listen to new incomming process
      val socket = Server.context.socket(ZMQ.PULL)

      socket.bind("inproc://processmanager")

      while (true){
        val processmessage :ProcessCMDMessage= socket.recvStr(Charset.defaultCharset())
        logger.debug("receiving process cmd : "+processmessage.cmd)

        if(processmessage.status=="STARTED") {
          logger.debug("Waiting for lock processQueue")
          ProcessManager.processQueue.synchronized{
            logger.debug("Acquired lock processQueue")
            logger.debug("nb running process is : "+runningProcess)
            if(runningProcess <=maxProcess){
              logger.debug("executing now")
              new ExecutableProcessCMDMessage(processmessage).execute();
              logger.debug("nb running process is now : "+runningProcess)
            }else{
              logger.debug("enqueing")
              ProcessManager.processQueue.enqueue(processmessage)
              logger.debug("process queue lenght is "+processQueue.length)
            }
            logger.debug("Released lock processQueue")
          }
        }else if(processmessage.status=="ENDED") {
          logger.debug("Waiting for lock processQueue")
          ProcessManager.processQueue.synchronized{
            logger.debug("Acquired lock processQueue")
            runningProcess -= processmessage.nthreads
            logger.debug("nb running process is now : "+runningProcess)
            logger.debug("Waiting for lock containerMap")
            ProcessManager.containersmap.synchronized{
              logger.debug("Acquired lock containerMap")
              if(ProcessManager.containersmap.contains(processmessage.id.toString)){
                ProcessManager.containersmap(processmessage.id.toString) match {
                  case  ProcessContainerDocker(uid,imagename)=>{
                    DockerManager.updateServiceStatus(Some(uid),processmessage.dockerimagename,false)
                  }
                  case ProcessContainerHostWrap(process)=>{

                  }
                }

                ProcessManager.containersmap -= processmessage.id.toString
              }
              logger.debug("Released lock containerMap")
            }


            if(runningProcess<=maxProcess){
              if(processQueue.length>0) {
                val processCmd = processQueue.dequeue()
                logger.debug("process queue lenght is "+processQueue.length)
                new ExecutableProcessCMDMessage(processCmd).execute()
                logger.debug("nb running process is now : "+runningProcess)
              }else if(abstractProcessQueue.length>0){
                logger.debug("Waiting for lock abstractQueue")
                val process = abstractProcessQueue.dequeue()
                logger.debug("running process "+process.moduleval.namespace)
                process.run()
              }else if(masterProcessQueue.length>0){
                val process = masterProcessQueue.dequeue()
                process.run()
              }
            }
            logger.debug("Released lock processQueue")
          }
        }
        else {
          logger.warn("Unknown process status! ("+processmessage.status+")")
        }
      }


    }





}


