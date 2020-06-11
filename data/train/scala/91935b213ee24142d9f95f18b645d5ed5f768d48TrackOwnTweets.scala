package jessitron.bison

import scalaz.stream._
import async.mutable.Queue
import scalaz.concurrent.Task

object TrackOwnTweets {

  val predicate: Message => Boolean = {m => m.isInstanceOf[TweetThis]}

  def enqueueTweets(q: Queue[Message])(p: Process[Task, Message]): Process[Task, Message] = {
    (p flatMap { m: Message =>
      if(predicate(m))
        Process.tell(m) ++ Process.emitO(m)
      else Process.emitO(m)
    }).drainW(async.toSink(q)) onComplete(Process.suspend {q.close; Process.halt})
  }

  def dropTweeteds: Process1[Message, Message] = process1.filter { ! predicate(_)}

}
