//When the actor is stopped, it will also stop the stream.
// Expanding on the example above, I will make the stream infinite and use a KillSwitch to manage the life-cycle of the stream.
class PrintMoreNumbers(implicit materializer: ActorMaterializer) extends Actor {
  private implicit val executionContext = context.system.dispatcher

  private val (killSwitch, done) =
    Source.tick(0 seconds, 1 second, 1)
    .scan(0)(_ + _)
    .map(_.toString)
    .viaMat(KillSwitches.single)(Keep.right)
    .toMat(Sink.foreach(println))(Keep.both)
    .run()

  done.map(_ => self ! "done")

  override def receive: Receive = {
    case "stop" =>
      println("Stopping")
      killSwitch.shutdown()
    case "done" =>
      println("Done")
      context.stop(self)
  }
}
