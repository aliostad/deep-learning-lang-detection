package models

import java.io.{IOException, ByteArrayInputStream}
import play.api.data._
import play.api.db.slick.Config.driver.simple._
import play.api.db.slick.DB
import play.api.libs.json._
import play.api.Logger
import play.api.Play.current

case class Symbol(
    id: Int,
    file: String,
    name: String,
    line: Int,
    kind: String) {
  def ~==(other: Symbol): Boolean = { // losely equals
    file == other.file &&
      name == other.name &&
      kind == other.kind
  }

  lazy val distinctive = (file, name, line, kind)

  def needsUpdate(other: Symbol): Boolean = {
    !((this ~== other) && line == other.line)
  }

  object unsafe { // scalastyle:ignore
    def insert() = {
      Symbol.create(file, name, line, kind)
    }
  }
}

object Symbol extends utils.Flyweight {
  type T = Symbol
  type Key = Int

  lazy private val Table = TableQuery[SymbolModel]

  def create(_1: String, _2: String, _3: Int, _4: String): Symbol = {
    create(Symbol(0, _1, _2, _3, _4))
  }

  protected def insert(symbol: Symbol): Symbol = {
    val newId = DB.withSession { implicit session =>
      (Table returning Table.map(_.id)) += symbol
    }
    symbol.copy(id = newId)
  }

  def rawGet(id: Key): Option[Symbol] = {
    DB.withSession { implicit session =>
      Table.filter(_.id === id).firstOption
    }
  }

  def synchronizeWithRepo(): Unit = {

    val srcCommit = Memcache.get("lastSymbolCommit")
    val dstCommit = RepoModel.lastCommit

    if (!srcCommit.isEmpty && srcCommit.get == dstCommit) {
      return // scalastyle:ignore
    }

    try {
      generateSymbols(srcCommit, dstCommit)
    } catch {
      case ex: IOException =>
        Logger.error("Couldn't generate symbols!")
    }
  }

  def generateSymbols(srcCommit: Option[String], dstCommit: String): Unit = {
    import scala.io._
    import scala.sys.process._

    val ctagsName = ".take2.ctags"

    (Seq(
      "ctags",
      "--excmd=numbers",
      "--tag-relative=yes",
      "-f", RepoModel.getFilePath(ctagsName),
      "--sort=no",
      "-R") ++
      // Ignore files from .accioignore
      RepoFile.getIgnoreRules.map { rule =>
        "--exclude=" + RepoModel.getFilePath(rule)
      } ++
      Seq(
        RepoModel.getFilePath("")
      )).!

    val accio = new utils.RpcClient("http://localhost:7432/")
    val ctagsFile = RepoModel.getFile(ctagsName)

    val it =
      Source
        .fromFile(ctagsFile)
        .getLines
        .map { line =>
          line(0) match {
            case '!' => None
            case _ => {
              val pieces = line.split("\t")
              Some(
                new Symbol(
                  -1,
                  pieces(1),
                  pieces(0),
                  pieces(2).filter(_.isDigit).toInt,
                  pieces(3)))
            }
          }
        }
        .flatten
        .buffered

    if (srcCommit == None) {
      // This is the first time we are building symbols, we do not
      // need to migrate
      it.foreach(_.unsafe.insert())
      Memcache += "lastSymbolCommit" -> dstCommit
      return // scalastyle:ignore
    }

    while (!it.isEmpty) {
      val file = it.head.file
      if (RepoFile.isTracked(file)) {
        Logger.info("processing symbols from: " + file)

        withFileSymbols(file) {
          val newSymbols = it.takeWhile(_.file == file).toList
          val oldSymbols = inMemory.sortBy(_.line)

          val oldLinesJson =
            JsObject(
              oldSymbols.map(
                symbol => symbol.line.toString -> JsNumber(symbol.line)
              ).toSeq)
            .toString

          val newLinesJson = (Seq(
            "accio",
            "translate",
            "--old_commit", srcCommit.get,
            "--new_commit", dstCommit,
            "--filename", RepoModel.getFilePath(file),
            "--repo_path", RepoModel.local
          ) #< new ByteArrayInputStream(oldLinesJson.getBytes("UTF-8"))).!!

          val resultLines =
            Json.parse(newLinesJson)
              .asInstanceOf[JsObject]
              .value
              .map { case (k, v) => k.toInt -> v.as[Int] }
              .toMap

          newSymbols.foreach { newSymbol =>
            findOldSymbol(
              newSymbol, newSymbols, oldSymbols, resultLines
            ) match {
              case Some(oldSymbol) => {
                if (newSymbol.needsUpdate(oldSymbol)) {
                  DB.withSession { implicit session =>
                    Table
                      .filter(_.id === oldSymbol.id)
                      .update(
                        newSymbol.copy(id = oldSymbol.id))
                  }
                }
              }

              case None            => newSymbol.unsafe.insert()
            }
          }
        }
      }
    }

    ctagsFile.delete()
    Memcache += "lastSymbolCommit" -> dstCommit
  }

  def findOldSymbol(
      newSymbol: Symbol,
      newSymbols: Seq[Symbol],
      oldSymbols: Seq[Symbol],
      newToOld: Map[Int, Int]): Option[Symbol] = {
    val newCount = newSymbols.count(_ ~== newSymbol)
    val oldCount = oldSymbols.count(_ ~== newSymbol)

    if (oldCount == 1 && newCount == 1) {
      // Unique names, so just update the old one
      return oldSymbols.find(_ ~== newSymbol) // scalastyle:ignore
    }

    // Otherwise, look at the diff to try to watch things move around
    newToOld.get(newSymbol.line) flatMap { oldLine =>
      val oldSymbol = oldSymbols.find(_.line == oldLine).get
      if (oldSymbol ~== newSymbol) {
        // The symbol has only moved
        Some(oldSymbol)
      } else if (oldSymbol.kind == newSymbol.kind &&
          !newSymbols.exists(_.name == oldSymbol.name)) {
        // There is no new symbol with the name that used to be here
        // so it is a rename
        Some(oldSymbol)
      } else {
        // Relatively major refactoring; nothing to do.
        None
      }
    }
  }

  object unmanaged {
    def getFileSymbols(file: String): Seq[Symbol] = {
      DB.withSession { implicit session =>
        Table.filter(_.file === file).list
      }
    }
  }

  def withFileSymbols(file: String)(func: => Unit): Unit = {
    preload {
      unmanaged.getFileSymbols(file)
    }

    func
    clear()
  }

  implicit def implSeqSymbolId = MappedColumnType.base[Seq[Symbol], String](
    ss => ss.map(_.id).mkString(";"),
    s =>
      s.split(";")
        .filter(_.length > 0)
        .map(_.toInt)
        .map(i => Symbol.getById(i).get)
  )
}

class SymbolModel(tag: Tag) extends Table[Symbol](tag, "Symbol") {
  def id = column[Int]("id", O.PrimaryKey, O.AutoInc)
  def file = column[String]("file")
  def name = column[String]("name")
  def line = column[Int]("line")
  def kind = column[String]("kind")
  def fileIndex = index("symbol_file_idx", file, unique = false)

  val underlying = Symbol.apply _
  def * = (
    id,
    file,
    name,
    line,
    kind
  ) <> (underlying.tupled, Symbol.unapply _)
}

