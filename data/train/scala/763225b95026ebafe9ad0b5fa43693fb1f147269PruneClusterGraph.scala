package com.mikea.bayes.belief


object PruneClusterGraph {

  def prune(graph: ClusterGraph): ClusterGraph = ???/*{
    val unionFind = new WeightedUnionFind(graph.V())
    val prunedNodes = newHashSet()
    for (v <- 0 until graph.V(); edge <- graph.intGraph.edges(v)) {
      val w = edge.other(v)
      val vSet = graph.node(v)
      val wSet = graph.node(w)
      if (vSet.containsAll(wSet) && !prunedNodes.contains(wSet)) {
        unionFind.union(v, w)
        prunedNodes.add(wSet)
      } else if (wSet.containsAll(vSet) && !prunedNodes.contains(vSet)) {
        unionFind.union(v, w)
        prunedNodes.add(vSet)
      }
    }
    val newNodes = new Array[VarSet](graph.V())
    for (v <- 0 until graph.V()) {
      val oldVarSet = graph.node(v)
      val v1 = unionFind.getComponent(v)
      newNodes(v1) = if (newNodes(v1) == null) oldVarSet else VarSet.union(newNodes(v1), oldVarSet)
    }
    val oldToNewNodes = newHashMap()
    for (v <- 0 until graph.V()) {
      val oldVarSet = graph.node(v)
      val v1 = unionFind.getComponent(v)
      oldToNewNodes.put(oldVarSet, newNodes(v1))
    }
    new ClusterGraphImpl(graph.getProbabilitySpace, Morph.morph(graph, new Function[VarSet, VarSet]() {

      override def apply(input: VarSet): VarSet = oldToNewNodes.get(input)
    }, new Function[List[VarSet], VarSet]() {

      override def apply(input: List[VarSet]): VarSet = VarSet.intersect(input)
    }, classOf[VarSet], false))
  }*/
}
