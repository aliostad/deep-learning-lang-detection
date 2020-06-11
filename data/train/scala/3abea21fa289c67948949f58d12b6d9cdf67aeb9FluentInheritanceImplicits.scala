package g.scala.anyval

/**
 * // TODO: Document this
 * @author Galder Zamarreño
 * @since // TODO
 */
object FluentInheritanceImplicits extends App {

  trait ScalaWrapper[In] {
    type Out
    def wrap(i:In): Out
  }

  implicit def wrap[A](i:A)(implicit wrap: ScalaWrapper[A]): wrap.Out = wrap wrap i

  // @inline
  implicit def asWriteStream(a: AsyncFile) = new WriteStream(a.asJava)

  implicit val asAsyncFileWrapper = new ScalaWrapper[JavaAsyncFile]{
    type Out = AsyncFile
    def wrap(i: JavaAsyncFile): AsyncFile = new AsyncFile(i)
  }

  implicit val asWriteStreamWrapper = new ScalaWrapper[JavaWriteStream[_]] {
    type Out = WriteStream
    def wrap(i: JavaWriteStream[_]): WriteStream = new WriteStream(i)
  }

//  implicit val writeStreamAsAsyncFile = new ScalaWrapper[JavaWriteStream[_]]{
//    type Out = AsyncFile
//    def wrap(i: JavaWriteStream[_]): AsyncFile = new AsyncFile(i)
//  }

  //  import asAsyncFile._

  class AsyncFile(val asJava: JavaAsyncFile) extends AnyVal

  class WriteStream(val asJava: JavaWriteStream[_]) extends AnyVal {
    def write()(implicit wrapper: ScalaWrapper[JavaWriteStream[_]]): wrapper.Out = {
      println("I'm B")
      asJava.write()
      // wrap(asJava)
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

  // file.write()



}

