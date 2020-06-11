package ru.bugzmanov.jstackcompact

import org.scalatest._

class CompactedThreadDumpTest extends FlatSpec with Matchers {

  "CompactedThreadDump trasform" should "collapse threads in same state" in {

    val threadDump = ThreadStack(
      """"NGSession 22: (idle) read chunk thread (NGInputStream pool) (idle)" prio=5 tid=0x00007fea3b82b000 nid=0x5a03 waiting on condition [0x0000700001961000]
        |   java.lang.Thread.State: WAITING (parking)
        |	at sun.misc.Unsafe.park(Native Method)
        |	- parking to wait for  <0x00000007eeb30078> (a java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject)
        |	at java.util.concurrent.locks.LockSupport.park(LockSupport.java:186)
        |	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
        |	at java.lang.Thread.run(Thread.java:745)""".stripMargin)

    val secondDump = ThreadStack(
      """"NGSession 13: (idle) read chunk thread (NGInputStream pool) (idle)" prio=5 tid=0x00007fea3b07d800 nid=0x5c03 waiting on condition [0x0000700001a64000]
        |   java.lang.Thread.State: WAITING (parking)
        |	at sun.misc.Unsafe.park(Native Method)
        |	- parking to wait for  <0x00000007eeb30078> (a java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject)
        |	at java.util.concurrent.locks.LockSupport.park(LockSupport.java:186)
        |	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
        |	at java.lang.Thread.run(Thread.java:745)""".stripMargin)

    val result = CompactedThreadDump.transform(Vector(threadDump, secondDump))

    result should have size 1
    result.head.threads should have size 2
    result.head.threads should contain("\"NGSession 13: (idle) read chunk thread (NGInputStream pool) (idle)\" prio=5 tid=0x00007fea3b07d800 nid=0x5c03 waiting on condition [0x0000700001a64000]")
    result.head.threads should contain("\"NGSession 22: (idle) read chunk thread (NGInputStream pool) (idle)\" prio=5 tid=0x00007fea3b82b000 nid=0x5a03 waiting on condition [0x0000700001961000]")

    result.head.state should be(threadDump.state)
    result.head.traceElement should be(threadDump.traceElements)
  }

  "CompactedThreadDump transform" should "distinguish threads in different states" in {
    val threadDump = ThreadStack(
      """"NGSession 22: (idle) read chunk thread (NGInputStream pool) (idle)" prio=5 tid=0x00007fea3b82b000 nid=0x5a03 waiting on condition [0x0000700001961000]
        |   java.lang.Thread.State: WAITING (parking)
        |	at sun.misc.Unsafe.park(Native Method)
        |	at java.lang.Thread.run(Thread.java:745)""".stripMargin)

    val secondDump = ThreadStack(
      """"NGSession 13: (idle) read chunk thread (NGInputStream pool) (idle)" prio=5 tid=0x00007fea3b07d800 nid=0x5c03 waiting on condition [0x0000700001a64000]
        |   java.lang.Thread.State: RUNNING (parking)
        |	at sun.misc.Unsafe.park(Native Method)
        |	at java.lang.Thread.run(Thread.java:745)""".stripMargin)

    val result = CompactedThreadDump.transform(Vector(threadDump, secondDump))

    result should have size 2
  }

}
