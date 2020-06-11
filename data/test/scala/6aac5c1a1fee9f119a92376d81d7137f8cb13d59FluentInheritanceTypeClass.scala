package g.scala.anyval

/**
 * // TODO: Document this
 * @author Galder Zamarreño
 * @since // TODO
 */
object FluentInheritanceTypeClass extends App {

  class AsyncFile[T <: JavaAsyncFile](val asJava: T) extends AnyVal

  class WriteStreamWrap extends Wrap {
//    type Out = AsyncFile[JavaWriteStream[_]]
//    def wrap(it: WriteStream): AsyncFile[JavaWriteStream[_]] =
//      new AsyncFile[JavaWriteStream[_]](it.asJava)
  }

  class WriteStream(val asJava: JavaWriteStream[_]) extends AnyVal {
    def write(implicit wrap: Wrap): WriteStream = {
      println("I'm B")
      asJava.write()
      this
    }
  }

  trait Wrap {
//    type Out
//    def wrap(it: In): Out
  }


  implicit val writeStreamToAsyncFileWrap = new WriteStreamWrap

//  private val file = new AsyncFile(new JavaAsyncFile {
//    def write(): JavaAsyncFile = {
//      println("I'm java write file")
//      this
//    }
//
//    def flush(): JavaAsyncFile = {
//      println("I'm java flush file")
//      this
//    }
//  })

//  private val stream = new WriteStream(new JavaWriteStream[_] {
//    def write(): JavaWriteStream[_] = {
//      println("I'm java write file")
//      this
//    }
//  })
//
//  stream.write()


}
