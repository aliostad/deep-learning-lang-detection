package sbtdumpsettings

import sbt._, Keys._

case class DumpSettingsResult(identifier: String, value: Any, typeExpr: TypeExpression)

object DumpSettings {
  def apply(dir: File, renderers: Seq[DumpSettingsRenderer],
    keys: Seq[DumpSettingsKey],
    proj: ProjectRef, state: State, cacheDir: File): Seq[File] =
    DumpSettingsTask(dir, renderers, keys, proj, state, cacheDir).files

  private def extraKeys(): Seq[DumpSettingsKey] = {
    val now = System.currentTimeMillis()
    val dtf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS")
    dtf.setTimeZone(java.util.TimeZone.getTimeZone("UTC"))
    val nowStr = dtf.format(new java.util.Date(now))
    Seq[DumpSettingsKey](
      "builtAtString" -> nowStr,
      "builtAtMillis" -> now
    )
  }

  def results(keys: Seq[DumpSettingsKey], project: ProjectRef, state: State): Seq[DumpSettingsResult] = {
    val distinctKeys = (keys ++ extraKeys()).toList.distinct
    val extracted = Project.extract(state)

    def entry[A](info: DumpSettingsKey.Entry[A]): Option[DumpSettingsResult] = {
      val typeExpr = TypeExpression.parse(info.manifest.toString())._1
      val result = info match {
        case DumpSettingsKey.Setting(key) => extracted getOpt (key in scope(key, project)) map {
          ident(key) -> _
        }
        case DumpSettingsKey.Task(key) => Some(ident(key) -> extracted.runTask(key in scope(key, project), state)._2)
        case DumpSettingsKey.Constant(tuple) => Some(tuple)
        case DumpSettingsKey.Action(name, fun) => Some(name -> fun.apply)
        case DumpSettingsKey.Mapped(from, fun) => entry(from).map { r => fun((r.identifier, r.value.asInstanceOf[A])) }
      }
      result.map { case (identifier, value) => DumpSettingsResult(identifier, value, typeExpr) }
    }

    distinctKeys.flatMap(entry(_))
  }

  private def scope(scoped: Scoped, project: ProjectReference) = {
    val scope0 = scoped.scope
    if (scope0.project == This) scope0 in project
    else scope0
  }

  private def ident(scoped: Scoped): String = {
    val scope = scoped.scope
    (scope.config.toOption match {
      case None => ""
      case Some(ConfigKey("compile")) => ""
      case Some(ConfigKey(x)) => x + "_"
    }) +
      (scope.task.toOption match {
        case None => ""
        case Some(x) => x.label + "_"
      }) +
      (scoped.key.label.split("-").toList match {
        case Nil => ""
        case x :: xs => x + (xs map {
          _.capitalize
        }).mkString("")
      })
  }

  private case class DumpSettingsTask(
    dir: File,
      renderers: Seq[DumpSettingsRenderer],
      keys: Seq[DumpSettingsKey],
      proj: ProjectRef,
      state: State,
      cacheDir: File
  ) {

    import FileInfo.hash
    import Tracked.inputChanged

    private def tempFile(r: DumpSettingsRenderer) = cacheDir / "sbt-dumpsettings" / s"dumpsettings.${r.extension}"
    private def outFile(r: DumpSettingsRenderer) = dir / s"dumpsettings.${r.extension}"

    def files: Seq[File] = {
      renderers.map(r => file(r))
    }

    // 1. make the file under cache/sbtbuildinfo.
    // 2. compare its SHA1 against cache/sbtbuildinfo-inputs
    def file(r: DumpSettingsRenderer): File = {
      makeFile(tempFile(r), r)
      cachedCopyFile(r)(hash(tempFile(r)))
      outFile(r)
    }

    def cachedCopyFile(r: DumpSettingsRenderer) =
      inputChanged(cacheDir / "sbtbuildinfo-inputs") { (inChanged, input: HashFileInfo) =>
        if (inChanged || !outFile(r).exists) {
          IO.copyFile(tempFile(r), outFile(r), preserveLastModified = true)
        } // if
      }

    def makeFile(file: File, renderer: DumpSettingsRenderer): File = {
      val values = results(keys, proj, state)
      val lines = renderer.renderKeys(values)
      IO.writeLines(file, lines, IO.utf8)
      file
    }

  }
}
