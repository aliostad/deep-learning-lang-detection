import scala.xml._
class  MyEnv(loadPath:Elem){
  def templetePath = (loadPath\\"templetePath").text
  def productPath = (loadPath \\"productPath").text
  def sourcePath = (loadPath \\"sourcePath").text
}

/*
object Main{
  def main(args:Array[String]){
    def loadPath = {
      println("load")
      XML.loadFile("./pathfile.xml")
    }
    val ld = loadPath
    val t = new CustomPath(ld)
    println(t.templetePath)
    println(t.templetePath)
    println(t.templetePath)
    println(t.templetePath)
    println(t.templetePath)
  }
}
*/
