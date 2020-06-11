import java.io.{File, PrintWriter}
import scala.io.Source

object ReadWriteFromFile extends ReadWrite {

  def read(fileLocation: String): String = {

    try {
      val file = new File(fileLocation)
      val content = Source.fromFile(file).getLines().mkString("\n")
      content
    }
    catch {
      case error: Exception => throw new Exception()
    }

  }

  def write(fileName: String, content: List[List[String]], dirPath: String): Boolean = {
    val writeData = content.map(testCase=>testCase.reduce((ele1,ele2)=>ele1 + "," + ele2)).reduce(_ + "\n" + _)
    new File(dirPath).mkdir()
    try {
      val writeToFile = new PrintWriter(dirPath + "/" + fileName + "_Result.csv")
      writeToFile.write(writeData)
      writeToFile.close()
      true
    }
    catch {
      case error: Exception => false
    }
  }

}
