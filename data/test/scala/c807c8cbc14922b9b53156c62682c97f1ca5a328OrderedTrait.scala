package com.example.mixin

class MyIntOldWay (val i:Int) {
  def > (that:MyIntOldWay) = {
    this.i > that.i
  }

  def < (that:MyIntOldWay) = that > this

  def >= (that:MyIntOldWay) = this > that || this.i == that.i

}


class MyIntBetterWay(val i:Int) extends Ordered[MyIntBetterWay] {
  override def compare(that: MyIntBetterWay): Int = {
    if (this.i == that.i)
      0
    if (this.i > that.i)
      1
    else
      -1
  }
}

object OrderedTrait {
  def main(args: Array[String]) {
    val t10 = new MyIntOldWay(10)
    val t100 = new MyIntOldWay(100)
    val t1 = new MyIntOldWay(10)
    println(t10 > t100)
    println(t10 < t100)
    println(t1 >= t10)


    val nT10 = new MyIntBetterWay(10)
    val nT100 = new MyIntBetterWay(10)
    val nT1 = new MyIntBetterWay(10)
    println(nT10 > nT100)
    println(nT10 < nT100)
    println(nT1 >= nT10)

  }
}
