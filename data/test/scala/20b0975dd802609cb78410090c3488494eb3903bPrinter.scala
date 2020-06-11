package libgcode

import java.io._
import dzufferey.utils.IO

class Printer(writer: BufferedWriter) {

  def apply(cmd: Command) = {
    cmd.line.foreach( l => {
      writer.write('N')
      writer.write(l.toString)
      writer.write(' ')
    })
    cmd.ctype match {
      case CmdType.Empty =>
        ()
      case other =>
        writer.write(other.toString)
        writer.write(cmd.code.mkString("."))
        if (cmd.parameters.nonEmpty) writer.write(' ')
        writer.write(cmd.parameters.mkString(" "))
    }
    cmd.comment.foreach( c => {
      if (cmd.ctype != CmdType.Empty) writer.write(' ')
      if (c contains '\n') {
        writer.write("( ")
        writer.write(c)
        writer.write(" )")
      } else {
        writer.write(';')
        writer.write(c)
      }
    })
    writer.newLine
  }

  def apply(cmds: Seq[Command]) {
    cmds.foreach(apply)
  }

}

object Printer {

  def apply(cmds: Seq[Command] ): String = {
    val s = new StringWriter()
    val b = new BufferedWriter(s)
    apply(cmds, b)
    b.close
    s.toString
  }

  def apply(cmds: Seq[Command], fileName: String) {
    IO.writeInFile(fileName, (b: BufferedWriter) => apply(cmds, b))
  }

  def apply(cmds: Seq[Command], out: BufferedWriter) {
    val p = new Printer(out)
    p(cmds)
  }

}
