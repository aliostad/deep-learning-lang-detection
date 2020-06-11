package com.scalastudy.chapter9

import java.io.File

import org.scalatest.FunSuite
import com.scalastudy.chapter9.CurriedFunctionsSample._


class CurriedFunctionsSample$Test extends FunSuite {

  test("plainOldSum"){
    assert(plainOldSum(1,1) == 2)
    assert(plainOldSum(1,2) == 3)

    val f = plainOldSum( _:Int, 5)
    assert(f(1) == 6)
    assert(f(2) == 7)
  }

  test("curriedSum"){
    assert(curriedSum(1)(1) == 2)
    assert(curriedSum(1)(2) == 3)

    val f = curriedSum(5)_
    assert(f(1) == 6)
    assert(f(2) == 7)

    val f2 = curriedSum(10)_
    assert(f2(1) == 11)
    assert(f2(2) == 12)
  }

  test("filter and modN"){
    val l = List(1,2,3,4,5,6,7,8)
    filter(l, modN(2)).foreach(println)

    println("*****")
    filter(l, modN(3)).foreach(println)
  }

  test("filter and modM"){
    println("*****")
    val l = List(1,2,3,4,5,6,7,8)
    filter(l,modM( 3, _:Int)).foreach(println)
  }

  test("twice"){
    assert(twice(_ + 1, 5) == 7)
    assert(twice((x:Double) => x + 1, 5) == 7)
  }

  test("withPrintWriter"){
    val file = new File("D:\\scala\\20151125\\date.txt")
    withPrintWriter(file, writer => writer.println(new java.util.Date))
  }

  test("withCurriedPrintWriter") {
    val file = new File("D:\\scala\\20151125\\date2.txt")
    withCurriedPrintWriter(file) {
      writer => writer.println(new java.util.Date)
    }
  }


}
