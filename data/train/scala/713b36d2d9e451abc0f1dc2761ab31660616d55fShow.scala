

// Copyright Shunsuke Sogame 2011.
//
// Copyright 2004, The University Court of the University of Glasgow.
// All rights reserved.
//
// Copyright (c) 2002 Simon Peyton Jones
//
// Distributed under the New BSD license.


package com.github.okomok
package ken


/**
 * Prefer overriding `Any.toString` to `Show` instances.
 * The precise Haskell's `Show` emulation seems impractical,
 * especially in case of complicated case-class hierarchies.
 * `Char` string issue is hard-coded in `List.toString`
 */
// @ceremonial("impractical")
trait Show[a] extends Typeclass[a] {
    final val asShow: Show[apply0] = this

    // Core
    //
    type showsPrec = Int => a => ShowS
    def showsPrec: showsPrec = _ => x => s => show(x) ++: s

    type show = a => String
    def show: show = x => shows(x)("")

    type showList = List[a] => ShowS
    def showList: showList = ls => s => Show.showList__(shows)(ls)(s)

    // Extra
    //
    type shows = a => ShowS
    def shows: shows = x => showsPrec(0)(x)
}


trait ShowProxy[a] extends Show[a] {
    type selfShow = Show[a]
    def selfShow: selfShow

    override val showsPrec: showsPrec = selfShow.showsPrec
    override val show: show = selfShow.show
    override val showList: showList = selfShow.showList

    override val shows: shows = selfShow.shows
}


object Show extends ShowInstance with ShowShortcut {
    def apply[a <: Kind.Function0](implicit i: Show[a#apply0]): Show[a#apply0] = i

    def deriving[nt <: Kind.Newtype](implicit j: Newtype[nt#apply0, nt#oldtype, _], i: Show[nt#oldtype]): Show[nt#apply0] = new Show[nt#apply0] {
        override val showsPrec: showsPrec = _ => x => show_prefix(x) `.` showChar('(') `.` i.shows(j.oldOf(x)) `.` showChar(')')
        //override val show: show = a => show_prefix(a) `.` showChar('(') `.` i.show(j.oldOf(a)) `.` showChar(')')
        //override val showList: showList = ls => show_prefix(a) `.` showChar('(') `.` i.showList(List.map((x: nt#apply0) => j.oldOf(x))(ls)) `.` showChar(')')

        //override val shows: shows = a => i.shows(j.oldOf(a))
    }

    def weak[nt <: Kind.Newtype](implicit j: Newtype[nt#apply0, nt#oldtype, _], i: Show[nt#apply0]): Show[nt#oldtype] = deriving[Kind.coNewtype[nt]](j.coNewtype, i)

    val showChar: Char => ShowS = List.op_!::
    val showString: String => ShowS = List.op_!++:
    val showParen: Bool => ShowS => ShowS = b => p => if (b) showChar('(') `.` p `.` showChar(')') else p
    val showSpace: ShowS = xs => ' ' :: xs

    def showList__[a](showx: a => ShowS)(xs: List[a]): ShowS = s => {
        xs match {
            case Nil => "Nil" ++: s
            case x :: xs => {
                def showl(ys: List[a]): String = ys match {
                    case Nil => ')' :: s
                    case y :: ys => ',' :: showx(y)(showl(ys.!))
                }
                "List(" ++: showx(x)(showl(xs.!))
            }
        }
    }

    trait Of[a] extends Show[a] {
        override val showsPrec: showsPrec = _ => a => showString(a.toString)
    }

    // Details
    //
    private[ken] val show_tuple: List[ShowS] => ShowS = ss => {
        showChar('(') `.` List.foldr1((s: ShowS) => (r: Lazy[ShowS]) => s `.` showChar(',') `.` r)(ss) `.` showChar(')')
    }

    private[ken] val show_product: List[ShowS] => ShowS => ShowS = ss => prefix => {
        prefix `.` showChar('(') `.` List.foldr1((s: ShowS) => (r: Lazy[ShowS]) => s `.` showChar(',') `.` r)(ss) `.` showChar(')')
    }

    private[ken] val show_prefix: Any => ShowS = x => xs => List.takeWhile[Char](_ /== '(')(x.toString) ++: xs

    private[ken] def showFloat[a](x: a): ShowS = showString(x.toString)
}


private[ken] sealed trait ShowInstance0 { this: Show.type =>
    implicit def of[a]: Show[a] = new Of[a] {} // vs `_ofNewtype`
}

sealed trait ShowInstance extends ShowInstance0 { this: Show.type =>
    implicit val _ofChar: Show[Char] = Char
    implicit val _ofDouble: Show[Double] = Double
    implicit val _ofFloat: Show[Float] = Float
    implicit val _ofInt: Show[Int] = Int
    implicit val _ofInteger: Show[Integer] = _Integer

    implicit def _ofNewtype[nt, ot, ds <: Kind.MethodList](implicit j: Newtype[nt, ot, ds], i: Show[ot], k: Kind.MethodList.Contains[ds, Show]): Show[nt] = deriving[Newtype[nt, ot, _]]
}


trait ShowShortcut {
    def showsPrec[a](x: Int)(s: a)(implicit i: Show[a]): ShowS = i.showsPrec(x)(s)
    def show[a](s: a)(implicit i: Show[a]): String = i.show(s)
    def showList[a](ls: List[a])(implicit i: Show[a]): ShowS = i.showList(ls)
    def shows[a](x: a)(implicit i: Show[a]): ShowS = i.shows(x)
}
