package runnables

import dump.XMLDumpCreator
import it.cnr.isti.hpc.wikipedia.reader.WikipediaArticleReader
import java.io.File

/**
 * Created by nico on 19/07/15.
 */
object JsonDumpCreator {
  def main(args: Array[String]) {
    val listsFile = args(0)
    val jsonFile = args(1)
    val xmlFile = "data/xmlDump.xml"
    val dumpCreator = new XMLDumpCreator()

    dumpCreator.readFromAndWriteTo(listsFile, xmlFile)
    val wap: WikipediaArticleReader = new WikipediaArticleReader(xmlFile, jsonFile, "en")

    try {
      wap.start()
    } catch {
      case e: Exception => {
        println("parsing the mediawiki {}", e.toString)
        System.exit(-1)
      }
    }
//    new File(xmlFile).delete()
//    System.exit(0)
  }
}
