package util

import java.io.{ DataInput, DataOutput }
import definition.expression.Expression

trait StoreClassInfo extends Product {
  def classID: Int
}


trait CustomSerializer {
  def writeToStream(out: DataOutput): Unit
}


/**
  * Created by Kathi on 18.02.2015.
  */
object CollUtils {
  Log

  def iterHeadOption[T](iter: Iterator[T]): Option[T] = if (iter.hasNext) Some(iter.next()) else None

  def tryWith[A <: java.io.Closeable, B](resource: => A)(code: A => B): Option[B] =
    try {
      val r = resource
      try {Some(code(r))}
      finally {try {r.close()} catch {case e: Exception => Log.e(e); None}}
    } catch {
      case e: Exception => Log.e(e); None
    }

  def writePrimitive(out: DataOutput, data: Any): Unit = {
    data match {
      case i: Int => out.writeInt(i)
      case s: String => out.writeUTF(s)
      case l: Long => out.writeLong(l)
      case d: Double => out.writeDouble(d)
      case f: Float => out.writeFloat(f)
      case b: Boolean => out.writeBoolean(b)
      case e: Enumeration#Value => out.writeInt(e.id)
      case c: CustomSerializer => c.writeToStream(out)
      case e: Expression => out.writeUTF(e.encode)
      case sci: StoreClassInfo => out.writeInt(sci.classID); writeToStream(out, sci)
      case p: Product => writeToStream(out, p)
    }
  }

  def readOptString(in: DataInput): String = if (in.readBoolean()) in.readUTF() else ""

  def writeToStream(out: DataOutput, data: Product): Unit = {
    for (d <- data.productIterator)
      d match {
        case i: Int => out.writeInt(i)
        case s: String => out.writeUTF(s)
        case l: Long => out.writeLong(l)
        case d: Double => out.writeDouble(d)
        case f: Float => out.writeFloat(f)
        case b: Boolean => out.writeBoolean(b)
        case b: Byte => out.writeByte(b)
        case e: Expression => out.writeUTF(e.encode)
        case sci: StoreClassInfo => out.writeInt(sci.classID); writeToStream(out, sci)
        case e: Enumeration#Value => out.writeInt(e.id)
        case Some(sci: StoreClassInfo) => out.writeBoolean(true); out.writeInt(sci.classID); writeToStream(out, sci)
        case Some(p: Product) => out.writeBoolean(true); writeToStream(out, p)
        case Some(other) => writePrimitive(out, other)
        case None => out.writeBoolean(false)
        case seq: Seq[_] => out.writeInt(seq.size); for (el <- seq) writePrimitive(out, el)
        case c: CustomSerializer => c.writeToStream(out)
        case p: Product => writeToStream(out, p)
        case o => println("unknown type " + o + " " + o.getClass)
      }

  }
}

