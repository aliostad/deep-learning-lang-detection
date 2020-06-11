package uvm

class UvmException(message: String = null, cause: Throwable = null) extends RuntimeException(message, cause)

class BundleLoadingException(message: String = null, cause: Throwable = null) extends UvmException(message, cause)

class TypeResolutionException(message: String = null, cause: Throwable = null) extends BundleLoadingException(message, cause)

class IllegalRedefinitionException(message: String = null, cause: Throwable = null) extends BundleLoadingException(message, cause)

class NameConflictException(val kind: String, val whatConflicts: String, val newItem: Identified, val oldItem: Identified, cause: Throwable = null) extends {
  val message = "Conflict: %s %s has the same %s as %s".format(kind, newItem.repr, whatConflicts, oldItem.repr)
} with UvmException(message, cause) {
  def toIllegalRedefinitionException(newSourceInfoRepo: SourceInfoRepo, oldSourceInfoRepo: SourceInfoRepo): IllegalRedefinitionException = {
    val oldSrcInfo = oldSourceInfoRepo(oldItem)
    val newSrcInfo = newSourceInfoRepo(newItem)
    throw new IllegalRedefinitionException(
      "Cannot redefine %s %s\n%s\nwhich is already defined %s".format(
        kind, newItem.repr, newSrcInfo.prettyPrint(), oldSrcInfo.prettyPrint()), this)

  }
}
