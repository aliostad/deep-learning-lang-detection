package pl.mpieciukiewicz.codereview.vcs

/**
 *
 */
abstract class FileChange(val changeType: String) {
  def currentName: Option[String]
}

case class FileAdd(newPath: String) extends FileChange("add") {
  override def currentName = Some(newPath)
}
case class FileModify(path: String) extends FileChange("modify") {
  override def currentName = Some(path)
}
case class FileDelete(oldPath: String) extends FileChange("delete") {
  override def currentName = None
}
case class FileRename(oldPath: String, newPath: String) extends FileChange("rename") {
  override def currentName = Some(newPath)
}
case class FileCopy(oldPath: String, newPath: String) extends FileChange("copy") {
  override def currentName = Some(newPath)
}
