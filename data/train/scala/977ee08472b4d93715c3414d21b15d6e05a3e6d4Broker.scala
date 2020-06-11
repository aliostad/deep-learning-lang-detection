package widebase.stream.socket.rq.test

import net.liftweb.common. { Loggable, Logger }

/* A broker test.
 *
 * Run:
 *
 * test:run-main widebase.stream.socket.rq.test.Broker -a etc/widebase-broker/auths.properties usr/sync/test/db
 *
 * @author myst3r10n
 */
object Broker extends Logger with Loggable {

  import widebase.stream.socket.rq

  def main(args: Array[String]) {

    val broker = rq.broker

    var i = 0

    while(i < args.length) {

      args(i) match {

        case "-a" =>
          i += 1
          broker.load(args(i))

        case "-f" =>
          i += 1
          broker.filter(args(i))

        case "-i" =>
          i += 1
          broker.interval = args(i).toInt

        case "-p" =>
          i += 1
          broker.port = args(i).toInt

        case path: String =>
          broker.path = path

        case _ =>
          error("Unfamiliar with argument: " + args(i))
          sys.exit(1)

      }

      i += 1

    }

    try {

      broker.bind

      info("Listen on " + broker.port)

      broker.await

    } catch {

      case e =>
        e.printStackTrace
        sys.exit(1)

    } finally {

      broker.close

    }
  }
}

