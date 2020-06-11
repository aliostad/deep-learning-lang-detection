package jp.ac.u_tokyo.i.ci.csg.hiroshi_yamaguchi.macros.cps_new

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

class TicketOldTest extends FunSuite {
  def hoge(a: Int): Unit = ???

  def piyo(a: Int)(b: Int): Unit = ???

  def fuga(a: Int)(b: Int, c: Int = 30): Unit = ???

  def funi(a: => Int): Unit = ???

  def in: Int = ???

  def bo: Boolean = ???

  def &&(a: Int): Boolean = ???

  import SimpleForkJoinTransformer._

  class Join[T] {
    def jget(): T = ???
  }

  def parInt(): Int@forkJoin[Join[Int]] = ???

  def parBoolean(): Boolean@forkJoin[Join[Boolean]] = ???

  import CPSTransformerOld._

  class M[T] {
    def fmap[U](f: T => U): M[U] = ???

    def bind[U](f: T => M[U]): M[U] = ???
  }

  def unit[T](v: T): M[T] = ???

  def reflectInt(): Int@cps[M[Int]] = ???

  def reflectBoolean(): Boolean@cps[M[Boolean]] = ???

  implicit def toBoolean(i: Int): Boolean = if (i == 0) false else true

  test("simple cases") {
    println(show(TicketOld.ticket {
      println(hoge(10))
    }))

    println(show(TicketOld.ticket {
      println("hoge" + 1)
    }))

    println(show(TicketOld.ticket {
      println(Math.sqrt(10))
    }))

    println(show(TicketOld.ticket {
      Array(10)(0)
    }))

    println(show(TicketOld.ticket {
      piyo(10)(20)
    }))

    println(show(TicketOld.ticket {
      println(Math.sqrt(10))
      println("hoge" + 1)
    }))

    println(show(TicketOld.ticket {
      (bo, in) match {
        case (a, b) => false;
        case _ => true
      }
    }))
  }


  test("@ simple cases (fork/join) @") {
    println(show(TicketOld.ticket {
      println(parInt())
    }))

    println(show(TicketOld.ticket {
      println(parInt() + 1)
    }))

    println(show(TicketOld.ticket {
      println(Math.sqrt(parInt()))
    }))

    println(show(TicketOld.ticket {
      Array(parInt())(parInt())
    }))

    println(show(TicketOld.ticket {
      piyo(parInt())(parInt())
    }))

    println(show(TicketOld.ticket {
      println(Math.sqrt(parInt()))
      println(parInt() + 1)
    }))

    println(show(TicketOld.ticket {
      (parBoolean(), parInt()) match {
        case (a, b) => false;
        case _ => true
      }
    }))
  }


  test("@ simple cases (non-blocking) @") {
    class F[T] {
      def jget(): T@cps[F[T]] = ???

      def fmap[U](f: T => U): F[U] = ???

      def bind[U](f: T => F[U]): F[U] = ???
    }

    def unit[T](v: T): F[T] = ???

    def parInt(): Int@forkJoin[F[Int]] = ???

    def parBoolean(): Boolean@forkJoin[F[Boolean]] = ???

    println(show(TicketOld.ticket {
      println(parInt())
    }))

    println(show(TicketOld.ticket {
      println(parInt() + 1)
    }))

    println(show(TicketOld.ticket {
      println(Math.sqrt(parInt()))
    }))

    println(show(TicketOld.ticket {
      Array(parInt())(parInt())
    }))

    println(show(TicketOld.ticket {
      piyo(parInt())(parInt())
    }))

    println(show(TicketOld.ticket {
      println(Math.sqrt(parInt()))
      println(parInt() + 1)
    }))

    println(show(TicketOld.ticket {
      (parBoolean(), parInt()) match {
        case (a, b) => false;
        case _ => true
      }
    }))
  }

  // no expasion
  test("by-names") {
    println(show(TicketOld.ticket {
      funi(1 + in)
    }))

    // short circuit operator
    println(show(TicketOld.ticket {
      bo && (bo && bo)
    }))
  }

  // expand
  test("not by-name") {
    // not short circuit operator
    println(show(TicketOld.ticket {
      &&(in + 1)
    }))

    println(show(TicketOld.ticket {
      if (&&(in + 1)) 10 else 20
    }))

    // prefix is not short circuit
    println(show(TicketOld.ticket {
      bo && bo && bo
    }))

    println(show(TicketOld.ticket {
      if (bo && bo && bo) 10 else 20
    }))
  }


  test("@ simple cases (cps) @") {
    println(show(TicketOld.ticket {
      println(reflectInt())
    }))

    println(show(TicketOld.ticket {
      println(reflectInt() + 1)
    }))

    println(show(TicketOld.ticket {
      println(Math.sqrt(reflectInt()))
    }))

    println(show(TicketOld.ticket {
      Array(reflectInt())(reflectInt())
    }))

    println(show(TicketOld.ticket {
      piyo(reflectInt())(reflectInt())
    }))

    println(show(TicketOld.ticket {
      println(Math.sqrt(reflectInt()))
      println(reflectInt() + 1)
    }))

    println(show(TicketOld.ticket {
      (reflectBoolean(), reflectInt()) match {
        case (a, b) => false;
        case _ => true
      }
    }))
  }



  test("@ simple cases (cps type) @") {
    println(show {
      val t = TicketOld.ticket {
        println(reflectInt())
      }
      t
    })
  }

  test("complex pattern") {
    val a = new TicketOldTest
    println(show(TicketOld.ticket {
      a.hoge(10)
    }))

    println(show(TicketOld.ticket {
      fuga(10)(b = 20)
    }))

    println(show(TicketOld.ticket {
      fuga(10)(20, c = 30)
    }))

    println(show(TicketOld.ticket {
      val a: String = "piyo"
      println(a)
    }))
  }

  test("type apply") {

    println(show(TicketOld.ticket {
      None.asInstanceOf[Option[Int]]
    }))

    println(show(TicketOld.ticket {
      None.isInstanceOf[Option[Int]]
    }))
  }

  test("if / match / try") {
    println(show(TicketOld.ticket {
      if (bo) 1 else 2
    }))

    // empty guards
    println(show(TicketOld.ticket {
      bo match {
        case _ => 1
      }
    }))

    // empty catch
    println(show(TicketOld.ticket {
      try {
        bo
      }
    }))
  }

  test("complex cases 2") {
    println(show(TicketOld.ticket {
      val a = {
        val a = 10
        a + 20
      } + 30
      println(a)
      a
    }))

    println(show(TicketOld.ticket {
      val a = 5
      val b = {
        val a = 10
        a + 20
      } + 30
      println(a)
      a
    }))

    println(show(TicketOld.ticket {
      (a: Int) => {
        a
      }
    }))

    println(show(TicketOld.ticket {
      if (bo)
        1
      else
        true
    }))
  }

  test("select expansion") {
    import scala.concurrent.Promise
    println(show(TicketOld.ticket {
      Promise.successful(if (bo) 10 else 20).trySuccess(10)
    }))

    println(show(TicketOld.ticket {
      Promise.successful(if (bo) 10 else 20)
    }))

    println(show(TicketOld.ticket {
      println(if (bo) 10 else 20)
    }))

    println(show(TicketOld.ticket {
      Promise.successful(if (bo) 10 else 20).future
    }))

    println(show(TicketOld.ticket {
      val a = scala.Predef
      Promise.successful(if (bo) 10 else 20).future.failed
    }))
  }

  test("def") {
    println(show {
      def f(a: Int): Unit = {
        TicketOld.ticket {
          val b = a
          println(b * a)
        }
      }
    })
  }
}
