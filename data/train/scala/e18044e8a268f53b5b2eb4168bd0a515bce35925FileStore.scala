package model

import java.io.File
import org.apache.commons.io.FileUtils

class FileStore(name: String) {

  val file = new File("store", name)
  val progress = new File(file.getAbsolutePath() + ".progress")
  val old = new File(file.getAbsolutePath() + ".old")

  def read: String =
    if (file.exists())
      FileUtils.readFileToString(file,"utf-8")
    else
      null

  def write(str: String) {
    FileUtils.writeStringToFile(progress, str, "utf-8")
    if (file.exists()) {
      file.renameTo(old)
    }
    progress.renameTo(file)
  }

}