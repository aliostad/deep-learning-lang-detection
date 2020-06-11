package scalapipe.opt

import scalapipe._

private[opt] object ReassignStates extends Pass {

    def run(context: IRContext, graph: IRGraph): IRGraph = {

        println("\tRelabeling states")

        val maxLabel = graph.blocks.map(_.label).max
        relabel(relabel(graph, maxLabel), 0)
    }

    private def relabel(g: IRGraph, start: Int): IRGraph = {
        val oldLabels = g.blocks.map(_.label).sortWith(_ < _)
        oldLabels.zipWithIndex.foldLeft(g) { (ng, v) =>
            val oldLabel = v._1
            val newLabel = if (v._1 == 0) 0 else v._2 + start
            val oldBlock = ng.block(oldLabel)
            ng.replace(oldBlock, oldBlock.copy(label = newLabel))
        }
    }

}
