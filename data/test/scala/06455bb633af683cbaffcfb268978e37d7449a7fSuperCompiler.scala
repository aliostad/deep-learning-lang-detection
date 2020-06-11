package hosc.sc

import hosc.HLanguage._
import hosc.ProcessTree
import hosc.ProcessTree.Node

/**
 * Generic supercompilation algorithm as described in:
 * Sørensen, Glück. Introduction to Supercompilation. 
 */
trait SuperCompiler extends ProcessTreeOperations {

  def program: Program
  def relevantAncestors(beta: Node): List[Node]
  
  def findRenaming(relevantAncs: List[Node], beta: ProcessTree.Node): Option[Node]
  def findInstance(relevantAncs: List[Node], beta: ProcessTree.Node): Option[Node]
  def findEmbedding(relevantAncs: List[Node], beta: ProcessTree.Node): Option[Node]
  
  def processRenaming(tree: ProcessTree, up: Node, down: Node): ProcessTree
  def processInstance(tree: ProcessTree, up: Node, down: Node): ProcessTree
  def processEmbedding(tree: ProcessTree, up: Node, down: Node): ProcessTree
  def processOther(tree: ProcessTree, node: Node): ProcessTree

  def buildProcessTree(e: Expression): ProcessTree = {
    var p = ProcessTree(e)
    while (!p.isClosed) {
      val beta = p.leafs.find(!_.isProcessed).get
      p = step(p, beta)
      //println(p)
      //println("----")
    }
    p
  }

  def step(tree: ProcessTree, beta: ProcessTree.Node): ProcessTree = {
    val expr = beta.expr
    expr match {

      case LetExpression(_, _) => driveNode(tree, beta)

      case _ => {

        val relevantAncs = relevantAncestors(beta)
        
        lazy val baseNode: Option[Node] = findRenaming(relevantAncs, beta)
        lazy val superNode: Option[Node] = findInstance(relevantAncs, beta)
        lazy val embeddedNode: Option[Node] = findEmbedding(relevantAncs, beta)

        if (baseNode.isDefined) {
          processRenaming(tree, baseNode.get, beta)
        } else if (superNode.isDefined) {
          processInstance(tree, superNode.get, beta)
        } else if (embeddedNode.isDefined) {
          processEmbedding(tree, embeddedNode.get, beta)
        } else {
          processOther(tree, beta)
        }
      }

    }
  }
}