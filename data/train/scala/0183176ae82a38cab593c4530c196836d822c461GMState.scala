package gmachine

import utils.Addr
import utils.Heap
import utils.Heap.hNull

case class GMState(code : List[Instruction], stack : List[Addr],
              dump : List[(List[Instruction], List[Addr])], heap : Heap[Node], globals : Map[String, Addr], stats : GMStats) {

  def eval : List[GMState] = {
    //            println(showStack)
    //            println(showInstructions)
    //            println("--------------------")
    if (code.isEmpty)
      List(this)
    else
      this :: this.step.doAdmin.eval
  }

  def doAdmin : GMState = new GMState(code, stack, dump, heap, globals, stats.admin(heap.size))

  def step : GMState = code match {
    case Nil => throw new Exception("no code found")
    case PushConstr(t, ar) :: is if globals.contains("{Pack " + t + ", " + ar + "}") =>
      new GMState(is, globals("{Pack " + t + ", " + ar + "}") :: stack, dump, heap, globals, stats)
    case PushConstr(t, ar) :: is => {
      val (newHeap, a) = heap.alloc(NGlobal(ar, List(Pack(t, ar), Update(0), Unwind)))
      new GMState(is, a :: stack, dump, newHeap, globals + ("{Pack " + t + ", " + ar + "}" -> a), stats)
    }
    case PushGlobal(f) :: is => {
      val globF = globals.getOrElse(f, throw new Exception("undeclared global " + f))
      new GMState(is, globF :: stack, dump, heap, globals, stats)
    }
    case MkAp :: is => {
      val (newHeap, a) = heap.alloc(NAp(stack(0), stack(1)))
      new GMState(is, a :: stack.drop(2), dump, newHeap, globals, stats)
    }
    case PushInt(n) :: is if (globals.contains(n.toString)) =>
      new GMState(is, globals(n.toString) :: stack, dump, heap, globals, stats)
    case PushInt(n) :: is => {
      val (newHeap, a) = heap.alloc(NNum(n))
      new GMState(is, a :: stack, dump, newHeap, globals + (n.toString -> a), stats)
    }
    case Push(n) :: is => new GMState(is, stack(n) :: stack, dump, heap, globals, stats)
    case Update(n) :: is => {
      val newHeap = heap.update(stack(n + 1))(NInd(stack.head))
      new GMState(is, stack.tail, dump, newHeap, globals, stats)
    }
    case Pop(n) :: is => new GMState(is, stack.drop(n), dump, heap, globals, stats)
    case Unwind :: Nil => heap.lookup(stack.head) match {
      case NNum(n) => dump match {
        case (dumpCode, dumpStack) :: ds => new GMState(dumpCode, stack.head :: dumpStack, ds, heap, globals, stats)
        case Nil                         => new GMState(Nil, stack, Nil, heap, globals, stats)
      }
      case NConstr(t, a) => dump match {
        case (dumpCode, dumpStack) :: ds => new GMState(dumpCode, stack.head :: dumpStack, ds, heap, globals, stats)
        case Nil                         => new GMState(Nil, stack, Nil, heap, globals, stats)
      }
      case NAp(a1, a2)                            => new GMState(List(Unwind), a1 :: stack, dump, heap, globals, stats)
      case NGlobal(n, c) if stack.tail.length < n => new GMState(dump.head._1, stack.last :: dump.head._2, dump.tail, heap, globals, stats)
      case NGlobal(n, c) => {
        val newStack = stack.tail.map(getArg).take(n) ++ stack.drop(n)
        new GMState(c, newStack, dump, heap, globals, stats)
      }
      case NInd(a) => new GMState(List(Unwind), a :: stack.tail, dump, heap, globals, stats)
    }
    case Unwind :: is => throw new Exception("unwind not last instruction")
    case Alloc(n) :: is => {
      val (newHeap, as) = allocNodes(n, heap)
      new GMState(is, as ++ stack, dump, newHeap, globals, stats)
    }
    case Slide(n) :: is => new GMState(is, stack.head :: stack.drop(n + 1), dump, heap, globals, stats)
    case Eval :: is     => new GMState(List(Unwind), List(stack.head), (is, stack.tail) :: dump, heap, globals, stats)
    case Add :: is      => primitive2n(x => y => x + y)
    case Sub :: is      => primitive2n(x => y => x - y)
    case Mul :: is      => primitive2n(x => y => x * y)
    case Div :: is      => primitive2n(x => y => x / y)
    case Neg :: is      => primitive1(x => -x)
    case Eq :: is       => primitive2b(x => y => x == y)
    case Ne :: is       => primitive2b(x => y => x != y)
    case Lt :: is       => primitive2b(x => y => x < y)
    case Le :: is       => primitive2b(x => y => x <= y)
    case Gt :: is       => primitive2b(x => y => x > y)
    case Ge :: is       => primitive2b(x => y => x >= y)
    case Pack(tag, arity) :: is => {
      val (newHeap, a) = heap.alloc(NConstr(tag, stack.take(arity)))
      new GMState(is, a :: stack.drop(arity), dump, newHeap, globals, stats)
    }
    case CaseJump(cases) :: is => heap.lookup(stack.head) match {
      case NConstr(tag, args) => new GMState(cases(tag) ++ is, stack, dump, heap, globals, stats)
      case _                  => throw new Exception("casejumping on a non constr")
    }
    case Split(n) :: is => heap.lookup(stack.head) match {
      case NConstr(tag, args) if n == args.length => new GMState(is, args ++ stack.tail, dump, heap, globals, stats)
      case NConstr(t, a)                          => throw new Exception("splitting the wrong number of args")
      case _                                      => throw new Exception("splitting on a non constr")
    }
    case Print :: is => heap.lookup(stack.head) match {
      case NConstr(tag, args) => {
        print("{ Pack " + tag + " ")
        val code = args.flatMap(a => List(Eval, Print)) ++ List(PrintLit("} "))
        new GMState(code ++ is, args ++ stack.tail, dump, heap, globals, stats)
      }
      case NNum(n)            => {
        print(n + " ")
        new GMState(is, stack.tail, dump, heap, globals, stats)
      }
      case _                  => throw new Exception("printing a non WHNF")
    }
    case PrintLit(s) :: is => {
      print(s)
      new GMState(is, stack, dump, heap, globals, stats)
    }
  }

  def getArg(a : Addr) : Addr = heap.lookup(a) match {
    case NAp(a1, a2) => a2
    case _           => throw new Exception("stack contains a non-application")
  }

  def allocNodes(n : Int, h : Heap[Node]) : (Heap[Node], List[Addr]) =
    if (n == 0) (h, Nil)
    else {
      val (heap1, as) = allocNodes(n - 1, h)
      val (heap2, a) = heap1.alloc(NInd(hNull))
      (heap2, a :: as)
    }

  def boxInt(i : Int) : (Heap[Node], Addr) = heap.alloc(NNum(i))

  def boxBool(b : Boolean) : (Heap[Node], Addr) = heap.alloc(NConstr(if (b) 1 else 2, Nil))

  def unboxInt(a : Addr) : Int = heap.lookup(a) match {
    case NNum(i) => i
    case _       => throw new Exception("unboxing a non-int")
  }

  def primitive1(op : Int => Int) : GMState = {
    val (newHeap, a) = boxInt(op(unboxInt(stack.head)))
    new GMState(code.tail, a :: stack.tail, dump, newHeap, globals, stats)
  }

  def primitive2n(op : Int => Int => Int) : GMState = {
    val (newHeap, a) = boxInt(op(unboxInt(stack.head))(unboxInt(stack.tail.head)))
    new GMState(code.tail, a :: stack.tail.tail, dump, newHeap, globals, stats)
  }

  def primitive2b(op : Int => Int => Boolean) : GMState = {
    val (newHeap, a) = boxBool(op(unboxInt(stack.head))(unboxInt(stack.tail.head)))
    new GMState(code.tail, a :: stack.tail.tail, dump, newHeap, globals, stats)
  }

  def showAtAddr(a : Addr) : String = heap.lookup(a) match {
    case NNum(n)            => "#" + n.toString
    case NInd(a)            => showAtAddr(a)
    case NAp(a1, a2)        => "(" + a1 + " " + a2 + ")"
    case NGlobal(n, c)      => (for (i <- c) yield i + " ").mkString
    case NConstr(tag, args) => "{" + tag + "," + (for (a <- args) yield showAtAddr(a) + " ").mkString + "}"
  }

  def showDefns : String = globals.map(showSC).toString

  def showSC(g : (String, Addr)) : String = g._1 + " = " + showAtAddr(g._2) + "\n"

  def showStack : String = (for (s <- stack) yield s + " ").mkString + '\n'

  def showInstructions : String = (for (i <- code) yield i + " ").mkString + '\n'

  def showHeap : String = (for (a <- heap.addresses) yield a + " = " + heap.lookup(a) + '\n').mkString

  def showResult : String = heap.lookup(stack.head).toString + '\n'

  def showDump : String = (for ((c, s) <- dump) yield c + " ").mkString + '\n' + (for ((c, s) <- dump) yield s + " ").mkString + '\n'

  def showStats : String =
    "Total number of steps = " + stats.getSteps + '\n' + "Final heap allocation = " + heap.size + '\n' + "Max heap allocation = " + stats.maxHeap + '\n'
}
