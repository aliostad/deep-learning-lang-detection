package org.rebeam.boxes.persistence

object PrimFormats {
  implicit val booleanFormat = new Format[Boolean] {
    def write(s: Boolean, c: WriteContext) = c.writer.write(BooleanToken(s))
    def read(c: ReadContext) = c.reader.pullBoolean()
  }
  implicit val intFormat = new Format[Int] {
    def write(s: Int, c: WriteContext) = c.writer.write(IntToken(s))
    def read(c: ReadContext) = c.reader.pullInt()
  }
  implicit val longFormat = new Format[Long] {
    def write(s: Long, c: WriteContext) = c.writer.write(LongToken(s))
    def read(c: ReadContext) = c.reader.pullLong()
  }
  implicit val floatFormat = new Format[Float] {
    def write(s: Float, c: WriteContext) = c.writer.write(FloatToken(s))
    def read(c: ReadContext) = c.reader.pullFloat()
  }
  implicit val doubleFormat = new Format[Double] {
    def write(s: Double, c: WriteContext) = c.writer.write(DoubleToken(s))
    def read(c: ReadContext) = c.reader.pullDouble()
  }
  implicit val bigIntFormat = new Format[BigInt] {
    def write(n: BigInt, c: WriteContext) = c.writer.write(BigIntToken(n))
    def read(c: ReadContext) = c.reader.pullBigInt()
  }
  implicit val bigDecimalFormat = new Format[BigDecimal] {
    def write(n: BigDecimal, c: WriteContext) = c.writer.write(BigDecimalToken(n))
    def read(c: ReadContext) = c.reader.pullBigDecimal()
  }
  implicit val stringFormat = new Format[String] {
    def write(s: String, c: WriteContext) = c.writer.write(StringToken(s))
    def read(c: ReadContext) = c.reader.pullString()
  }
}
