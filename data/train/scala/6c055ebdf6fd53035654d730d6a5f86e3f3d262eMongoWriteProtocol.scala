package org.sproto.mongo

import org.sproto._
import com.mongodb.BasicDBObject
import com.mongodb.BasicDBList

class MongoWriter {

  var result: Any = null

}

class MongoObjectWriter extends MapWriter[MongoWriter] {

  val result = new BasicDBObject

  def writeField[T](name: String, value: T)(implicit canWrite: CanWrite[T, MongoWriter]) {
    val anyWriter = new MongoWriter // TODO Reusing?
    canWrite.write(value, anyWriter)
    result.put(name, anyWriter.result.asInstanceOf[AnyRef])
  }

}

class MongoListWriter extends SeqWriter[MongoWriter] {

  val result = new BasicDBList

  def writeElement[T](value: T)(implicit canWrite: CanWrite[T, MongoWriter]) {
    val anyWriter = new MongoWriter // TODO Reusing?
    canWrite.write(value, anyWriter)
    result.add(anyWriter.result.asInstanceOf[AnyRef])
  }

}

trait MongoWriteProtocolLow {

  implicit def canConvert[T](implicit cw: CanWrite[T, MongoWriter]) = new CanConvertTo[T, Any] {

    def convertTo(that: T) = {
      val w = new MongoWriter
      cw.write(that, w)
      w.result
    }

  }

}

trait MongoWriteProtocol extends WriteProtocol with WriteMapSupport with WriteOptionAsNoField with WriteSeqSupport with MongoWriteProtocolLow {

  implicit def canConvertToObj[T](implicit cw: CanWrite[T, MongoObjectWriter]) = new CanConvertTo[T, BasicDBObject] {

    def convertTo(that: T) = {
      val w = new MongoObjectWriter
      cw.write(that, w)
      w.result
    }

  }

  implicit def canConvertToList[T](implicit cw: CanWrite[T, MongoListWriter]) = new CanConvertTo[T, BasicDBList] {

    def convertTo(that: T) = {
      val w = new MongoListWriter
      cw.write(that, w)
      w.result
    }

  }

  implicit def toObjectWriter(w: MongoWriter) = {
    val r = new MongoObjectWriter
    w.result = r.result
    r
  }

  implicit def toListWriter(w: MongoWriter) = {
    val r = new MongoListWriter
    w.result = r.result
    r
  }

  def canWriteDirect[T] = new CanWrite[T, MongoWriter] {
    def write(that: T, to: MongoWriter) {
      to.result = that
    }
  }

  implicit val canWriteString = canWriteDirect[String]
  implicit val canWriteShort = canWriteDirect[Short]
  implicit val canWriteInt = canWriteDirect[Int]
  implicit val canWriteLong = canWriteDirect[Long]
  implicit val canWriteFloat = canWriteDirect[Float]
  implicit val canWriteDouble = canWriteDirect[Double]
  implicit val canWriteNumber = canWriteDirect[Number]
  implicit val canWriteBoolean = canWriteDirect[Boolean]

}

object MongoWriteProtocol extends MongoWriteProtocol
