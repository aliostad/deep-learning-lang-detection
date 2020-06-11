package exericse4

import exercise3._


object ReduceWhile {
  type T = WhileASTNode
  type S = WSKEAMachine.S
  type E = WSKEAMachine.E
  type A = WSKEAMachine.A
  type State = Tuple3[S,E,A]
  type ReduceTerm = Tuple2[T,State]
  val store0: S = WSKEAMachine.store0
  type WSKEA = WSKEAMachine.WSKEA

  // Aufgabe 1
  def initProgram(prog: T, input: E): ReduceTerm =
    (prog,(store0, input, Nil))

  def semanticFunc(rTerm: ReduceTerm): ReduceTerm = {
    val (term, _) = rTerm
    val wskea = initWSKEA(rTerm)
    term match {
      case Skip => rTerm
      case t: Term => semanticFunc(deltaKArithmetic(wskea))
      case b: BooleanTerm => semanticFunc(deltaKBooleanTerm(wskea))
      case c: Command => semanticFunc(deltaKCommand(wskea))
      case _ => throw new RuntimeException("can not apply semantic reduce function")
    }
  }

  def initWSKEA(rTerm: ReduceTerm): WSKEA = {
    val (t,(s,e,a)) = rTerm
    (Nil, s, t :: Nil, e, a)
  }

  def deltaKArithmetic(wskea: WSKEA): ReduceTerm = {
    val (w,s,_,e,a) = WSKEAMachine.delta(wskea)
    val Number(n) :: ws = w
    (Number(n), (s,e,a))
  }

  def deltaKBooleanTerm(wskea: WSKEA): ReduceTerm = {
    val (w,s,_,e,a) = WSKEAMachine.delta(wskea)
    val TruthValue(b) :: ws = w
    (TruthValue(b), (s,e,a))
  }

  def deltaKCommand(wskea: WSKEA): ReduceTerm = {
    val (_,s,_,e,a) = WSKEAMachine.delta(wskea)
    (Skip, (s,e,a))
  }

  // Aufgabe 2
  def eval(prog: T, input: E) = {
    val startTuple = initProgram(prog, input)
    val result: Option[ReduceTerm] = reduce(startTuple)
    result match {
      case Some((Skip, (s,e,a))) => a.reverse
      case Some((t, (s,e,a))) => throw new RuntimeException("can not reduce this term")
      case None => throw new RuntimeException("undefined state")
    }
  }

  def reduce(rTerm: ReduceTerm): Option[ReduceTerm] = {
    var rTermBefore: Option[ReduceTerm] = Some(rTerm)
    var rTermAfter: Option[ReduceTerm] = reduceStep(rTermBefore)
    while (rTermBefore != rTermAfter) {
      rTermBefore = rTermAfter
      rTermAfter = reduceStep(rTermBefore)
    }
    rTermBefore
  }

  def reduceStep(rTerm: Option[ReduceTerm]): Option[ReduceTerm] = {
    if (rTerm.isEmpty) rTerm
    val Some((t, oldState)) = rTerm
    println((t, oldState))
    val (s,e,a) =   oldState
    t match {

      // term part
      case Identifier(id) =>
        if (s.contains(id))
          Some((Number(s(id)), oldState))
        else
          None

      case BinOp(op, Number(num), Number(mun)) =>
        op match {
          case ArithmeticOp.Plus => Some((Number(num + mun), oldState))
          case ArithmeticOp.Minus => Some((Number(num - mun), oldState))
          case ArithmeticOp.Times => Some((Number(num * mun), oldState))
          case ArithmeticOp.Div =>
            if (mun == 0) throw new RuntimeException("Division with zero is not allowed")
            Some((Number(num / mun), oldState))
          case ArithmeticOp.Mod => Some((Number(num % mun), oldState))
          case _ => None
        }

      case BinOp(op, Number(num), right) =>
        val rightReduce = reduce(right, oldState)
        rightReduce match {
          case Some((Number(mun), newState)) => Some((BinOp(op, Number(num), Number(mun)), newState))
          case None => None
        }

      case BinOp(op,left, right) =>
        val leftReduce = reduce(left, oldState)
        leftReduce match {
          case Some((Number(num), newState)) => Some((BinOp(op, Number(num), right), newState))
          case None => None
        }

      case Read =>
        if (e.isEmpty)
          None
        else {
          val num :: es = e
          Some((Number(num), (s,es, a)))
        }

      // boolean term part
      case Not(arg) =>
        val argReduce = reduce(arg, oldState)
        argReduce match {
          case Some((TruthValue(b), newState)) => Some((TruthValue(!b), newState))
          case None => None
        }

      case BRead =>
        if (e.isEmpty)
          None
        else {
          val num :: es = e
          val b = if (num == 0) false else true
          Some((TruthValue(b), (s,es, a)))
        }

      case BinBooleanOp(op, Number(n1), Number(n2)) =>
        op match {
          case BooleanOp.Eq => Some((TruthValue(n1 == n2), oldState))
          case BooleanOp.GEq => Some((TruthValue(n1 >= n2), oldState))
          case BooleanOp.Greater => Some((TruthValue(n1 > n2), oldState))
          case BooleanOp.LEq => Some((TruthValue(n1 <= n2), oldState))
          case BooleanOp.Less => Some((TruthValue(n1 < n2), oldState))
          case BooleanOp.NEq => Some((TruthValue(n1 != n2), oldState))
          case _ => None
        }

      case BinBooleanOp(op, Number(n1), right) =>
        val rightReduce = reduce(right, oldState)
        rightReduce match {
          case Some((Number(n2), newState)) => Some((BinBooleanOp(op, Number(n1), Number(n2)), newState))
          case None => None
        }

      case BinBooleanOp(op,left, right) =>
        val leftReduce = reduce(left, oldState)
        leftReduce match {
          case Some((Number(num), newState)) => Some((BinBooleanOp(op, Number(num), right), newState))
          case None => None
        }

      // commands part
      case Assign(Identifier(id), rvalue) =>
        val rvalueReduced = reduce(rvalue, oldState)
        rvalueReduced match {
          case Some((Number(num), (newS, newE, newA))) => Some((Skip, (newS + (id -> num), newE, newA)))
          case None => None
        }
      case CommandSeq(com :: seq) =>
        val comReduced = reduce(com, oldState)
        comReduced match {
          case Some((Skip, newState)) => Some(CommandSeq(seq), newState)
          case None => None
        }
      case CommandSeq(Nil) => Some(Skip, oldState)
      case If(cond, thenPart, elsePart) =>
        val conditionReduced = reduce(cond, oldState)
        conditionReduced match {
          case Some((TruthValue(b), newState)) =>
            if (b)
              Some(thenPart, newState)
            else
              Some(elsePart, newState)
          case None => None
        }

      case While(cond, body) =>
        val conditionReduced = reduce(cond, oldState)
        conditionReduced match {
          case Some((TruthValue(b), newState)) =>
            if (b)
              Some(CommandSeq(body :: While(cond, body) :: Nil), newState)
            else
              Some(Skip, newState)
          case None => None
      }
      case OutputTerm(term) =>
        val termReduced = reduce(term, oldState)
        termReduced match {
          case Some((Number(num), (newS, newE, newA))) => Some(Skip, (newS, newE, num :: newA))
          case None => None
        }

      case OutputBTerm(bTerm) =>
        val termReduced = reduce(bTerm, oldState)
        termReduced match {
          case Some((TruthValue(b), (newS, newE, newA))) =>
            val n = if (b) 1 else 0
            Some(Skip, (newS, newE, n :: newA))
          case None => None
        }
      case _ => rTerm
    }
  }
}