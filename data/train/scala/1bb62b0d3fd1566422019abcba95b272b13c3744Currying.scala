package com.my.scala.chapter9

object Currying {

  def main(args: Array[String]) {

    println(plainOldSum(1, 2))
    println(curriedSum(1)(2))

    val second = first(1)
    println(second(2))

    val onePlus = curriedSum(1)_
    println(onePlus(2))

    val twoPlus = curriedSum(2)_
    println(twoPlus(2))
  }

  def plainOldSum(x: Int, y: Int) = x + y

  // curried analog of plainOldSum
  def curriedSum(x: Int)(y: Int) = x + y

  // under hood of curried function
  def first(x: Int) = (y: Int) => x + y
}
