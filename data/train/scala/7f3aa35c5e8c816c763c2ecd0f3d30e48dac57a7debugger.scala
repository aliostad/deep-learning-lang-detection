package object debugger {
  private val SHOW_DEBUGGING_1 = true
  private val SHOW_DEBUGGING_2 = false
  private val SHOW_DEBUGGING_3 = true

  def debug[A](msg: A): A = {
    if (SHOW_DEBUGGING_1) {
      println(Console.YELLOW + msg + Console.RESET)
    }
    return msg
  }

  def debug2[A](msg: A): A = {
    if (SHOW_DEBUGGING_2) {
      println(Console.MAGENTA + msg + Console.RESET)
    }
    return msg
  }

  def debug3[A](msg: A): A = {
    if (SHOW_DEBUGGING_3) {
      println(Console.CYAN + msg + Console.RESET)
    }
    return msg
  }
}
