

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


trait Monoid[m] extends Semigroup[m] { outer =>
    final val asMonoid: Monoid[apply0] = this

    // Core
    //
    type mempty = m
    def mempty: mempty

    type mappend = m => Lazy[m] => m
    def mappend: mappend

    type mconcat = List[m] => m
    def mconcat: mconcat = { x => List.foldr(mappend)(mempty)(x) }

    // Overrides
    //
    override def op_<>: : op_<>: = mappend

    // Extra
    //
    type dual = Monoid[m]
    def dual: dual = new Monoid[m] {
        override val mempty: m = outer.mempty
        override val mappend: m => Lazy[m] => m = x => y => outer.mappend(y.!)(x)
    }
}


trait MonoidProxy[m] extends Monoid[m] with SemigroupProxy[m] {
    type selfMonoid = Monoid[m]
    def selfMonoid: selfMonoid
    override def selfSemigroup: selfSemigroup = selfMonoid

    override def mempty: mempty = selfMonoid.mempty
    override def mappend: mappend = selfMonoid.mappend
    override def mconcat: mconcat = selfMonoid.mconcat

    override def dual: dual = selfMonoid.dual
}


object Monoid extends MonoidInstance with MonoidShortcut with MonoidType {
    def apply[m <: Kind.Function0](implicit i: Monoid[m#apply0]): Monoid[m#apply0] = i

    def deriving[nt <: Kind.Newtype](implicit j: Newtype[nt#apply0, nt#oldtype, _], i: Monoid[nt#oldtype]): Monoid[nt#apply0] = new Monoid[nt#apply0] with SemigroupProxy[nt#apply0] {
        override val selfSemigroup: selfSemigroup = Semigroup.deriving[nt]

        override val mempty: mempty = j.newOf(i.mempty)
        override val mappend: mappend = x => y => j.newOf(i.mappend(j.oldOf(x))(j.oldOf(y)))
        override val mconcat: mconcat = xs => j.newOf(i.mconcat(List.map[nt#apply0, nt#oldtype](j.oldOf)(xs)))
    }

    def weak[nt <: Kind.Newtype](implicit j: Newtype[nt#apply0, nt#oldtype, _], i: Monoid[nt#apply0]): Monoid[nt#oldtype] = deriving[Kind.coNewtype[nt]](j.coNewtype, i)
}


sealed trait MonoidInstance { this: Monoid.type =>
    implicit val _ofUnit: Monoid[Unit] = Unit
    implicit def _ofFunction[z, b](implicit mb: Monoid[b]): Monoid[z => b] = Function._asMonoid[z, b]
    implicit def _ofTuple2[a, b](implicit ma: Monoid[a], mb: Monoid[b]): Monoid[(a, b)] = Tuple2._asMonoid[a, b]
}


trait MonoidShortcut extends SemigroupShortcut {
    def mempty[m](implicit i: Monoid[m]): m = i.mempty
    def mappend[m](x: m)(y: Lazy[m])(implicit i: Monoid[m]): m = i.mappend(x)(y)
    def mconcat[m](xs: List[m])(implicit i: Monoid[m]): m = i.mconcat(xs)

    def dual[m](implicit i: Monoid[m]): Monoid[m] = i.dual
}


sealed trait MonoidType { this: Monoid.type =>

    // Dual
    //
    final case class Dual[+a](override val old: a) extends NewtypeOf[a]

    object Dual {
        implicit def _asNewtype[a]: Newtype[Dual[a], a, Eq ^:: Ord ^:: Show ^:: Bounded ^:: Kind.Nil] = new Newtype[Dual[a], a, Eq ^:: Ord ^:: Show ^:: Bounded ^:: Kind.Nil] {
            override val newOf: newOf = ot => Dual(ot)
            override val oldOf: oldOf = nt => nt.old
        }

        implicit def _asMonoid[a](implicit i: Monoid[a]): Monoid[Dual[a]] = new Monoid[Dual[a]] {
            override val mempty: mempty = Dual(i.mempty)
            override val mappend: mappend = x => y => Dual(i.mappend(y.old)(x.old))
        }
    }

    // All
    //
    final case class All(override val old: Bool) extends NewtypeOf[Bool]

    object All extends Newtype[All, Bool, Eq ^:: Ord ^:: Show ^:: Bounded ^:: Kind.Nil] with ThisIsInstance {
        // Overrides
        //
        // Newtype
        override val newOf: newOf = ot => All(ot)
        override val oldOf: oldOf = nt => nt.old

        implicit val _asMonoid: Monoid[All] = new Monoid[All] {
            // Semigroup
            private type a = All
            override def times1p[n](n: n)(a: a)(implicit j: Integral[n]): a = a
            // Monoid
            override val mempty: mempty = All(True)
            override val mappend: mappend = x => y => All(x.old && y.old)
        }
    }

    // Any_
    //
    final case class Any_(override val old: Bool) extends NewtypeOf[Bool]

    object Any_  extends Newtype[Any_, Bool, Eq ^:: Ord ^:: Show ^:: Bounded ^:: Kind.Nil] with ThisIsInstance {
        // Overrrides
        //
        // Newtype
        override val newOf: newOf = ot => Any_(ot)
        override val oldOf: oldOf = nt => nt.old

        implicit val _asMonoid: Monoid[Any_] = new Monoid[Any_] {
            // Semigroup
            private type a = Any_
            override def times1p[n](n: n)(a: a)(implicit j: Integral[n]): a = a
            // Monoid
            override val mempty: mempty = Any_(False)
            override val mappend: mappend = x => y => Any_(x.old || y.old)
        }
    }

    // Sum
    //
    final case class Sum[a](override val old: a) extends NewtypeOf[a]

    object Sum {
        implicit def _asNewtype[a]: Newtype[Sum[a], a, Eq ^:: Ord ^:: Show ^:: Bounded ^:: Kind.Nil] = new Newtype[Sum[a], a, Eq ^:: Ord ^:: Show ^:: Bounded ^:: Kind.Nil] {
            override val newOf: newOf = ot => Sum(ot)
            override val oldOf: oldOf = nt => nt.old
        }

        implicit def _asMonoid[a](implicit i: Num[a]): Monoid[Sum[a]] = new Monoid[Sum[a]] {
            import i.+
            override val mempty: mempty = Sum(i.fromIntegral(0))
            override val mappend: mappend = x => y => Sum(x.old + y.old)
        }
    }

    // Product
    //
    final case class Product[a](override val old: a) extends NewtypeOf[a]

    object Product {
        implicit def _asNewtype[a]: Newtype[Product[a], a, Eq ^:: Ord ^:: Show ^:: Bounded ^:: Kind.Nil] = new Newtype[Product[a], a, Eq ^:: Ord ^:: Show ^:: Bounded ^:: Kind.Nil] {
            override val newOf: newOf = ot => Product(ot)
            override val oldOf: oldOf = nt => nt.old
        }

        implicit def _asMonoid[a](implicit i: Num[a]): Monoid[Product[a]] = new Monoid[Product[a]] {
            import i.*
            override val mempty: mempty = Product(i.fromIntegral(1))
            override val mappend: mappend = x => y => Product(x.old * y.old)
        }
    }

    // First
    //
    final case class First[a](override val old: Maybe[a]) extends NewtypeOf[Maybe[a]]

    object First {
        implicit def _asNewtype[a]: Newtype[First[a], Maybe[a], Eq ^:: Ord ^:: Show ^:: Kind.Nil] = new Newtype[First[a], Maybe[a], Eq ^:: Ord ^:: Show ^:: Kind.Nil] {
            override val newOf: newOf = ot => First(ot)
            override val oldOf: oldOf = nt => nt.old
        }

        implicit def _asMonoid[z]: Monoid[First[z]] = new Monoid[First[z]] {
            // Semigroup
            private type a = First[z]
            override def times1p[n](n: n)(a: a)(implicit j: Integral[n]): a = a
            // Monoid
            override val mempty: mempty = First(Nothing)
            override val mappend: mappend = x => y => (x, y.!) match {
                case (r @ First(Just(_)), _) => r
                case (First(Nothing), r) => r
            }
        }
    }

    // Last
    //
    final case class Last[a](override val old: Maybe[a]) extends NewtypeOf[Maybe[a]]

    object Last {
        implicit def _asNewtype[a]: Newtype[Last[a], Maybe[a], Eq ^:: Ord ^:: Show ^:: Kind.Nil] = new Newtype[Last[a], Maybe[a], Eq ^:: Ord ^:: Show ^:: Kind.Nil] {
            override val newOf: newOf = ot => Last(ot)
            override val oldOf: oldOf = nt => nt.old
        }

        implicit def _asMonoid[z]: Monoid[Last[z]] = new Monoid[Last[z]] {
            // Semigroup
            private type a = Last[z]
            override def times1p[n](n: n)(a: a)(implicit j: Integral[n]): a = a
            // Monoid
            override val mempty: mempty = Last(Nothing)
            override val mappend: mappend = x => y => (x, y.!) match {
                case (_, r @ Last(Just(_))) => r
                case (r, Last(Nothing)) => r
            }
        }
    }
}
