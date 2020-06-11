import scala.xml._
import scala.collection.mutable.Map
import scala.collection.mutable.ListBuffer
import MyRWTool._
import java.io._

object VersionControl{
  def generatePostnameFile(b:String) = {
    val oldFile = loadXML("./config/old.xml")
    val newFile = loadXML("./config/new.xml")
    val oldMap = Map[String,Int]()
    val newMap = Map[String,Int]()
    val content = ListBuffer[String]()
    content += "<post>"
    
    for(k <- oldFile\\"file")
      oldMap += ((k\\"name").text -> (k\\"time").text.toInt)
    for(k <- newFile\\"file")
      newMap += ((k\\"name").text -> (k\\"time").text.toInt)

    for((k,v) <- newMap){
      if(b == "new")
          content += <new-post>{k}</new-post>.mkString
      else if("none" != oldMap.get(k).getOrElse("none")){
        if(newMap(k) > oldMap(k))
          content += <new-post>{k}</new-post>.mkString
      }
      else
        content += <new-post>{k}</new-post>.mkString

    }
    val sorted = newMap.toSeq.sortBy(_._1).reverse
    for((k,v) <- sorted)
      content += <name>{k}</name>.mkString
    content +="</post>"
    writeToFile(new File("./config/postname.xml"),content.toList)


  }
}
