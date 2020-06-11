package com.github.fedeoasi.app.omdb

import com.github.fedeoasi.app.omdb.OmdbDumpUtils._
import java.io.{OutputStream, FileOutputStream}
import OmdbDumpFields._

object OmdbDumpExporter {
  def main(args: Array[String]) = {
    if(args.length < 2) {
      println("Usage: [dump_location] [output_location]")
    }  else {
      exportMoviesWithImdbVotes(args(0), args(1))
    }
  }

  def exportDump(inputLocation: String, outputLocation: String): Unit = {
    exportDumpInternal(inputLocation, outputLocation) {
      (_, _) => true
    }
  }

  def exportMoviesWithImdbVotes(inputLocation: String, outputLocation: String): Unit = {
    exportDumpInternal(inputLocation, outputLocation) {
      (values, indexByField) =>
        val optionalVotes = parseOptionalInt(values(indexByField(ImdbVotes)))
        val titleType = values(indexByField(Type))
        optionalVotes.exists(_ > 1000) && titleType == "movie"
    }
  }

  def exportDumpInternal(inputLocation: String, outputLocation: String)
                        (p: (Array[String], Map[String, Int]) => Boolean): Unit = {
    val inputLines = dumpInputStreamLines(inputLocation)
    val indexByField = extractHeaderIndex(inputLines)
    val interestingFieldIds = extractInterestingFieldIndex(indexByField)
    val fos = new FileOutputStream(outputLocation)
    writeHeader(fos)
    inputLines.foreach { l =>
      val split = l.split(tabRegex)
      if (p(split, indexByField)) {
        val interestingFieldValues = interestingFieldIds.map(split(_))
        val string = tabSeparatedLine(interestingFieldValues)
        fos.write(string.getBytes)
      }
    }
    fos.close()
  }

  def writeHeader(os: OutputStream): Unit = {
    val header = tabSeparatedLine(interestingFields)
    os.write(header.getBytes)
  }

  def tabSeparatedLine(values: Seq[String]): String = {
    values.mkString("\t") + "\n"
  }
}
