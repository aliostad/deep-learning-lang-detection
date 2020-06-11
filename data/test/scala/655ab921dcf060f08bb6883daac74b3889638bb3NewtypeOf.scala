

// Copyright Shunsuke Sogame 2011.
// Distributed under the New BSD license.


package com.github.okomok
package ken


import scala.annotation.unchecked.uncheckedVariance // Why needed?


trait NewtypeOf[+a] extends Up[NewtypeOf[a]] with Kind.Newtype {
    override type apply0 = this.type
    override type oldtype = a @uncheckedVariance

    type old = a
    def old: old

    type get = a
    final def get: get = old
    type run = a
    final def run: run = old
    type app = a
    final def app: app = old
}


trait NewtypeOfProxy[+a] extends NewtypeOf[a] {
    type selfNewtypeOf = NewtypeOf[a]
    def selfNewtypeOf: selfNewtypeOf

    override def old: old = selfNewtypeOf.old
}
