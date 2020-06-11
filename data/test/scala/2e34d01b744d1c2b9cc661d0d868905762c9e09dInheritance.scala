package g.scala.anyval

/**
 * // TODO: Document this
 * @author Galder Zamarreño
 * @since // TODO
 */
object Inheritance extends App {

  class AsyncFile(val asJava: JavaAsyncFile) extends AnyVal

  class WriteStream(val asJava: JavaWriteStream[_]) extends AnyVal {
    def write(): WriteStream = {
      println("I'm B")
      asJava.write()
      this
    }
  }

  @inline implicit def asWriteStream(a: AsyncFile) = new WriteStream(a.asJava)

  new AsyncFile(new JavaAsyncFile{
    def write(): JavaAsyncFile = {
      println("I'm java write file")
      this
    }

    def flush(): JavaAsyncFile = {
      println("I'm java flush file")
      this
    }

  }).write()

}
