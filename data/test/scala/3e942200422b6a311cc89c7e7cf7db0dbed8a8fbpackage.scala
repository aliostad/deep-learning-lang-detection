package io.tmos

/**
 * ARM4S - Automatic Resource Management for Scala
 *
 * This library provides a way of succinctly dealing with resources in an exception safe manner. The behaviour
 * is identical to Java's exception handling in `try`-with-resources statement and a substitute for scala which does not
 * have an equivalent construct natively.
 *
 * Unlike Java's try-with-resource constructs, managed resources are not limited to `java.lang.AutoClosable`s.
 * Further types such as `java.util.concurrent.ExecutorService` can be supported with implicit converters in user code.
 * See examples below. Also unlike try-with-resource constructs, ARM4S's managed block (the body) can
 * actually yield results, ensuring that resources are closed properly before returning.
 *
 * For example: Parse multiple resources implicitly and yield a result
 * {{{
 *     import io.tmos.arm.Implicits._
 *     import java.io._
 *     import java.net.{Socket, InetAddress, ServerSocket}
 *
 *     val line = for {
 *       socket <- new Socket(InetAddress.getLoopbackAddress, port)
 *       out <- new PrintWriter(socket.getOutputStream, true)
 *       in <- new BufferedReader(new InputStreamReader(socket.getInputStream))
 *     } yield {
 *       val line = in.readLine()
 *       out.println(line.toUpperCase)
 *       return line
 *     }
 * }}}
 * For more examples see, the Examples section below.
 *
 * == Exception Behaviour ==
 * This library differs from other Scala ARM libraries in that it has been designed with consideration for different
 * exception scenarios and with the following goals regarding exception safe behaviour:
 *
 * 1. The [[io.tmos.arm.CanManage.withFinally `withFinally`]] of a managed resource
 *    (delegates to `close` of `AutoCloseable`s) must be called even if the body throws ''any'' `Throwable` exception
 *    including fatal ones to ensure that no resources are leaked. Example of fatal exceptions include anything not
 *    matched by [[scala.util.control.NonFatal$]] such as `InterruptedException`, `ControlThrowable` and
 *    `VirtualMachineError`. Though you should not try to handle such unchecked errors, finally logic should still
 *    (attempted to) be executed regardless.
 *
 * 2. The `withFinally` method may also throw any `Throwable` too. Unfortunately this is a
 *    possibility as permitted by `AutoCloseable`, but gives flexibility in implementing cleanup logic.
 *
 * 3. Importantly, any `Throwable` thrown by `withFinally` should not mask (suppress) any exception thrown firstly by the
 *    body, if any. Instead the secondary exception thrown in the finally clause should be caught and recorded as a
 *    suppressed exception against the primary (currently throwing) exception. This is what Java's try with resource
 *    construct does; for more details, see Oracle's tech article on
 *    [[http://www.oracle.com/technetwork/articles/java/trywithresources-401775.html Try-with-resources]].
 *
 * == Using ARM4S ==
 *
 * There are two ways you can import arm4s.
 *
 * For explicit resource management
 * {{{
 *     import io.tmos.arm._
 *     for (r <- manage(resource))
 *       ...
 * }}}
 * Or implicitly
 * {{{
 *     import io.tmos.arm.Implicits._
 *     for (r <- resource)
 *        ...
 * }}}
 * Any resource of type `T` for which an implicit `CanManage[T]` object is provided in scope can be managed.
 *
 * By default the following `CanManage[T]` that are automatically provided in scope on import
 *   * `type T = java.lang.AutoClosable`
 *   * `type T = { def close() }` - via scala reflection
 *
 * Managed resources may be composed together/chained in a monadic manner that allows for optionally yielding
 * results or imperatively using `for`-comprehensions.
 *
 * The managed resources are automatically closed, and in reverse declaration order.
 *
 * The resources are closed in a `finally` clause regardless of any exception thrown in the body of the
 * `for`-comprehension, or any prior `withFinally` called on other resources.
 *
 * == Examples ==
 * Using [[https://www.scala-lang.org/files/archive/spec/2.12/06-expressions.html#for-comprehensions-and-for-loops For-Comprehensions]]
 * {{{
 *     import io.tmos.arm._
 *     val lines: Seq[String] = for (inputStream <- managed(new FileInputStream("data.json")) yield {
 *       Json.parse(inputStream).as[Seq[String]]
 *     }
 * }}}
 * which translates the the following monadic style
 * {{{
 *     import io.tmos.arm._
 *     val lines = managed(new FileInputStream("data.json")) map { inputStream =>
 *        Json.parse(inputStream).as[Seq[String]]
 *     }
 * }}}
 * or if composing multiple resources this can be done easily too
 * {{{
 *     import io.tmos.arm._
 *     val result = for {
 *       a <- managed(new A)
 *       b <- managed(new B(a))
 *       c <- managed(new C)
 *     } yield {
 *       ...
 *     }
 * }}}

 * == Comprehensive Example ==
 *
 * Here is a comprehensive example of managing multiple resources implicitly, including an `ExectorService` which we
 * define `withFinally` logic for. This sample code runs a server socket in a separate thread echoing back text it
 * receives in uppercase.
 * {{{
 *     import io.tmos.arm.Implicits._
 *     import scala.collection.JavaConverters._
 *
 *     implicit val canManageExectorService = new CanManage[ExecutorService] {
 *       override def withFinally(pool: ExecutorService): Unit = {
 *         pool.shutdown() // Disable new tasks from being submitted
 *         try {
 *           if (!pool.awaitTermination(10, TimeUnit.SECONDS)) { // wait for normal termination
 *             pool.shutdownNow() // force terminate
 *             if (!pool.awaitTermination(10, TimeUnit.SECONDS)) // wait for forced termination
 *               throw new RuntimeException("ExecutorService did not terminate")
 *           }
 *         } catch {
 *           case e: InterruptedException =>
 *             pool.shutdownNow()  // (Re-)Cancel if current thread also interrupted
 *             Thread.currentThread().interrupt()  // Preserve interrupt status
 *         }
 *       }
 *     }
 *
 *     val port = new CompletableFuture[Int]
 *
 *     val callable = new Callable[Unit] {
 *       override def call(): Unit = {
 *         for (ss <- new ServerSocket(0, 0, InetAddress.getLoopbackAddress)) {
 *           port.complete(ss.getLocalPort)
 *           for {
 *             connection <- ss.accept
 *             out <- new PrintWriter(connection.getOutputStream, true)
 *             in <- new BufferedReader(new InputStreamReader(connection.getInputStream))
 *             line <- in.lines().iterator().asScala // note not a resource, but now a traversable
 *           } out.println(line.toUpperCase)
 *         }
 *       }
 *     }
 *
 *     // manage an executor service using the user defined canManageExectorService.
 *     // This will shutdown and wait termination
 *     val completedFuture = for (executorService <- Executors.newSingleThreadExecutor()) yield {
 *       val future = executorService.submit(callable)
 *       val upperPhrase = for {
 *         s <- new Socket(InetAddress.getLoopbackAddress, port.get)
 *         out <- new PrintWriter(s.getOutputStream, true)
 *         in <- new BufferedReader(new InputStreamReader(s.getInputStream))
 *       } yield {
 *         out.println("hello")
 *         out.println("world")
 *         in.readLine() + ' ' + in.readLine()
 *       }
 *       assert(upperPhrase === "HELLO WORLD")
 *       future
 *     }
 *
 *     assert(completedFuture.isCancelled || completedFuture.isDone)
 *     completedFuture.get() // should not block
 * }}}
 */
package object arm {

  /**
   * Explicitly manages a resource. For implicit management see `io.tmos.arm.Implicits`
   *
   * Note that the resource is passed by-name and as it not evaluated until the construct is applied
   * over the body. This allows for example resources to be constructed/open lazily.
   *
   * @param r the resource to managed passed by-name
   * @tparam R the type of the Resource
   *
   * @return a managed resource
   */
  def manage[R: CanManage](r: => R): ManagedResource[R] = new DefaultManagedResource(r)


}
