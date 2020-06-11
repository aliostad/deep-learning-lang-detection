/**
 *
 */
package ru.kfu.itis.issst.nfcrawler.util
import java.io.File
import org.apache.commons.io.FileUtils

/**
 * @author Rinat Gareev (Kazan Federal University)
 *
 */
trait ErrorDumping {

  protected val dumpFileNamePattern: String
  private var idCounter: Int = 0

  protected def dumpErrorContent(obj: Any): File = {
    idCounter += 1
    val dumpFile = new File(dumpFileNamePattern.format(idCounter))
    try {
      FileUtils.writeStringToFile(dumpFile, String.valueOf(obj), "utf-8")
      dumpFile
    } catch {
      case ex: Exception => null
    }
  }

}