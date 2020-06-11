package projectAnalyzer

import java.io.File

import scala.util.matching.Regex

// This class will manage file locations
class fileManager(dirString:String) {
  def getListOfFiles(): Array[File] = {
    // Regular expression for .java files
    val javaReg = """.*\.java$""".r

    // Gets the list of files and returns it
    val projectsList: Array[File] = getAllFiles(new File(dirString), javaReg)
    projectsList
  }

  // Recursive definition that will retrieve all files matching the .java extension
  def getAllFiles(f: File, r: Regex): Array[File] = {
    val these = f.listFiles
    val good = these.filter(f => r.findFirstIn(f.getName).isDefined)
    good ++ these.filter(_.isDirectory).flatMap(getAllFiles(_, r))
  }
}
