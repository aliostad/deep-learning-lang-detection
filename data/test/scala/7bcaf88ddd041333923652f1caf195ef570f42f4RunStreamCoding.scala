package toolbox8.akka.statemachine

import akka.util.ByteString
import monix.execution.Scheduler.Implicits.global
import monix.reactive.Observable

import scala.io.StdIn
import scala.util.Random
/**
  * Created by pappmar on 18/10/2016.
  */
object RunStreamCoding {

  def generate(count: Int, size: () => Int) = {
    (1 to count)
      .map({ _ =>
        val ba =
          Array.ofDim[Byte](size())
        Random.nextBytes(
          ba
        )
        ByteString.fromArray(
          ba
        )
      })
  }

  def main(args: Array[String]): Unit = {
    val data = generate(10, () => Random.nextInt(100) + 100)

    Observable
      .fromIterable(
        data
      )
      .dump("in")
      .map(Observable.now)
      .transform(StreamCoding.Terminal.encoder)
      .dump("code")
      .transform(StreamCoding.Terminal.decoder)
      .flatMap({ o =>
        o
          .dump("con")
          .foldLeftF(ByteString.empty)(_ ++ _)
      })
//      .mergeMap({ o =>
//
//      })
//      .transform(StreamCoding.Terminal.strict)
      .dump("out")
      .toListL
      .runAsync
      .foreach({ r =>
        println(r sameElements data)
      })

    StdIn.readLine()
  }

}
