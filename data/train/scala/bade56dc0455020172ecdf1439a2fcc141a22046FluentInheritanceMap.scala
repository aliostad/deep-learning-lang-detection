package g.scala.anyval

/**
* // TODO: Document this
* @author Galder Zamarreño
* @since // TODO
*/
object FluentInheritanceMap extends App {

  class AsyncFile(val asJava: JavaAsyncFile) extends AnyVal {
    def flush(): AsyncFile = {
      asJava.flush()
      this
    }
  }

  // WriteStream[WriteStream] => WriteStream[AsyncFile]

  class WriteStream[+A](val asJava: JavaWriteStream[_]) extends AnyVal {

    def map[B](f: A => B): WriteStream[B] = {
      println("Map")
      // this.
      // f(this.)
      new WriteStream[B](asJava)
    }

    // def flatMap[B](f: A => WriteStream[B]): WriteStream[B] =

    def write(): WriteStream[A] = {
      asJava.write()
      this
    }

    // def map[B](f: A => B): WriteStream[B] = new WriteStream(f(asJava))
    // if (isEmpty) None else Some(f(this.get))

//    def write(): WriteStream = {
//      println("I'm B")
//      asJava.write()
//      this
//    }
  }

  @inline implicit def asWriteStream(a: AsyncFile) = new WriteStream[AsyncFile](a.asJava)

  private val f = new AsyncFile(new JavaAsyncFile {
    def write(): JavaAsyncFile = {
      println("I'm java async write")
      this
    }

    def flush(): JavaAsyncFile = {
      println("I'm java async flush")
      this
    }
  })
//  f.write()
//  f.flush()

  // f.map(_.write().map(_.flush()))
  f.write().map(_.flush())


}

