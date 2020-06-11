package org.scalair.hoopl

import TypeDefines._
import TypeDefines.OrderedMap._

/**
 * User: wangn
 * Date: 5/29/11
 */

final case class OldFact[A](val x:A)
final case class NewFact[A](val x:A)


object JoinFun {
  def extendToJoinWithTop[a<:Ordered[a]](join:JoinFun[a]):JoinFun[Pointed[a]] = {
    new JoinFun[Pointed[a]] {
      def apply(id:BlockId, oldFact:OldFact[Pointed[a]], newFact:NewFact[Pointed[a]]):(ChangeFlag,Pointed[a]) = {
        (oldFact, newFact) match {
          // (some,some)
          case (OldFact(Pointed(_,_,Some(a))), NewFact(Pointed(_,_,Some(b)))) => {
            val (chg, v0) = join(id, OldFact(a), NewFact(b))
            (chg, Pointed.pelem[a](v0))
          }
          // (top,_)
          case (OldFact(Pointed(C(),_,None)), NewFact(_)) => (NoChange, Pointed.gettop[a]())
          // (_, bot)
          case (OldFact(f), NewFact(Pointed(_,C(),None))) => (NoChange, f)
          // (_,top)
          case (OldFact(_), NewFact(Pointed(C(),_,None))) => (SomeChange, Pointed.gettop[a]())
          // (bot,_)
          case (OldFact(Pointed(_,C(),None)), NewFact(f)) => (SomeChange, f)
        }
      }
    }
  }

  def extendToJoinMaps[a<:Ordered[a], k<:Ordered[k]](join:JoinFun[a]):JoinFun[OrderedMap[k,a]] = {
    def upadd(id:BlockId):((ChangeFlag, OrderedMap[k,a]), (k,a)) => (ChangeFlag, OrderedMap[k,a]) =
    { case ((ch,jm), (key, new_v)) =>
      jm.get(key) match {
        case None => (SomeChange, jm + (key -> new_v))
        case Some(old_v) => {
          join(id, OldFact(old_v), NewFact(new_v)) match {
            case (SomeChange, v0) => (SomeChange, jm + (key -> v0))
            case (NoChange, _) => (ch, jm)
          }
        }
      }
    }
    new JoinFun[OrderedMap[k,a]] {
      def apply(id:BlockId, oldFact:OldFact[OrderedMap[k,a]], newFact:NewFact[OrderedMap[k,a]]):(ChangeFlag, OrderedMap[k,a]) = {
        newFact.x.foldLeft[(ChangeFlag, OrderedMap[k,a])]((NoChange, oldFact.x)){ (p,e) =>
          upadd(id)(p,e)
        }
      }
    }
  }
}

trait JoinFun[a<:Ordered[a]]{
  def apply(id:BlockId, oldFact:OldFact[a], newFact:NewFact[a]):(ChangeFlag, a)

  // add this to make it code completion friendly
  final def liftToJoinWithTop:JoinFun[Pointed[a]] = JoinFun.extendToJoinWithTop[a](this)
  final def liftToJoinMaps[k<:Ordered[k]]:JoinFun[OrderedMap[k,a]] = JoinFun.extendToJoinMaps[a,k](this)
}

object ChangeFlag {
  def changeIf(b:Boolean):ChangeFlag = if (b) SomeChange else NoChange
}

sealed abstract class ChangeFlag
final case object NoChange extends ChangeFlag
final case object SomeChange extends ChangeFlag



trait DataflowLattice[F<:Ordered[F]] { self =>
  val name:String
  val bot:F
  val join:JoinFun[F]

  final def addTop:DataflowLattice[Pointed[F]] = new DataflowLattice[Pointed[F]] {
    val name = self.name + " + T"
    val bot = Pointed.withTop[F](self.bot)
    val join = self.join.liftToJoinWithTop
  }

  final def mkFactBase(facts:List[(BlockId, F)]):FactBase[F] = {
    def add(map:FactBase[F], t:(BlockId, F)):FactBase[F] = {
      val (lbl, f) = t
      def newFact:F = map.get(lbl) match {
        case None => f
        case Some(x) => join(lbl, OldFact(x), NewFact(f))._2
      }
      map + (lbl -> newFact)
    }
    facts.foldLeft(new FactBase[F]()) ((p,e) => add(p, e))
  }

  final def getFact(l:BlockId, factBase:FactBase[F]):F = factBase.get(l) match {
    case Some(f) => f
    case None => bot
  }

  final def updateFact(lbs:BlockIdSet, lbl:BlockId, new_fact:F, tuple:(ChangeFlag, FactBase[F])):(ChangeFlag, FactBase[F]) = {
    val (cha, fbase) = tuple
    val (cha2, res_fact) = fbase.get(lbl) match {
      case Some(old_fact) => join(lbl, OldFact(old_fact), NewFact(new_fact))
      case None => {
        val (_, new_fact_debug) = join(lbl, OldFact(bot), NewFact(new_fact))
        (SomeChange, new_fact_debug)
      }
    }
    cha2 match {
      case NoChange => tuple
      case SomeChange => {
        val new_fbase = fbase + (lbl -> res_fact)
        if (lbs.contains(lbl)) (SomeChange, new_fbase)
        else (cha, new_fbase)
      }
    }
  }

  final def joinInFacts(fb:FactBase[F]):FactBase[F] = {
    def botJoin(t:(BlockId, F)) = { val (l,f) = t; (l, join(l, OldFact(bot), NewFact(f))._2) }
    mkFactBase(fb.toList.map(botJoin(_)))
  }
}