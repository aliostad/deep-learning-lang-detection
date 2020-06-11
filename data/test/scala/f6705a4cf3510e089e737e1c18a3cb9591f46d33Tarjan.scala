package ks.configuration


object Tarjan {

  def scc[T](graph:Map[T,Set[T]]): Map[T,T] = {
    //`dfs` finds all strongly connected components below `node`
    //`path` holds the the depth for all nodes above the current one
    //'sccs' holds the representatives found so far; the accumulator
    def dfs(node: T, path: Map[T,Int], sccs: Map[T,T]): Map[T,T] = {
      //returns the earliest encountered node of both arguments
      //for the case both aren't on the path, `old` is returned
      def shallowerNode(old: T,candidate: T): T =
        (path.get(old),path.get(candidate)) match {
          case (_,None) => old
          case (None,_) => candidate
          case (Some(dOld),Some(dCand)) =>  if(dCand < dOld) candidate else old
        }

      //handle the child nodes
      val children: Set[T] = graph(node)
      //the initially known shallowest back-link is `node` itself
      val (newState,shallowestBackNode) = children.foldLeft((sccs,node)){
        case ((foldedSCCs,shallowest),child) =>
          if(path.contains(child))
            (foldedSCCs, shallowerNode(shallowest,child))
          else {
            val sccWithChildData = dfs(child,path + (node -> path.size),foldedSCCs)
            val shallowestForChild = sccWithChildData(child)
            (sccWithChildData, shallowerNode(shallowest, shallowestForChild))
          }
      }

      newState + (node -> shallowestBackNode)
    }

    //run the above function, so every node gets visited
    graph.keys.foldLeft(Map[T,T]()){ case (sccs,nextNode) =>
      if(sccs.contains(nextNode))
        sccs
      else
        dfs(nextNode,Map(),sccs)
    }
  }
}
