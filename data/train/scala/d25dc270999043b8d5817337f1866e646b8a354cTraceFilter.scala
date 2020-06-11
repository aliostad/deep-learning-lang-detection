package ru.mg.coverage.filter

import ru.mg.parsing.esql.ast.{BeginEndNode, EsqlAstNode}
import ru.mg.parsing.broker.trace.ast.{BrokerTraceStatementNode, BrokerTraceAstNode}

trait TraceFilter {

  protected def brokerTraces: List[BrokerTraceAstNode]

  protected def tracesForEsqlAstNode(node: EsqlAstNode) = {
    brokerTraces.filter { line: BrokerTraceAstNode =>
      line match {
        case trace: BrokerTraceStatementNode => isTraceForNode(node, trace)
        case _ => false
      }
    }
  }

  def isSameCodePart(node: EsqlAstNode, trace: BrokerTraceStatementNode) = node.codePart == trace.codePart

  def isInLineRange(node: EsqlAstNode, trace: BrokerTraceStatementNode): Boolean  = node match {
    // TODO relative line nums
    case b: BeginEndNode => true
    case _ => node.linesRange.contains(trace.esqlLineNo)
  }

  def isTraceForNode(node: EsqlAstNode, traceLine: BrokerTraceStatementNode) = isSameCodePart(node, traceLine) && isInLineRange(node, traceLine)
}
