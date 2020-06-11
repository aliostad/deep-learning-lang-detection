package scalisp

trait PortImpl {
  def in: Option[PortIn]
  def out: Option[PortOut]
  def close(): Either[String, Unit]
}

trait PortIn {
  type ReadResult[A] = Either[String, Option[A]]

  def readByte(): ReadResult[Byte]
  def readBytes(size: Int): ReadResult[Array[Byte]]
  def readLine(): ReadResult[Array[Byte]]
}

trait PortOut {
  type WriteResult = Either[String, Int]

  def writeByte(byte: Byte): WriteResult
  def writeBytes(bytes: Array[Byte]): WriteResult
  def writeLine(line: Array[Byte]): WriteResult
  def flush(): WriteResult
}
