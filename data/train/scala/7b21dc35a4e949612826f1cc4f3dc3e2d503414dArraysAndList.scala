package com.ufasoli.sia.ch2

/**
 *
 * User: ufasoli
 * Date: 03/07/13
 * Time: 17:31
 * project : scala
 */

object ArraysAndList{

  def main(args: Array[String]) {
  val array = new Array[String](3)
  array(0) ="This"
  array(1) ="is"
  array(2) ="mutable"

  array.foreach(println)

    val myList = List("This", "is", "immutable")

    myList.foreach(println)

    // manipulating collections
    val oldList = List(1,2)

    oldList.foreach(println)

    // create a new list by adding the element '3' at the end of the oldList
    val newList = 3 :: oldList
    newList.foreach(println)

    // create a new list by adding the element '3' at the begining of the oldList
    val newList2 = oldList :+ 3
    newList2.foreach(println)

    // using the Nil obj to create List
    val myList2 = "This" :: "is" :: "immutable" :: Nil
    myList2.foreach(println)


    // delete the 3rd element from the newList2 obj
    val afterDelete = newList2.filterNot(_ ==3)
    afterDelete.foreach(println)

  }
}
