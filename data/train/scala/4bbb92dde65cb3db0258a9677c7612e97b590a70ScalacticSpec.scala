package es.weso.monads

import org.scalatest._
import org.scalatest.prop.PropertyChecks
import org.scalatest.prop.Checkers

import org.scalactic._
import Accumulation._
import TypeCheckedTripleEquals._

class ScalacticSpec
    extends FunSpec
    with Matchers
    with Checkers {
  
  describe ("Scalactic tests") {
    case class SingleError(msg: String)
    
    type Ctx = String => Int
    type Comp[A] = Ctx => Stream[A] Or Every[SingleError]
    
    val ctx : Ctx = { (x) => 
      x match {
        case "x1" => 1
        case "x2" => 2
      }
    }

    def value(a: String): Comp[Int] = { (ctx) =>
      try {
        val v = a.trim.toInt
        if (v >= 0) 
          Good(Stream(v)) 
        else 
          Bad(Every(SingleError(v + " is not a valid number")))
      }
      catch {
        case _: NumberFormatException => Bad(Every(SingleError(a + " is not a valid integer")))
      }
    }

    def unite(st: Stream[Comp[Int]]): Comp[Stream[Int]] = { (ctx) => {
      if (st.isEmpty) Good(Stream())
      else {
        ???
      }
    }
       
    }
    
    def combine(s1: Stream[Int], s2: Stream[Int], f: (Int,Int) => Comp[Int]): Comp[Int] = { (ctx) => {
      val pairs = s1 zip s2
      val newStream : Stream[Comp[Int]] = pairs.map  { case (x,y) => addInt(x,y) }
      ??? // unite(newStream)
     }
    }
    
    def addInt(x: Int, y: Int): Comp[Int] = { ??? 
    /*{
      attempt(x + y).badMap{ 
        case e => Bad(Every(SingleError(e.getMessage)))
      } */
    }
   
    def add(a: String, b:String): Comp[Int] = {
      val x = value(a)
      val y = value(b)
      // withGood(x,y) { case (x,y) => combine(x,y,(_ + _)) }
      ???
    } 
    
    def div(a: String, b:String): Comp[Int] = {
      val x = value(a)
      val y = value(b)
      // withGood(x,y) { case (x,y) => combine(x,y,(_ / _)) }
      ???
    } 
    
    it("Should compare values that have the same type") {
      (3 === 4) should be(false) 
    }
    
    // I thought the following code should not compile (why not?)
    it("Should not compare values that have different type") {
      (Some(3) === 4) should be(false) 
    }
    
/*    it("Should manage errors when converting to int a valid number") {
      val x = value("23")
      x.get should be(Stream(23))
    }

    it("Should manage errors when converting to int a wrong number") {
      val x = value("xx")
      x.isBad should be(true)
    }
    it("Should manage errors when adding numbers are ok") {
      val x = add("2","3")
      x.get should be(Stream(5))
    }
    it("Should manage errors when adding numbers that are not ok") {
      val x = add("xx","yy")
      x match {
        case Good(g) => fail("Unexpected good value " + g)
        case Bad(es) => {
         info("Bad values = " + es)
         es.size should be(2)
        } 
      }
    }
    it("Should manage errors when divinding by zero") {
      val x = div("2","0")
      x.isBad should be(true)
    }
    it("Should manage errors when divinding by zero and check that we have 3 errors") {
      val x = div("xx","yy")
      x match {
        case Good(g) => fail("Unexpected good value " + g)
        case Bad(es) => {
         info("Bad values = " + es)
         es.size should be(3)
        }
      }
    }
*/
  }
  
}
