package ru.mg.coverage.tree

import ru.mg.parsing.esql.ast.{FunctionNode, ModuleNode, EsqlAstNode}
import ru.mg.coverage.ast.CoverageNode


trait EsqlAstTreeTraversal extends TreeTraversAndTransform[EsqlAstNode, CoverageNode] {

  protected def getChildren(node: EsqlAstNode) = node match {
    case m: ModuleNode => m.statements
    case f: FunctionNode => f.statements
    case _ => Nil
  }

  protected def accumulate(
    outputNode: CoverageNode,
    oldAccumulator: List[CoverageNode]): List[CoverageNode] =

    if(outputNode.ignore)
      oldAccumulator
    else
      outputNode :: oldAccumulator
}
