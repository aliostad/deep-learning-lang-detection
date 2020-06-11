package me.lyh.gitective

import scala.collection.{immutable, mutable}

object Author {
  def apply() = new Author()
}

class Author extends BasicStats {
  private var _commits: Int = 0
  private val fileStats = mutable.Map[String, BasicStats]()

  def commits = _commits

  def insertLines(path: String, n: Int): Author = {
    fileStats.getOrElseUpdate(path, BasicStats()).insert(n)
    insert(n)
    this
  }

  def deleteLines(path: String, n: Int): Author = {
    fileStats.getOrElseUpdate(path, BasicStats()).delete(n)
    delete(n)
    this
  }

  def renameFile(oldPath: String, newPath: String) {
    if (fileStats.contains(oldPath)) {
      fileStats(newPath) = fileStats.getOrElseUpdate(oldPath, BasicStats())
      fileStats.remove(oldPath)
    }
  }

  def commit(): Author = {
    _commits += 1
    this
  }

  def getFileStats: immutable.Map[String, BasicStats] = fileStats.toMap
}