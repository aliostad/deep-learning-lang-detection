

// Copyright Shunsuke Sogame 2011.
// Distributed under the New BSD license.


package com.github.okomok.kentest


import com.github.okomok.ken._


class ShowTest extends org.scalatest.junit.JUnit3Suite {

    def testTrivial {
        val s = Show.show(List(1,2)).asJString
        expect("List(1,2)")(s)
    }

    def testListNothing {
        val s = Show.show(Nil.up).asJString
        expect("Nil")(s)
    }

    def testNilType {
        val s = Show.show(Nil).asJString
        expect("Nil")(s)
    }

    def testNested {
        val s = Show.show(List(List(1,2), List(3,4,5))).asJString
        expect("List(List(1,2),List(3,4,5))")(s)
    }

    def testString_1 {
        val s = Show.show(List('a')).asJString
        expect("\"a\"")(s)
    }

    def testString_2 {
        val s = Show.show(List('a','b')).asJString
        expect("\"ab\"")(s)
    }

    def testNestedString_ {
        val s = Show.show(List(List('1','2'), List('3','4','5'))).asJString
        expect("List(\"12\",\"345\")")(s)
    }

    def testHmmm {
    /*
        instance[Eq[Nothing]]
        instance[Ord[Nothing]]
        instance[Show[Nothing]]
        instance[Eq[List[Nothing]]]
        instance[Ord[List[Nothing]]]
        instance[Show[List[Nothing]]]

        instance[Show[Nil.type]]
        instance[Eq[Nil.type]]
        instance[Ord[Nil.type]]
    */
    }
}
