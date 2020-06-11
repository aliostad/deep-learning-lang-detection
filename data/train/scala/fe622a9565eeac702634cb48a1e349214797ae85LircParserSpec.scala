package services

import javax.inject.Provider

import io.TestableProcessLogger
import org.scalatest.{FlatSpec, MustMatchers}
import org.scalamock.scalatest.MockFactory

import scala.sys.process._

/**
  * Created by jimbo on 02/01/17.
  */
class LircParserSpec extends FlatSpec with MustMatchers with MockFactory {

  "The irsend command" should "find devices" in {

    val process = mock[ProcessCreation]
    val builder = mock[ProcessBuilder]
    val provider = mock[Provider[TestableProcessLogger]]
    val logger = mock[TestableProcessLogger]

    (process.apply(_:String,_:Seq[String])).expects("irsend", Seq("list", "", "")).returns(builder)
    (logger.processLogger _).expects().returns(null)
    (logger.lines _).expects().returns(List("irsend: sony", "irsend: jvc"))
    (provider.get _).expects().returns(logger)
    (builder.lineStream_! (_: ProcessLogger)).expects(*)

    val lircParser = new DefaultLircParser(process, provider)
    lircParser.listDevices must be(Seq("sony", "jvc"))
  }

  it should "find buttons for a device" in {

    val process = mock[ProcessCreation]
    val builder = mock[ProcessBuilder]
    val provider = mock[Provider[TestableProcessLogger]]
    val logger = mock[TestableProcessLogger]

    (process.apply(_:String,_:Seq[String])).expects("irsend", Seq("list", "sony", "")).returns(builder)
    (logger.processLogger _).expects().returns(null)
    (logger.lines _).expects().returns(List("irsend: 0000000000000481 KEY_VOLUMEUP", "irsend: 0000000000000c81 KEY_VOLUMEDOWN"))
    (provider.get _).expects().returns(logger)
    (builder.lineStream_! (_:ProcessLogger)).expects(*)

    val lircParser = new DefaultLircParser(process, provider)
    lircParser.listButtons("sony") must be(Seq("KEY_VOLUMEUP", "KEY_VOLUMEDOWN"))
  }

  it should "press buttons for a device" in {

    val process = mock[ProcessCreation]
    val builder = mock[ProcessBuilder]
    val provider = mock[Provider[TestableProcessLogger]]
    val logger = mock[TestableProcessLogger]

    (process.apply(_:String,_:Seq[String])).expects("irsend", Seq("SEND_ONCE", "sony", "KEY_VOLUMEUP")).returns(builder)
    (builder.! _).expects().returns(0)

    val lircParser = new DefaultLircParser(process, null)
    lircParser.pressButton("sony", "KEY_VOLUMEUP") must be(true)
  }
}
