package io.blep.tda

import java.nio.file.{Files, Paths}

import io.blep.tda.ThreadDumpAnalyzer._

class ThreadDumpAnalyzerTest extends org.scalatest.FunSuite {

  def readDump(fileName:String) = {
    val path = Paths.get(ClassLoader.getSystemResource(fileName).toURI())
    val bytes = Files.readAllBytes(path)
    new String(bytes)
  }

  test("should parse a blocking monitor"){
    val frame = "	- waiting to lock <0x00000000e16e5ca0> (a com.acme.content.AtomicReferenceOptionCache)"

    val expected = Left(BlockingMonitor("0x00000000e16e5ca0", "com.acme.content.AtomicReferenceOptionCache"))

    val res = parseFrame(frame)

    assert(res === expected)
  }

  test("should find 2 owned monitors"){
    val frames =  "	at java.lang.Throwable.fillInStackTrace(Native Method)" ::
                  "	at java.lang.Throwable.fillInStackTrace(Throwable.java:783)" ::
                  "	- locked <0x00000000d32e6e58> (a net.liftweb.json.MappingException)" ::
                  "	at java.lang.Throwable.<init>(Throwable.java:287)" ::
                  "	- locked <0x00000000e16e5ca0> (a com.acme.content.AtomicReferenceOptionCache)" ::
                  "	at com.acme.content.OptionCache$class.onceOtherwise$1(CacheModule.scala:170)" ::
                  "	at java.lang.Thread.run(Thread.java:745)" :: "" :: Nil

    val expected = OwnedMonitor("0x00000000e16e5ca0", "com.acme.content.AtomicReferenceOptionCache") ::
      OwnedMonitor("0x00000000d32e6e58", "net.liftweb.json.MappingException") :: Nil

    val res = parseStackFrames(frames)._1

    assert (res === expected)
  }

  test("should find a blocking monitor"){
    val dump=   "	at com.acme.content.OptionCache$class.onceOtherwise$lzycompute$1(CacheModule.scala:170)" ::
                "	- waiting to lock <0x00000000e16e5ca0> (a com.acme.content.AtomicReferenceOptionCache)" ::
                " at com.acme.content.OptionCache$class.onceOtherwise$1(CacheModule.scala:170)" ::
                " at java.lang.Thread.run(Thread.java:745)" :: "" :: Nil

    val expected = BlockingMonitor("0x00000000e16e5ca0", "com.acme.content.AtomicReferenceOptionCache")::Nil

    val res = parseStackFrames(dump) _1

    assert(res === expected )
  }

  test("should find 2 monitors: waitin + locking"){
    val dump = "	at java.lang.Object.wait(Native Method)" ::
                "	- waiting on <0x00000000e01075c8> (a java.lang.Object)" ::
                "	at java.lang.Object.wait(Object.java:502)" ::
                "	at org.eclipse.jetty.util.thread.QueuedThreadPool.join(QueuedThreadPool.java:381)" ::
                "	- locked <0x00000000e01075c8> (a java.lang.Object)" ::
                "	at org.eclipse.jetty.server.Server.join(Server.java:560)" ::
                "	at org.eclipse.jetty.runner.Runner.run(Runner.java:510)" ::
                "	at org.eclipse.jetty.runner.Runner.main(Runner.java:557)" :: "" :: Nil

    val expected = OwnedMonitor("0x00000000e01075c8", "java.lang.Object") ::
      WaitedMonitor("0x00000000e01075c8","java.lang.Object") :: Nil

    val res = parseStackFrames(dump) _1

    assert(res === expected )

  }

  test("should not find any monitor"){
    val dump=   "	at com.acme.content.OptionCache$class.onceOtherwise$lzycompute$1(CacheModule.scala:170)" ::
                " at com.acme.content.OptionCache$class.onceOtherwise$1(CacheModule.scala:170)" ::
                " at java.lang.Thread.run(Thread.java:745)" :: "" :: Nil

    val expected = Nil

    val res = parseStackFrames(dump)  _1

    assert(res === expected )
  }

  test("should parse a sys thread"){
    val threadStr = """"GC task thread#0 (ParallelGC)" os_prio=31 tid=0x00007fbe2400d000 nid=0x2103 runnable"""

    val before: ParsingThreads = ParsingThreads("","")
    val after = parseThread(threadStr::Nil, before)._1

    assert(after.systemThreads.head === SysThread("0x00007fbe2400d000","GC task thread#0 (ParallelGC)"))
  }

  test("should read the thread id"){
        val lines = """"Attach Listener" #1101 daemon prio=9 os_prio=31 tid=0x00007fbe248c9800 nid=0x768b waiting on condition [0x0000000000000000]""" ::
          """   java.lang.Thread.State: RUNNABLE""" :: Nil

    val (threads , _) = parseThread(lines, ParsingThreads("",""))

    assert(threads.runningThreads.size === 1)
    val thread = threads.runningThreads.head
    assert(thread.id === "0x00007fbe248c9800")

  }

  test("should parse an app thread"){

    val lines = """"Workbench-System-akka.io.pinned-dispatcher-5" #41 prio=5 os_prio=31 tid=0x00007fbe28a9d000 nid=0x5c0f runnable [0x0000000118482000]""" ::
      """   java.lang.Thread.State: RUNNABLE""" ::
      """	at sun.nio.ch.KQueueArrayWrapper.kevent0(Native Method)""" ::
      """	at sun.nio.ch.KQueueArrayWrapper.poll(KQueueArrayWrapper.java:198)""" ::
      """	at sun.nio.ch.KQueueSelectorImpl.doSelect(KQueueSelectorImpl.java:103)""" ::
      """	at sun.nio.ch.SelectorImpl.lockAndDoSelect(SelectorImpl.java:86)""" :: Nil


    val before: ParsingThreads = ParsingThreads("","")
    val (after,_) = parseThread(lines, before)

    val thread: RunningThread = after.runningThreads.head
    assert( thread.isInstanceOf[RunningThread])
    assert( thread.name === "Workbench-System-akka.io.pinned-dispatcher-5")
    assert( thread.state === Runnable(Nil))
    assert( thread.stackTrace.size === 4)
    assert( thread.stackTrace.head === "	at sun.nio.ch.KQueueArrayWrapper.kevent0(Native Method)")

  }

  test("should parse version"){
    val versionLine = "Full thread dump Java HotSpot(TM) 64-Bit Server VM (25.25-b02 mixed mode):"
    val expected = "Java HotSpot(TM) 64-Bit Server VM (25.25-b02 mixed mode)"

    val version = parseVersion(versionLine)

    assert (version === expected)

  }


  test("should read a thread dump"){

    val dumpStr = readDump("full_dump2.txt")
//    val dumpStr = readDump("full_dump1.txt")
    val threadDump = parseDump(dumpStr)

    println("threadDump = " + threadDump)

    val states = threadDump.threads.collect{
      case RunningThread(_,name,state, _) if name != "Finalizer" => state
    }

    assert( threadDump.runningThreads.flatMap(_.state.monitors.filter(!_.isInstanceOf[OwnedMonitor])) === Nil)
    threadDump.blockedThreads.filter(_.name != "Finalizer").foreach(t => assert (t.state.monitors.head.isInstanceOf[BlockingMonitor]))
    threadDump.waitingThreads.foreach(t => assert (t.state.monitors.head.isInstanceOf[WaitedMonitor]))


    println("threadDump.blockedThread.size = " + threadDump.blockedThreads.size)

    println("sharedLocks = " + threadDump.sharedLocks)
//    assert(threadDump.threads.length === 229)
  }


}
