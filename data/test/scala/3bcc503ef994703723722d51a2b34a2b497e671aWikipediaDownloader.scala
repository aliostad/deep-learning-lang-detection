package org.clulab.wikipedia

import java.net.URL
import java.io.File
import java.util.Calendar

import org.apache.commons.io.FileUtils


/**
  * Downloads latest data dump for given language code
  */
object WikipediaDownloader {

  def download(lang: String = "en"): String = {

    val dumpName: String = "wiki-latest-pages-articles.xml.bz2"
    val langCode = lang.toLowerCase match {
      case "en" => "en"
      case "de" => "de"
      case "zh" => "zh"
      case other => throw new Exception(s"Unsupported language '$lang'")
    }

    val timeStr: String = {
      val now = Calendar.getInstance()
      val year = now.get(Calendar.YEAR)
      val month = now.get(Calendar.MONTH)
      val day = now.get(Calendar.DAY_OF_MONTH)
      s"$month-$day-$year"
    }

    val dumpURL = s"https://dumps.wikimedia.org/${langCode}wiki/latest/${langCode}wiki-latest-pages-articles.xml.bz2"

    println(dumpURL)

    val outDir = new File(timeStr)
    outDir.mkdirs()

    val outFile = new File(timeStr, dumpName)

    val url = new URL(dumpURL)

    FileUtils.copyURLToFile(url, outFile)

    outFile.getAbsolutePath
  }

}
