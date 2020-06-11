package babylon.crawler.actor

import akka.actor.{Actor, ActorLogging}
import babylon.crawler.actor.SupervisorActor.DumpReady
import babylon.common.format.PageFormat.PageList
import babylon.crawler.writer.Writer

/**
  * This actor dumps a page list using a writer
  * This is used to save the JSON file of the scraped pages
  */
class DumperActor(writer: Writer[PageList]) extends Actor with ActorLogging {

    import DumperActor._

    def receive: Receive = {
        case Dump(output) =>
            writer.write(output)
            sender ! DumpReady
    }
}

object DumperActor {
    sealed trait Message

    /**
      * The only message supported by this actor: a request to dump the output
      */
    case class Dump(output: PageList) extends Message
}
