package cassandra.streams

import akka.NotUsed
import akka.stream.BidiShape
import akka.stream.scaladsl._
import akka.util.ByteString

import util.ByteStrings

object TcpDumpBidi {
  val dump: BidiFlow[ByteString, ByteString, ByteString, ByteString, NotUsed] = BidiFlow.fromGraph(GraphDSL.create() { implicit b =>
    def ios(direction: String) = Flow[ByteString].map { bytes =>
      println(direction + " " + System.currentTimeMillis)
      println(ByteStrings.dump(bytes))
      bytes
    }

    BidiShape.fromFlows(b.add(ios("I ~> O")), b.add(ios("I <~ O")))
  })
}