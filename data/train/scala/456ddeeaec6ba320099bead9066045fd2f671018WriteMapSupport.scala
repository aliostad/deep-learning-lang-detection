package org.sproto

trait CanWriteInField[-That, -Writer] {

  def writeInField(name: String, that: That, mapWriter: MapWriter[Writer])

}

trait MapWriter[+Writer] {

  def writeField[T](name: String, value: T)(implicit cw: CanWrite[T, Writer])

}

trait WriteMapSupportLowest {

  implicit def canWriteInMap[T, W](implicit cw: CanWrite[T, W]) = new CanWriteInField[T, W] {

    def writeInField(name: String, that: T, mapWriter: MapWriter[W]) =
      mapWriter.writeField(name, that)

  }

}

trait WriteMapSupportLow extends WriteMapSupportLowest {

  implicit def canWriteAsMap[T, W](implicit conv: W => MapWriter[W], cw: CanWrite[T, MapWriter[W]]) = new CanWrite[T, W] {

    def write(that: T, writer: W) =
      cw.write(that, conv(writer))

  }

}

trait WriteMapSupport extends WriteMapSupportLow with WriteMapSupportGen {

  def writeField[T, W](name: String, that: T, to: MapWriter[W])(implicit cwf: CanWriteInField[T, W]) =
    cwf.writeInField(name, that, to)

  implicit def canWriteStringMap[T, W](implicit cw: CanWrite[T, W]) = new CanWrite[Map[String, T], MapWriter[W]] {

    def write(that: Map[String, T], writer: MapWriter[W]) {
      that.foreach(t => writer.writeField(t._1, t._2))
    }

  }

}

trait WriteOptionAsNoField {

  implicit def canWriteOptionAsNoField[T, W](implicit cw: CanWrite[T, W]) = new CanWriteInField[Option[T], W] {

    def writeInField(name: String, that: Option[T], mapWriter: MapWriter[W]) =
      that.foreach(mapWriter.writeField(name, _))

  }

}

object WriteMapSupport extends WriteMapSupport
