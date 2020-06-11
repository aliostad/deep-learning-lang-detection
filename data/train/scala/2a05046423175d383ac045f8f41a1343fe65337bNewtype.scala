

// Copyright Shunsuke Sogame 2011.
// Distributed under the New BSD license.


package com.github.okomok
package ken


trait Newtype[nt, ot, ds <: Kind.MethodList] extends TypeclassLike with Kind.Newtype { outer =>
    override type apply0 = nt
    override type oldtype = ot
    override type deriving = ds

    final val asNewtype: Newtype[nt, ot, ds] = this

    // Core
    //
    type newOf = Lazy[ot] => nt
    def newOf: newOf

    type oldOf = Lazy[nt] => ot
    def oldOf: oldOf

    // Extra
    //
    final def run(nt: nt): ot = oldOf(nt)

    type coNewtype = Newtype[ot, nt, ds]
    def coNewtype: coNewtype = new Newtype[ot, nt, ds] {
        override val oldOf: oldOf = ot => outer.newOf(ot)
        override val newOf: newOf = nt => outer.oldOf(nt)
    }
}


trait Newtype0Proxy[nt, ot, ds <: Kind.MethodList] extends Newtype[nt, ot, ds] {
    type selfNewtype = Newtype[nt, ot, ds]
    def selfNewtype: selfNewtype

    override def newOf: newOf = selfNewtype.newOf
    override def oldOf: oldOf = selfNewtype.oldOf

    override def coNewtype: coNewtype = selfNewtype.coNewtype
}


object Newtype extends Newtype0Instance {
    def apply[nt <: Kind.Newtype](implicit i: Newtype[nt#apply0, nt#oldtype, nt#deriving]): Newtype[nt#apply0, nt#oldtype, nt#deriving] = i
}


sealed trait Newtype0Instance { this: Newtype.type =>
    implicit def _ofNewtype1[nt[+_], ot[+_], ds <: Kind.MethodList, a](implicit i: Newtype1[nt, ot]): Newtype[nt[a], ot[a], ds] = new Newtype[nt[a], ot[a], ds] {
        override val newOf: newOf = ot => i.newOf(ot)
        override val oldOf: oldOf = nt => i.oldOf(nt)
    }

    implicit def _ofNewtype2[nt[-_, +_], ot[-_, +_], ds <: Kind.MethodList, a, b](implicit i: Newtype2[nt, ot]): Newtype[nt[a, b], ot[a, b], ds] = new Newtype[nt[a, b], ot[a, b], ds] {
        override val newOf: newOf = ot => i.newOf(ot)
        override val oldOf: oldOf = nt => i.oldOf(nt)
    }
}
