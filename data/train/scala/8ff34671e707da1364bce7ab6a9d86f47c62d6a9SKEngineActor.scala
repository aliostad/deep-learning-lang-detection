package com.neo.sk.arachnez.framework

import akka.actor.Actor.Receive
import akka.actor.{Props, Actor, ActorLogging}
import com.neo.sk.arachnez.commons.SKURL
import com.neo.sk.arachnez.core.Launch
import org.slf4j.{LoggerFactory, Logger}

import scala.collection.mutable
import scala.io.Source

/**
 * Created with IntelliJ IDEA.
 * User: chenlingpeng
 * Date: 2014/10/12
 * Time: 17:16
 *
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//
//   █████▒█    ██  ▄████▄   ██ ▄█▀       ██████╗ ██╗   ██╗ ██████╗
// ▓██   ▒ ██  ▓██▒▒██▀ ▀█   ██▄█▒        ██╔══██╗██║   ██║██╔════╝
// ▒████ ░▓██  ▒██░▒▓█    ▄ ▓███▄░        ██████╔╝██║   ██║██║  ███╗
// ░▓█▒  ░▓▓█  ░██░▒▓▓▄ ▄██▒▓██ █▄        ██╔══██╗██║   ██║██║   ██║
// ░▒█░   ▒▒█████▓ ▒ ▓███▀ ░▒██▒ █▄       ██████╔╝╚██████╔╝╚██████╔╝
//  ▒ ░   ░▒▓▒ ▒ ▒ ░ ░▒ ▒  ░▒ ▒▒ ▓▒       ╚═════╝  ╚═════╝  ╚═════╝
//  ░     ░░▒░ ░ ░   ░  ▒   ░ ░▒ ▒░
//  ░ ░    ░░░ ░ ░ ░        ░ ░░ ░
//           ░     ░ ░      ░  ░
// 
 *
 */
class SKEngineActor extends Actor{
  private val logger: Logger = LoggerFactory.getLogger(classOf[SKEngineActor])
  private var jobNameMap = mutable.HashMap[String, String]()

  override def receive: Receive = {
    case AddJob(seed, properties) =>
      if(jobNameMap.contains(properties.getJobName)){
        val oldJob = context.child(properties.getJobName + "-" + jobNameMap.get(properties.getJobName).get)
        if(oldJob.isDefined){
          context unwatch oldJob.get
          context.stop(oldJob.get)
        }
        jobNameMap.remove(properties.getJobName)
      }

//      val oldJob = context.actorSelection(properties.getJobName + "-*")
//      oldJob ! KillJob
//      context.sto
//      if (oldJob.isDefined) {
//        context unwatch oldJob.get
//        oldJob.get ! KillJob
//      }

      val seeds = Source.fromFile(seed).getLines().toList
      val timestamp = System.currentTimeMillis().toString
      jobNameMap.put(properties.getJobName, timestamp)
      val jobActor = context.actorOf(Props[SKJobActor](new SKJobActor(properties, seeds)), properties.getJobName + "-" + timestamp)
      context watch jobActor
      jobActor ! StartJob
    case AddUrl(url, jobName) =>
      val childJob = context.actorSelection(jobName + "-" + jobNameMap.get(jobName).get)
      childJob ! new SKURL(url, false)

    case KillJob(jobName) =>
      if(jobNameMap.contains(jobName)){
        val oldJob = context.child(jobName + "-" + jobNameMap.get(jobName).get)
        if(oldJob.isDefined){
          context unwatch oldJob.get
          context.stop(oldJob.get)
        }
        jobNameMap.remove(jobName)
      }
  }
}

object SKEngine {
  private val engine = Launch().actorOf(Props[SKEngineActor], "engineActor")
  def apply() = {
    engine
  }

  def addUrl(jobName: String, url: String) = {
//    println("^^^^^^^^^^^^^^^^^^^^^^^^6"+url)
    engine ! AddUrl(url, jobName)
  }
}