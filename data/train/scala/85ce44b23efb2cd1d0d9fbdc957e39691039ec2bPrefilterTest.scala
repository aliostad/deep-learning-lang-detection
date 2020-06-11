package parser
import util.AtomicPattern

import scala.util.matching.Regex

/**
  * Created by hungdv on 09/03/2017.
  */
object PrefilterTest {
  def main(args: Array[String]): Unit ={
    val loadLogExample2 = "\"Feb 01 2017 06:59:59\",\"DLK-MP01-3\",\"-704633153\",\"dldsl-160613-176\",\"205923\",\"589891846\",\"-650829781\",\"0\",\"323378\",\"100.108.149.233\",\"24:00:ba:98:1b:cf\",\"\""
    val loadLogExample  = "\"ACTALIVE\",\"Feb 01 2017 06:59:59\",\"DLK-MP01-3\",\"-704633153\",\"dldsl-160613-176\",\"205923\",\"589891846\",\"-650829781\",\"0\",\"323378\",\"100.108.149.233\",\"24:00:ba:98:1b:cf\",\"\""
    val connLogExample1 = "06:59:59 00001228 Auth-Local:Reject: Hnfdl-140821-285, Result 103, No DSP on port.fpt.net (4c:f2:bf:21:c4:a6)"

    val loadRegexPre: Regex =  AtomicPattern.loadGeneralRegex
    val connRegexPre = AtomicPattern.connGeneralRegex

    val loadHead: String = "\"(\\w{3,} \\d{2} \\d{4} \\d{2}:\\d{2}:\\d{2}|[a-zA-Z]{6,})\""  // time1 | status
    val loadTail = "(.*)" // Match any cheracter except new line.
    val time2                 = "(\\d{2}:\\d{2}:\\d{2})"
    val connTail  = "(.*)"

    loadLogExample match{
      case loadRegexPre(loadHead,loadTail) => println("LOAD")
      case _ => println("FAIL LOAD")
    }

    loadLogExample2 match{
      case loadRegexPre(loadHead,loadTail) => println("LOAD")
      case _ => println("FAIL LOAD")
    }

    connLogExample1 match{
      case connRegexPre(time2,connTail) => println("CONN")
      case _ => println("FAIL CONN")
    }


  }
}
