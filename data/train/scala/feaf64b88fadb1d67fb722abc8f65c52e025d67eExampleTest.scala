

// Copyright Shunsuke Sogame 2014.
// Distributed under the New BSD license.


package com.github.okomoktest.litytest


import com.github.okomok.lity._

import junit.framework.Assert._


class ExampleTest extends org.scalatest.junit.JUnit3Suite {

    Assert(ScalaVersion() >= Version("2.11.0"))

    def testExample() {
        Compile {
            if (ScalaVersion() < Version("2.11.1")) {
                "oldFoo()"
            } else {
                "foo()"
            }
        }
    }

    def oldFoo() = ()
    def foo() = ()
}


