package ru.maxkar.backend.js.model

import ru.maxkar.backend.js.out.CompactContext

/** Function body definition. */
final case class FunctionBody(
      args : Seq[AnyRef],
      vars : Seq[AnyRef],
      funcs : Seq[(AnyRef, FunctionBody)],
      labels : Seq[AnyRef],
      stmt : Seq[Statement]) {

  /** All declared locals. */
  private val allLocals : Set[AnyRef] = (
    args ++ vars ++ funcs.map(x ⇒ x._1)).toSet


  /** Writes function into a given context. */
  private[model] def writeTo(baseCtx : CompactContext) : Unit = {
    val ctx = baseCtx.sub(allLocals, labels)

    /* Write args. */
    ctx.write('(')
    val argsi = args.iterator
    if (argsi.hasNext)
      ctx.writeVariable(argsi.next)
    while (argsi.hasNext) {
      ctx.write(',')
      ctx.writeVariable(argsi.next)
    }
    ctx.write("){")

    /* Write local vars. */
    if (!vars.isEmpty) {
      ctx.write("var ")
      val varsi = vars.iterator
      ctx.writeVariable(varsi.next)
      while (varsi.hasNext) {
        ctx.write(',')
        ctx.writeVariable(varsi.next)
      }
      ctx.write(';')
    }

    /* Write local functions. */
    funcs.foreach(x ⇒  writeFunc(ctx, x._1, x._2))

    /* Write function statements. */
    stmt.foreach(x ⇒ x.writeStatement(ctx))

    /* End function. */
    ctx.write('}')
  }


  /** Writes a local function. */
  private def writeFunc(ctx : CompactContext, id : AnyRef,
      body : FunctionBody) : Unit = {
    ctx.write("function ")
    ctx.writeVariable(id)
    body.writeTo(ctx)
  }
}
