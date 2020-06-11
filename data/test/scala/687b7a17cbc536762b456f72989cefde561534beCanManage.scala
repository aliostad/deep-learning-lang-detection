package io.tmos.arm

/**
 * For encapsulating the `finally` logic of a resource.
 *
 * Logic for any `java.lang.AutoClosable`, else any object which has structural type
 * `type T = { def close() }` is provided by the companion object implicitly.
 *
 * Other types may be provided in scope by the user. For example
 * {{{
 *   import java.util.concurrent._
 *   import io.tmos.arm.Implicits._
 *
 *   implicit val canManageExectorService = new CanManage[ExecutorService] {
 *     override def withFinally(pool: ExecutorService): Unit = {
 *       pool.shutdown() // Disable new tasks from being submitted
 *       try {
 *         if (!pool.awaitTermination(10, TimeUnit.SECONDS)) { // wait for normal termination
 *           pool.shutdownNow() // force terminate
 *           if (!pool.awaitTermination(10, TimeUnit.SECONDS)) // wait for forced termination
 *             throw new RuntimeException("ExecutorService did not terminate")
 *         }
 *       } catch {
 *         case e: InterruptedException =>
 *           pool.shutdownNow()  // (Re-)Cancel if current thread also interrupted
 *           Thread.currentThread().interrupt()  // Preserve interrupt status
 *       }
 *     }
 *   }
 *
 *   for (executorService <- Executors.newSingleThreadExecutor) { ... }
 * }}}
 *
 * @tparam R the underlying type of the resource passed to the managed body
 */
trait CanManage[R] {

  /**
   * Releases the resource.
   *
   * IMPORTANT: From Java's `java.lang.AutoCloseable` but also applicable to any implementation of this trait:
   *
   * "Implementers of this interface are also strongly advised to not have the
   * method throw `java.lang.InterruptedException`. This exception interacts with a thread's
   * interrupted status, and runtime misbehavior is likely to occur if an `java.lang.InterruptedException`
   * is suppressed. More generally, if it would cause problems for an exception to be suppressed,
   * the AutoCloseable.close method should not throw it."
   */
  def withFinally(r: R): Unit
}

/**
 * Companion object to the Resource type trait.
 *
 * Contains implicit implementations of CanManage
 */
object CanManage {
  import scala.language.reflectiveCalls

  /**
   * The structural type of objects to manage
   */
  type ReflectiveCloseable = {
    def close()
  }

  /**
   * Implicit value for managing any object who's structural type implements the `def close()` method.
   *
   * @tparam R type of the resource that is reflectively a subtype of `ReflectiveCloseable`
   * @return a CanManage who's finally logic is to call `close`
   */
  implicit def reflectiveCloseableResource[R <: ReflectiveCloseable]: CanManage[R] = new CanManage[R] {
    // TODO: Figure out how to conditionally cross compile this as a SAM when Scala 2.12
    override def withFinally(r: R): Unit = r.close()
  }

  /**
   * Implicit value for managing any object that is a `java.lang.AutoClosable`
   *
   * @tparam R type of the resource that a subtype of `AutoClosable`
   * @return a CanManage who's finally logic is to call `close`
   */
  implicit def autoCloseableResource[R <: AutoCloseable]: CanManage[R] = new CanManage[R] {
    // TODO: Figure out how to conditionally cross compile this as a SAM when Scala 2.12
    override def withFinally(r: R): Unit = r.close()
  }

}
