package org.sproto

trait SeqWriter[Writer] {

  def writeElement[T](value: T)(implicit cw: CanWrite[T, Writer])

}

trait WriteSeqSupportLow {

  implicit def canWriteAsSeq[T, W](implicit conv: W => SeqWriter[W], cw: CanWrite[T, SeqWriter[W]]) = new CanWrite[T, W] {

    def write(that: T, writer: W) =
      cw.write(that, conv(writer))

  }

}

trait WriteSeqSupport extends WriteSeqSupportLow {

  def writeElement[T, W](that: T, to: SeqWriter[W])(implicit cw: CanWrite[T, W]) =
    to.writeElement(that)

  implicit def canWriteTraversable[T, W](implicit cw: CanWrite[T, W]) = new CanWrite[Traversable[T], SeqWriter[W]] {

    def write(that: Traversable[T], writer: SeqWriter[W]) {
      that.foreach(writer.writeElement(_))
    }

  }

}
