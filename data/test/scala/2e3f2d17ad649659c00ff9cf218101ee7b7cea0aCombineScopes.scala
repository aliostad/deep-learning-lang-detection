package compile

/**
  * Combines all SymbolTable's in a program into one.
  * Adds '^' to the beginning of symbols from embedded blocks.
  */
object CombineScopes {
  import IR._
  import IRShared._
  import SymbolTable._
  import FunctionalUtils._

  def combineScopes(program: ProgramIR) : ProgramIR = {
    val methods: List[MethodSymbol] = program.symbols.getMethods
    methods.map(m => m.block = combineScopesTopLevel(m.block))
    return program
  }

  def combineScopesTopLevel(block: Block) : Block = {
    val newStmts = block.stmts.map(combineScopes(_, block.fields))
    return Block(newStmts, block.fields)
  }

  def combineScopes(stmt: Statement, table : SymbolTable) : Statement = stmt match {
    case a:Assignment => a

    case m:MethodCall => m

    case c:CalloutCall => c

    case If(preStmts, cond, thenb, elseb) => If(
      preStmts.map(combineScopes(_, table)),
      cond,
      combineScopes(thenb, table),
      elseb.map(combineScopes(_, table))
    )

    case For(id, start, iter, thenb) => For(
      id,
      start,
      iter,
      combineScopes(thenb, table)
    )

    case While(preStmts, cond, thenb, max) => While(
      preStmts.map(combineScopes(_, table)),
      cond,
      combineScopes(thenb, table),
      max
    )

    case r:Return => r

    case b:Break => b

    case c:Continue => c
  }

  def combineScopes(block: Block, table: SymbolTable) : Block = {
    val newBlock = combineScopesTopLevel(block)
    var newStmts = newBlock.stmts
    for (sym <- newBlock.fields.symbols) sym match {
      case FieldSymbol(dtype, oldId, size) => {
        val newId = "^" + oldId
        table.addSymbol(FieldSymbol(dtype, newId, size))
        newStmts = newStmts.map(renameVarStmt(oldId, newId))
      }
      case _ => ();
    }
    return Block(newStmts, table)
  }

  /**
    * Renames all references to the variable oldName with newName in
    * the given expression.
    */
  def renameVarExpr(oldName: ID, newName: ID)(expr: Expr) : Expr = {
    val renameE = renameVarExpr(oldName, newName)(_)
    expr match {
      case MethodCall(method, args) => MethodCall(method, args.map(_.map(renameE)));

      case CalloutCall(callout, args) => CalloutCall(callout, args.map(_.map(renameE)));

      case BinOp(left, op, right) => BinOp(
        renameE(left),
        op,
        renameE(right)
      )

      case UnaryOp(op, operand) => UnaryOp(op, renameE(operand))

      case Ternary(cond, left, right) => Ternary(
        renameE(cond),
        renameE(left),
        renameE(right)
      )

      case LoadField(FieldSymbol(dtype, id, size), index) =>
        val name = if (id == oldName) newName else id
        LoadField(FieldSymbol(dtype, name, size), index.map(renameE))

      case _:LoadInt  => expr
      case _:LoadBool => expr
    }
  }

  /**
    * Renames all references to the variable oldName with newName in
    * the given statement.
    */
  def renameVarStmt(oldName: ID, newName: ID)(stmt: Statement) : Statement = {
    val renameE = renameVarExpr(oldName, newName)(_)
    val renameS = renameVarStmt(oldName, newName)(_)
    val renameB = renameVarBlock(oldName, newName)(_)
    stmt match {
      case Assignment(Store(FieldSymbol(dtype, id, size), index), right) =>
        val name = if (id == oldName) newName else id
        Assignment(Store(FieldSymbol(dtype, name, size), index.map(renameE)), renameE(right))

      case MethodCall(method, args) => MethodCall(method, args.map(_.map(renameE)));

      case CalloutCall(callout, args) => CalloutCall(callout, args.map(_.map(renameE)));

      case If(preStmts, cond, thenb, elseb) => If(
        preStmts.map(renameS),
        renameE(cond),
        renameB(thenb),
        elseb.map(renameB)
      )

      case For(id, start, iter, thenb) => For(
        id,
        renameE(start),
        renameE(iter),
        renameB(thenb)
      )

      case While(preStmts, condition, block, max) => While(
        preStmts.map(renameS),
        renameE(condition),
        renameB(block),
        max
      )

      case Return(expr) => Return(expr.map(renameE))
      case b: Break => b
      case c: Continue => c
    }
  }

  /**
    * Renames all references to the variable oldName with newName in
    * the given block.
    */
  def renameVarBlock(oldName: ID, newName: ID)(block: Block) : Block = {
    return Block(block.stmts.map(renameVarStmt(oldName, newName)), block.fields)
  }

}
