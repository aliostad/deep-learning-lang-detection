package joos.assemgen

import java.io.PrintWriter
import joos.core.Writable

trait AssemblyExpression extends AssemblyLine {
  self =>

  def +(other: AssemblyExpression) = {
    new AssemblyExpression {
      override def write(writer: PrintWriter) {
        self.write(writer)
        writer.write(" + ")
        other.write(writer)
      }
    }
  }

  def -(other: AssemblyExpression) = {
    new AssemblyExpression {
      override def write(writer: PrintWriter) {
        self.write(writer)
        writer.write(" - ")
        other.write(writer)
      }
    }
  }
}
