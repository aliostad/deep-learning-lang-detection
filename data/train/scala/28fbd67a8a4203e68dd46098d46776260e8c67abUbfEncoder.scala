/**
  * @since 08.02.2016.
  */

object UbfEncoder {

  def encode(o: UbfObject): String = write(o) + "$"

  protected def write(obj: UbfObject): String = obj match {
    case s: UbfString => write(s)
    case s: UbfAtom => write(s)
    case s: UbfBinary => write(s)
    case s: UbfInteger => write(s)
    case s: UbfTuple => write(s)
    case s: UbfList => write(s)
  }

  protected def write(s: UbfString): String = writeDelimited(s.value, '\"')

  protected def write(s: UbfAtom): String = writeDelimited(s.value, '\'')

  protected def write(b: UbfBinary): String =
    b.size.toString + "~" + new String(b.value.toArray) + "~"

  protected def write(obj: UbfInteger): String = obj.value.toString

  protected def write(obj: UbfTuple): String =
    obj.value.map { write } mkString("{"," ","}")

  protected def write(obj: UbfList): String = {
    val closing = if (obj.value.nonEmpty) " & " else ""
    obj.value.map { write } mkString("# ", " & ", closing)
  }

  protected def writeDelimited(s: String, delimiter: Char): String =
    (delimiter :: s.foldLeft(delimiter :: Nil) { (acc, c) =>
      c match {
        case del if del == delimiter => delimiter :: '\\' :: acc
        case '\\' => '\\' :: '\\' :: acc
        case other => other :: acc
      }
    }).reverse.mkString

}
