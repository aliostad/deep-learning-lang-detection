package lib

class BackgroundProcessStreamReader(val process: java.lang.Process)(callback: String => Unit) {
  val thread = new Thread(new Runnable {
    override def run(): Unit = {
      val ss = scala.io.Source.fromInputStream(process.getInputStream)
      try ss.getLines().foreach(callback)
      finally ss.close()
    }
  })
  thread.setDaemon(true)
  thread.start()

  def shutdown(): Unit = {
    process.destroy()
  }
}

object BackgroundProcessStreamReader {
  def launch(exe: String, args: String*)(callback: String => Unit): BackgroundProcessStreamReader = {
    val processBuilder = new ProcessBuilder(List(exe) ++ args: _*)
    val process = processBuilder.start()
    new BackgroundProcessStreamReader(process)(callback)
  }
}
