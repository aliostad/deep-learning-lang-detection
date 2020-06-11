package ru.mg.parsing.broker.trace.parser

import org.parboiled.scala._
import parts.{StatementParser, TimestampParser}
import ru.mg.parsing.broker.trace.ast.{BrokerTraceStatementNode, BrokerTraceLineNode}
import ru.mg.parsing.broker.trace.ast.BrokerTraceAstNode._

trait BrokerTraceParser extends StatementParser {

  def Trace = rule { TraceLines ~ EOI }

  def TraceLines = rule { zeroOrMore(StatementTraceLine | CommonTraceLine) ~ EOI }

  def StatementTraceLine: Rule1[BrokerTraceStatementNode] = rule {
    Timestamp ~ WS ~ ThreadId ~ WS ~ TraceType ~ WS ~ Node ~ WS ~ StatementTrace ~ WS ~ CodePlace ~~> { brokerStatementNode } ~ (oneOrMore(!(Timestamp) ~ ANY) | EOI)
  }

  def CommonTraceLine: Rule1[BrokerTraceLineNode] = rule {
    Timestamp ~ WS ~ ThreadId ~ WS ~ TraceType ~ WS ~ Message ~~> { brokerTraceLineNode }
  }

  def ThreadId = rule { oneOrMore("0" - "9") ~> { _.toString } }

  def TraceType = rule { oneOrMore(("a" - "z") | ("A" - "Z")) ~> { _.toString } }

  def Message = rule { oneOrMore(!(Timestamp) ~ ANY) ~> { _.toString } }

}
