package fr.jbu.asyncperf.core.dump.log

import org.scalatest.matchers.ShouldMatchers
import org.scalatest.FunSuite
import java.nio.file.Paths
import fr.jbu.asyncperf.core.injector.InjectorResult
import fr.jbu.asyncperf.core.injector.http.{HttpHeader, HttpResponse, HttpRequest}
import collection.mutable.HashMap
import java.net.URI
import java.nio.ByteBuffer

class TestXmlDump extends FunSuite with ShouldMatchers {

  test("log a result with httprequest and httpresponse") {
    val filePath = "src/test/target/testXmlDump.xml"
    Paths.get(filePath).deleteIfExists
    val dump: XmlDump = new XmlDump(filePath, true)
    // Create a mock result
    val injectorResult = new InjectorResult[HttpRequest, Option[HttpResponse]](
      new HttpRequest(new URI("http://test.fr/test")),
      Some(new HttpResponse(200, ByteBuffer.wrap("La belle page de test".getBytes), "http://test.fr/test", new HttpHeader(new HashMap[String, String]))),
      0, 1000000000)
    dump.dumpTransaction(injectorResult)
    dump.endAndCloseReport
    // assert too few. Only file is present and not null
    Paths.get(filePath).exists should equal(true)
  }
}
