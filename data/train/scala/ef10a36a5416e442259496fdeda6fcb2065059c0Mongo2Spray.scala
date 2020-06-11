package hu.tilos.service3

import java.nio.ByteBuffer

import scala.util.Failure
import scala.util.Success
import scala.util.Try

import org.apache.commons.codec.binary.Hex
import org.jboss.netty.buffer.ChannelBuffers


import reactivemongo.bson._
import spray.json._

/**
  * @author rleibman
  *
  * source: https://gist.github.com/rleibman/7103325d0193be268ed7
  */
trait Mongo2Spray {

  implicit val writer = new BSONDocumentWriter[JsObject] {

    override def write(json: JsObject): BSONDocument = {
      BSONDocument(json.fields.map(writePair))
    }

    private def writeArray(arr: JsArray): BSONArray = {
      val values = arr.elements.zipWithIndex.map(p ⇒ writePair((p._2.toString, p._1))).map(_._2)
      BSONArray(values)
    }

    private val IsoDateTime = """^(\d{4,})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})\.(\d{3})Z$""".r

    private def manageTimestamp(o: JsObject) = o.fields.toList match {
      case ("t", JsNumber(t)) :: ("i", JsNumber(i)) :: Nil ⇒
        Success(BSONTimestamp((t.toLong & 4294967295L) | (i.toLong << 32)))
      case _ ⇒ Failure(new IllegalArgumentException("Illegal timestamp value"))
    }

    private def manageSpecials(obj: JsObject): BSONValue =
      if (obj.fields.size > 2) writeObject(obj)
      else (obj.fields.toList match {
        case ("$oid", JsString(str)) :: Nil            ⇒ Try(BSONObjectID(Hex.decodeHex(str.toArray)))
        case ("$undefined", JsTrue) :: Nil             ⇒ Success(BSONUndefined)
        // case ("$minKey", JsNumber(n)) :: Nil if n == 1 => Success(BSONMinKey) // Bug on reactivemongo
        case ("$maxKey", JsNumber(n)) :: Nil if n == 1 ⇒ Success(BSONMaxKey)
        case ("$js", JsString(str)) :: Nil             ⇒ Success(BSONJavaScript(str))
        case ("$sym", JsString(str)) :: Nil            ⇒ Success(BSONSymbol(str))
        case ("$jsws", JsString(str)) :: Nil           ⇒ Success(BSONJavaScriptWS(str))
        case ("$timestamp", ts: JsObject) :: Nil       ⇒ manageTimestamp(ts)
        case ("$regex", JsString(r)) :: ("$options", JsString(o)) :: Nil ⇒
          Success(BSONRegex(r, o))
        case ("$binary", JsString(d)) :: ("$type", JsString(t)) :: Nil ⇒
          Try(BSONBinary(ChannelBuffers.wrappedBuffer(Hex.decodeHex(d.toArray)).array(),
            findSubtype(Hex.decodeHex(t.toArray))))
        // case ("$ref", JsString(v)) :: ("$id", JsString(i)) :: Nil => // Not implemented
        //   Try(BSONDBPointer(v, Hex.decodeHex(i.toArray)))
        case _ ⇒ Success(writeObject(obj))
      }) match {
        case Success(v) ⇒ v
        case Failure(_) ⇒ writeObject(obj)
      }

    def findSubtype(bytes: Array[Byte]) =
      ByteBuffer.wrap(bytes).getInt match {
        case 0x00 ⇒ Subtype.GenericBinarySubtype
        case 0x01 ⇒ Subtype.FunctionSubtype
        case 0x02 ⇒ Subtype.OldBinarySubtype
        case 0x03 ⇒ Subtype.UuidSubtype
        case 0x05 ⇒ Subtype.Md5Subtype
        // case 0X80 => Subtype.UserDefinedSubtype // Bug on reactivemongo
        case _    ⇒ throw new IllegalArgumentException("unsupported binary subtype")
      }

    private def writeObject(obj: JsObject): BSONDocument = BSONDocument(obj.fields.map(writePair))

    private def writePair(p: (String, JsValue)): (String, BSONValue) = (p._1, p._2 match {
      case JsString(str)   ⇒ BSONString(str)
      case JsNumber(value) ⇒ BSONDouble(value.doubleValue)
      case obj: JsObject   ⇒ manageSpecials(obj)
      case arr: JsArray    ⇒ writeArray(arr)
      case JsTrue          ⇒ BSONBoolean(true)
      case JsFalse         ⇒ BSONBoolean(false)
      case JsNull          ⇒ BSONNull
    })
  }


}
