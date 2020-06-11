package org.mephi.cquiz

import util.Random

object Pointers extends Topic {
  override val id = "pointers"

  override val titleKey = "pointersTitle"

  override val descriptionKey = "pointersDescription"

  override def question(_seed: Long) = new SimpleCOutput {
    protected override def write(code: Writer) {
      val rnd = new Random(_seed)
      rnd.shuffle(Seq("a", "b", "c", "d", "e", "f")) match {
        case Seq(v0, v1, p0, p1, pp0, pp1) =>
          code.write("int ")
            .write(v0).write(" = ").write(rnd.nextInt(5)).write(", ")
            .write(v1).write(" = ").write(rnd.nextInt(5)).write(", ")
            .write("*").write(p0).write(" = ").write("&").write(if (rnd.nextBoolean()) v0 else v1).write(", ")
            .write("*").write(p1).write(" = ").write("&").write(if (rnd.nextBoolean()) v0 else v1).write(", ")
            .write("**").write(pp0).write(" = ").write("&").write(if (rnd.nextBoolean()) p0 else p1).write(", ")
            .write("**").write(pp1).write(" = ").write("&").write(if (rnd.nextBoolean()) p0 else p1).write(";").nextLine()
          val sum = rnd.shuffle(Seq(v0, v1, "*" + p0, "*" + p1, "**" + pp0, "**" + pp1)).mkString(" + ")
          code.write( """printf("%i\n", """).write(sum).write(");").nextLine()
      }
    }
  }
}
