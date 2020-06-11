package com.komanov.serialization.converters

import java.io.ByteArrayOutputStream

import com.komanov.serialization.domain.SiteEventData
import org.apache.commons.io.HexDump
import org.specs2.mutable.SpecificationWithJUnit
import org.specs2.specification.Scope
import org.specs2.specification.core.Fragments

class SerializationTest extends SpecificationWithJUnit {

  sequential

  doTest("JSON", JsonConverter)
  doTest("ScalaPB", ScalaPbConverter)
  doTest("Java Protobuf", JavaPbConverter)
  doTest("Java Thrift", JavaThriftConverter)
  doTest("Scrooge", ScroogeConverter)
  doTest("Serializable", JavaSerializationConverter)
  doTest("Pickling", PicklingConverter)
  doTest("BooPickle", BoopickleConverter)
  doTest("Chill", ChillConverter)

  "ScalaPB and Java Protobuf" should {
    Fragments.foreach(TestData.sites) { case (name, site) =>
      s"be interoperable for site of $name" in new ctx {
        val javaMessage = JavaPbConverter.toByteArray(site)
        val scalaMessage = ScalaPbConverter.toByteArray(site)
        toHexDump(javaMessage) must be_===(toHexDump(scalaMessage))
      }
    }

    Fragments.foreach(TestData.events) { case (name, events) =>
      s"be interoperable events of $name" in new ctx {
        for (SiteEventData(_, event, _) <- events) {
          val javaMessage = JavaPbConverter.toByteArray(event)
          val scalaMessage = ScalaPbConverter.toByteArray(event)
          toHexDump(javaMessage) must be_===(toHexDump(scalaMessage))
        }
      }
    }
  }

  "Scrooge and Java Thrift" should {
    Fragments.foreach(TestData.sites) { case (name, site) =>
      s"be interoperable for site of $name" in new ctx {
        val javaMessage = JavaThriftConverter.toByteArray(site)
        val scalaMessage = ScroogeConverter.toByteArray(site)
        toHexDump(javaMessage) must be_===(toHexDump(scalaMessage))
      }
    }

    Fragments.foreach(TestData.events) { case (name, events) =>
      s"be interoperable events of $name" in new ctx {
        for (SiteEventData(_, event, _) <- events) {
          val javaMessage = JavaThriftConverter.toByteArray(event)
          val scalaMessage = ScroogeConverter.toByteArray(event)
          toHexDump(javaMessage) must be_===(toHexDump(scalaMessage))
        }
      }
    }
  }

  class ctx extends Scope

  def toHexDump(arr: Array[Byte]): String = {
    if (arr.isEmpty) {
      ""
    } else {
      val baos = new ByteArrayOutputStream
      HexDump.dump(arr, 0, baos, 0)
      new String(baos.toByteArray)
    }
  }

  def doTest(converterName: String, converter: MyConverter) = {
    converterName should {
      Fragments.foreach(TestData.sites) { case (name, site) =>
        s"serialize-parse site of $name" in new ctx {
          val bytes = converter.toByteArray(site)
          val parsed = converter.fromByteArray(bytes)
          parsed must be_===(site)
        }
      }

      Fragments.foreach(TestData.events) { case (name, events) =>
        s"serialize-parse site events of $name" in new ctx {
          for (SiteEventData(_, event, _) <- events) {
            val bytes = converter.toByteArray(event)
            val parsed = converter.siteEventFromByteArray(event.getClass, bytes)
            parsed must be_===(event)
          }
        }
      }
    }
  }

}
