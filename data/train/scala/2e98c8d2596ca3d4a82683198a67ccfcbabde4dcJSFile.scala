package ru.maxkar.backend.js.model

import ru.maxkar.backend.js.out.CompactContext

/** Javascript file. */
final class JSFile private[model](
    globals : Map[AnyRef, String],
    vars : Seq[AnyRef],
    funcs :Seq[(AnyRef, FunctionBody)],
    inits :Seq[Statement]) {

  /** Writes to a context. */
  private def writeTo(ctx : CompactContext) : Unit = {
    val localIds = (vars ++ funcs.map(_._1)).toSet -- globals.keys.toSet

    val sc = ctx.sub(localIds, Seq.empty)

    /* Write variables. */
    if (!vars.isEmpty) {
      sc.write("var ")
      sc.sepby[AnyRef](vars, ',', sc.writeVariable)
      sc.write(';')
    }

    funcs.foreach(x ⇒ {
        sc.write("function ")
        sc.writeVariable(x._1)
        x._2.writeTo(sc)
      });

    inits.foreach(x ⇒  x.writeStatement(sc))
  }


  /** Writes context of this file into a writer. */
  def writeToWriter(w : java.io.Writer) : Unit = {
    val ctx = CompactContext.forWriter(w, globals)
    writeTo(ctx)
  }


  /** Writes a function. */
  private def writeFunc(ctx : CompactContext, n : String, b : FunctionBody) : Unit = {
    ctx.write("function ")
    ctx.write(n)
    b.writeTo(ctx)
  }
}
