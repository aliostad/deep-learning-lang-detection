package exercises.chapter18

/**
 * Created by michal on 12/25/14.
 */
object e7 extends App {
  def execute(target: { def process(): Unit; def close(): Unit}): Unit = {
    try {
      target.process()
    } finally {
      target.close()
    }
  }

  object TargetNoException {
    def process() = println("TargetNoException process")
    def close() = println("TargetNoException close")
  }


  object TargetException {
    def process() = {println("TargetException process"); throw new Exception("process exception")}
    def close() = println("TargetException close")
  }

  execute(TargetNoException)
  execute(TargetException)

}
