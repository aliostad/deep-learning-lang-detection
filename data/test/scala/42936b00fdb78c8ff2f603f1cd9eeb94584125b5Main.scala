package xiatian.knowledge

import akka.actor.ActorSystem
import xiatian.knowledge.api.HttpApiServer
import xiatian.knowledge.models.{Journal, Publication}
import xiatian.knowledge.service.PublicationService

object Main extends App {

  case class Config(dumpIn: Boolean = false,
                    server: Boolean = false,
                    init: Boolean = false,
                    dir: Option[String] = None)

  val parser = new scopt.OptionParser[Config]("bin/knowledge") {
    head("Knowledge Mining from Publications", "1.0")

    opt[Unit]("server").action((_, c) =>
      c.copy(server = true)).text("Start API Server.")

    opt[Unit]("init").action((_, c) =>
      c.copy(init = true)).text("Init the data.")

    opt[Unit]("dumpIn").action((_, c) =>
      c.copy(dumpIn = true)).text("dump publications from directory.")

    opt[String]('d', "dir").optional().
      action((x, c) => c.copy(dir = Some(x))).
      text("Directory, use with other params like dumpIn.")

    help("help").text("prints this usage text")

    note("\n xiatian, xia@ruc.edu.cn.")
  }

  parser.parse(args, Config()) match {
    case Some(config) =>
      if (config.dumpIn) {
        if (config.dir.isEmpty) {
          println("Please specify a directory by parameter d")
        }
        else {
          PublicationService.importFromDir(config.dir.get)
          Publication.terminate()
        }
      }

      if (config.server) {
        startServer()
      }

      if(config.init) {
        Journal.init()
        Journal.terminate()
      }
    case None => {
      println("Wrong parameters :(")
    }
  }

  def startServer(): Unit = {
    val system = ActorSystem("knowledgeSystem")
    implicit val executionContext = system.dispatcher

    val bindingFuture = HttpApiServer.start(system, None)

    sys.addShutdownHook {
      println("shutdown server...")

      //当Rest服务关闭时，同时把system停止
      implicit val executionContext = system.dispatcher
      bindingFuture.flatMap(_.unbind()).onComplete(_ => system.terminate())

      //不用再调用terminate，因为在解除Rest服务端口绑定时，已经调用terminate
      //system.terminate

      println("server closed.")
    }
  }


}