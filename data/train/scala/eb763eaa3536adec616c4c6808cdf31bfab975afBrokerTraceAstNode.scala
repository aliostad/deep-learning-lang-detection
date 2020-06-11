package ru.mg.parsing.broker.trace.ast


object BrokerTraceAstNode {
  def brokerTraceLineNode = { (timestamp: String, threadId: String, traceType: String, message: String) =>
    new BrokerTraceLineNode(timestamp, threadId, traceType, message)
  }

  def brokerStatementNode = { (timestamp: String, threadId: String, traceType: String, nodeName: String, statement: String, codePart: String, lineNo: Long) =>
    new BrokerTraceStatementNode(timestamp, threadId, traceType, nodeName, statement, codePart, lineNo)
  }
}

sealed abstract class BrokerTraceAstNode (
  timestamp: String,
  threadId: String,
  traceType: String
)

case class BrokerTraceLineNode(
  timestamp: String,
  threadId: String,
  traceType: String,
  message: String
) extends BrokerTraceAstNode(timestamp, threadId, traceType)

case class BrokerTraceStatementNode(
  timestamp: String,
  threadId: String,
  traceType: String,
  nodeName: String,
  statement: String,
  codePart: String,
  esqlLineNo: Long
) extends BrokerTraceAstNode(timestamp, threadId, traceType)
