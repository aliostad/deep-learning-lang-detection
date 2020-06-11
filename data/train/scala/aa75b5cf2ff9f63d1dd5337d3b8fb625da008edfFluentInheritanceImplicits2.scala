package g.scala.anyval

/**
 * // TODO: Document this
 * @author Galder Zamarreño
 * @since // TODO
 */
object FluentInheritanceImplicits2 extends App {

  trait Wrapper[In] {
    type Out
    def wrap(i:In): Out
  }

  // implicit def wrap[A](i:A)(implicit wrap: Wrapper[A]): wrap.Out = wrap wrap i

  @inline implicit def asWriteStream(a: AsyncFile) = new WriteStream(a.asJava)

  implicit val asWriteStreamWrapper = new Wrapper[JavaWriteStream[_]] {
    type Out = WriteStream[JavaWriteStream[_]]
    def wrap(i: JavaWriteStream[_]): WriteStream[JavaWriteStream[_]] =
      new WriteStream[JavaWriteStream[_]](i)
  }

  implicit val asAsyncFileWrapper = new Wrapper[JavaAsyncFile] {
    type Out = AsyncFile
    def wrap(i: JavaAsyncFile): AsyncFile = new AsyncFile(i)
  }

  class AsyncFile(val asJava: JavaAsyncFile) extends AnyVal {
    def flush(): AsyncFile = {
      asJava.flush()
      this
    }
  }

  class WriteStream[T <: JavaWriteStream[_]](val asJava: T) extends AnyVal {
    def write()(implicit wrapper: Wrapper[T]): wrapper.Out = {
      asJava.write()
      wrapper.wrap(asJava)
    }
  }

  private val file = new AsyncFile(new JavaAsyncFile {
    def write(): JavaAsyncFile = {
      println("I'm java write file")
      this
    }

    def flush(): JavaAsyncFile = {
      println("I'm java flush file")
      this
    }
  })

  println("Flush, then write:")
  file.flush().write()
  println("------------------")
  println("Write, then flush:")
  file.write().flush()

}

