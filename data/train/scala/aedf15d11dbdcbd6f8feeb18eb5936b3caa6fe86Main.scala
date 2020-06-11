package com.salexandru.CsvEncoder

import shapeless._

case class IceCream(name: String, amount: Int, cost: Double, falvoures: List[String])

sealed trait Tree[A]
case class Leaf[A](value: A) extends Tree[A]
case class Branch[A](left: Tree[A], value: A, right: Tree[A]) extends Tree[A]

object Main extends App {

  def write[A](value: A)(implicit enc: CsvEncoder[A]): Unit = {
    println(s"${enc.encode(value) mkString ","}")
  }


  write(1)
  write(true)
  write( (true , 1) )
  write("Ana are mere")
  write(1 :: true :: "Ana are mere" :: 1.98f :: 1.9 :: (true, 1) :: HNil)
  write(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: 10 :: Nil)

  write(IceCream("one", 500, 90.9, Nil))
  write(IceCream("two", 170, 80.9, "chocolate" :: "vanila" :: Nil))

  write(Leaf(1))
  write(Branch(Leaf(1), 2, Leaf(3)))
  write(Branch(Branch(Leaf(1), 2, Leaf(3)), 4, Branch(Leaf(5), 6, Leaf(7))))

  println("all to Tree[Int]")

  write( (Leaf(1): Tree[Int]) )
  write( (Branch(Leaf(1), 2, Leaf(3))): Tree[Int] )
  write( (Branch(Branch(Leaf(1), 2, Leaf(3)), 4, Branch(Leaf(5), 6, Leaf(7)))): Tree[Int] )
}
