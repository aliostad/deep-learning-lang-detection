package org.change.parser.verification

import generated.reachlang.ReachLangBaseVisitor
import generated.reachlang.ReachLangParser.InvariantContext
import org.change.v2.analysis.memory.TagExp
import scala.collection.JavaConverters._
import org.change.symbolicexec.types._

object InvariantListParser extends ReachLangBaseVisitor[List[TagExp]] {
  override def visitInvariant(ctx: InvariantContext): List[TagExp] =
    (for {
      f <- ctx.field().asScala
      if TcpDumpFields.contains(f.getText)
    } yield tcpDumpToCanonical(f.getText)).toList
}
