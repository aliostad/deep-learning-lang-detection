package scalapipe.opt

import scala.annotation.tailrec
import scalapipe._

private[opt] object CSE extends Pass {

    override def toString = "CSE"

    def run(context: IRContext, graph: IRGraph): IRGraph = {

        println("\tEliminating common subexpressions")

        cse(context, graph)

    }

    @tailrec
    private def cse(context: IRContext, graph: IRGraph): IRGraph = {

        val ae = AvailableExpressions.solve(context.kt, graph)

        // Find an expression to replace.
        // Note that ae is a mapping from block to a set of expressions
        // available to that block.
        val canReplace = graph.blocks.view.flatMap { block =>
            val nodes = block.nodes.flatMap { old =>
                val expr = ae(block.label).find { avail =>
                    !block.nodes.contains(avail) &&
                    (old.isInstanceOf[IRInstruction] ||
                     old.isInstanceOf[IRLoad]) &&
                    old.op == avail.op &&
                    old.op != NodeType.assign &&
                    !old.dests.isEmpty &&
                    !avail.dests.isEmpty &&
                    avail.srcs.equals(old.srcs) &&
                    old.srcs.forall(s => !s.isInstanceOf[PortSymbol])
                }
                expr.map(n => ((old, n)))
            }
            nodes
        }

        canReplace.headOption match {
            case Some((o, n)) =>
                val odest = o.dests.head
                val ndest = n.dests.head
                val assign = IRInstruction(NodeType.assign, odest, ndest)
                println("\t\tReplacing " + o + " with " + assign)
                val newGraph = graph.replace(o, assign)
                cse(context, newGraph)
            case None => graph
        }

    }

}
