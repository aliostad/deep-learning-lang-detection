package com.dsouzam.language_analysis

import com.dsouzam.language_analysis.tables._
import java.io.File

import de.tudarmstadt.ukp.jwktl.JWKTL
import slick.jdbc.MySQLProfile.api._
import slick.jdbc.meta.MTable

import scala.concurrent.Await
import scala.concurrent.duration.Duration
import scala.concurrent.ExecutionContext.Implicits._


object Initializer {
  val WIKTIONARY_DUMP_PATH = "res/enwiktionary-latest-pages-articles.xml"
  val WIKTIONARY_OUTPUT_PATH = "res/wiktionary"

  val DATABASE_NAME = "main"
  def main(args: Array[String]): Unit = {
    initialize
  }

  def initialize: Database = {
    initializeWiktionary
    initializeDatabase
  }

  // Before running, place decompressed xml file in res/.
  // This function will parse the Wiktionary dump into an Oracle Berkeley DB so it can be more easily queried by JWKTL.
  // This process can take a while, even up to 2 hours (https://dkpro.github.io/dkpro-jwktl/documentation/getting-started/).
  def initializeWiktionary = {
    val output = new File(WIKTIONARY_OUTPUT_PATH)
    if (output.exists) {
      println(s"Parsed Wiktionary found at '$WIKTIONARY_OUTPUT_PATH'!")
    } else {
      println(s"Parsed Wiktionary not found at '$WIKTIONARY_OUTPUT_PATH'. Parsing now.")
      val dump = new File(WIKTIONARY_DUMP_PATH)
      if (!dump.exists) throw new RuntimeException(s"Dump file expected but missing. Expected '$WIKTIONARY_OUTPUT_PATH' to exist.")
      val begin = System.nanoTime
      JWKTL.parseWiktionaryDump(dump, output, true)
      val end = System.nanoTime
      println(s"Finished parsing Wiktionary in ${(end-begin)/(1000*1000*1000)} s.")
    }
  }

  def initializeDatabase = {
    val db = Database.forConfig("main")
    val repositories = TableQuery[Repositories]
    val languages = TableQuery[Languages]
    val repositoryLanguages = TableQuery[RepositoryLanguages]

    val tables = Seq(repositories, languages, repositoryLanguages)
    val existing = Await.result(db.run(MTable.getTables(Some(DATABASE_NAME), None, None, None)), Duration.Inf)

    val setup = DBIO.sequence(
      sqlu"CREATE DATABASE IF NOT EXISTS #$DATABASE_NAME" +:
      tables.filterNot(tbl => existing.exists(_.name.name == tbl.baseTableRow.tableName.toLowerCase))
          .map(_.schema.create)
    )
    print("Initializing database... ")
    Await.result(db.run(setup), Duration.Inf)
    println("Done!")
    db
  }
}
