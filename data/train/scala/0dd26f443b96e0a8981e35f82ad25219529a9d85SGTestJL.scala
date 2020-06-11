package org.opensplice.mobile.dev.main.group

import java.io.PrintWriter

import org.opensplice.mobile.dev.common.DDSIdentifier
import org.opensplice.mobile.dev.group.event.{ JoinedGroupEvent, LeftGroupEvent }
import org.opensplice.mobile.dev.group.stable.StableGroup
import org.opensplice.mobile.dev.group.stable.StableGroup.Default.{ defaultClientFactory, defaultExecutorFactory, defaultLeaderFactory }

class SGTestJL(identifier: DDSIdentifier, val WARMUP: Int, val TEST: Int) extends GroupManager {

  val latencies = new Array[Long](TEST)

  var startTimeLeave = 0L
  var startTimeJoin = 0L

  var iterations = 0;
  var testIterations = 0;
  var testStarted = false;
  var testStopped = false;

  var droppedJoins = 0
  var droppedLeaves = 0
  nuvo.spaces.Config.registerTypes()
  val group = StableGroup(identifier)
  println("Created Group")
  var joined = false;

  group.events += {
    case e: JoinedGroupEvent => {
      //println("JoinedGroupEvent")
      if (!testStopped && !joined && e.memberIds.find(elem => elem.equals(identifier.actorId)).isDefined) {
        //println("Me Joined")
        if (iterations % 10000 == 0)
          println(iterations)

        iterations = iterations + 1

        if (testStarted) {
          latencies(testIterations) = System.nanoTime() - startTimeJoin
          testIterations = testIterations + 1
        }

        if (!testStarted && iterations == WARMUP) {
          manageTestStart()
        }

        if (testStarted && testIterations >= TEST) {
          manageTestEnd
        }

        joined = true;

        //Thread.sleep(1);

        if (testStarted) {
          startTimeLeave = System.nanoTime()
        }

        group.leave;
      } else {
        // println("Other Joined")
        droppedJoins += 1
      }
    }

    case e: LeftGroupEvent =>
      {
        //println("LeftGroupEvent")
        if (!testStopped && joined && e.memberIds.find(elem => elem.equals(identifier.actorId)).isDefined) {
          //println("Me Left")
          if (iterations % 10000 == 0)
            println(iterations)

          iterations = iterations + 1

          if (testStarted) {
            latencies(testIterations) = System.nanoTime() - startTimeLeave
            testIterations = testIterations + 1
          }

          if (!testStarted && iterations == WARMUP) {
            manageTestStart()
          }

          if (testStarted && testIterations >= TEST) {
            manageTestEnd
          }

          joined = false;

          //Thread.sleep(1);

          if (testStarted) {
            startTimeJoin = System.nanoTime()
          }

          group.join;
        } else {
          //println("Other Left")
          droppedLeaves += 1
        }
      }

    case e => { println(e) }
  }

  println("Joining")
  group.join();

  def manageTestEnd() {
    println("##### TEST END ##### " + Thread.currentThread().getName())
    testStarted = false;
    testStopped = true;
    group.events += {
      case _ => {}
    }
    joined = false;

    new Thread(new InnerThread()).start

    class InnerThread extends Runnable {

      override def run() {
        import java.io.PrintWriter
        val writer = new PrintWriter("data")

        for (i <- 0 to (latencies.length - 1)) {
          writer.print("%d\n".format(latencies(i)))

        }
        writer.close()
        println("Dropped Joins: %d, Leaves: %d".format(droppedJoins, droppedLeaves))

        Thread.sleep(5000)
        println("##### TEST END ##### " + Thread.currentThread().getName())

      }

    }
  }

  def manageTestStart() {
    println("##### TEST START #####")
    testStarted = true;
  }

  override def manageCommand(commands: List[String]) {
  }

  override def manageArgs(args: List[String]) {
    args match {
      case Nil => {

      }

      case _ => {
        println("Stable Group Test Join Leave:\n" +
          "no options! ")
      }
    }
  }

}