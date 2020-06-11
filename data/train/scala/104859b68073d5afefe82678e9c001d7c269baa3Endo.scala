

// Copyright Shunsuke Sogame 2011.
// Distributed under the New BSD license.


package com.github.okomok
package ken


final case class Endo[a](override val old: a => a) extends NewtypeOf[a => a] with (a => a) {
    override def apply(x: a): a = old(x)
}


object Endo {
    implicit def _asNewtype[a]: Newtype[Endo[a], a => a, Kind.Nil] = new Newtype[Endo[a], a => a, Kind.Nil] {
        override val newOf: newOf = ot => Endo(ot)
        override val oldOf: oldOf = nt => nt.run

    }

    implicit def _asMonoid[a]: Monoid[Endo[a]] = new Monoid[Endo[a]] {
        override val mempty: mempty = Endo(id[a])
        override val mappend: mappend = x => y => Endo(x.run `.` y.!.run)
    }
}
