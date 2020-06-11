package core.dump

import java.io.File

import buildInfo.BuildInfo
import com.lambdaworks.jacks.JacksMapper
import core.globals.PropertyType
import core.rdf.Triples.{OrdinaryStatement, ResultStatement}
import org.apache.commons.io.FileUtils
import play.api.libs.json._

import scala.collection.mutable
/**
  * Created by Espen on 09.11.2016.
  */

object DumpObject {




  def dumpMap[T:Manifest, U:Manifest](m : Map[T, U], filename: String) = {
    val json = JacksMapper.writeValueAsString[Map[T, U]](m)
    val fullFilename: String = picklePath + filename + ".txt"
    FileUtils.write(new File(fullFilename), json)
  }
  def readMap[T: Manifest, U:Manifest](filename : String): Map[T, U] = {
    val json = FileUtils.readFileToString(new File(picklePath + filename + ".txt"))
    return JacksMapper.readValue[Map[T, U]](json)
  }

  def dumpList[T: Manifest](l : List[T],filename : String) = {
    val json = JacksMapper.writeValueAsString[List[T]](l)
    val fullFilename: String = picklePath + filename + ".txt"
    FileUtils.write(new File(fullFilename), json)
  }
  def getList[T: Manifest](filename : String): List[T] = {
    val json = FileUtils.readFileToString(new File(picklePath + filename + ".txt"))

    return JacksMapper.readValue[List[T]](json)
 }

  def getMapStringBoolean(filename: String): Map[String, Boolean] = {
    val json = FileUtils.readFileToString(new File(picklePath + filename + ".txt"))
    return JacksMapper.readValue[Map[String, Boolean]](json)
  }
  def dumpMapStringInt(dumpObject: Map[String, Int], filename: String) = {
    val json = JacksMapper.writeValueAsString[Map[String, Int]](dumpObject)
    val fullFilename: String = picklePath + filename + ".txt"
    FileUtils.write(new File(fullFilename), json)
  }
  def getMapStringInt(filename: String): Map[String, Int] = {
    val json = FileUtils.readFileToString(new File(picklePath + filename + ".txt"))
    return JacksMapper.readValue[Map[String, Int]](json)
  }
  def dumpListString(dumpObject: List[String], filename: String) = {
    val json = JacksMapper.writeValueAsString[List[String]](dumpObject)
    val fullFilename: String = picklePath + filename + ".txt"
    FileUtils.write(new File(fullFilename), json)
  }
  def getListString(filename: String): List[String] = {
    val json = FileUtils.readFileToString(new File(picklePath + filename + ".txt"))
    return JacksMapper.readValue[List[String]](json)
  }


  def getQEntityStatistics(): mutable.HashMap[String, mutable.HashMap[String, Int]] = {
    val importantFilenames = List(3, 17, 24)
    val fullMap = mutable.HashMap[String, mutable.HashMap[String, Int]]()
    for (f <- importantFilenames) {
      val json = FileUtils.readFileToString(new File(picklePath + s"qEntityStatistics$f" + ".txt"))
      val map = JacksMapper.readValue[mutable.HashMap[String, mutable.HashMap[String, Int]]](json)
      fullMap ++= map
    }
    return fullMap
  }


  def dumpMapStringListDouble(dumpObject: Map[String, List[Double]], filename: String) = {
    val json = JacksMapper.writeValueAsString[Map[String, List[Double]]](dumpObject)
    val fullFilename: String = picklePath + filename + ".txt"
    FileUtils.write(new File(fullFilename), json)
  }


  def dumpJsonMapStringTuple(dumpObject: Map[String, (Double, Double)], filename: String) = {
    val json = JacksMapper.writeValueAsString[Map[String, (Double, Double)]](dumpObject)
    val fullFilename: String = picklePath + filename + ".txt"
    FileUtils.write(new File(fullFilename), json)
  }

  def readMapStringListDouble(filename: String): Map[String, List[Double]] = {
    val json = FileUtils.readFileToString(new File(picklePath + filename + ".txt"))
    val map = JacksMapper.readValue[Map[String, List[Double]]](json)
    return map
  }

  def getQEntityResultForExpected(): mutable.Map[String, List[(String, (Double, Int))]] = {
    val importantFilenames = List(3, 17, 24)
    val fullMap = mutable.HashMap[String, List[(String, (Double, Int))]]()
    for (f <- importantFilenames) {
      val json = FileUtils.readFileToString(new File(picklePath + s"qEntityResultExpectedSimilarityFinder$f" + ".txt"))
      val map = JacksMapper.readValue[mutable.HashMap[String, List[(String, (Double, Int))]]](json)
      fullMap ++= map
    }
    return fullMap
  }

  def getQEntityResult(): mutable.HashMap[String, mutable.HashMap[String, Double]] = {
    val importantFilenames = List(3, 17, 24)
    val fullMap = mutable.HashMap[String, mutable.HashMap[String, Double]]()
    for (f <- importantFilenames) {
      val json = FileUtils.readFileToString(new File(picklePath + s"qEntityResultSimilarityFinder$f" + ".txt"))
      val map = JacksMapper.readValue[mutable.HashMap[String, mutable.HashMap[String, Double]]](json)
      fullMap ++= map
    }
    return fullMap
  }

  def dumpMapStringListStringDoubleInt(dumpObject: mutable.HashMap[String, List[(String, (Double, Int))]], filename: String) = {
    val json = JacksMapper.writeValueAsString[mutable.HashMap[String, List[(String, (Double, Int))]]](dumpObject)
    val fullFilename: String = picklePath + filename + ".txt"
    FileUtils.write(new File(fullFilename), json)
  }

  def dumpMapStringMapStringDouble(dumpObject: mutable.HashMap[String, mutable.HashMap[String, Double]], filename: String) = {
    val json = JacksMapper.writeValueAsString[mutable.HashMap[String, mutable.HashMap[String, Double]]](dumpObject)
    val fullFilename: String = picklePath + filename + ".txt"
    FileUtils.write(new File(fullFilename), json)
  }

  def dumpMapStringMapStringInt(dumpObject: mutable.HashMap[String, mutable.HashMap[String, Int]], filename: String) = {
    val json = JacksMapper.writeValueAsString[mutable.HashMap[String, mutable.HashMap[String, Int]]](dumpObject)
    val fullFilename: String = picklePath + filename + ".txt"
    FileUtils.write(new File(fullFilename), json)
  }

  def dumpJsonMapStringListString(stringToStrings: Map[String, List[String]], filename: String): Unit = {
    val json = JacksMapper.writeValueAsString[Map[String, List[String]]](stringToStrings)
    val fullFilename: String = picklePath + filename + ".txt"
    FileUtils.write(new File(fullFilename), json)
  }
  def dumpJsonMapStringPropertyType(stringToStrings: Map[String, PropertyType], filename: String): Unit = {
    val formatedStringsToPropTypes = stringToStrings.map{case (st, pT) => (st -> pT.toString)}
    val json = JacksMapper.writeValueAsString[Map[String, String]](formatedStringsToPropTypes)
    val fullFilename: String = picklePath + filename + ".txt"
    FileUtils.write(new File(fullFilename), json)
  }
  def readJsonMapStringPropertyType(filename: String): Map[String, PropertyType] = {
    val json = FileUtils.readFileToString(new File(picklePath + filename + ".txt"))
    val map = JacksMapper.readValue[Map[String, String]](json)
    return map.map{case (st, ptSt) => (st -> PropertyType.stringToPropType(ptSt))}
  }

  def getCurrentDirectory = new java.io.File(".").getCanonicalPath
//  final val picklePath = "SimilarEntitiesWikidata/output/pickles/"
  final val picklePath = BuildInfo.similarEntitiesCorePath + "/output/pickles/"

  def dumpJsonMap(objectToDump: Map[String, Double], filename: String): Unit = {
    val fullFilename: String = picklePath + filename + ".txt"
    //    test1.thePickle.
    val json = objectToDump match {
      case m: Map[String, Double] => JacksMapper.writeValueAsString[Map[String, Double]](m)
      case s => print(s); throw new Exception("Failed")
    }
    FileUtils.write(new File(fullFilename), json)
  }

  def loadJsonMap(filename: String): Map[String, Double] = {
    val json = FileUtils.readFileToString(new File(picklePath + filename + ".txt"))
    val map = JacksMapper.readValue[Map[String, Double]](json)
    return map
  }

  def getStringMap(filename: String): Map[String, List[String]] = {
    val json = FileUtils.readFileToString(new File(picklePath + filename + ".txt"))
    val map = JacksMapper.readValue[Map[String, List[String]]](json)
    return map
  }

  def getMapStringTuple(filename: String): Map[String, (Double, Double)] = {
    val json = FileUtils.readFileToString(new File(picklePath + filename + ".txt"))
    val map = JacksMapper.readValue[Map[String, (Double, Double)]](json)
    return map
  }
}
