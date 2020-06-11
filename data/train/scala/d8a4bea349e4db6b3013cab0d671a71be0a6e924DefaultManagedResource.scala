package io.tmos.arm

/**
 * The default implementation of a [[ManagedResource]].
 *
 * This implementation has identical to Java's try-with-resource constructs. See the package documentation for
 * a description on the exception behaviour of this implementation.
 *
 * @param r the resource passed by name
 * @tparam R the type of the resource to manage
 */
class DefaultManagedResource[R : CanManage](r: => R) extends ManagedResource[R] {

  override def apply[B](f: R => B) : B = {
    val resource = r // construct resource
    val canManage = implicitly[CanManage[R]]
    var throwing: Throwable = null
    try {
      f(resource)
    } catch {
      case e: Throwable =>
        throwing = e
        throw e
    } finally {
      if (resource != null) {
        if (throwing != null) {
          try {
            canManage.withFinally(resource)
          } catch {
            case e: Throwable =>
              throwing.addSuppressed(e)
          }
        } else {
          canManage.withFinally(resource)
        }
      }
    }
  }

}
