package io.tmos.arm

import java.io._
import java.net.{InetAddress, ServerSocket, Socket}
import java.util.concurrent._

import org.scalatest.FunSuite

class ArmSuite extends FunSuite {

  private class SimpleAutoCloseableTest(val msg: String) extends Closeable {
    protected var closed = false
    def except = throw new RuntimeException(msg)
    def isClosed = closed
    override def close(): Unit = closed = true
  }

  implicit val canManageExectorService = new CanManage[ExecutorService] {
    override def withFinally(pool: ExecutorService): Unit = {
      pool.shutdown() // Disable new tasks from being submitted
      try {
        if (!pool.awaitTermination(10, TimeUnit.SECONDS)) { // wait for normal termination
          pool.shutdownNow() // force terminate
          if (!pool.awaitTermination(10, TimeUnit.SECONDS)) // wait for forced termination
            throw new RuntimeException("ExecutorService did not terminate")
        }
      } catch {
        case e: InterruptedException =>
          pool.shutdownNow()  // (Re-)Cancel if current thread also interrupted
          Thread.currentThread().interrupt()  // Preserve interrupt status
      }
    }
  }

  test("Resources should be closed when explicitly managed") {
    val resource: SimpleAutoCloseableTest = new SimpleAutoCloseableTest("1")
    for (r <- manage(resource)) {
      assert(!r.isClosed)
    }
    assert(resource.isClosed)
  }

  test("Resources should be closed when implicitly managed") {
    import io.tmos.arm.Implicits._
    val resource: SimpleAutoCloseableTest = new SimpleAutoCloseableTest("1")
    for (r <- resource) {
      assert(!r.isClosed)
    }
    assert(resource.isClosed)
  }

  test("Resources should be closed in reverse order when foreach-ing over them") {
    var resource1: SimpleAutoCloseableTest = null
    var resource2: SimpleAutoCloseableTest = null
    var resource3: SimpleAutoCloseableTest = null

    resource1 = new SimpleAutoCloseableTest("1") {
      override def close(): Unit = {
        super.close()
        assert(resource2.isClosed)
        assert(resource3.isClosed)
      }
    }

    resource2 = new SimpleAutoCloseableTest("2") {
      override def close(): Unit = {
        super.close()
        assert(!resource1.isClosed)
        assert(resource3.isClosed)
      }
    }

    resource3 = new SimpleAutoCloseableTest("3") {
      override def close(): Unit = {
        super.close()
        assert(!resource1.isClosed)
        assert(!resource2.isClosed)
      }
    }

    for {
      r1 <- manage(resource1)
      r2 <- manage(resource2)
      r3 <- manage(resource3)
    } {
      assert(!r1.isClosed)
      assert(!r2.isClosed)
      assert(!r3.isClosed)
    }

    assert(resource1.isClosed)
    assert(resource2.isClosed)
    assert(resource3.isClosed)
  }

  test("Resources should be closed in reverse order when yield-ing over them") {
    var resource1: SimpleAutoCloseableTest = null
    var resource2: SimpleAutoCloseableTest = null
    var resource3: SimpleAutoCloseableTest = null

    resource1 = new SimpleAutoCloseableTest("1") {
      override def close(): Unit = {
        super.close()
        assert(resource2.isClosed)
        assert(resource3.isClosed)
      }
    }

    resource2 = new SimpleAutoCloseableTest("2") {
      override def close(): Unit = {
        super.close()
        assert(!resource1.isClosed)
        assert(resource3.isClosed)
      }
    }

    resource3 = new SimpleAutoCloseableTest("3") {
      override def close(): Unit = {
        super.close()
        assert(!resource1.isClosed)
        assert(!resource2.isClosed)
      }
    }

    val value = for {
      r1 <- manage(resource1)
      r2 <- manage(resource2)
      r3 <- manage(resource3)
    } yield r1.msg + r2.msg + r3.msg

    assert(resource1.isClosed)
    assert(resource2.isClosed)
    assert(resource3.isClosed)
    assert(value === "123")
  }

  test("Resource should be closed when exception is thrown") {
    val resource = new SimpleAutoCloseableTest("msg")
    try {
      for { r <- manage(resource) }
        r.except
    } catch {
      case e: RuntimeException =>
        assert(e.getMessage === "msg")
    }
    assert(resource.isClosed)
  }

  test("Correct exception should be propagated when close on resource also excepts whilst currently excepting") {
    val resource = new SimpleAutoCloseableTest("msg1") {
      override def close(): Unit = {
        super.close()
        throw new RuntimeException("msg2")
      }
    }
    try {
      for { r <- manage(resource) }
        r.except
    } catch {
      case e: RuntimeException =>
        assert(e.getMessage === "msg1")
        val suppressed = e.getSuppressed
        assert(suppressed.length === 1)
        assert(suppressed(0).getMessage === "msg2")
    }
    assert(resource.isClosed)
  }

  test("Composing resources and lookup of user defined CanManage should work") {

    import io.tmos.arm.Implicits._

    import scala.collection.JavaConverters._

    val port = new CompletableFuture[Int]

    val callable = new Callable[Unit] {
      override def call(): Unit = {
        for (ss <- new ServerSocket(0, 0, InetAddress.getLoopbackAddress)) {
          port.complete(ss.getLocalPort)
          for {
            connection <- ss.accept
            out <- new PrintWriter(connection.getOutputStream, true)
            in <- new BufferedReader(new InputStreamReader(connection.getInputStream))
            line <- in.lines().iterator().asScala // note not a resource, but now a traversable
          } out.println(line.toUpperCase)
        }
      }
    }

    // manage an executor service using the user defined canManageExectorService.
    // This will shutdown and wait termination
    val completedFuture = for (executorService <- Executors.newSingleThreadExecutor()) yield {
      val future = executorService.submit(callable)

      val upperPhrase = for {
        s <- new Socket(InetAddress.getLoopbackAddress, port.get)
        out <- new PrintWriter(s.getOutputStream, true)
        in <- new BufferedReader(new InputStreamReader(s.getInputStream))
      } yield {
        out.println("hello")
        out.println("world")
        in.readLine() + ' ' + in.readLine()
      }
      assert(upperPhrase === "HELLO WORLD")
      future
    }

    assert(completedFuture.isCancelled || completedFuture.isDone)
    completedFuture.get() // should not block or throw any error

  }

}

