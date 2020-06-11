package com.github.fedeoasi.app.omdb

import OmdbDumpUtils._
import OmdbDumpFields._
import com.github.fedeoasi.app.persistence.ProdPersistenceManager
import com.github.fedeoasi.app.model.IMovie

case class OmdbTitle(id: Long, imdbId: String, title: String, year: Int, runtime: String, genre: String, imdbRating: Option[Double],
                 imdbVotes: Option[Int], poster: String)

object OmdbDumpImporter {
  def main(args: Array[String]) = {
    if(args.length < 1) {
      println("Dump location required")
    }  else {
      importDump(args(0))
    }
  }

  def importDump(location: String): Unit = {
    val pm = ProdPersistenceManager()
    val inputLines = dumpInputStreamLines(location)
    val indexByField = extractHeaderIndex(inputLines)
    val titles = inputLines.map { l =>
      val values = l.split(tabRegex)
      val id = values(indexByField(Id)).toLong
      val year = values(indexByField(Year)).toInt
      val imdbId = values(indexByField(ImdbId))
      val title = values(indexByField(Title))
      val runtime = values(indexByField(Runtime))
      val genre = values(indexByField(Genre))
      val imdbVotes = parseOptionalInt(values(indexByField(ImdbVotes)))
      val imdbRating = parseOptionalDouble(values(indexByField(ImdbRating)))
      val poster = values(indexByField(Poster))
      OmdbTitle(id, imdbId, title, year, runtime, genre, imdbRating, imdbVotes, poster)
    }
    titles.foreach { om =>
      pm.saveIMovie(IMovie(om.id, om.title, om.year, BigDecimal(om.imdbRating.get), om.imdbVotes.get, om.genre, om.poster, Some(om.imdbId)))
    }
  }

  def printTopK(titles: Array[OmdbTitle]): Unit = {
    val sorted = titles.toArray.sortBy(_.imdbRating.get)
    val topK = sorted.filter(_.genre != "Documentary").reverse.take(50)
    topK.foreach(println)
  }

  def printHeader(location: String): Unit = {
    val inputLines = dumpInputStreamLines(location)
    val header = extractHeader(inputLines)
    println(header.mkString("\t"))
  }
}