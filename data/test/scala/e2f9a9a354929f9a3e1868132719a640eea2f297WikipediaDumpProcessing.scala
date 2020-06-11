package org.opencompare.stats

import java.io.{FileWriter, File}

import org.opencompare.api.java.PCMContainer
import org.opencompare.api.java.impl.io.KMFJSONExporter
import org.opencompare.api.java.io.HTMLExporter
import org.opencompare.io.wikipedia.io.{MediaWikiAPI, WikiTextLoader}
import org.opencompare.stats.utils.WikiTextKeepTemplateProcessor

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent._
import scala.concurrent.duration._
import scala.util.{Failure, Success}
import scala.xml.XML

import scala.collection.JavaConversions._

/**
 * Created by gbecan on 8/25/15.
 */
object WikipediaDumpProcessing extends App {


  val dumpFile = new File("wikipedia-dump/zuwiki-20150806-pages-articles-multistream.xml")
  //  val dumpFile = new File("wikipedia-dump/zuwiki-20150806-pages-meta-history.xml")

//  val compressedDumpFile = new File("wikipedia-dump/zuwiki-20150806-pages-articles-multistream.xml.bz2")
//  val compressedDumpFile = new File("/var/wikipedia-dumps/20150805/fr/frwiki-20150602-pages-articles-multistream.xml.bz2")
  val compressedDumpFile = new File("/var/wikipedia-dumps/20150805/en/enwiki-20150805-pages-articles-multistream.xml.bz2")

  val outputDir = new File(dumpFile.getAbsolutePath.substring(0, dumpFile.getAbsolutePath.size - ".xml".size))

  val processor = new WikipediaDumpProcessor

  // Cut dump in pageId/revisionId.xml files
  //  processor.cutDump(dumpFile, outputDir)

  // Read extracted XML files, detect tables and extract PCMs

//  val api = new MediaWikiAPI("wikipedia.org")
//
//  val jobs = (for (pageDir <- outputDir.listFiles() if pageDir.isDirectory) yield {
//    for (revisionFile <- pageDir.listFiles() if revisionFile.isFile && revisionFile.getName.endsWith(".xml")) yield {
//      val job = Future {
//        val revXml = XML.loadFile(revisionFile)
//        val revId = (revXml \ "id").text
//        val revContent = (revXml \ "text").text
//        val containsTable = revContent.contains("{|")
//
//        if (containsTable) {
//          val pcmMiner = new WikiTextLoader(new WikiTextKeepTemplateProcessor(api))
//          val kmfExporter = new KMFJSONExporter
//          val htmlExporter = new HTMLExporter
//          val pcmContainers = pcmMiner.load(revContent)
//          val pcmFileBasePath = revisionFile.getAbsolutePath.substring(0, revisionFile.getAbsolutePath.size - ".xml".size)
//
//          // Write PCMs
//          for ((pcmContainer, index) <- pcmContainers.zipWithIndex) {
//            val kmfWriter = new FileWriter(pcmFileBasePath + "_" + index + ".pcm")
//            kmfWriter.write(kmfExporter.export(pcmContainer))
//            kmfWriter.close()
//
//            val htmlWriter = new FileWriter(pcmFileBasePath + "_" + index + ".html")
//            htmlWriter.write(htmlExporter.export(pcmContainer))
//            htmlWriter.close()
//          }
//
//          Some(revisionFile, pcmContainers.size())
//        } else {
//          None
//        }
//      }
//
//      job.onSuccess {
//        case Some(result) => println(result._1.getAbsolutePath + " = " + result._2)
//        case None =>
//      }
//
//      job.onFailure {
//        case e => e.printStackTrace()
//      }
//
//      job
//    }
//  }).flatten.toList
//
//
//  val aggregatedJobs = Future.sequence(jobs)
//
//  Await.result(aggregatedJobs, 10 minutes)


  val nbOfTables = processor.countTablesInCompressedDump(compressedDumpFile)
  println("final result = " + nbOfTables)

}

