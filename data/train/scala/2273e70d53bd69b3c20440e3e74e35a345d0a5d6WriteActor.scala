package history

import akka.actor._
import java.io.FileWriter
import channels.PingMessage

/**
 * WriteActor configuration factory
 */
object WriteActor {
  def props(filename: String) = Props(new WriteActor(filename))
}
/**
 * WriteActor is responsible for storing messages into a file
 *
 * @filename Name of logging file
 *
 */
class WriteActor(filename: String) extends Actor with ActorLogging {

  def receive = {
    // write message to file
    case WriteAction(message,channel) => {
      log.info("store message [" + message + "] to file [" + filename + "]")
      val fw = new FileWriter(filename, true)
      try {
        fw.write(message) 
        fw.write(System.lineSeparator())
        channel ! ContentChange
      } finally fw.close()
      
    }
    // not accept other kinds of message
    case other =>
      log.error("unhandled: " + other)
  }
}