// Public domain

package com.github.okomok.kentest.example.vshaskell

import com.github.okomok.ken._

class ExistentialTest extends org.scalatest.junit.JUnit3Suite {

    def testShow {
/*
        data Obj = forall a. (Show a) => Obj a

        xs :: [Obj]
        xs = [Obj 1, Obj "foo", Obj 'c']

        doShow :: [Obj] -> String
        doShow [] = ""
        doShow ((Obj x):xs) = show x ++ doShow xs
*/
        type ObjRep[a] = (a, Show[a])

        // Order matters: SI-3772
        object Obj {
            def apply[a](a: a)(implicit s: Show[a]): Obj = new Obj(a, s)
        }
        final case class Obj(rep: ObjRep[_]) {
            // Is there a better SI-5022 workaround?
            def apply[b](f: ObjRep[_] => b): b = f(rep)
        }

        val xs: List[Obj] = List(Obj(1), Obj("foo"), Obj('c'))

        lazy val doShow: List[Obj] => String = {
            case Nil => ""
            // case Obj((x, s)) :: xs => show(x)(s) ++: doShow(xs)
            case obj :: xs => obj { case (x, s) => show(x)(s) } ++: doShow(xs)
        }

        expect("1fooc")(doShow(xs).asJString)
    }
}

// References
//
// http://www.haskell.org/haskellwiki/Existential_type

