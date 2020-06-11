package sae.interpreter.arithmetics


import idb.syntax.iql.IR.{Table, Relation}
import sae.interpreter.{Interpreter, Syntax}
import scala.collection.mutable
import idb.SetTable
import sae.interpreter.utils.MaterializedMap

object StandardInterpreter /*{

	var printUpdates = true

	trait ArithExp
	case class Num(n: Int) extends ArithExp
	case class Add(e1: ArithExp, e2: ArithExp) extends ArithExp
	case class Sub(e1: ArithExp, e2: ArithExp) extends ArithExp

	type Exp = ArithExp
	type Value = Int

	def interp(e: Exp): Value = e match {
		case Num(n) => n
		case Add(e1, e2) => interp(e1) + interp(e2)
		case Sub(e1, e2) => interp(e1) - interp(e2)
	}

	trait ArithExpKind
	case object NumKind extends ArithExpKind
	case object AddKind extends ArithExpKind
	case object SubKind extends ArithExpKind


	type ExpKind = ArithExpKind
	type Key = Int
	type IExpTable = Table[(Key, Either[(ExpKind,Seq[Key]),Value])]
	type IExpMap = mutable.Map[Key, Either[(ExpKind,Seq[Key]),Value]]
	type IExp = (IExpTable, IExpMap)
	type IValue = Relation[(Key, Value)]

	private var freshID = 0

	private def fresh() : Int = {
		freshID = freshID + 1
		freshID
	}

	def insertExp(e: Exp, tab: IExp): Key = e match {
		case Num(n) => insertValue(n, tab)
		case Add(e1, e2) => insertNode(AddKind, Seq(insertExp(e1, tab), insertExp(e2, tab)), tab)
		case Sub(e1, e2) => insertNode(SubKind, Seq(insertExp(e1, tab), insertExp(e2, tab)), tab)
	}

	def insertValue(v: Value, tab: IExp): Key = {
		val exp = Right(v)
		val id = fresh()
		tab._1 add (id, exp)
		tab._2.put(id, exp)
		id
	}

	def insertNode(k: ExpKind, kids: Seq[Key], tab: IExp): Key = {
		val exp = Left(k, kids)
		val id = fresh()
		tab._1 add (id, exp)
		tab._2.put(id, exp)
		id
	}

	def updateExp(oldKey : Key, newExp : Exp, tab: IExp) : Key = {
		val oldValue = tab._2(oldKey)
		(newExp, oldValue) match {
			//1. Both literals with the same value
			case (Num(n), Right(v1)) if n == v1 => oldKey
			//2 ... else...
			case (Num(n), _ ) => updateValue(oldKey, n, tab)

			//1. Both are adds
			case (Add(e1, e2), Left((AddKind, seq))) => {
				updateExp(seq(0), e1, tab)
				updateExp(seq(1), e2, tab)
				oldKey
			}
			//2. 1 add and 1 non-add, but children are potentially the same
			case (Add(e1,e2), Left((_, seq))) if seq.size == 2 => {
				updateExp(seq(0), e1, tab)
				updateExp(seq(1), e2, tab)
				updateNode(oldKey, AddKind, seq, tab)
			}
			//3. Not the same at all
			case (Add(e1,e2),_) =>
				updateNode(oldKey, AddKind, Seq(insertExp(e1,tab), insertExp(e2,tab)), tab)
		/*	case (Add(e1,e2), _) => {
				val ref1 = updateExp(oldKey, e1, tab)
				val ref2 = updateExp(oldKey, e2, tab)
				insertNode(AddKind, Seq(ref1, ref2), tab)
			}*/

			//Analogous to add
			case (Sub(e1, e2), Left((SubKind, seq))) => {
				updateExp(seq(0), e1, tab)
				updateExp(seq(1), e2, tab)
				oldKey
			}
			case (Sub(e1,e2), Left((_, seq))) if seq.size == 2 => {
				updateExp(seq(0), e1, tab)
				updateExp(seq(1), e2, tab)
				updateNode(oldKey, SubKind, seq, tab)
			}
			case (Sub(e1,e2), _) => {
				updateNode(oldKey, SubKind, Seq(insertExp(e1,tab), insertExp(e2,tab)), tab)
			}
		}
	}

	def updateValue(oldKey : Key, v : Value, tab : IExp): Key = {
		if (printUpdates) println("updateValue: oldKey = " + oldKey + ", v = " + v)
		val exp = Right(v)
		tab._1.update((oldKey, tab._2(oldKey)), (oldKey, exp))
		tab._2.put(oldKey, exp)
		oldKey
	}

	def updateNode(oldKey : Key, k : ExpKind, kids : Seq[Key], tab : IExp): Key = {
		if (printUpdates) println("updateNode: oldKey = " + oldKey + ", k = " + k + ", kids = " + kids)
		val exp = Left(k, kids)
		tab._1.update((oldKey, tab._2(oldKey)), (oldKey, exp))
		tab._2.put(oldKey, exp)
		oldKey
	}

	def getValues(tab : IExp) : PartialFunction[Key, Value] with Iterable[(Key,Value)] = {
		val interpreter = new IncrementalInterpreter(tab._1)
		val result = new MaterializedMap[Key,Nothing, Value]
		interpreter.values(null).addObserver(result)
		result
		null
	}

	def createIExp : IExp = (SetTable.empty[(Key, Either[(ExpKind,Seq[Key]),Value])], mutable.HashMap.empty)

	private class IncrementalInterpreter(override val expressions : IExpTable) extends Interpreter[Key, ExpKind, Null, Value] {
		override def interpret(e: ExpKind, c : Null, s: Seq[Value]): Value = e match {
			case NumKind => s(0)
			case AddKind => s(0) + s(1)
			case SubKind => s(0) - s(1)
		}
	}


	def main(args : Array[String]) {
		val tab : IExp = createIExp

		val exp1 = Add(Add(Num(5), Num(2)), Num(10))
		val exp2 = Add(Sub(Num(6), Num(2)), Num(10))
		val exp3 = Add(Add(Num(5), Num(2)), Num(10))
		val exp4 = Add(exp1, Num(100))

		val values = getValues(tab)

		var ref1 = insertExp(exp1, tab)

		println("Before update: " + values(ref1) + "[" + ref1 + "]")
		println("exps")
		tab._2.foreach(println)
		println("values")
		values.foreach(println)

		ref1 = updateExp(ref1, exp4, tab)

		println("After update: " + values(ref1) + "[" + ref1 + "]")
		println("exps")
		tab._2.foreach(println)
		println("values")
		values.foreach(println)



	}
}         */