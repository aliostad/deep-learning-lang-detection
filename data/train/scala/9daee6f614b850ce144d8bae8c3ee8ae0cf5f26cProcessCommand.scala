package beyond.launcher

object ProcessCommand {
  lazy val macProcessCommand = new MacProcessCommand()
  lazy val linuxProcessCommand = new LinuxProcessCommand()
  lazy val windowsProcessCommand = new WindowsProcessCommand()
  def apply(): ProcessCommand = {
    val linuxRex = "Linux(.)*".r
    val macRex = "Mac(.)*".r
    val windowsRex = "Windows(.)*".r
    System.getProperty("os.name") match {
      case linuxRex(_) => linuxProcessCommand
      case macRex(_) => macProcessCommand
      case windowsRex(_) => windowsProcessCommand
    }
  }
}

trait ProcessCommand {
  def terminate(pid: Int): Int
}
