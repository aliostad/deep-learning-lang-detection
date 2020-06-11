package model

import scala.collection.immutable.Map
import scala.xml.Elem

class XMLType(val fName: String, val mapKey: String, val dat:Map[String, String] = Map())

case class New(fileName: String, data:Map[String, String]) extends XMLType(fName = fileName, mapKey = "new", dat = data)

case class Old(fileName: String, data:Map[String, String]) extends XMLType(fName = fileName, mapKey = "old", dat = data)

case class Others(fileName:String) extends XMLType(fName = fileName, mapKey = "others")


sealed class TestStepType

case class DataSource() extends TestStepType

case class DataGen() extends TestStepType

case class HttpRequest(request: String) extends TestStepType

case class TestSuit(name: String, testCases: Seq[TestCase])

case class TestCase(name: String, testSteps: Seq[TestStep])

class TestStep(val name: String, val testType: String, val request: Option[Elem] = None, val disbled: Boolean = false) {
  def process(suitLocation: String): XMLType = {
    def getType(testName: String): XMLType = {
      def getFileName(name: String, patterns: String*) = {
        var newName = name.trim
        patterns foreach { pattern =>
          newName = newName.replace(pattern, "")
        }
        newName
      }
      testName match {
        case name if (testName.endsWith("_Old") || testName.endsWith("_OLd") || testName.endsWith("_OLD")) =>
          Old("", Map())
//          Old(getFileName(testName, "_Old", "_OLd", "_OLD"), RequestXMLFactory(request.get.toString).getValueMap)
        case name if testName.endsWith("_New") =>
          New("", Map())
//          New(getFileName(testName, "_New"), RequestXMLFactory(request.get.toString).getValueMap)
        case othertype => new Others(name)
      }
    }

    import util.StringUtils.StringImprovements
    val xmlType = getType(name)
    testType match {
      case "httprequest" => {
        xmlType match {
          case old: Old =>
            old.fileName.removeNumberPrefix
          case nw: New =>
            nw.fileName.removeNumberPrefix
        }
      }
      case unknown => println(s"unhandled type $unknown")
    }
    xmlType
  }

}
