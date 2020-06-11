package   model

import   model._
import   model.statement._

object StatementProcessor {
  def process(tu: TranslationUnit, visitor: StatementVisitor): Unit = {
    new StatementProcessor(visitor).process(tu)
  }
  def process(function: FunctionDef, visitor: StatementVisitor): Unit = {
    new StatementProcessor(visitor).process(function)
  }
  def process(statement: Statement, visitor: StatementVisitor): Unit = {
    new StatementProcessor(visitor).process(statement)
  }
}

class StatementProcessor(private val visitor: StatementVisitor) {

  def process(tu: TranslationUnit): Unit = {
    if (visitor.visit(tu) == StatementVisitor.Continue)
      tu.functions.foreach(f => process(f))
    visitor.leave(tu)
  }

  def process(function: FunctionDef): Unit = {
    if (visitor.visit(function) == StatementVisitor.Continue)
      process(function.body)
    visitor.leave(function)
  }

  def process(stmt: Statement): Unit = {
    if (visitor.visit(stmt) == StatementVisitor.Continue) {
      stmt match {
        case s: StatementBlock => process(s)
        case s: FunctionCallStatement => process(s)
        case s: DeclarationStatement => process(s)
        case s: ExpressionStatement => process(s)
        case s: ForStatement => process(s)
        case s: IfStatement => process(s)
        case s: WhileStatement => process(s)
        case s: DoStatement => process(s)
        case s: SwitchStatement => process(s)
        case s: CaseStatement => process(s)
        case s: ReturnStatement => process(s)
        case s: BreakStatement => process(s)
        case s: ContinueStatement => process(s)
        case s: DefaultStatement => process(s)
        case s: NullStatement => process(s)
        case s: GotoStatement => process(s)
        case s: LabelStatement => process(s)
        case s: AssignmentStatement => process(s)
        case _ => //println("Unknown Statement: " + stmt.getClass)
      }
    }
  }

  def process(stmt: StatementBlock): Unit = {
    if (visitor.visit(stmt) == StatementVisitor.Continue) {
      stmt.statements.foreach(s => process(s))
    }
    visitor.leave(stmt)
  }

  def process(stmt: FunctionCallStatement): Unit = {
    visitor.visit(stmt)
    visitor.leave(stmt)
  }

  def process(stmt: DeclarationStatement): Unit = {
    visitor.visit(stmt)
    visitor.leave(stmt)
  }

  def process(stmt: ExpressionStatement): Unit = {
    visitor.visit(stmt)
    visitor.leave(stmt)
  }

  def process(stmt: ForStatement): Unit = {
    if (visitor.visit(stmt) == StatementVisitor.Continue)
      process(stmt.body)
    visitor.leave(stmt)
  }

  def process(stmt: IfStatement): Unit = {
    if (visitor.visit(stmt) == StatementVisitor.Continue) {
      process(stmt.thenBody)
      if (stmt.elseBody.isDefined) process(stmt.elseBody.get)
    }
    visitor.leave(stmt)
  }

  def process(stmt: WhileStatement): Unit = {
    if (visitor.visit(stmt) == StatementVisitor.Continue)
      process(stmt.body)
    visitor.leave(stmt)
  }

  def process(stmt: DoStatement): Unit = {
    if (visitor.visit(stmt) == StatementVisitor.Continue)
      process(stmt.body)
    visitor.leave(stmt)
  }

  def process(stmt: SwitchStatement): Unit = {
    if (visitor.visit(stmt) == StatementVisitor.Continue)
      process(stmt.body)
    visitor.leave(stmt)
  }

  def process(stmt: CaseStatement): Unit = {
    visitor.visit(stmt)
    visitor.leave(stmt)
  }

  def process(stmt: ReturnStatement): Unit = {
    visitor.visit(stmt)
    visitor.leave(stmt)
  }

  def process(stmt: BreakStatement): Unit = {
    visitor.visit(stmt)
    visitor.leave(stmt)
  }

  def process(stmt: ContinueStatement): Unit = {
    visitor.visit(stmt)
    visitor.leave(stmt)
  }

  def process(stmt: DefaultStatement): Unit = {
    visitor.visit(stmt)
    visitor.leave(stmt)
  }

  def process(stmt: NullStatement): Unit = {
    visitor.visit(stmt)
    visitor.leave(stmt)
  }

  def process(stmt: GotoStatement): Unit = {
    visitor.visit(stmt)
    visitor.leave(stmt)
  }

  def process(stmt: LabelStatement): Unit = {
    if (visitor.visit(stmt) == StatementVisitor.Continue)
      process(stmt.nestedStmt)
    visitor.leave(stmt)
  }

  def process(stmt: AssignmentStatement): Unit = {
    visitor.visit(stmt)
    visitor.leave(stmt)
  }
}
