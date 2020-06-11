package org.mephi.cquiz

/** Question: what does this C program print given no input? */
trait SimpleCOutput extends Question {
  final override def writeCode(code: Writer) {
    code.write("#include <stdio.h>").nextLine()
    for (include <- includes) {
      code.write("#include ").write(include).nextLine()
    }
    code.write("int main()").block {
      write(code)
      code.write("return 0;").nextLine()
    }.nextLine().nextLine()
  }

  final override lazy val answer = {
    val runner = new GdbRunner()
    val answer = try {
      runner.result((x, y) => writeCode(x), minSteps, maxSteps)
    } finally {
      runner.close()
    }
    answer
  }

  /** Writes relevant portion of main(). */
  protected def write(code: Writer)

  /** Returns additional includes. */
  protected def includes: Iterable[String] = None
}
