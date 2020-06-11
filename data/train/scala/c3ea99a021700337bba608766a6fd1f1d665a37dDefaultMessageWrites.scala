package backbone.format

import backbone.MessageWriter

/**
 * Default message writes for primitive data types.
 */
trait DefaultMessageWrites {

  /**
   * Write a Short value to a String value.
   */
  implicit val shortWrite: MessageWriter[Short] = new MessageWriter[Short] {
    override def write(message: Short): String = String.valueOf(message)
  }

  /**
   * Write a Int value to a String value.
   */
  implicit val intWrite: MessageWriter[Int] = new MessageWriter[Int] {
    override def write(message: Int): String = String.valueOf(message)
  }

  /**
   * Write a Long value to a String value.
   */
  implicit val longWrite: MessageWriter[Long] = new MessageWriter[Long] {
    override def write(message: Long): String = String.valueOf(message)
  }

  /**
   * Write a Float value to a String value.
   */
  implicit val floatWrite: MessageWriter[Float] = new MessageWriter[Float] {
    override def write(message: Float): String = String.valueOf(message)
  }

  /**
   * Write a Double value to a String value.
   */
  implicit val doubleWrite: MessageWriter[Double] = new MessageWriter[Double] {
    override def write(message: Double): String = String.valueOf(message)
  }

  /**
   * Write a Boolean value to a String value.
   */
  implicit val booleanWrite: MessageWriter[Boolean] = new MessageWriter[Boolean] {
    override def write(message: Boolean): String = String.valueOf(message)
  }

  /**
   * Write a String value to a String value.
   */
  implicit val stringWrite: MessageWriter[String] = new MessageWriter[String] {
    override def write(message: String): String = message
  }

  /**
   * Write a Array[Byte] value to a String value.
   */
  implicit val byteWrite: MessageWriter[Array[Byte]] = new MessageWriter[Array[Byte]] {
    override def write(message: Array[Byte]): String = new String(message)
  }

  /**
   * Write a Array[Char] value to a String value.
   */
  implicit val charWrite: MessageWriter[Array[Char]] = new MessageWriter[Array[Char]] {
    override def write(message: Array[Char]): String = new String(message)
  }

}
