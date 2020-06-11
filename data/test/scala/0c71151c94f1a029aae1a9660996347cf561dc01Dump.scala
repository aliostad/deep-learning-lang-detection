package tiny08.statement

import tiny08.{Simulator, Machine}
import java.io.File

class Dump(val address: Int, val filename: String, val lineNum: Int)
  extends DebugCommand {

  val debugger = true

  def execute(machine: Machine) {
    val filenameOnly = new File(filename).getName
    for(r <- (0 to 15)) {
      val value = machine.getRegister(r)
      println(f"$filenameOnly:$lineNum: R$r = $value%2d")
    }
  }

  override def toString = {
    f"${s"%dump%\tat $address"}%-25s at $address"
  }
}

object Dump extends StatementFactory {
  def apply(code: String, addr: Int, filename: String, lineNum: Int): Option[Dump] = {
    val pattern = """%dump""".r
    code match {
      case pattern() => Some(new Dump(addr, filename, lineNum))
      case _ => None
    }
  }
}
