package com.thoughtworks.pact.verify.junit

import org.scalatest.{FlatSpec, Matchers}
import play.api.libs.json.Json


/**
  * Created by xfwu on 27/07/2017.
  */
class JunitReportSpec extends FlatSpec with Matchers {

  "Junit Report" should "dump pretty json report" in {
    val expected = """{"numbers":{"a":4,"b":5,"c":6}} """
    val expectedJsValue = Json.parse(expected)
    val failure = Failure("match failure", "failure", Some(Json.stringify(expectedJsValue)))
    val tc = TestCase("assertions","className","name","status",0,None,Some(failure))
    val ts = TestSuite("disabled",0,1,"hostname","id","name","pkg","skipped",1,1,"timestampe",Seq(tc))
    val tss = TestSuites("disabled",0,1,"dump_pretty_json","tests","time",Seq(ts))
    val files = JunitReport.dumpJUnitReport("target/junit_dump", Seq(tss))
    println(files.head)
  }


}
