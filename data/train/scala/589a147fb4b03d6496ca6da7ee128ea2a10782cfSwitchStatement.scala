package ru.maxkar.backend.js.model

import ru.maxkar.backend.js.out.CompactContext

private[model] final class SwitchStatement(
      chooser : Expression,
      rmap : Seq[(Seq[Expression], Seq[Statement])],
      onElse : Option[Seq[Statement]])
    extends Statement {

  private[model] def writeStatement(ctx : CompactContext) : Unit = {
    ctx.write("switch(")
    chooser.writeExpression(ctx)
    ctx.write("){")

    for ((ks, ss) ← rmap) {
      if (!ks.isEmpty) {
        ks.foreach(ck ⇒  {
            ctx.write("case ")
            ck.writeExpression(ctx)
            ctx.write(':')
          })
        ss.foreach(_.writeStatement(ctx))
        ctx.write("break;")
      }
    }

    onElse match {
      case None ⇒ ()
      case Some(x) ⇒
        ctx.write("default:")
        x.foreach(_.writeStatement(ctx))
    }
    ctx.write('}')
  }
}
