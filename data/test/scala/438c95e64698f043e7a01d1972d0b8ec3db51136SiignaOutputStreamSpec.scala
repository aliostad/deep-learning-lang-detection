package com.siigna.util.io

import org.scalatest.{BeforeAndAfter, FunSpec}
import org.scalatest.matchers.ShouldMatchers
import org.ubjson.io.{ByteArrayInputStream, UBJInputStream, IUBJTypeMarker, ByteArrayOutputStream}
import version.IOVersion
import java.nio.charset.CharsetDecoder
import java.nio.CharBuffer
import java.lang.String
import com.siigna.app.model.Model
import com.siigna.util.collection.Attributes

/**
 * Tests the siigna output stream class.
 */
class SiignaOutputStreamSpec extends FunSpec with ShouldMatchers with BeforeAndAfter {

  var arr : ByteArrayOutputStream = null
  var out : SiignaOutputStream = null
  var in : SiignaInputStream = null

  before {
    arr = new ByteArrayOutputStream()
    out = new SiignaOutputStream(arr, IOVersion(IOVersion.Current))
    in = new SiignaInputStream(new ByteArrayInputStream(arr.getArray), IOVersion(IOVersion.Current))
  }

  describe("SiignaOutputStream") {

    it("can write null") {
      out.writeObject(null)
      in.readNull()
    }

    it ("can write a byte") {
      out.writeObject(2.asInstanceOf[Byte])
      in.readByte() should equal(2.asInstanceOf[Byte])
    }

    it ("can write a char") {
      out.writeObject('x')
      in.readByte() should equal('x'.asInstanceOf[Byte])
    }

    it ("can write a short") {
      val n = -137.asInstanceOf[Short]
      out.writeObject(n.asInstanceOf[Short])
      in.readInt16() should equal (n)
    }

    it ("can write an int") {
      val n = 13182381
      out.writeObject(n)
      in.readInt32() should equal (n)
    }

    it ("can write a long") {
      val n = 1238912321L
      out.writeObject(n)
      in.readInt64() should equal(n)
    }

    it ("can write a double") {
      val n = 7941.371562d
      out.writeObject(n)
      in.readDouble() should equal(n)
    }

    it ("can write a string") {
      val s = "Hello world! ÆØÅ - §!\"#¤%&/()=? _ @£$€{[]} | ^\\ - ça va?"
      out.writeObject(s)
      in.readString() should equal (s)
    }

    it ("can write multiple objects") {
      val i = 123L
      val s = "Hi! Tæll Me Måre $\\^^\"@!"
      val d = 134123d
      out.writeObject(i)
      out.writeObject(s)
      out.writeObject(d)
      out.writeObject(null)
      out.writeObject(s)
      out.writeObject(d)
      in.readInt64() should equal(i)
      in.readString() should equal(s)
      in.readDouble() should equal(d)
      in.readNull()
      in.readString() should equal(s)
      in.readDouble() should equal(d)
    }

  }

}
