package g.scala.anyval

/**
 * // TODO: Document this
 * @author Galder Zamarreño
 * @since // TODO
 */
object FluentInheritanceWrapping extends App {

  class AsyncFile(val asJava: JavaAsyncFile) extends AnyVal {
    def flush(): AsyncFile = {
      println("WriteStreamAsyncFileOps.write()")
      asJava.flush()
      this
    }
  }

  //

//  class WriteStreamAsyncFileOps(val async: AsyncFile) extends AnyVal {
//    def write(): AsyncFile = {
//      println("WriteStreamAsyncFileOps.write()")
//      async.asJava.write()
//      async
//    }
//  }

//  class WriteStream(val asJava: JavaWriteStream[_]) extends AnyVal {
//    def write(): WriteStream = {
//      println("I'm B")
//      asJava.write()
//      this
//    }
//  }

///  @inline implicit def asWriteStream(a: AsyncFile) = new WriteStreamAsyncFileOps(a)

//  new AsyncFile(new JavaAsyncFile{
//    def write(): JavaAsyncFile = {
//      println("I'm java write file")
//      this
//    }
//
//    def flush(): JavaAsyncFile = {
//      println("I'm java flush file")
//      this
//    }
//
//  }).write().flush()

}
