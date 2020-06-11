package jp.ac.u_tokyo.i.ci.csg.hiroshi_yamaguchi.macros.cps_new.sample

/*
Copyright (c) 2015, Hiroshi Yamaguchi (Core Software Group)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import jp.ac.u_tokyo.i.ci.csg.hiroshi_yamaguchi.macros.debug._
import org.scalatest.FunSuite

import scala.language.implicitConversions

class CPSTransformerOldTest extends FunSuite {
  def hoge(a: Int): Unit = ???

  def piyo(a: Int)(b: Int): Unit = ???

  def fuga(a: Int)(b: Int, c: Int = 30): Unit = ???

  def funi(a: => Int): Unit = ???

  def in: Int = ???

  def bo: Boolean = ???

  def &&(a: Int): Boolean = ???

  class M[T] {
    def fmap[U](f: T => U): M[U] = ???

    def bind[U](f: T => M[U]): M[U] = ???
  }

  def unit[T](v: T): M[T] = ???

  import jp.ac.u_tokyo.i.ci.csg.hiroshi_yamaguchi.macros.cps_new.CPSTransformerOld._

  def reflectInt(): Int@cps[M[Int]] = ???

  def reflectBoolean(): Boolean@cps[M[Boolean]] = ???

  implicit def toBoolean(i: Int): Boolean = if (i == 0) false else true

  test("simple cases") {
    println(show(CPSTransformOld.cpsTransform {
      println(hoge(10))
    }))

    println(show(CPSTransformOld.cpsTransform {
      println("hoge" + 1)
    }))

    println(show(CPSTransformOld.cpsTransform {
      println(Math.sqrt(10))
    }))

    println(show(CPSTransformOld.cpsTransform {
      Array(10)(0)
    }))

    println(show(CPSTransformOld.cpsTransform {
      piyo(10)(20)
    }))

    println(show(CPSTransformOld.cpsTransform {
      println(Math.sqrt(10))
      println("hoge" + 1)
    }))

    println(show(CPSTransformOld.cpsTransform {
      (bo, in) match {
        case (a, b) => false;
        case _ => true
      }
    }))
  }


  test("@ simple cases @") {
    println(show(CPSTransformOld.cpsTransform {
      println(reflectInt())
    }))

    println(show(CPSTransformOld.cpsTransform {
      println(reflectInt() + 1)
    }))

    println(show(CPSTransformOld.cpsTransform {
      println(Math.sqrt(reflectInt()))
    }))

    println(show(CPSTransformOld.cpsTransform {
      Array(reflectInt())(reflectInt())
    }))

    println(show(CPSTransformOld.cpsTransform {
      piyo(reflectInt())(reflectInt())
    }))

    println(show(CPSTransformOld.cpsTransform {
      println(Math.sqrt(reflectInt()))
      println(reflectInt() + 1)
    }))

    println(show(CPSTransformOld.cpsTransform {
      (reflectBoolean(), reflectInt()) match {
        case (a, b) => false;
        case _ => true
      }
    }))
  }


  test("@ simple cases (val) @") {
    println(show(CPSTransformOld.cpsTransform {
      val a = reflectInt()
      println(a)
    }))

    println(show(CPSTransformOld.cpsTransform {
      val a = reflectInt()
      println(a + 1)
    }))

    println(show(CPSTransformOld.cpsTransform {
      val a = reflectInt()
      println(Math.sqrt(a))
    }))

    println(show(CPSTransformOld.cpsTransform {
      val a = reflectInt()
      val b = reflectInt()
      Array(a)(b)
    }))

    println(show(CPSTransformOld.cpsTransform {
      val a = reflectInt()
      val b = reflectInt()
      piyo(a)(b)
    }))

    println(show(CPSTransformOld.cpsTransform {
      val a = reflectInt()
      println(Math.sqrt(a))
      val b = reflectInt()
      println(b + 1)
    }))

    println(show(CPSTransformOld.cpsTransform {
      val a = reflectBoolean()
      val b = reflectInt()
      (a, b) match {
        case (a, b) => false;
        case _ => true
      }
    }))
  }


  // no expasion
  test("by-names") {
    println(show(CPSTransformOld.cpsTransform {
      funi(1 + in)
    }))

    // short circuit operator
    println(show(CPSTransformOld.cpsTransform {
      bo && (bo && bo)
    }))
  }

  // expand
  test("not by-name") {
    // not short circuit operator
    println(show(CPSTransformOld.cpsTransform {
      &&(in + 1)
    }))

    println(show(CPSTransformOld.cpsTransform {
      if (&&(in + 1)) 10 else 20
    }))

    // prefix is not short circuit
    println(show(CPSTransformOld.cpsTransform {
      bo && bo && bo
    }))

    println(show(CPSTransformOld.cpsTransform {
      if (bo && bo && bo) 10 else 20
    }))
  }

  test("complex pattern") {
    val a = new CPSTransformerOldTest
    println(show(CPSTransformOld.cpsTransform {
      a.hoge(10)
    }))

    println(show(CPSTransformOld.cpsTransform {
      fuga(10)(b = 20)
    }))

    println(show(CPSTransformOld.cpsTransform {
      fuga(10)(20, c = 30)
    }))

    println(show(CPSTransformOld.cpsTransform {
      val a: String = "piyo"
      println(a)
    }))
  }

  test("type apply") {

    println(show(CPSTransformOld.cpsTransform {
      None.asInstanceOf[Option[Int]]
    }))

    println(show(CPSTransformOld.cpsTransform {
      None.isInstanceOf[Option[Int]]
    }))
  }

  test("if / match / try") {
    println(show(CPSTransformOld.cpsTransform {
      if (bo) 1 else 2
    }))

    // empty guards
    println(show(CPSTransformOld.cpsTransform {
      bo match {
        case _ => 1
      }
    }))

    // empty catch
    println(show(CPSTransformOld.cpsTransform {
      try {
        bo
      }
    }))
  }

  test("complex cases 2") {
    println(show(CPSTransformOld.cpsTransform {
      val a = {
        val a = 10
        a + 20
      } + 30
      println(a)
      a
    }))

    println(show(CPSTransformOld.cpsTransform {
      val a = 5
      val b = {
        val a = 10
        a + 20
      } + 30
      println(a)
      a
    }))

    println(show(CPSTransformOld.cpsTransform {
      (a: Int) => {
        a
      }
    }))

    println(show(CPSTransformOld.cpsTransform {
      if (bo)
        1
      else
        true
    }))
  }

  test("select expansion") {
    import scala.concurrent.Promise
    println(show(CPSTransformOld.cpsTransform {
      Promise.successful(if (bo) 10 else 20).trySuccess(10)
    }))

    println(show(CPSTransformOld.cpsTransform {
      Promise.successful(if (bo) 10 else 20)
    }))

    println(show(CPSTransformOld.cpsTransform {
      println(if (bo) 10 else 20)
    }))

    println(show(CPSTransformOld.cpsTransform {
      Promise.successful(if (bo) 10 else 20).future
    }))

    println(show(CPSTransformOld.cpsTransform {
      val a = scala.Predef
      Promise.successful(if (bo) 10 else 20).future.failed
    }))
  }

  test("def") {
    println(show {
      def f(a: Int): Unit = {
        CPSTransformOld.cpsTransform {
          val b = a
          println(b * a)
        }
      }
    })
  }
}
