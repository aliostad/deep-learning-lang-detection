package pl.umk.bugclassification.scmparser.invokers
import scala.sys.process.Process

trait InvokerOnDirectory {

  def dirUrl: String

  protected def createProcessBuilder(command: Command): scala.sys.process.ProcessBuilder = {
    val pb = Process((new java.lang.ProcessBuilder(command.command))
      directory new java.io.File(dirUrl))
    return pb
  }

  protected def createProcessBuilder(command: Command, subDir:String): scala.sys.process.ProcessBuilder = {
    val pb = Process((new java.lang.ProcessBuilder(command.command))
      directory new java.io.File(dirUrl+subDir))
    return pb
  }
}